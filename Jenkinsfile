def component = [
    vtw: false
]

pipeline {
    agent any
    stages {
        stage("Checkout") {
            steps {
                checkout scm
            }
        }
        stage("Build and Push") {
            steps {
                script {
                    component.each { entry ->
                        if (entry.value) {
                            def componentName = entry.key.toLowerCase()
                            stage("Build ${componentName.capitalize()}") {
                                sh "docker-compose build ${componentName}"
                            }
                            stage("Push ${componentName.capitalize()}") {
                                withCredentials([[$class: 'UsernamePasswordMultiBinding',
                                    credentialsId: 'docker_credentials',
                                    usernameVariable: 'kys513',
                                    passwordVariable: 'requiem513!'
                                ]]) {
                                    sh "docker tag spaceship_pipeline_${componentName}:latest kys/vtw_${componentName}:${BUILD_NUMBER}"
                                    sh "docker login -u kys513 -p requiem513!"
                                    sh "docker push kys/vtw_${componentName}:${BUILD_NUMBER}"
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
