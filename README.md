# プライベートサブネット上に構築したEC2インスタンスにSession Managerを利用してSSH接続、HTTP接続を行う手順

## 想定利用者
- パブリックサブネットにEC2インスタンスを構築し、セキュリティグループでアクセス制限を行っている方
- EC2インスタンスへのSSH接続やHTTP接続をよりセキュアに行いたい方

## 前提
プライベートサブネット上にEC2インスタンスを構築し、EC2インスタンスにNginxをインストールする。

## 実現したいこと
Session Managerを利用して以下を実現する。
1. ローカル端末からプライベートサブネット上のEC2インスタンスへSSH接続する。
2. ローカル端末からプライベートサブネット上のEC2インスタンス上にインストールしたNginxにHTTP接続する。

## システム構成図
構築するシステム構成は以下の通り<br>
黒線がデータの流れを示し、点線がデータ制御を示す。<br>
「VPC Endpoint Network Interface」は以下の3つのエンドポイントを利用する。<br>
このエンドポイントはSession Managerと通信を行うために利用する。SSM AgentよりHTTPSのインバウンドルールを有効にすることで、Session Managerと通信を行うことが可能。
1. com.amazonaws.ap-northeast-1.ssm
2. com.amazonaws.ap-northeast-1.ssmmessages
3. com.amazonaws.ap-northeast-1.ec2messages

「VPC Endpoint Gateway」は以下のエンドポイントを利用する。<br>
以下のエンドポイントを利用することで、Amazon Linux2 AMI リポジトリをホストする S3 バケットへのトラフィックを許可することが出来、そのリポジトリに対して「yum update」等のコマンドを実行することが可能となる。
1. com.amazonaws.ap-northeast-1.s3

<img src="./img/sec_dev_ec2.jpg" alt="AWSシステム構成" title="AWSシステム構成">

## 事前準備
1. ローカル端末にTerraformをインストール
2. ローカル端末にAWS CLIをインストール
3. ローカル端末に[Session Managerプラグイン](https://docs.aws.amazon.com/systems-manager/latest/userguide/session-manager-troubleshooting.html#plugin-not-found
)をインストール
4. 以下の権限を有するIAMポリシーに紐づいたIAMユーザーを用意し、ローカル端末でAWS CLIでIAMクレデンシャル情報を設定する。
   1. AmazonEC2FullAccess
   2. IAMFullAccess
   3. AmazonSSMFullAccess
5. SSH設定ファイルを更新
   1. 更新手順については、[AWS公式ページ](https://docs.aws.amazon.com/ja_jp/systems-manager/latest/userguide/session-manager-getting-started-enable-ssh-connections.html)を参考

## 使用方法
1. main.tfファイル直下に移動し、以下のコマンドを実行する
```
terraform init
terraform plan
terraform apply
```
2. インスタンスIDを確認する　※前提としてPowershellでの実行を想定
```
terraform show | Select-String -Pattern "id.*=.*i-" 
```

3. 以下のコマンドでSSH接続を行う
※以下のコマンドを利用する際、インスタンスIDについては上記で確認した内容を記載すること
```
aws ssm start-session --target [インスタンスID]　
```

4. 以下のコマンドでポートフォワードを行う。これによりローカル端末からHTTP接続が可能となる。但し、ポート番号10080はブラウザで制限されているため、制限されていないポート番号を利用する。ポート番号9999は制限されていないため以下で利用している。
※以下のコマンドを利用する際、インスタンスIDについては上記で確認した内容を記載すること
```
aws ssm start-session --target [インスタンスID] `
                      --document-name AWS-StartPortForwardingSession `
                      --parameters '{\"portNumber\":[\"80\"],\"localPortNumber\":[\"9999\"]}'
```

5. 利用を終了したい場合、以下のコマンドで削除する
```
terraform destroy
```

## 参考
https://dev.classmethod.jp/articles/terraform-session-manager-linux-ec2-vpcendpoint/#toc-1

## ライセンス
MIT.
