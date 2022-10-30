# 學習建立PODs

## Pod 的概念[^2]

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

直接使用 kubectl 指令建制

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

然後透過 kubectl 執行

```shell=
kubectl apply -f nginx.yaml
```
## Kubernetes Object
一個yaml, 用來描述K8S的Object,需要包含有四個必備屬性[^1]
- apiVersion - 告訴K8S, 該用哪個API version來建立該object
- kind - 哪一個類型的object要被建立
- metadata - 對於該object, 能給一些標籤來識別這唯一的物件
- spec - 對該object的desire state的描述

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
## References
[^1]: [Understanding Kubernetes Objects](https://kubernetes.io/docs/concepts/overview/working-with-objects/kubernetes-objects/#required-fields) 

[^2]: [k8s workload Pod](https://kubernetes.io/docs/concepts/workloads/pods/)

[^3]: [k8s workload Deployment](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/)

[^4]: [k8s workload StatefulSet](https://kubernetes.io/docs/concepts/workloads/controllers/statefulset/)

[^5]: [k8s workload DaemonSet](https://kubernetes.io/docs/concepts/workloads/controllers/daemonset/)

[^6]: [K8s Pod](https://raw.githubusercontent.com/QueenieCplusplus/K8s_Pod/master/Pod.png)

[^7]: [k8s Pod lifecycle](https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle/)