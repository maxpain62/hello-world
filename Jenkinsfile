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
      image: maxpain62/ubuntu24:jdk11-maven3.8.6
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
            sh 'ls -l'
        }

        stage('validate java and maven') {
            container('maven') {
                sh '''
                    echo "===== Maven & Java Versions ====="
                    mvn -version
                    java -version
                    echo "===== Building Project ====="
                '''
            }
        }
        stage ('check maven access') {
            container ('maven') {
                sh '''
                echo "Checking network access..."
                curl -v https://repo.maven.apache.org/maven2/
                '''
            }
        }
        stage ('build') {
            container ('maven') {
                sh 'mvn clean package'
            }
        }
        echo "✅ Pipeline completed successfully inside K8s Pod"
    }
}
