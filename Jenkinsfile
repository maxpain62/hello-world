podTemplate(
    yaml: """
apiVersion: v1
kind: Pod
metadata:
  labels:
    app: maven-build
spec:
  serviceAccountName: jenkins
  containers:
    - name: maven
      image: maxpain62/maven-3.9:jre11
      imagePullPolicy: Always
      command:
        - cat
      tty: true
      resources:
        limits:
          memory: "2Gi"
          cpu: "1000m"
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
        }
        stage ('build') {
            container ('maven') {
                sh 'mvn clean install'
            }
        }
        echo "✅ Pipeline completed successfully inside K8s Pod"
    }
}
