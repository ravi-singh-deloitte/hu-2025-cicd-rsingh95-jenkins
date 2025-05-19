pipeline {
    agent any

    environment {
        IMAGE_NAME = "hu-2025-docker-rsingh95-backend-1:v1"
    }

    triggers {
        cron('H/5 * * * *')
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

        stage('Tag Image for Private Registry') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'docker-creds', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
                    script {
                        env.REGISTRY_IMAGE = "${USERNAME}/hu-2025-docker-rsingh95-backend-1:v1"
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
                script {
                    sh "docker push $REGISTRY_IMAGE"
                }
            }
        }
    }
}