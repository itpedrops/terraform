resource "aws_instance" "${var.name-instance}" {
  ami           = "${var.ami-id}"
  instance_type = "${var.size-instance}"
#  count = 1
  subnet_id = "subnet-0ecb4f69"
  key_name = "dmy-key-par"
  security_groups = [
    "sg-0d248aa8b905c9aa3"
  ] 
  tags {
    Name = "${var.name-instance}"
  }  
  ebs_block_device {
    delete_on_termination = true
    device_name = "/dev/xvdb"
    volume_size = "${var.size-ebs}"
    volume_type = "gp2"
  }

  provisioner "file" {
    source      = "scripts/install-docker.sh"
    destination = "/home/ec2-user/install-docker.sh"
    
    connection {
    type     = "ssh"
    user     = "ec2-user"
    private_key = "${file("~/xxx.pem")}"
    agent = false
  }
  }
    provisioner "file" {
    source      = "scripts/restart-docker.sh"
    destination = "/home/ec2-user/restart-docker.sh"
    
    connection {
    type     = "ssh"
    user     = "ec2-user"
    private_key = "${file("~/xxx.pem")}"
    agent = false
  }
  }
  provisioner "file" {
    source      = "scripts/web-compose/code/index.php"
    destination = "/home/ec2-user/index.php"
    
    connection {
    type     = "ssh"
    user     = "ec2-user"
    private_key = "${file("~/xxx.pem")}"
    agent = false
  }
  }
  provisioner "file" {
    source      = "scripts/web-compose/conf/default.conf"
    destination = "/home/ec2-user/default.conf"
    
    connection {
    type     = "ssh"
    user     = "ec2-user"
    private_key = "${file("~/xxx.pem")}"
    agent = false
  }
  }
  provisioner "file" {
    source      = "scripts/web-compose/docker-compose.yaml"
    destination = "/home/ec2-user/docker-compose.yaml"
    
    connection {
    type     = "ssh"
    user     = "ec2-user"
~/xxx.pem    agent = false
  }
  }
  provisioner "remote-exec" {
    inline = [
      "sudo chmod +x /home/ec2-user/install-docker.sh",
      "/home/ec2-user/install-docker.sh",
    ]
    
    connection {
    type     = "ssh"
    user     = "ec2-user"
    private_key = "${file("~/xxx.pem")}"
    agent = false
  }
  }
    provisioner "remote-exec" {
    inline = [
      "sudo chmod +x /home/ec2-user/restart-docker.sh",
      "/home/ec2-user/restart-docker.sh",
    ]
    
    connection {
    type     = "ssh"
    user     = "ec2-user"
    private_key = "${file("~/xxx.pem")}"
    agent = false
  }
  }  
}
