# 學習建立PODs

## Kubernetes Object
一個yaml, 用來描述K8S的Object,需要包含有四個必備屬性[^1]
- apiVersion - 告訴K8S, 該用哪個API version來建立該object
- kind - 哪一個類型的object要被建立
- metadata - 對於該object, 能給一些標籤來識別這唯一的物件
- spec - 對該object的desire state的描述

## References
[^1]: [Understanding Kubernetes Objects](https://kubernetes.io/docs/concepts/overview/working-with-objects/kubernetes-objects/#required-fields) 