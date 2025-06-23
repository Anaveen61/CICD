pipeline {
  agent any
  environment {
    DOCKERHUB = 'dockerhub-cred'  // Docker Hub credentials ID
    SSH_KEY   = 'app-ssh-key'     // SSH key credentials ID
    APP_IP    = '<65.0.127.120>'        // App server IP address
    IMAGE     = 'yourhubuser/yourapp'
  }
  options {
    retry(1)                        // Retry once on failure
    timeout(time: 30, unit: 'MINUTES')
  }
  stages {
    stage('Checkout') {
      steps {
        git url: 'https://github.com/Anaveen61/CICD.git', branch: 'main'
      }
    }
    stage('Build Image') {
      steps {
        script {
          docker.build("${IMAGE}:${env.BUILD_ID}")
        }
      }
    }
    stage('Push Image') {
      steps {
        script {
          docker.withRegistry('', DOCKERHUB) {
            docker.image("${IMAGE}:${env.BUILD_ID}").push()
          }
        }
      }
    }
    stage('Deploy') {
      steps {
        sshagent([SSH_KEY]) {
          sh """
            ssh -o StrictHostKeyChecking=no ubuntu@${APP_IP} \
              "docker pull ${IMAGE}:${BUILD_ID} && \
               docker stop app || true && \
               docker rm app || true && \
               docker run -d --name app -p 80:3000 ${IMAGE}:${BUILD_ID}"
          """
        }
      }
    }
  }
  post {
    always {
      echo "Build #${env.BUILD_ID} finished with status: ${currentBuild.currentResult}"
    }
    failure {
      echo 'Build failed. Check logs!'
    }
  }
}
