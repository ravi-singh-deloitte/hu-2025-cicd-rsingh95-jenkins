pipeline {
    agent any

    environment {
        IMAGE_NAME = "hu-2025-docker-rsingh95-backend-3:v1"
        CONTAINER_NAME = "hu-2025-rsingh95-backend-3"
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t $IMAGE_NAME .'
            }
        }

        stage('Run Tests') {
            steps {
                sh 'docker run --rm $IMAGE_NAME pytest test_app.py'
            }
        }

        stage('Tag Image for Private Registry') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'docker-creds', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
                    script {
                        def registryImage = "${USERNAME}/${IMAGE_NAME}"
                        env.REGISTRY_IMAGE = registryImage
                        sh "docker tag $IMAGE_NAME $REGISTRY_IMAGE"
                    }
                }
            }
        }

        stage('Login to Registry') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'docker-creds', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
                    sh 'echo $PASSWORD | docker login -u $USERNAME --password-stdin'
                }
            }
        }

        stage('Push to Registry') {
            steps {
                sh 'docker push $REGISTRY_IMAGE'
            }
        }

        stage('Deploy Application') {
            steps {
                script {
                    sh "docker stop $CONTAINER_NAME || true"
                    sh "docker rm $CONTAINER_NAME || true"
                    sh "docker pull $REGISTRY_IMAGE"
                    sh "docker run -d --name $CONTAINER_NAME -p 8000:5000 $REGISTRY_IMAGE"
                }
            }
        }
    }
}