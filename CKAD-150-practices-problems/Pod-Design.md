# Pod Design 
Practice questions based on these concepts

* Understand how to use Labels, Selectors and Annotations
* Understand Deployments and how to perform rolling updates
* Understand Deployments and how to perform rollbacks
* Understand Jobs and CronJobs

36. Get the pods with label information
```shell=
kubectl get pods --show-labels
```
37. Create 5 nginx pods in which two of them is labeled env=prod and three of them is labeled env=dev
```shell=
kubectl run nginx-dev1 --image=nginx --restart=Never --labels=env=dev
kubectl run nginx-dev2 --image=nginx --restart=Never --labels=env=dev
kubectl run nginx-dev3 --image=nginx --restart=Never --labels=env=dev
kubectl run nginx-prod1 --image=nginx --restart=Never --labels=env=prod
kubectl run nginx-prod2 --image=nginx --restart=Never --labels=env=prod
```
38. Verify all the pods are created with correct labels
```shell=
kubectl get pods --show-labels
```
39. Get the pods with label env=dev
```shell=
kubectl get pods -l env=dev
```
40. Get the pods with label env=dev and also output the labels
```shell=
kubectl get pods -l env=dev --show-labels
```
41. Get the pods with label env=prod
```shell=
kubectl get pods -l env=prod
```
42. Get the pods with label env=prod and also output the labels
```shell=
kubectl get pods -l env=prod --show-labels
```
43. Get the pods with label env
```shell=
kubectl get pods -L env
```
44. Get the pods with labels env=dev and env=prod
```shell=
kubectl get pods -l 'env in (dev,prod)'
```
45. Get the pods with labels env=dev and env=prod and output the labels as well
```shell=
kubectl get pods -l 'env in (dev,prod)' --show-labels
```
46. Change the label for one of the pod to env=uat and list all the pods to verify
```shell=
kubectl label pod/nginx-dev3 env=uat --overwrite
kubectl get pods --show-labels
```
47. Remove the labels for the pods that we created now and verify all the labels are removed
```shell=
kubectl label pod nginx-dev{1..3} env-
kubectl label pod nginx-prod{1..2} env-
kubectl get po --show-labels
```
48. Let’s add the label app=nginx for all the pods and verify
```shell=
kubectl label pod nginx-dev{1..3} app=nginx
kubectl label pod nginx-prod{1..2} app=nginx
kubectl get po --show-labels
```
49. Get all the nodes with labels (if using minikube you would get only master node)
```shell=
kubectl get nodes --show-labels
```
50. Label the node (minikube if you are using) nodeName=nginxnode
```shell=
kubectl label node minikube nodeName=nginxnode
```
51. Create a Pod that will be deployed on this node with the label nodeName=nginxnode
```shell=
kubectl run nginx --image=nginx --restart=Never --dry-run -o yaml > pod.yaml
// add the nodeSelector like below and create the pod
kubectl create -f pod.yaml
```
```yaml=
apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    run: nginx
  name: nginx
spec:
  nodeSelector:
    nodeName: nginxnode
  containers:
  - image: nginx
    name: nginx
    resources: {}
  dnsPolicy: ClusterFirst
  restartPolicy: Never
status: {}
```
52.  Verify the pod that it is scheduled with the node selector
```shell=
kubectl describe po nginx | grep Node-Selectors
```
53. Verify the pod nginx that we just created has this label
```shell=
kubectl describe po nginx | grep Labels
```
54. Annotate the pods with name=webapp
```shell=
kubectl annotate pod nginx-dev{1..3} name=webapp
kubectl annotate pod nginx-prod{1..2} name=webapp
```
55. Verify the pods that have been annotated correctly
```shell=
kubectl describe po nginx-dev{1..3} | grep -i annotations
kubectl describe po nginx-prod{1..2} | grep -i annotations
```
56. Remove the annotations on the pods and verify
```shell=
kubectl annotate pod nginx-dev{1..3} name-
kubectl annotate pod nginx-prod{1..2} name-
kubectl describe po nginx-dev{1..3} | grep -i annotations
kubectl describe po nginx-prod{1..2} | grep -i annotations
```
57. Remove all the pods that we created so far
```shell=
kubectl delete po --all
```
58. Create a deployment called webapp with image nginx with 5 replicas
```shell=
kubectl create deploy webapp --image=nginx --dry-run -o yaml > webapp.yaml
// change the replicas to 5 in the yaml and create it
kubectl create -f webapp.yaml
```
```yaml=
apiVersion: apps/v1
kind: Deployment
metadata:
  creationTimestamp: null
  labels:
    app: webapp
  name: webapp
spec:
  replicas: 5
  selector:
    matchLabels:
      app: webapp
  strategy: {}
  template:
    metadata:
      creationTimestamp: null
      labels:
        app: webapp
    spec:
      containers:
      - image: nginx
        name: nginx
        resources: {}
status: {}
```
59.  Get the deployment you just created with labels
```shell=
kubectl get deploy webapp --show-labels
```
60. Output the yaml file of the deployment you just created
```shell=
kubectl get deploy webapp -o yaml
```
61. Get the pods of this deployment
```shell=
// get the label of the deployment
kubectl get deploy --show-labels
// get the pods with that label
kubectl get pods -l app=webapp
```
62. Scale the deployment from 5 replicas to 20 replicas and verify
```shell=
kubectl scale deploy webapp --replicas=20
kubectl get po -l app=webapp
```
63. Get the deployment rollout status
```shell=
kubectl rollout status deploy webapp
```
64. Get the replicaset that created with this deployment
```shell=
kubectl get rs -l app=webapp
```
65. Get the yaml of the replicaset and pods of this deployment
```shell=
kubectl get rs -l app=webapp -o yaml
kubectl get po -l app=webapp -o yaml
```
66. Delete the deployment you just created and watch all the pods are also being deleted
```shell=
kubectl delete deploy webapp
kubectl get po -l app=webapp -w
```
67. Create a deployment of webapp with image nginx:1.17.1 with container port 80 and verify the image version
```shell=
kubectl create deploy webapp --image=nginx:1.17.1 --dry-run -o yaml > webapp.yaml
// add the port section and create the deployment
kubectl create -f webapp.yaml
// verify
kubectl describe deploy webapp | grep Image
```
```yaml=
apiVersion: apps/v1
kind: Deployment
metadata:
  creationTimestamp: null
  labels:
    app: webapp
  name: webapp
spec:
  replicas: 1
  selector:
    matchLabels:
      app: webapp
  strategy: {}
  template:
    metadata:
      creationTimestamp: null
      labels:
        app: webapp
    spec:
      containers:
      - image: nginx:1.17.1
        name: nginx
        ports:
        - containerPort: 80
        resources: {}
status: {}
```
68. Update the deployment with the image version 1.17.4 and verify
```shell=
kubectl set image deploy/webapp nginx=nginx:1.17.4
kubectl describe deploy webapp | grep Image
```
69. Check the rollout history and make sure everything is ok after the update
```shell=
kubectl rollout history deploy webapp
kubectl get deploy webapp --show-labels
kubectl get rs -l app=webapp
kubectl get po -l app=webapp
```
70. Undo the deployment to the previous version 1.17.1 and verify Image has the previous version
```shell=
kubectl rollout undo deploy webapp
kubectl describe deploy webapp | grep Image
```
71. Update the deployment with the image version 1.16.1 and verify the image and also check the rollout history
```shell=
kubectl set image deploy/webapp nginx=nginx:1.16.1
kubectl describe deploy webapp | grep Image
kubectl rollout history deploy webapp
```
72. Update the deployment to the Image 1.17.1 and verify everything is ok
```shell=
kubectl rollout undo deploy webapp --to-revision=3
kubectl describe deploy webapp | grep Image
kubectl rollout status deploy webapp
```
73. Update the deployment with the wrong image version 1.100 and verify something is wrong with the deployment
```shell=
kubectl set image deploy/webapp nginx=nginx:1.100
kubectl rollout status deploy webapp (still pending state)
kubectl get pods (ImagePullErr)
```
74. Undo the deployment with the previous version and verify everything is Ok
```shell=
kubectl rollout undo deploy webapp
kubectl rollout status deploy webapp
kubectl get pods
```
75. Check the history of the specific revision of that deployment
```shell=
kubectl rollout history deploy webapp --revision=7
```
76. Pause the rollout of the deployment
```shell=
kubectl rollout pause deploy webapp
```
77. Update the deployment with the image version latest and check the history and verify nothing is going on
```shell=
kubectl set image deploy/webapp nginx=nginx:latest
kubectl rollout history deploy webapp (No new revision)
```
78. Resume the rollout of the deployment
```shell=
kubectl rollout resume deploy webapp
```
79. Check the rollout history and verify it has the new version
```shell=
kubectl rollout history deploy webapp
kubectl rollout history deploy webapp --revision=9
```
80. Apply the autoscaling to this deployment with minimum 10 and maximum 20 replicas and target CPU of 85% and verify hpa is created and replicas are increased to 10 from 1
```shell=
kubectl autoscale deploy webapp --min=10 --max=20 --cpu-percent=85
kubectl get hpa
kubectl get pod -l app=webapp
```
81. Clean the cluster by deleting deployment and hpa you just created
```shell=
kubectl delete deploy webapp
kubectl delete hpa webapp
```
82. Create a Job with an image node which prints node version and also verifies there is a pod created for this job
```shell=
kubectl create job nodeversion --image=node -- node -v
kubectl get job -w
kubectl get pod
```
83. Get the logs of the job just created
```shell=
kubectl logs <pod name> // created from the job
```
84. Output the yaml file for the Job with the image busybox which echos “Hello I am from job”
```shell=
kubectl create job hello-job --image=busybox --dry-run -o yaml -- echo "Hello I am from job"
```
85. Copy the above YAML file to hello-job.yaml file and create the job
```shell=
kubectl create job hello-job --image=busybox --dry-run -o yaml -- echo "Hello I am from job" > hello-job.yaml
kubectl create -f hello-job.yaml
```
86. Verify the job and the associated pod is created and check the logs as well
```shell=
kubectl get job
kubectl get po
kubectl logs hello-job-*
```
87. Delete the job we just created
```shell=
kubectl delete job hello-job
```
88. Create the same job and make it run 10 times one after one
```shell=
kubectl create job hello-job --image=busybox --dry-run -o yaml -- echo "Hello I am from job" > hello-job.yaml
// edit the yaml file to add completions: 10
kubectl create -f hello-job.yaml
```
```yaml=
apiVersion: batch/v1
kind: Job
metadata:
  creationTimestamp: null
  name: hello-job
spec:
  completions: 10
  template:
    metadata:
      creationTimestamp: null
    spec:
      containers:
      - command:
        - echo
        - Hello I am from job
        image: busybox
        name: hello-job
        resources: {}
      restartPolicy: Never
status: {}
```
89. Watch the job that runs 10 times one by one and verify 10 pods are created and delete those after it’s completed
```shell=
kubectl get job -w
kubectl get po
kubectl delete job hello-job
```
90. Create the same job and make it run 10 times parallel
```shell=
kubectl create job hello-job --image=busybox --dry-run -o yaml -- echo "Hello I am from job" > hello-job.yaml
// edit the yaml file to add parallelism: 10
kubectl create -f hello-job.yaml
```
```yaml=
apiVersion: batch/v1
kind: Job
metadata:
  creationTimestamp: null
  name: hello-job
spec:
  parallelism: 10
  template:
    metadata:
      creationTimestamp: null
    spec:
      containers:
      - command:
        - echo
        - Hello I am from job
        image: busybox
        name: hello-job
        resources: {}
      restartPolicy: Never
status: {}
view raw
```
1.  Watch the job that runs 10 times parallelly and verify 10 pods are created and delete those after it’s completed
```shell=
kubectl get job -w
kubectl get po
kubectl delete job hello-job
```
92. Create a Cronjob with busybox image that prints date and hello from kubernetes cluster message for every minute
```shell=
kubectl create cronjob date-job --image=busybox --schedule="*/1 * * * *" -- bin/sh -c "date; echo Hello from kubernetes cluster"
```
93. Output the YAML file of the above cronjob
```shell=
kubectl get cj date-job -o yaml
```
94. Verify that CronJob creating a separate job and pods for every minute to run and verify the logs of the pod
```shell=
kubectl get job
kubectl get po
kubectl logs date-job-<jobid>-<pod>
```
95. Delete the CronJob and verify all the associated jobs and pods are also deleted.
```shell=
kubectl delete cj date-job
// verify pods and jobs
kubectl get po
kubectl get job
```