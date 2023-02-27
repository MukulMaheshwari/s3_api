# Using flask to make an api
# import necessary libraries and functions
import boto3
from botocore.exceptions import ClientError
from flask import Flask, jsonify, request
  
# creating a Flask app
app = Flask(__name__)

#creating s3 connection
s3 = boto3.resource('s3')

#list all buckets route
@app.route('/list-bucket-content', methods = ['GET'])
def home():
    if(request.method == 'GET'):
        Buckets = []
        
        for bucket in s3.buckets.all():
            Buckets.append(bucket.name)
        
        return jsonify({'content': Buckets})

#list bucket route contents with the given name
@app.route('/list-bucket-content/<value>', methods = ['GET'])
def child(value):
    if(request.method == 'GET'):
        try:
            #data = "hello world"
            #return jsonify({'data': data})
            Buckets = []
            my_bucket = s3.Bucket(value)

            for my_bucket_object in my_bucket.objects.all():
                # Getting high level directories only
                Buckets.append(my_bucket_object.key.split("/")[0])
                print(my_bucket_object.key.split("/")[0])
            
            res = [*set(Buckets)]

            return jsonify({'content': res})
        except ClientError as e:
            return jsonify({'Error' : "Bucket not found"})
    else :
        print("error")
  
  
# driver function
if __name__ == '__main__':
  
    app.run(debug = True)
