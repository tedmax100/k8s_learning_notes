# Services and Networking
Practice questions based on these concepts

* Understand Services
* Demonstrate a basic understanding of NetworkPolicies

144. Create an nginx pod with a yaml file with label my-nginx and expose the port 80
```shell=
kubectl run nginx --image=nginx --restart=Never --port=80 --dry-run -o yaml > nginx.yaml
// edit the label app: my-nginx and create the pod
kubectl create -f nginx.yaml
```
```yaml=
apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    app: my-nginx
  name: nginx
spec:
  containers:
  - image: nginx
    name: nginx
    ports:
    - containerPort: 80
    resources: {}
  dnsPolicy: ClusterFirst
  restartPolicy: Never
status: {}
```

145. Create the service for this nginx pod with the pod selector app: my-nginx
```shell=
// create the below service
kubectl create -f nginx-svc.yaml
```
```yaml=
apiVersion: v1
kind: Service
metadata:
  name: my-service
spec:
  selector:
    app: my-nginx
  ports:
    - protocol: TCP
      port: 80
      targetPort: 9376
```

146. Find out the label of the pod and verify the service has the same label
```shell=
// get the pod with labels
kubectl get po nginx --show-labels
// get the service and check the selector column
kubectl get svc my-service -o wide
```
147. Delete the service and create the service with kubectl expose command and verify the label
```shell=
// delete the service
kubectl delete svc my-service
// create the service again
kubectl expose po nginx --port=80 --target-port=9376
// verify the label
kubectl get svc -l app=my-nginx
```
148. Delete the service and create the service again with type NodePort
```shell=
// delete the service
kubectl delete svc nginx
// create service with expose command
kubectl expose po nginx --port=80 --type=NodePort
```
149. Create the temporary busybox pod and hit the service. Verify the service that it should return the nginx page index.html.
```shell=
// get the clusterIP from this command
kubectl get svc nginx -o wide
// create temporary busybox to check the nodeport
kubectl run busybox --image=busybox --restart=Never -it --rm -- wget -o- <Cluster IP>:80
```
150. Create a NetworkPolicy which denies all ingress traffic
```yaml=
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: default-deny
spec:
  podSelector: {}
  policyTypes:
  - Ingress
```  