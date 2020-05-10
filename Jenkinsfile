pipeline {
    agent any
    environment {
        dockerhubCredentials = 'dockerhubCredentials'
        CHECK_URL = "https://myurl.com/ping" //LoadBalancer Url
        CMD = "curl --write-out %{http_code} --silent --output /dev/null ${CHECK_URL}"
    }
    stages {
        stage('Lint') {
            steps {
                // Will lint python code and Dockerfile
                sh 'hadolint app/v2/Dockerfile'
                sh 'cd app/v2'
                sh 'python3 -m venv venv'
                sh '. venv/bin/activate'
                sh 'pip install --upgrade pip &&\
                        pip install -r requirements.txt'
                sh 'pylint --disable=R,C,W1203,W1309 app.py'
                sh 'cd ..'
            }
        }
        stage('Build') {
            steps {
                // Will build the image
                sh 'docker build --tag=flask-app:v2 ./app/v2'
            }
        }
        stage('Upload') {
            steps {
                // It will upload the docker registry in order to be used later by kubernetes //url: ""
                withDockerRegistry([ credentialsId: 'dockerId', url: '' ]) {
                    sh 'docker tag flask-app:v2 dantesaggin/flask-app:v2'
                    sh 'docker push dantesaggin/flask-app:v2'
                }

            }
        }
        stage('Deploy') {
            steps {
                // It will upload the docker registry in order to be used later by kubernetes
                withAWS(region:'us-west-2',credentials:'aws-static') {
                    sh 'aws eks --region us-west-2 update-kubeconfig --name capstone-project-EKS-Cluster'
                    // In a future version let the version as a parameter getting and sed into the yaml and using the same as the docker file
                    sh 'kubectl apply -f kubernetes-resources/deployment/deployment.yaml'
                    sh 'kubectl rollout status deploy flask-app-2 -w'
                    // Changing the Service
                    sh 'kubectl patch service flask-app --patch "$(cat ./kubernetes-resources/deployment/service-patch.yaml)"'
                }

            }
        }
        stage('SmokeTest') {
            steps {
                script {
                     sleep 60
//                    response = $(CMD)
//                    if (response = '200') {
//                        echo "Deploy successfull"
//                    }
//                    else {
//                        echo "Rollback Started"
//                        sh 'kubectl patch service flask-app --patch "$(cat ./kubernetes-resources/deployment/service-patch.yaml)"'
//                        exit 1
//                    }
                }
            }
        }
        stage("Cleaning Docker up") {
            steps {
                script {
                    sh "echo 'Cleaning Docker up'"
                    sh "docker system prune"
                }
            }
        }
    }
}