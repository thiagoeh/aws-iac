resource "aws_ec2_managed_prefix_list" "home-ip-prefix-list" {
  name           = "Home IP address (created and updated with terraform)"
  address_family = "IPv4"
  max_entries    = 1

  entry {
    cidr        = join("", [data.http.home-ip-address.body, "/32"])
    description = "Home sweet home IP fixed"
  }

  tags = {
    iac_tool = "terraform"
  }
}

# "adopts" the default VPC
resource "aws_default_vpc" "default" {
  tags = {
    Name = "Default VPC"
  }
}

resource "aws_default_security_group" "default" {
  vpc_id = aws_default_vpc.default.id

  ingress {
    protocol  = -1
    self      = true
    from_port = 0
    to_port   = 0
  }

  ingress {
    protocol    = -1
    cidr_blocks = [join("", [data.http.home-ip-address.body, "/32"])]
    from_port   = 0
    to_port     = 0
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

data "http" "home-ip-address" {
  url = "https://api.ipify.org?format=text"
}

output "home-ip-address" {
  value = join("", [data.http.home-ip-address.body, "/32"])
}

output "default-vpc-id" {
  value = aws_default_vpc.default.id
}
