pipeline {
	agent any

	environment {
	    DOCKERHUB_USR = 'thrld'
	}

	stages {


		stage('Lint HTML') {
			steps {
				sh '''
				    tidy -q -e ./blue_green_static_html/blue/*.html
				    tidy -q -e ./blue_green_static_html/green/*.html
				   '''
			}
		}

        stage('Build Docker images') {
            steps{
                sh '''
                    cd ./blue_green_static_html/blue
                    docker build --tag=$DOCKERHUB_USR/blueimage .
                    docker image ls

                    cd ../green
                    docker build --tag=$DOCKERHUB_USR/greenimage .
                    docker image ls
                   '''
            }
        }

        stage('Login to DockerHub') {
            steps {
                withCredentials([string(credentialsId: 'docker-pwd', variable: 'DOCKERHUB_PWD')]) {
                    sh 'docker login -u $DOCKERHUB_USR -p $DOCKERHUB_PWD'
                }
            }
        }

		stage('Push images To DockerHub') {
			steps {
					sh '''
                    docker push $DOCKERHUB_USR/blueimage
                    docker push $DOCKERHUB_USR/greenimage
					'''
			}
		}

		stage('Set current kubectl context') {
			steps {
				withAWS(region:'us-east-2', credentials:'aws-static') {
					sh '''
						kubectl config current-context
					'''
				}
			}
		}
		stage('Deploy blue container') {
			steps {
				withAWS(region:'us-eest-2', credentials:'aws-static') {
					sh '''
						kubectl apply -f ./blue_green_static_html/blue/blue-controller.json
					'''
				}
			}
		}

		stage('Deploy green container') {
			steps {
				withAWS(region:'us-east-2', credentials:'aws-static') {
					sh '''
						kubectl apply -f ./blue_green_static_html/green/green-controller.json
					'''
				}
			}
		}

		stage('Wait for user approval') {
            steps {
                input "Ready to redirect traffic to green?"
            }
        }

		stage('Switch to green') {
			steps {
				withAWS(region:'us-east-2', credentials:'aws-static') {
					sh '''
						kubectl apply -f ./blue_green_static_html/green-service.json
					'''
				}
			}
		}

        stage('Done') {
            steps {
                sh 'echo "Done!"'
            }
        }

	}
}
