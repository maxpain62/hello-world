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
    - name: aws-container
      image: amazon/aws-cli
      imagePullPolicy: Always
      command:
        - /bin/sh
        - -c
        - aws codeartifact get-authorization-token --domain test --domain-owner 134448505602 --region ap-south-1
      resources:
        limits:
          memory: "100Mi"
          cpu: "150m"
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
            echo "Running on node: ${env.NODE_NAME}"
            echo "value of POD_LABEL is: ${env.POD_LABEL}"
            git branch: 'master', url: 'https://github.com/maxpain62/hello-world.git'
            ls -l
        }
        stage ('aws code artifact token') {
          container ('aws-container') {
            sh 'aws --version'
            stash includes: '/token.txt', name: 'token.txt'
          }
        }
        stage ('unstash token') {
          container ('maven') {
            unstash 'token.txt'
            sh 'CODEARTIFACT_AUTH_TOKEN=$(cat token.txt) && export $CODEARTIFACT_AUTH_TOKEN && echo $CODEARTIFACT_AUTH_TOKEN'
          }
        }
        stage ('build') {
            container ('maven') {
                sh 'mvn clean install'
                stash includes: 'webapp/target/webapp.war', name: 'webapp.war'
            }
        }
        echo "✅ Pipeline completed successfully inside K8s Pod"
    }
}
