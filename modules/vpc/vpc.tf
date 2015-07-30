variable "vpc_cidr" { default = "10.0.0.0/16" }
variable "all_net" { default = "0.0.0.0/0" }

resource "aws_vpc" "coreos-cluster" {
    cidr_block = "${var.vpc_cidr}"
    tags {
        Name = "coreos-cluster"
    }
    enable_dns_support = true
    enable_dns_hostnames = true
}

resource "aws_internet_gateway" "coreos-cluster" {
    vpc_id = "${aws_vpc.coreos-cluster.id}"
}

resource "aws_route_table" "coreos-cluster" {
    vpc_id = "${aws_vpc.coreos-cluster.id}"
    route {
        cidr_block = "${var.all_net}"
        gateway_id = "${aws_internet_gateway.coreos-cluster.id}"
    }
}

output "vpc_id" {
    value = "${aws_vpc.coreos-cluster.id}"
}

output "vpc_cidr" {
    value = "${var.vpc_cidr}"
}

output "vpc_route_table" {
    value = "${aws_route_table.coreos-cluster.id}"
}

output "vpc_gateway" {
    value = "${aws_internet_gateway.coreos-cluster.id}"
}