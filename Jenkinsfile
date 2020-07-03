pipeline {
	agent any
	stages {


		stage('Lint HTML') {
			steps {
				sh '''
				    tidy -q -e ./blue_green_static_html/blue/*.html
				    tidy -q -e ./blue_green_static_html/green/*.html
				   '''
			}
		}

        stage('Build Docker image') {
            steps{
                sh '''
                    cd ./blue_green_static_html/blue
                    docker build --tag=thrld/blueimage .
                    docker image ls
                   '''
            }
        }

        stage('Login to dockerhub') {
            steps {
                withCredentials([string(credentialsId: 'docker-pwd', variable: 'DOCKERHUB_PWD')]) {
                    sh 'docker login -u thrld -p ${DOCKERHUB_PWD}'
                }
            }
        }

		stage('Push Image To DockerHub') {
			steps {
					sh '''
                    DOCKER_USER=thrld
                    IMAGE_NAME=blueimage
                    DOCKER_PATH=$DOCKER_USER/$IMAGE_NAME

                    echo "Docker ID and Image: $DOCKER_PATH"

                    # Push image to a docker repository
                    docker push $DOCKER_PATH
					'''
			}
		}


		stage('Wait user approve') {
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
