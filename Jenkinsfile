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
            git branch: 'master', url: 'https://github.com/yankils/hello-world.git'
        }
        echo "✅ Pipeline completed successfully inside K8s Pod"
    }
}
