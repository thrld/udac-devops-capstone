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


		stage('Wait for user approval') {
            steps {
                input "Ready to redirect traffic to green?"
            }
        }

        stage('Done') {
            steps {
                sh 'echo "Done!"'
            }
         }
	}
}
