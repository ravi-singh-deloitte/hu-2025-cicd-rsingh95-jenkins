pipeline {
    agent any

    environment {
        IMAGE_NAME = "hu-2025-docker-rsingh95-backend:v1"
        REGISTRY_IMAGE = "localhost:5000/hu-2025-docker-rsingh95-backend:v1"
    }

    triggers {
        cron('H/5 * * * *')
    }

    stages {
        stage('Build Docker Image') {
            steps {
                sh 'docker build -t $IMAGE_NAME .'
            }
        }
        stage('Tag Image for Private Registry') {
            steps {
                sh 'docker tag $IMAGE_NAME $REGISTRY_IMAGE'
            }
        }
        stage('Push to Local Registry') {
            steps {
                sh 'docker push $REGISTRY_IMAGE'
            }
        }
    }
}