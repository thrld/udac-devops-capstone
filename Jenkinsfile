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
			    withCredentials([usernamePassword(credentialsId: 'dockerhub', passwordVariable: 'DOCKERHUB_PWD', usernameVariable: 'DOCKERHUB_USR')]) {
					sh '''
                    ./blue_green_static_html/blue/upload_docker.sh
					'''
				}
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
