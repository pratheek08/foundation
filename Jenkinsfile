pipeline {
    agent any

    environment {
        IMAGE_NAME = "igris08/java-microservice"
    }

    triggers {
        pollSCM('* * * * *')
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build with Maven') {
            steps {
                dir('java-microservice') {
                    sh 'mvn clean package'
                }
            }
        }

        stage('Docker Build & Push') {
            when {
                branch 'develop'
            }
            steps {
                dir('java-microservice') {
                    script {
                        def imageTag = "${env.IMAGE_NAME}:${env.BUILD_NUMBER}"
                        sh "docker build -t ${imageTag} ."

                        withCredentials([usernamePassword(credentialsId: 'docker_creds', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                            sh "echo \$DOCKER_PASS | docker login -u \$DOCKER_USER --password-stdin"
                        }

                        sh "docker push ${imageTag}"
                    }
                }
            }
        }

        stage('Deploy to Kubernetes') {
            when {
    anyOf {
        branch 'main'
        branch 'develop'
    }
}

            steps {
                sh 'kubectl apply -f k8s/'
            }
        }
    }
}
