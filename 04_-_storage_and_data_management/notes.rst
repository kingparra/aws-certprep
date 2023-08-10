***************************************
 Module 4: Storage and Data Management
***************************************


S3 Naming rules
---------------
S3 buckets must be valid DNS hostnames.
They can be between 3..63 characters in length.
Also, bucket names cannot have underscores in them.


What is an object?
------------------
An object is a binary blob. It has a key, which is like
a file name, and a body, which is like the file
contents.

One interesting thing about buckets is that there is no
concept of a directory. Only objects with slashes in
their key (name).

The key is composed of a prefix and an object name.
``s3://my-bucket/my_folder1/another_folder/my_file.txt``.

Really think of objects as trees/blobs in the git object
store.


S3 Server-side Encryption for Objects
-------------------------------------
Server-side encryption happens after your object
arrives at the bucket.

You can set the **default** server-side encryption method
for objects when you create a bucket. **Or you can set
the server-side encryption for a particular object when
you upload one.**

Here's an example of uploading an object with the
server-side encryption set to SSE-S3::

  aws s3api put-object \
    --server-side-encryption AES256 \
    --bucket    $bucket_name \
    --key       $object_name \
    --body      file://$path

There are three methods of server-side encryption:
**SSE-S3**, **SSE-KMS**, **SSE-C**. There is also
client-side encryption.

(Docs here:
https://docs.aws.amazon.com/AmazonS3/latest/userguide/serv-side-encryption.html)

SSE-S3
^^^^^^
Using SSE-S3 keys are fully managed by the S3 service,
and you don't have any visibility to them. The
encryption type is AES-256. This is the default
server-side encryption method. During HTTP PUT
operations, set the header
``"x-amz-server-side-encryption": "AES256"``.

SSE-KMS
^^^^^^^
With this encryption method, keys and handled and
managed using the KMS service. You have some visibility
to them. You can control the keys and get an audit
trail on them. During PUT operations, set
``"x-amz-server-side-encryption": "aws:kms"``.

SSE-C
^^^^^
With SSE-C the keys are fully managed by the customer
outside of AWS. They are stored on-prem. HTTPS must be
used for PUT operations, and the server-side-encryption
method must be provided in the HTTP header for every
request made.


Client-side encryption for objects
----------------------------------
Client-side encryption happens before you send your
object to S3. You encrypt it on your source machine,
the client. You can use both client-side encryption and
server-side encryption together.

You can use a tool like ``gpg``, but then you'll have
to manually decrypt/encrypt for every transaction.

Another way is to use a library provided by AWS that
makes the client-side encryption transparent, and
automatic as part of your PutObject and GetObject
operations, called
``amazon-s3-encryption-client-${language_name}``.

More in the SDK developer guide here:
https://docs.aws.amazon.com/amazon-s3-encryption-client/latest/developerguide/what-is-s3-encryption-client.html


S3 Encryption in flight
-----------------------
S3 exposes endpoints using either HTTP or HTTPS.
So, TLS encrypts data in flight.
For SSE-C, HTTPS is required.
