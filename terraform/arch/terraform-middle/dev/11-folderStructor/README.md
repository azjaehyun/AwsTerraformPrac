### terraform 기본 file 구조
```
.
├── README.md
├── main.tf  // main 실행 파일
├── output.tf // terraform resource output 정보
├── provider.tf // provider 정보 - region , profile 설정
├── terraform.tfvars // 변수 값
└── variables.tf // 변수 타입 설정
```

### 해당 terraform module 개발시 위 형태 file 구조가 module 기본 구조가 됨 
* #### 예시
```
module "aws_vpc" {
  source     = "../../../../modules/aws/vpc"
  cidr_block = "${var.vpc_cidr}.0.0/16"
  tag_name = merge(local.tags, {Name = format("%s-vpc", local.name_prefix)})
}
```

