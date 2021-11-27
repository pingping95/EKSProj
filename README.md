# EKSProj
**EKS 관련 내용 정리**

## TODO List
---
1. Launch Template을 활용하여 Worker node의 Custom Image 관리하기
    - 자사 보안 기준을 통과한 커스텀 이미지를 사용하고 싶다면 LT를 사용해야 한다.

        (추가 Policy 필요)
    - Packer, Ansible을 통한 Image 관리
2. LB Ingress Controller
    - ALB Ingress Controller
    - Nginx Ingress Controller

3. Prometheus + Grafana Monitoring
    - Alert Manager
    - Slack
4. Logging System
    - DaemonSet
    - ELK
    - EFK
5. Helm Chart Study
6. Jenkins, ArgoCD
    - SpringBoot
    - NodeJS
    - Python DJango
    - Slack 승인 체계
7. When to use API Gateway
8. IAM User, IAM Role & awsauth ConfigMap (IAM과 Service Account연동)
9. 기본적으로 VPC는 EKS와 별도로 구성하는 경우가 일반적임
    - VPC를 별도 프로젝트로 분리하되, S3 Backend에 있는 tfstate로 vpc, table, subnet 등을 참조하여 해당 프로젝트에서 사용하기
10. IRSA의 내부 동작 및 원리 파악하기 (WebIdentity)
11. Affinity 등 Pod Scheduling 기법 학습
12. Draining 학습
---

## Terraform Resources
```
VPC

VPC Endpoint

SG

IAM Policies & IAM Roles (IAM Role For Service Account, IRSA)

OIDC

EFS

EC2

EKS Cluster

Worker Node

EFS

...
```

---

## 과정은 개인 블로그에 정리중입니다.
---

 Terraform으로 EKS Provisioning : https://nyyang.tistory.com/110

 External DNS : https://nyyang.tistory.com/111

 EBS CSI Driver : https://nyyang.tistory.com/112

 Jenkins CICD : https://nyyang.tistory.com/113