# 學習建立PODs

## Pod 的概念

![](https://i.imgur.com/CUs7Se9.png)

Pod 是 k8s 中最小運行單位

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

## References
[^1]: [Understanding Kubernetes Objects](https://kubernetes.io/docs/concepts/overview/working-with-objects/kubernetes-objects/#required-fields) 

[^2]: [k8s workload Pod](https://kubernetes.io/docs/concepts/workloads/pods/)