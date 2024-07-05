pipeline {
    agent any

    environment {
        DOCKER = 'image:test'
    }

    stages {
        stage('Preparar entorno') {
            steps {
                script {
                    // Asegurarse de tener Docker y Trivy instalados
                    sh 'docker --version'
                    sh 'trivy --version'
                }
            }
        }

        stage('Descargar imagen de Alpine') {
            steps {
                script {
                    // Descargar la imagen de Alpine
                    sh "docker build . -t ${env.DOCKER}"
                }
            }
        }

        stage('Analizar imagen con Trivy') {
            steps {
                script {
                    // Analizar la imagen descargada con Trivy
                    sh "trivy image ${env.DOCKER}"
                }
            }
        }
    }

    post {
        always {
            // Limpiar recursos después del pipeline
            sh "docker rmi ${env.DOCKER}"
        }
    }
}
