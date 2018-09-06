resource "aws_eip" "default" {
   instance = "${aws_instance.nginx-php.id}"
   vpc = true
  }
