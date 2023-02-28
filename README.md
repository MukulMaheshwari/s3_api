# S3 API
### S3 api to list bucket content


Written in flask, this api list contents of S3 bucket on AWS. It runs on port 5000 & uses gunicorn server for serving requests.GET requests are served to retrieve contents in json format, no POST currently.

Required dependencies to setup (manual) :
- Python3
- aws-cli
- boto3
- gunicorn
- Flask

To run manually,steps are :

- Clone repo to local
- gunicorn --bind 0.0.0.0:5000 wsgi:app --daemon


Automated setup via Terraform on EC2:
- Clone repo on local & perform init, plan & apply.

Few things to keep in mind :
- Configure your aws cli credentials beforehand
- EC2 connects to S3 via assigned role (instance profile).
- Replace your vpc with the one defined in terraform file.

Terraform layout :
- main.tf

Rest of the files are cloned to local from git repo while setup.

It follows the following structure : 
- http://IP:PORT/list-bucket-content : Lists all buckets in your account
- http://IP:PORT/list-bucket-content/<bucket-name> : Lists all directories under it.
- http://IP:PORT/list-bucket-content/<bucket-name-not-present> : Gives error message 


Outputs:
- List high level directory or all buckets present :
  
![s3-2](https://user-images.githubusercontent.com/31155543/221487110-8100699d-d239-4e92-b7a5-ba2757f72df4.jpeg)
  
- List bucket contents, bucket name : mukultest 

![s3](https://user-images.githubusercontent.com/31155543/221485182-dfb7322d-fb79-40d2-af09-75eb9f7fc68a.jpeg)

- List bucket contents, bucket doesnt't exists.
  
![s3-1](https://user-images.githubusercontent.com/31155543/221486932-fbd1b873-f744-45e8-bcd4-8362a757a4f4.jpeg)
