# 學習建立Deployment

![](k8s_6_levels_abs.png)

![](deployment_composite.png)

## 自愈
當Deployment管理的Pod出現故障, 則會被替換掉, 這就是```自愈```
底層雖然用到了運行在後台的ReplicaSet, 但用戶應該只要專注與Deployment打交道就好.

## 擴容
### Reconciliation

## 滾動更新

## 回滾