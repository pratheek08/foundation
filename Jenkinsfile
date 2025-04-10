pipeline {
    agent any

    environment {
        REGISTRY = 'igris08' 
        IMAGE_NAME = 'java-microservice'
    }

    stages {
        stage('Build & Test') {
            steps {
                echo "Running Maven build on branch: ${env.BRANCH_NAME}"
                sh 'mvn clean package'
            }
        }

        stage('Docker Build & Push') {
            when {
                branch 'develop'
            }
            steps {
                script {
                    def imageTag = "${REGISTRY}/${IMAGE_NAME}:${env.BUILD_NUMBER}"
                    sh "docker build -t ${imageTag} ."
                    sh "docker push ${imageTag}"
                }
            }
        }

        stage('Deploy to Kubernetes') {
            when {
                branch 'develop'
            }
            steps {
                sh 'kubectl apply -f k8s/deployment.yaml'
                sh 'kubectl apply -f k8s/service.yaml'
            }
        }
    }

    post {
        failure {
            echo "Pipeline failed for branch: ${env.BRANCH_NAME}"
        }
        success {
            echo "Pipeline completed successfully for branch: ${env.BRANCH_NAME}"
        }
    }
}
