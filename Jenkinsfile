pipeline {  
    agent any  
  
    environment {  
        IMAGE_NAME = "hu-2025-docker-rsingh95-backend:v1"  
        REGISTRY_IMAGE = "ravisingh66/hu-2025-docker-rsingh95-backend:v1"  
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
                sh 'docker tag $IMAGE_NAME $REGISTRY_IMAGE'  
            }  
        }  
  
        stage('Login to Registry') {  
            steps {  
                withCredentials([usernamePassword(credentialsId: 'docker-creds', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {  
                    sh 'echo $PASSWORD | docker login localhost:5000 -u $USERNAME --password-stdin || true'  
                }  
            }  
        }  
  
        stage('Push to Local Registry') {  
            steps {  
                sh 'docker push $REGISTRY_IMAGE'  
            }  
        }  
    }  
}