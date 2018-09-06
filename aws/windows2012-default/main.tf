resource "aws_eip" "default" {
   instance = "${aws_instance.windows2012.id}"
   vpc = true
  }

resource "aws_instance" "windows2012" {
  ami           = "ami-07355e1e938a6b6cb"
  instance_type = "t2.medium"
#  count = 1
  subnet_id = "subnet-0ecb4f69"
  key_name = "my-key-name"
  security_groups = [
    "sg-0d248aa8b905c9aa3"
  ] 
  tags {
    Name = "windows2012"
  }
  connection {
    type     = "winrm"
    user     = "Administrator"
    password = "${var.admin_password}"
  }
  user_data = <<EOF
<powershell>
# Set Administrator password
$admin = [adsi]("WinNT://./administrator, user")
$admin.psbase.invoke("SetPassword", "${var.admin_password}")
</powershell>
EOF
}
