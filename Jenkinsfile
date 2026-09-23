pipeline {
agent any
 
environment {
APP_NAME = "python-app"
BUILD_TAG = "${BUILD_NUMBER}"
}
 
stages {
 
stage('Checkout') {
steps {
checkout scm
}
}
 
stage('Build Docker Image') {
steps {
sh """
docker build \
-t ${APP_NAME}:${BUILD_TAG} \
-t ${APP_NAME}:latest .
"""
}
}
 
stage('Deploy Container') {
steps {
sh """
docker stop ${APP_NAME} || true
docker rm ${APP_NAME} || true
 
docker run -d \
--name ${APP_NAME} \
--restart unless-stopped \
-p 8000:8000 \
--memory=512m \
--cpus=1 \
${APP_NAME}:${BUILD_TAG}
"""
}
}
}
 
post {
always {
sh 'docker image prune -f || true'
}
}
}
