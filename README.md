# s3_api
S3 api to list bucket content


Written in flask, this api list contents in bucket on AWS. 

Required dependencies to setup on EC2 instance : 



It follows the following structure : 
- http://IP:PORT/list-bucket-content : Lists all buckets in your account
- http://IP:PORT/list-bucket-content/<bucket-name> : Lists all directories under it.
- http://IP:PORT/list-bucket-content/<bucket-name-not-present> : Gives error message 
