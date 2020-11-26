provider "aws" {
    access_key = "AKIA327PBOTP2OJMNPX4"
    secret_key = "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"
    region     = var.region
}

resource "aws_vpc" "wayne-vpc" {
    cidr_block = "10.0.0.0/16"
    enable_dns_hostnames = true
    tags = {
        Name = "wayne-vpc"
    }
}

resource "aws_internet_gateway" "wayne-gw" {
    vpc_id = aws_vpc.wayne-vpc.id
}

resource "aws_subnet" "wayne_test_subnet1" {
    vpc_id = aws_vpc.wayne-vpc.id
    cidr_block = "10.0.0.0/24"
    map_public_ip_on_launch = true
    depends_on = [aws_internet_gateway.wayne-gw]
}

resource "aws_instance" "wayne-ec2" {
    ami = "ami-0b2c2a754d5b4da22"
    instance_type = "t2.micro"
    private_ip = "10.0.0.12"
    subnet_id = aws_subnet.wayne_test_subnet1.id
    tags = {
        Name = "wayne-ec2"
    }
}

resource "aws_eip" "wayne_1" {
    vpc = true
    instance = aws_instance.wayne-ec2.id
    associate_with_private_ip = "10.0.0.12"
    depends_on = [aws_internet_gateway.wayne-gw]
}




output "instance_private_ip" {
    value = aws_instance.wayne-ec2.private_ip
}
output "instance_public_ip" {
    value = aws_instance.wayne-ec2.public_ip
}