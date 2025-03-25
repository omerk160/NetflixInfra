pipeline {
    agent { label 'agent1' }
    environment {
        GITHUB_CREDENTIALS = credentials('github')
    }
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Git setup') {
            steps {
                script {
                    sh 'git config --global user.email "jenkins@yourcompany.com"'
                    sh 'git config --global user.name "Jenkins"'
                    sh 'git checkout -b dev || git checkout dev'
                }
            }
        }

        stage('Update YAML manifest') {
            steps {
                script {
                    sh '[ -f k8s/dev/NetflixFrontend/netflix-frontend-deploy.yaml ] && sed -i "s|image: .*|image: omerk160/netflix-frontend-dev:v1.0.7|" k8s/dev/NetflixFrontend/netflix-frontend-deploy.yaml'
                    sh 'git add k8s/dev/NetflixFrontend/netflix-frontend-deploy.yaml'
                    sh 'git commit -m "Update NetflixFrontend image to omerk160/netflix-frontend-dev:v1.0.7"'
                }
            }
        }

        stage('Git push') {
            steps {
                withCredentials([string(credentialsId: 'github-token', variable: 'GITHUB_TOKEN')]) {
                    script {
                        sh 'git push https://$GITHUB_TOKEN@github.com/omerk160/NetflixInfra.git dev'
                    }
                }
            }
        }
    }

    post {
        cleanup {
            cleanWs()
        }
    }
}