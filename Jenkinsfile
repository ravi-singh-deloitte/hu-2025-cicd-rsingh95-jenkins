pipeline {
    agent any

    environment {
        IMAGE_NAME = "hu-2025-docker-rsingh95-backend-5:v1"
        CONTAINER_NAME = "hu-2025-rsingh95-backend-5"
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
                    sh "docker run -d --name $CONTAINER_NAME -p 8001:5000 $REGISTRY_IMAGE"
                }
            }
        }
    }

    post {
        always {
            script {
                   wrap([$class: 'BuildUser']) {
                    office365ConnectorSend(
                        webhookUrl: 'https://deloitte.webhook.office.com/webhookb2/d6ec191f-9653-4bc6-9995-e7bc47ca8037@36da45f1-dd2c-4d1f-af13-5abe46b99921/IncomingWebhook/889dbf714cdf4437bd34a074bcaae257/ba21d169-adfc-4a72-ab8b-2a830d095170/V2YOUNwjZxExykprOuRMHKisZ77RXJckd2DyPdo-ZL4ew1',
                        status: currentBuild.currentResult,
                        message: """
                            JobName: ${env.JOB_NAME}\n
                            Build Id : ${env.BUILD_NUMBER}\n
                            Event: ${currentBuild.buildCauses.shortDescription.join(', ')}\n
                            Status: ${currentBuild.currentResult}\n
                            Actor: ${env.BUILD_USER_ID}
                            """
                    )
               }
            }
        }
    }
}