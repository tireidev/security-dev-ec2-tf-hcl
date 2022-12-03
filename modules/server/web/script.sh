#!/bin/bash
sudo yum install -y https://s3.ap-northeast-1.amazonaws.com/amazon-ssm-ap-northeast-1/latest/linux_amd64/amazon-ssm-agent.rpm

# yum updateに時間がかかるため、EC2インスタンス生成後は5分程度待つこと
sudo yum update -y

# nginx install
amazon-linux-extras info nginx1
sudo amazon-linux-extras install -y nginx1

# nginx start, enable
sudo systemctl start nginx
sudo systemctl status nginx
sudo systemctl enable nginx