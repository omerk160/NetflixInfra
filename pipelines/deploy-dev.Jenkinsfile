pipeline {
    agent any

    environment {
        GIT_REPO = "https://github.com/omerk160/NetflixInfra.git"
        BRANCH = "dev"
        IMAGE_TAG = "omer160/netflix-frontend-dev:v1.0.7"
        YAML_FILE = "k8s/dev/NetflixFrontend/netflix-frontend-deploy.yaml"
    }

    stages {
        stage('Checkout Code') {
            steps {
                git branch: "${BRANCH}", credentialsId: 'github-token', url: "${GIT_REPO}"
            }
        }

        stage('Git Setup') {
            steps {
                script {
                    sh '''
                        git config --global user.email "jenkins@yourcompany.com"
                        git config --global user.name "Jenkins"
                    '''
                }
            }
        }

        stage('Update YAML manifest') {
            steps {
                script {
                    sh '''
                        if [ -f ${YAML_FILE} ]; then
                            sed -i "s|image: .*|image: ${IMAGE_TAG}|" ${YAML_FILE}
                            git add ${YAML_FILE}
                            git commit -m "Update NetflixFrontend image to ${IMAGE_TAG}"
                        else
                            echo "YAML file not found!"
                            exit 1
                        fi
                    '''
                }
            }
        }

        stage('Git Push') {
            steps {
                withCredentials([string(credentialsId: 'github-token', variable: 'GITHUB_TOKEN')]) {
                    script {
                        sh '''
                            git push https://${GITHUB_TOKEN}@github.com/omerk160/NetflixInfra.git ${BRANCH}
                        '''
                    }
                }
            }
        }
    }

    post {
        failure {
            cleanWs()
        }
        success {
            echo "Deployment update pushed successfully!"
        }
    }
}
