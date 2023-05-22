resource "aws_ecr_repository" "CM_ecr" {
  name                  = "cmecr"
  image_tag_mutability  = "MUTABLE"
}

resource "aws_ecr_lifecycle_policy" "CM_ecr" {
  repository = aws_ecr_repository.CM_ecr.name
 
  policy = jsonencode({
   rules = [{
     rulePriority = 1
     description  = "keep last 10 images"
     action       = {
       type = "expire"
     }
     selection     = {
       tagStatus   = "any"
       countType   = "imageCountMoreThan"
       countNumber = 10
     }
   }]
  })
}