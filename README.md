# 03_devsecops_consul
DevSecOps X MultiCloud 위한 시나리오

## 1) DevSecOps on Naver Cloud Platform

## 2) Consul for MultiCloud (HashiCorp)

> 두 Kubernetes 환경을 컨트롤하므로 실행에 주의가 필요합니다.
> Consul helm github : https://github.com/hashicorp/consul-helm

### GKE provisioning (option)
- GKE 환경 프로비저닝을 위한 tf 샘플 : `google_tf`
- 프로비저닝을 위해서는 Google Cloud Platform 계정 및 비용이 발생합니다.

### NKS Consul
- NKS 샘플 : `ncloud_consul`
- NKS를 위한 consul 구성시 올바른 Server IP:Port(서비스)를 찾기위해 dnsPolicy 설정이 필요합니다.
    ```yaml
    <생략>
    client:
        enabled: true
        <생략>
        hostNetwork: true
        dnsPolicy: ClusterFirstWithHostNet
    <생략>
    ```
- NKS Consul 구성 후 해당 Consul을 Primary로 가정하여 federation을 위한 secret을 가져오는 작업이 실행됩니다.

### GKE Consul
- Consul 구성시 federation을 위한 secret은 NKS에서 생성한 값을 참조합니다.