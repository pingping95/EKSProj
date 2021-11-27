# EKSProj
EKSProject

### TODO List
1. Launch Template을 활용하여 Worker node의 Custom Image 관리하기
    Packer, Ansible을 통한 Image 관리
2. LB Ingress Controller
    ALB Ingress Controller
    Nginx Ingress Controller
3. Prometheus + Grafana Monitoring
    Alert Manager
    Slack
4. Logging System
    DaemonSet
    ELK
    EFK
5. Custom Helm Chart Study
6. Jenkins, ArgoCD
    SpringBoot
    NodeJS
    Python DJango
    Slack 승인 체계
7. When to use API Gateway
8. IAM User, IAM Role & awsauth ConfigMap (IAM과 Service Account연동)
9. 기본적으로 VPC는 EKS와 별도로 구성하는 경우가 일반적임
    VPC를 별도 프로젝트로 분리하되, S3 Backend에 있는 tfstate로 vpc, route table, subnet 등을 참조하여 해당 프로젝트에서 사용하기


---

### Terraform Resources

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

---

### 과정은 개인 블로그에 정리 예정.
---

 Terraform으로 EKS Provisioning : https://nyyang.tistory.com/110

 External DNS : https://nyyang.tistory.com/111

 EBS CSI Driver : https://nyyang.tistory.com/112

 Jenkins CICD : https://nyyang.tistory.com/113