# Core Concepts

Practice questions based on these concepts:

* Understand Kubernetes API Primitives
* Create and Configure Basic Pods

1. List all the namespaces in the cluster

```shell=
kubectl get namespaces
```
or
```shell=
kubectl get ns
```

2. List all the pods in all namespaces
  
```shell=
kubectl get po -all-namespaces
```

3. List all the pods in the particular namespace
```shell=
kubectl get po -n <namespace name>
```
4. List all the services in the particular namespace
```shell=
kubectl get svc -n <namespace name>
```
5. List all the pods showing name and namespace with a json path expression
```shell=
kubectl get pods -o=jsonpath="{.items[*]['metadata.name', 'metadata.namespace']}"
```
6. Create an nginx pod in a default namespace and verify the pod running
```shell=
// creating a pod
kubectl run nginx --image=nginx --restart=Never
// List the pod
kubectl get po
```
7. Create the same nginx pod with a yaml file
```shell=
// get the yaml file with --dry-run flag
kubectl run nginx --image=nginx --restart=Never --dry-run -o yaml > nginx-pod.yaml
// cat nginx-pod.yaml
apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    run: nginx
  name: nginx
spec:
  containers:
  - image: nginx
    name: nginx
    resources: {}
  dnsPolicy: ClusterFirst
  restartPolicy: Never
status: {}
// create a pod 
kubectl create -f nginx-pod.yaml
```
8. Output the yaml file of the pod you just created
```shell=
kubectl get po nginx -o yaml
```
9. Output the yaml file of the pod you just created without the cluster-specific information
```shell=
kubectl get po nginx -o yaml --export
```
10. Get the complete details of the pod you just created
```shell=
kubectl describe pod nginx
```
11. Delete the pod you just created
```shell=
kubectl delete po nginx
kubectl delete -f nginx-pod.yaml
```
12. Delete the pod you just created without any delay (force delete)
```shell=
kubectl delete po nginx --grace-period=0 --force
```
13. Create the nginx pod with version 1.17.4 and expose it on port 80
```shell=
kubectl run nginx --image=nginx:1.17.4 --restart=Never --port=80
```
14. Change the Image version to 1.15-alpine for the pod you just created and verify the image version is updated
```shell=
kubectl set image pod/nginx nginx=nginx:1.15-alpine
kubectl describe po nginx
// another way it will open vi editor and change the version
kubectl edit po nginx
kubectl describe po nginx
```
15. Change the Image version back to 1.17.1 for the pod you just updated and observe the changes
```shell=
kubectl set image pod/nginx nginx=nginx:1.17.1
kubectl describe po nginx
kubectl get po nginx -w # watch it
```
16. Check the Image version without the describe command
```shell=
kubectl get po nginx -o jsonpath='{.spec.containers[].image}{"\n"}'
```
17. Create the nginx pod and execute the simple shell on the pod
```shell=
// creating a pod
kubectl run nginx --image=nginx --restart=Never
// exec into the pod
kubectl exec -it nginx /bin/sh
```
18. Get the IP Address of the pod you just created
```shell=
kubectl get po nginx -o wide
```
19. Create a busybox pod and run command ls while creating it and check the logs
```shell=
kubectl run busybox --image=busybox --restart=Never -- ls
kubectl logs busybox
```
20. If pod crashed check the previous logs of the pod
```shell=
kubectl logs busybox -p
```
21. Create a busybox pod with command sleep 3600
```shell=
kubectl run busybox --image=busybox --restart=Never -- /bin/sh -c "sleep 3600"
```
22. Check the connection of the nginx pod from the busybox pod
```shell=
kubectl get po nginx -o wide
// check the connection
kubectl exec -it busybox -- wget -o- <IP Address>
```
23. Create a busybox pod and echo message ‘How are you’ and delete it manually
```shell=
kubectl run busybox --image=nginx --restart=Never -it -- echo "How are you"
kubectl delete po busybox
```
24. Create a busybox pod and echo message ‘How are you’ and have it deleted immediately
```shell=
// notice the --rm flag
kubectl run busybox --image=nginx --restart=Never -it --rm -- echo "How are you"
```
25. Create an nginx pod and list the pod with different levels of verbosity
```shell=
// create a pod
kubectl run nginx --image=nginx --restart=Never --port=80
// List the pod with different verbosity
kubectl get po nginx --v=7
kubectl get po nginx --v=8
kubectl get po nginx --v=9
```
26. List the nginx pod with custom columns POD_NAME and POD_STATUS
```shell=
kubectl get po -o=custom-columns="POD_NAME:.metadata.name, POD_STATUS:.status.containerStatuses[].state"
```
27. List all the pods sorted by name
```shell=
kubectl get pods --sort-by=.metadata.name
```
28. List all the pods sorted by created timestamp
```shell=
kubectl get pods--sort-by=.metadata.creationTimestamp
```