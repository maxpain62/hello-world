podTemplate(
    yaml: """
apiVersion: v1
kind: Pod
metadata:
  labels:
    app: maven-build
spec:
  serviceAccountName: code-artifact-sa
  containers:
    - name: aws
      image: amazon/aws-cli
      command:
        - cat
      tty: true
      volumeMounts:
        - name: maven-cache
          mountPath: /root/.m2
    - name: maven
      image: maxpain62/maven-3.9:jdk12
      imagePullPolicy: Always
      command:
        - cat
      tty: true
      resources:
        limits:
          memory: "500Mi"
          cpu: "250m"
      volumeMounts:
        - name: maven-cache
          mountPath: /root/.m2
    - name: kaniko
      image: gcr.io/kaniko-project/executor:latest
      args: ["--sleep"]
      volumeMounts:
        - name: ecr-config 
          mountPath: /kaniko/.docker/
          readOnly: true
  volumes:
    - name: maven-cache
      emptyDir: {}
    - name: docker
      hostPath: 
        path: /var/run/
    - name: ecr-config
      secret:
        secretName: ecr-secret
"""
) {

    node(POD_LABEL) {
        
        stage('Checkout Source') {
          git branch: 'master', url: 'https://github.com/maxpain62/hello-world.git'
          sh 'ls -l'
        }
        stage('Get Latest Tag') {
          script {
            env.LATEST_TAG = sh(
            script: "git tag --sort=-creatordate | head -1",
            returnStdout: true
            ).trim()
          }
        echo "Latest Tag = ${env.LATEST_TAG}"
        }
        stage ('read token.txt file') {
          container ('aws') {
            sh '''
              aws --version
              aws codeartifact get-authorization-token --domain test --domain-owner 134448505602 --region ap-south-1 --query authorizationToken --output text > /root/.m2/token.txt
               '''
            }
        }
        /*stage ('build') {
          container ('maven') {
            sh '''
              cp settings.xml /root/.m2/settings.xml && export TOKEN=$(cat /root/.m2/token.txt)
              sed "s|replace_me|$TOKEN|" settings-template.xml > /root/.m2/settings.xml
              mvn clean deploy
               '''
            }
        }*/
        /*stage ('download artifact') {
          container ('aws') {
            sh """
              echo "Latest Tag = ${env.LATEST_TAG}"
              echo "${env.LATEST_TAG}"
              #aws codeartifact get-package-version-asset --domain test --domain-owner 134448505602 --repository hello-world \
                --format maven --namespace com.example.maven-project --package --package-version ${env.LATEST_TAG} --asset webapp-${env.LATEST_TAG}.war
               """
          }
        }*/
        stage ('download artifact') {
          container ('aws') {
            sh """
              echo "Latest Tag = ${LATEST_TAG}"
              echo "${LATEST_TAG}"

              aws codeartifact get-package-version-asset --domain test --domain-owner 134448505602 \
              --repository hello-world --format maven --namespace com.example.maven-project \
              --package webapp --package-version ${env.LATEST_TAG} \
              --asset webapp-${env.LATEST_TAG}.war webapp-${env.LATEST_TAG}.war

              ls -l
               """
            }
        }
        stage ('create docker image') {
          container ('kaniko') {
            sh """
              sed "s|VERSION|${env.LATEST_TAG}|" Dockerfile
              cat  Dockerfile

               """
            }
        }
    }
}
