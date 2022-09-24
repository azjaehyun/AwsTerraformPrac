# spring boot sample docker hub 
```
# dockerhub 
https://hub.docker.com/r/symjaehyun/springhelloterra/tags?page=1&ordering=last_updated
```


# terraform 실행위치 해당 프로젝트 별로 폴더 구성. BTC-prac-1 프로젝트 위치
```
cd terraform/arch/BTC-prac-1/dev/  폴더 경로에 main.tf가 실행위치.
terraform init
terraform plan
terraform apply
```
# 해당 리소스 별로 module로 나눠놓고 main.tf에서 각 모듈을 호출함.