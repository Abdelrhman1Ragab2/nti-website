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
               
                 sh 'docker build -t ${ECR_REPOSITORY_URI}/project-repo:${BUILD_NUMBER} ./frontend/.'
                 sh 'aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${ECR_REPOSITORY_URI}'
                 sh 'docker push ${ECR_REPOSITORY_URI}/project-repo:${BUILD_NUMBER}'
             }
         }
         stage('Build Docker Image back') {
             steps {
                 sh 'docker build -t ${ECR_REPOSITORY_URI}/my-ecr-repo:${BUILD_NUMBER} ./backend/.'
                 sh 'aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${ECR_REPOSITORY_URI}'
                 sh 'docker push ${ECR_REPOSITORY_URI}/my-ecr-repo:${BUILD_NUMBER}'
             }
         }
         stage('Kubernetes Edit Files') {
             steps {
                    sh "sed -i 's|image:.*|image: ${ECR_REPOSITORY_URI}/my-ecr-repo:${BUILD_NUMBER}|g' ./backend.yaml"
                    sh "sed -i 's|image:.*|image: ${ECR_REPOSITORY_URI}/project-repo:${BUILD_NUMBER}|g' ./frontend.yaml"
                      sh "aws eks update-kubeconfig --region eu-west-1 --name nti "
             }
        }

        
        stage('apply database') {
            steps {
             
                 sh 'kubectl apply -f secret.yaml '  
                 sh 'kubectl apply -f configmap.yaml '
                 sh 'kubectl apply -f postgress_serves.yaml '
                 sh 'kubectl apply -f postgress.yaml '  
            }
        }

        stage('apply backend') {
            steps {
                  sh 'kubectl apply -f backend.yaml '  
                  sh 'kubectl apply -f backend_service.yaml '  
            }
        }

        stage('apply frontend') {
            steps {
                sh 'kubectl apply -f frontend.yaml '  
                sh 'kubectl apply -f frontend_service.yml '  
            }
        }

    }
}
