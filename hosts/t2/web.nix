config: {
  config.terraform.resource."aws_instance"."web" = {
    name = "web-vm";
    instance_type = "t2.micro";
    ami = "ami-830c94e3";
    tags = {
      Name = "HelloWorld";
    };
  };
}