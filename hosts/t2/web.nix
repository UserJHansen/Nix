config: {
  terraform.resource."aws_instance"."web" = {
    name = "web-vm";
    instance_type = "t2.micro";
    tags = {
      Name = "HelloWorld";
    };
  };
}