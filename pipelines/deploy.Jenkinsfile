pipeline {
    agent any

    parameters {
        string(name: 'SERVICE_NAME', defaultValue: 'NetflixFrontend', description: 'Name of the service (directory name)')
        string(name: 'IMAGE_FULL_NAME_PARAM', defaultValue: 'omerk160/nf:latest', description: 'Full Docker image name including tag')
    }

    stages {
        stage('Git setup') {
            steps {
                sh 'git checkout -b main || git checkout main'
            }
        }

        stage('Update YAML manifest') {
            steps {
                script {
                    def yamlFile = "K8s/${params.SERVICE_NAME}/netflix-frontend-deploy.yaml"
                    def image = params.IMAGE_FULL_NAME_PARAM ?: 'omerk160/nf:latest'

                    sh """
                        if [ -f "${yamlFile}" ]; then
                            sed -i 's|image: .*|image: ${image}|' ${yamlFile}
                        else
                            echo "ERROR: ${yamlFile} not found!"
                            exit 1
                        fi
                    """

                    sh """
                        git config --global user.email "jenkins@yourcompany.com"
                        git config --global user.name "Jenkins"
                        git add ${yamlFile}
                        git commit -m "Update ${params.SERVICE_NAME} image to ${params.IMAGE_FULL_NAME_PARAM}"
                    """
                }
            }
        }

        stage('Git push') {
            steps {
                withCredentials([
                    usernamePassword(credentialsId: 'github', usernameVariable: 'GITHUB_USERNAME', passwordVariable: 'GITHUB_TOKEN')
                ]) {
                    sh 'git push https://$GITHUB_TOKEN@github.com/omerk160/NetflixInfra.git main'
                }
            }
        }

        stage('Trigger Deploy') {
            steps {
                build job: 'NetflixDeployPipeline', wait: false, parameters: [
                    string(name: 'SERVICE_NAME', value: params.SERVICE_NAME),
                    string(name: 'IMAGE_FULL_NAME_PARAM', value: params.IMAGE_FULL_NAME_PARAM)
                ]
            }
        }
    }

    post {
        cleanup {
            cleanWs()
        }
    }
}
pipeline {
    agent any

    parameters {
        string(name: 'SERVICE_NAME', defaultValue: 'NetflixFrontend', description: 'Name of the service (directory name)')
        string(name: 'IMAGE_FULL_NAME_PARAM', defaultValue: 'omerk160/nf:latest', description: 'Full Docker image name including tag')
    }

    stages {
        stage('Git setup') {
            steps {
                sh 'git checkout -b main || git checkout main'
            }
        }

        stage('Update YAML manifest') {
            steps {
                script {
                    def yamlFile = "K8s/${params.SERVICE_NAME}/netflix-frontend-deploy.yaml"
                    def image = params.IMAGE_FULL_NAME_PARAM ?: 'omerk160/nf:latest'

                    sh """
                        if [ -f "${yamlFile}" ]; then
                            sed -i 's|image: .*|image: ${image}|' ${yamlFile}
                        else
                            echo "ERROR: ${yamlFile} not found!"
                            exit 1
                        fi
                    """

                    sh """
                        git config --global user.email "jenkins@yourcompany.com"
                        git config --global user.name "Jenkins"
                        git add ${yamlFile}
                        git commit -m "Update ${params.SERVICE_NAME} image to ${params.IMAGE_FULL_NAME_PARAM}"
                    """
                }
            }
        }

        stage('Git push') {
            steps {
                withCredentials([
                    usernamePassword(credentialsId: 'github', usernameVariable: 'GITHUB_USERNAME', passwordVariable: 'GITHUB_TOKEN')
                ]) {
                    sh 'git push https://$GITHUB_TOKEN@github.com/omerk160/NetflixInfra.git main'
                }
            }
        }

        stage('Trigger Deploy') {
            steps {
                build job: 'NetflixDeployPipeline', wait: false, parameters: [
                    string(name: 'SERVICE_NAME', value: params.SERVICE_NAME),
                    string(name: 'IMAGE_FULL_NAME_PARAM', value: params.IMAGE_FULL_NAME_PARAM)
                ]
            }
        }
    }

    post {
        cleanup {
            cleanWs()
        }
    }
}
