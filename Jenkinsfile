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
        - sleep 
        - 180s
      tty: true
      volumeMounts:
        - name: maven-cache
          mountPath: /root/.m2
    - name: maven
      image: maxpain62/maven-3.9:jre11
      imagePullPolicy: Always
      command:
        - cat
      tty: true
      resources:
        limits:
          memory: "200Mi"
          cpu: "150m"
      volumeMounts:
        - name: maven-cache
          mountPath: /root/.m2
  volumes:
    - name: maven-cache
      emptyDir: {}
"""
) {

    node(POD_LABEL) {
        stage('Checkout Source') {
            git branch: 'master', url: 'https://github.com/maxpain62/hello-world.git'
            ls -l
        }
        stage ('read token.txt file') {
          container('aws') {
                sh '''
                    aws codeartifact get-authorization-token \
                        --domain test \
                        --domain-owner 134448505602 \
                        --region ap-south-1 \
                        --query authorizationToken \
                        --output text > /root/.m2/token.txt
                '''
            }
        }
        stage ('dummy build') {
          container ('maven') {
            sh 'CODEARTIFACT_AUTH_TOKEN=$(cat /root/.m2/token.txt) && echo $CODEARTIFACT_AUTH_TOKEN'
          }
        }
    }
}
