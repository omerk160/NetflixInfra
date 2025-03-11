pipeline {
    agent any

    parameters {
        string(name: 'SERVICE_NAME', defaultValue: 'netflix-frontend', description: 'Name of the service (directory name)')
        string(name: 'IMAGE_FULL_NAME_PARAM', defaultValue: '', description: 'Full Docker image name including tag')
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
                    def yamlFile = "${params.SERVICE_NAME}/${params.SERVICE_NAME}-deploy.yaml"
                    def image = "${params.IMAGE_FULL_NAME_PARAM}"

                    if (!image?.trim()) {
                        error("IMAGE_FULL_NAME_PARAM parameter is required!")
                    }

                    // Update image field using sed
                    sh """
                        sed -i 's|image: .*|image: ${image}|' ${yamlFile}
                    """

                    // Commit changes
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
    }

    post {
        always {
            cleanWs()
        }
    }
}
