pipeline {
	agent any
	stages {


		stage('Lint HTML') {
			steps {
				sh '''
				    tidy -q -e ./blue/*.html
				    tidy -q -e ./green/*.html
				   '''
			}
		}

        stage('Build Docker image') {
            steps{
                sh '''
                    docker build -t thrld/capstone .
                    docker tag thrld/capstone thrld/capstone
                   '''
            }
        }

		stage('Push Image To DockerHub') {
			steps {
			    withCredentials([usernamePassword(credentialsId: 'dockerhub', passwordVariable: 'DOCKERHUB_PWD', usernameVariable: 'DOCKERHUB_USR')]) {
					sh '''
                        docker login -u $DOCKERHUB_USR -p $DOCKERHUB_PWD"
						docker push thrld/capstone
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
