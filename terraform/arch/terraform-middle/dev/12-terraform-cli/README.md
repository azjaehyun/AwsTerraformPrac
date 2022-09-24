## terraform 기본 cli 명령어 
### 1. terraform init
```
terraform init
```

### 2. terraform plan
```
terraform plan
```
* 특정 리소스만 plan 보기
```
terraform plan -target={resourceName}
ex) terraform plan -target=module.aws_key_pair
```

### 3. terraform apply
```
terraform plan
```
* 특정 리소스만 apply
```
terraform apply -arget={resourceName}
ex) terraform plan -target=module.aws_key_pair
```


### 4. terraform destroy
```
terraform destroy
```
* 특정 리소스만 destroy
```
terraform destroy -target={resourceName}
ex) terraform destroy -target=module.aws_key_pair
```