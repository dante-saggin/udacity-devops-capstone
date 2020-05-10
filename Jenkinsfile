pipeline {
    agent any
    environment {
        CHECK_URL = "https://myurl.com/ping" //LoadBalancer Url
        CMD = "curl --write-out %{http_code} --silent --output /dev/null ${CHECK_URL}"
        VERSION = "0" // TODO: externilize this into a separeted file
        ROLLBACKTO = "0" //TODO: Get the active deployment version
    }
    stages {
        stage('Lint') {
            steps {

                script {
                    echo "Before Script"
                    env.VERSION = 'cat kubernetes-resources/deployment/revision'
                    env.ROLLBACKTO = 'cat cat kubernetes-resources/deployment/versionToRollback'
                    echo "after Script"
                }
                // Will lint python code and Dockerfile
                sh 'hadolint app/v${VERSION}/Dockerfile'
                sh '''
                cd app/v${VERSION}
                python3 -m venv venv
                . venv/bin/activate
                pip install --upgrade pip &&\
                        pip install -r requirements.txt
                pylint --disable=R,C,W1203,W1309 app.py
                deactivate
                cd ..
                '''
            }
        }
        stage('Build') {
            steps {
                // Will build the image
                sh 'docker build --tag=flask-app:v${VERSION} ./app/v${VERSION}'
            }
        }
        stage('Upload') {
            steps {
                // It will upload the docker registry in order to be used later by kubernetes //url: ""
                withDockerRegistry([ credentialsId: 'dockerId', url: '' ]) {
                    sh 'docker tag flask-app:v${VERSION} dantesaggin/flask-app:v${VERSION}'
                    sh 'docker push dantesaggin/flask-app:v${VERSION}'
                }

            }
        }
        stage('Deploy') {
            steps {
                // It will upload the docker registry in order to be used later by kubernetes
                sh 'sed -i "s/##Revision##/${VERSION}/g" kubernetes-resources/deployment/deployment.yaml'
                sh 'sed -i "s/##Revision##/${VERSION}/g" kubernetes-resources/deployment/service-patch.yaml'
                sh 'sed -i "s/##Revision##/${ROLLBACKTO}/g" kubernetes-resources/deployment/service-patch-rollback.yaml'
                withAWS(region:'us-west-2',credentials:'aws-static') {
                    sh 'aws eks --region us-west-2 update-kubeconfig --name capstone-project-EKS-Cluster'
                    // In a future version let the version as a parameter getting and sed into the yaml and using the same as the docker file
                    sh 'kubectl apply -f kubernetes-resources/deployment/deployment.yaml'
                    sh 'kubectl rollout status deploy flask-app-${VERSION} -w'
                    // Changing the Service
                    sh 'kubectl patch service flask-app --patch "$(cat ./kubernetes-resources/deployment/service-patch.yaml)"'
                }

            }
        }
        stage('SmokeTest') {
            steps {
                script {
                     sleep 60
                    response = $(CMD)
                    if (response == '200') {
                        echo "Deploy successfull"
                        withAWS(region:'us-west-2',credentials:'aws-static') {
                            sh 'aws eks --region us-west-2 update-kubeconfig --name capstone-project-EKS-Cluster'
                            sh 'kubectl delete deployment flask-app-${ROLLBACKTO}'
                            echo 'removing previous version'
                        }
                    }
                    else {
                        echo "Rollback Started"
                        withAWS(region:'us-west-2',credentials:'aws-static') {
                            sh 'aws eks --region us-west-2 update-kubeconfig --name capstone-project-EKS-Cluster'
                            sh 'kubectl patch service flask-app --patch "$(cat ./kubernetes-resources/deployment/service-patch-rollback.yaml)"'
                            sh 'kubectl delete deployment flask-app-${VERSION}'
                            echo 'removing new and failed version'
                        }
                        exit 1
                    }
                }
            }
        }
        stage("CleaningDocker") {
            steps {
                script {
                    sh "echo 'Cleaning Docker up'"
                    sh "docker system prune"
                }
            }
        }
    }
}