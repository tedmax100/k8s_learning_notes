# 學習建立PODs

## VScode extentions
- [YAML](https://marketplace.visualstudio.com/items?itemName=redhat.vscode-yaml)
- [Kubernetes Support](https://marketplace.visualstudio.com/items?itemName=ipedrazas.kubernetes-snippets)
- 
## Pod的概念[^2]

![](https://i.imgur.com/CUs7Se9.png)

Pod 是 k8s 中最小運行單位

## Pod 組成

![](https://raw.githubusercontent.com/QueenieCplusplus/K8s_Pod/master/Pod.png)[^6]

如同其字面翻譯 Pod 像是豌豆匣一樣

一個 Pod 內部可以包含不只一個 Container

這些 Container 共同組成一個 Pod 來完成一個特定的應用

Pod 內 Container 共享這個 Pod 的所有資源： network 與 storage

## 建立 Pod 的方式

* 命令式

直接使用 kubectl 指令建制[^8]

```shell=
kubectl run $PodName --image $ImageName
```

舉例來說建制 nginx image

```shell=
kubectl run nginx --image nginx
```

* 宣告式

使用 Kubernetes Object 

宣告要建制的方式

建立一個 nginx.yaml 如下

```yaml=
apiVersion: v1
kind: Pod
metadata:
  name: nginx
  label: nginx-app
spec:
  containers:
  - name: nginx
    image: nginx
```

然後透過 kubectl 執行[^8]

```shell=
kubectl apply -f nginx.yaml
```
## Kubernetes Object
一個YAML檔, 用來描述K8S的Object,需要包含有四個必備屬性[^1]
- apiVersion - string, 告訴K8S, 該用哪個API version來建立該object
- kind - string, 哪一個類型的object要被建立, 有Pod, Service, ReplicaSet, Deployment
- metadata - dictionary, 對於該object, 能給一些標籤來識別這唯一的物件
- spec - dictionary, 對該object的desire state的描述

pod-definition.yml
```yaml=
apiVersion: v1
kind: Pod
metadata:
    name: myapp-pod
    labels:
        app: myapp
        type: front-end
spec:
    containers:
        - name: nginx-container
          image: nginx
```
```bash=
# create pod
kubectl create -f pod-definition.yml

# check pod list
kubectl get pods

# get more information for specific pod
kubectl describe pod myapp-pod
```

## 透過指令產生 kubernetes object[^8]

```shell=
kubectl run nginx --image=nginx restart=Never -o yaml --dry-run=client > nginx.yaml
```
### Exercise
1. Create a Kubernetes Pod definition file using values below: 
>Name: postgres  
Labels: tier => db-tier  
Container name: postgres  
Image: postgres  

2.  Set an environment variable for the docker container. POSTGRES_PASSWORD with a value mysecretpassword.
To pass in an environment variable add a new property 'env' to the container object.

## 運行 Pod 的概念

一般來說，通常不會 k8s cluster 直接管理 Pod

而是會透過一層抽象層或是稱為 Controller 來處理管理 Pod 

以下是常見的幾種 Controller

* [Deployment](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/)[^3]
* [StatefulSet](https://kubernetes.io/docs/concepts/workloads/controllers/statefulset/)[^4]
* [DaemonSet](https://kubernetes.io/docs/concepts/workloads/controllers/daemonset/)[^5]

## Pod LifeCycle[^7]

![](https://i.imgur.com/OZIuD8U.png)

* Pod 本身並無法自我治癒，需要透過 controller 來做處理

* Pod 本身根據目前 Container 啟動的情形可以分做以下 Phase


| Phase     | 描述                                                                    |
| --------- | ----------------------------------------------------------------------- |
| Pending   | Pod 資訊已經被 k8s 叢集接收， 但仍然有 Container 還沒資源還沒準備好執行 |
| Running   | Pod 已經被設定到某個 node，並且所有 Pod 內的 Container 都被建立。       |
| Succeeded | 所有 Pod 的內 Container 都被執行成功。                                  |
| Failed    | 所有 Pod 內的 Container 都被關閉，且至少有一個 Container 沒有執行成功。 |
| Unknown   | 因為某些因素造成 Pod 狀態沒辦法被取得                                   |

透過這些 Phase ， Controller 能夠對 Pod 做 Desired 狀態的管理

**備註** 當 Pod 被關閉時，讀取到的狀態會是 Terminating ， Terminating 並不在以上 Phase 中。

Pod 預設是 gracefully terminate , 會預留 30 秒處理未完成的工作以及釋放資源。

## Pod Kinds
- Deployment
  - 適合無狀態的app, 方便app隨時被替代
- StatefulSet
  - 有狀態的應用, ex: db
- DaemonSet
  - 在每個Node上跑一個Pod, 可以做monitor, log collector...etc
- Job & CronJob
  - Job 表達一次性的任務
  - CronJob會依照cron expression來按時反覆執行

## Pod異常場景 [^9]

## References
[^1]: [Understanding Kubernetes Objects](https://kubernetes.io/docs/concepts/overview/working-with-objects/kubernetes-objects/#required-fields) 

[^2]: [k8s workload Pod](https://kubernetes.io/docs/concepts/workloads/pods/)

[^3]: [k8s workload Deployment](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/)

[^4]: [k8s workload StatefulSet](https://kubernetes.io/docs/concepts/workloads/controllers/statefulset/)

[^5]: [k8s workload DaemonSet](https://kubernetes.io/docs/concepts/workloads/controllers/daemonset/)

[^6]: [K8s Pod](https://raw.githubusercontent.com/QueenieCplusplus/K8s_Pod/master/Pod.png)

[^7]: [k8s Pod lifecycle](https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle/)

[^8]: [kubectl command cheat sheet](https://kubernetes.io/docs/reference/kubectl/cheatsheet/)

[^9]: [解读K8s Pod的13种典型异常](https://zhuanlan.zhihu.com/p/583550457)