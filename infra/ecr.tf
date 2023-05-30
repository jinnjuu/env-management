resource "aws_ecr_repository" "ecr" {
  name                 = var.ecr_name
  image_tag_mutability = "MUTABLE"

  force_delete = "true"
}

resource "null_resource" "build_and_push" {
  triggers = {
    repository_id = aws_ecr_repository.ecr.id
  }

  provisioner "local-exec" {
    command = "aws ecr get-login-password --region ${var.region} | docker login --username AWS --password-stdin ${aws_ecr_repository.ecr.repository_url}"
  }

  provisioner "local-exec" {
    command = "docker build -t ${var.ecr_name} ."
    working_dir = "../"
  }

  provisioner "local-exec" {
    command = "docker tag ${var.ecr_name}:latest ${aws_ecr_repository.ecr.repository_url}:latest"
  }

  provisioner "local-exec" {
    command = "docker push ${aws_ecr_repository.ecr.repository_url}:latest"
  }

}
