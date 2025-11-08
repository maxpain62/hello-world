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
      image: maxpain62/docker-awscli2.0:1.0.0
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
  volumes:
    - name: maven-cache
      emptyDir: {}
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
        stage ('print tag') {
          container ('maven') {
            echo "Latest Tag = ${env.LATEST_TAG}"
          }
        }
    }
}
