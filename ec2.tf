data "aws_ami" "ubuntu" {
  # most_recent = true
  name_regex = "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-20240927"
  owners     = ["099720109477"]

  # filter {
  #   name = "Name"
  #   values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-20240927"]
  # }
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

output "NameofImage" {
  value = data.aws_ami.ubuntu.name
}

resource "null_resource" "nr1" {
  provisioner "local-exec" {
    command = "echo I like samosa > samosa.txt"

  }
}

resource "aws_instance" "Natwest-Vm-Ewan" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.medium"
  key_name               = aws_key_pair.nkpEW.key_name
  vpc_security_group_ids = [aws_security_group.sg1.id]
  subnet_id              = aws_subnet.sn1.id
  tags = {
    "Name" = "Natwest-Vm-Ewan"
  }
  associate_public_ip_address = true

  provisioner "file" {
    source      = "docker.sh"
    destination = "/home/ubuntu/docker.sh"
  }
  provisioner "remote-exec" {
    inline = [
      "sudo mkdir -p /home/ubuntu/php",
      "sudo mkdir -p /home/ubuntu/project",
      "sudo chmod -R 777 /home/ubuntu/php",
      "sudo chmod -R 777 /home/ubuntu/project"
    ]
  }

  provisioner "file" {
    source      = "dockerfiles/"
    destination = "/home/ubuntu/project"
  }
  provisioner "remote-exec" {
    inline = [
      "sudo chmod a+x /home/ubuntu/docker.sh",
      "sudo bash /home/ubuntu/docker.sh",
      "sudo cp /home/ubuntu/project/index.php /home/ubuntu/php/index.php",
      "sudo docker-compose -f /home/ubuntu/project/docker-compose.yaml up -d"
    ]
  }
  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ubuntu"
    private_key = var.privatekey
    timeout     = "3m"
  }
}
output "PublicIpAddress" {
  value = aws_instance.Natwest-Vm-Ewan.public_ip
}
