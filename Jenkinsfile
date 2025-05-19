pipeline {
    agent any

    environment {
        IMAGE_NAME = "hu-2025-docker-rsingh95-backend:v1"
        REGISTRY_IMAGE = "placeholder/hu-2025-docker-rsingh95-backend:v1" 
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
                        env.REGISTRY_IMAGE = "${USERNAME}/hu-2025-docker-rsingh95-backend:v1"
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
    }
}