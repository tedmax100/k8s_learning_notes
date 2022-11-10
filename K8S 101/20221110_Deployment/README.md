# 學習建立Deployment

![](k8s_6_levels_abs.png)

![](deployment_composite.png)

## 自愈
當Deployment管理的Pod出現故障, 則會被替換掉, 這就是```自愈```
底層雖然用到了運行在後台的ReplicaSet, 但用戶應該只要專注與Deployment打交道就好.


### 指定擴容
```shell=
kubectl scale deployment/my-nginx-deployment --replicas=10
```
### 自動括容

```shell=
kubectl autoscale deployment/my-nginx-deployment --min=10 --max=15 --cpu-percent=80
```

### Reconciliation[^1]

Reconciliation Loops 會一直運行著，一直觀察著 Pod 是否如預期般的運作著必要數量副本。 

## 滾動更新

當 Pod 內容更新， Deployment 預設是採用滾動式更新

也就是一次更新一個逐次更新 ReplicasSet 內所有的 Pod

## 回滾

## 建立 Deployment

### k8s 物件結構

my-nginx-deployment.yaml

```yaml==
apiVersion: apps/v1
kind: Deployment
metadata:
   name: my-nginx-deployment
spec:
## selector to match label with Pod
   selector:
     matchLabels:
       app: myapp
## define how many pod in this replicaset	   
   replicas: 3
## the blue print to create pod
   template:
     metadata:
       name: nginx
       labels:
         app: myapp
     spec:
       containers:
       - name: nginx
         image: nginx
```

透過以下指令建立 Deployment
```shell=
kubectl create -f my-nginx-deployment.yaml
```

### 更新 Pod 的 image[^2]

```shell=
kubectl set image deployment.v1.apps/my-nginx-deployment nginx=nginx:1.16.1
```

### 察看更新的結果

```shell=
kubectl rollout status deployment/my-nginx-deployment
```

### 復原更新前的狀態

```shell=
kubectl rollout undo deployment/my-nginx-deployment
```

## 佈署更新策略[^3]

### 內建策略

k8s Deployment 內建有兩種更新策略

1. Rolling Update(預設)： 逐佈更新

2. ReCreate: 先把舊的全部關閉，再建立新的

### Canary 部署策略

同時讓新舊版系統同時在線上

透過導流方式把流量分配到新舊兩個系統上

![](https://i.imgur.com/9YDCu8k.png)

k8s 可以透過多個 selector

並且加上 track 用來標記不同版本

### Blue Green 部署策略

同時建立兩個新舊版本系統

![](https://i.imgur.com/tbcg1Sz.png)

測試完成後，將 Public Service 切換至 V2 版本

![](https://i.imgur.com/xWnmrEr.png)

最後再移除掉舊的系統

## References

[^1]: https://fufu.gitbook.io/kk8s/pod-replicaset

[^2]: https://kubernetes.io/zh-cn/docs/concepts/workloads/controllers/deployment/

[^3]: https://blog.kevinyang.net/2021/07/16/k8s-note-002/