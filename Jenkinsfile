pipeline {
  agent {
    label 'local-agent'
  }

  options {
    ansiColor('xterm')
    timestamps()
  }

  environment {
    DOCKER_IMAGE = 'webpep/static-file-server'
    DOCKER_REGISTRY = credentials('docker_registry')
  }

  stages {
    stage('Get Submodules') {
      when {
        allOf {
          branch 'master'

          not {
            changeRequest()
          }
        }
      }

      steps {
        echo 'Getting submodules...'

        git submodule update --init
      }
    }

    stage('Build Docker Image') {
      when {
        allOf {
          branch 'master'

          not {
            changeRequest()
          }
        }
      }

      steps {
        echo 'Building docker image...'

        script {
          image = docker.build(DOCKER_IMAGE, "--no-cache .")
        }
      }
    }

    stage('Deploy Docker Image') {
      when {
        allOf {
          branch 'master'

          not {
            changeRequest()
          }
        }
      }

      steps {
        echo 'Deploying docker image to registry...'

        script {
          docker.withRegistry(DOCKER_REGISTRY, 'gitea_packages_account') {
            image.push('latest')
          }
        }
      }
    }

    stage('Update Application Deployment') {
      when {
        allOf {
          branch 'master'

          not {
            changeRequest()
          }
        }
      }

      environment {
        DEPLOY_SERVER_CREDS = credentials('deployment_ssh_creds')
        DEPLOY_SERVER_HOST = credentials('deployment_ssh_host')

        DEPLOYMENT_DIR = '/home/dev/services/webpep'
      }

      steps {
        echo 'Updating application deployment...'

        script {
          def remote = [:]
          remote.name = 'deployment'
          remote.host = DEPLOY_SERVER_HOST
          remote.user = DEPLOY_SERVER_CREDS_USR
          remote.password = DEPLOY_SERVER_CREDS_PSW
          remote.allowAnyHosts = true

          sshCommand remote: remote, command: "cd ${DEPLOYMENT_DIR} && docker-compose stop && docker-compose rm -f && docker-compose pull && docker-compose up -d"
        }
      }
    }
  }
}
