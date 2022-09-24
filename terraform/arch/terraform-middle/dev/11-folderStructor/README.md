## terraform 기본 folder 구조
```
.
├── README.md
├── main.tf  // main 실행 파일
├── output.tf // terraform resource output 정보
├── provider.tf // provider 정보 - region , profile 설정
└── variables.tf // 변수값 설정
```

## 해당 terraform module 개발시 위 형태 파일구조가 module 생성시 구조가 됨 
### 예시
```
module "aws_vpc" {
  source     = "../../../../modules/aws/vpc"
  cidr_block = "${var.vpc_cidr}.0.0/16"
  tag_name = merge(local.tags, {Name = format("%s-vpc", local.name_prefix)})
}
```

