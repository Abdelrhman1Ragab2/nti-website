pipeline {
    agent any

    environment {
        // Credentials ID from AWS Credentials Plugin
        AWS_ACCESS_KEY_ID = credentials('aws-c')
        AWS_SECRET_ACCESS_KEY = credentials('aws-c')
        ECR_REPOSITORY_URI= '058264315018.dkr.ecr.eu-west-1.amazonaws.com'
        AWS_REGION = 'eu-west-1'
    }

    stages {
        stage('Build Docker Image front') {
            steps {
                sh 'docker build -t ${ECR_REPOSITORY_URI}/project-repo:${BUILD_NUMBER} .'
                sh 'aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${ECR_REPOSITORY_URI}'
                sh 'docker push ${ECR_REPOSITORY_URI}/project-repo:${BUILD_NUMBER}'
            }
        }
        stage('Build Docker Image back') {
            steps {
                sh 'docker build -t ${ECR_REPOSITORY_URI}/my-ecr-repo:${BUILD_NUMBER} .'
                sh 'aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${ECR_REPOSITORY_URI}'
                sh 'docker push ${ECR_REPOSITORY_URI}/my-ecr-repo:${BUILD_NUMBER}'
            }
        }
        stage('kube edit files') {
            steps {
                 script {
                    def backendFile = './backend/backend.yaml'
                    def frontFile = './frontend/frontend.yaml'
                     
                    def newImageNameFront = '${ECR_REPOSITORY_URI}/project-repo:${BUILD_NUMBER}'
                    def newImageNameBack = '${ECR_REPOSITORY_URI}/my-ecr-repo:${BUILD_NUMBER}'
                    

                    // Use sh block to execute shell commands
                    sh """
                        sed -i "s|image: .*$|image: ${newImageNameBack}|" ${backendFile}
                        sed -i "s|image: .*$|image: ${newImageNameFront}|" ${frontFile}
                    """
                }

            }
        }

        
        stage('kubectl aplly files') {
            steps {
                sh"cd k8s"
                sh'kubectl apply -f .'
            }
        }
    }
}
