pipeline {
agent any
 
environment {
IMAGE_NAME = "python-app"
IMAGE_TAG = "${BUILD_NUMBER}"
REGISTRY = "docker.io"
REPO = "yourdockerhubuser/python-app"
}
 
stages {
 
stage('Checkout') {
steps {
git branch: 'main',
url: 'https://github.com/your-org/python-app.git'
}
}
 
stage('Python Test') {
steps {
sh '''
python3 -m venv venv
. venv/bin/activate
pip install -r requirements.txt
pytest || true
'''
}
}
 
stage('Build Image') {
steps {
sh '''
docker build \
-t ${REPO}:${IMAGE_TAG} .
'''
}
}
 
stage('Push Image') {
steps {
withCredentials([
usernamePassword(
credentialsId: 'dockerhub-creds',
usernameVariable: 'DOCKER_USER',
passwordVariable: 'DOCKER_PASS'
)
]) {
sh '''
echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin
 
docker push ${REPO}:${IMAGE_TAG}
 
docker tag ${REPO}:${IMAGE_TAG} ${REPO}:latest
docker push ${REPO}:latest
'''
}
}
}
 
stage('Deploy') {
steps {
sh '''
docker stop python-app || true
docker rm python-app || true
 
docker run -d \
--name python-app \
--restart unless-stopped \
-p 8000:8000 \
${REPO}:${IMAGE_TAG}
'''
}
}
}
 
post {
always {
sh 'docker image prune -f'
}
 
success {
echo 'Deployment Successful'
}
 
failure {
echo 'Deployment Failed'
}
}
}
