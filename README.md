# S3 API
S3 api to list bucket content


Written in flask, this api list contents of S3 bucket on AWS. 

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

Terraform layout :
-- main.tf


It follows the following structure : 
- http://IP:PORT/list-bucket-content : Lists all buckets in your account
- http://IP:PORT/list-bucket-content/<bucket-name> : Lists all directories under it.
- http://IP:PORT/list-bucket-content/<bucket-name-not-present> : Gives error message 
