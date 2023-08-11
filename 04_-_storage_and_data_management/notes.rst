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


S3 MFA Delete
-------------
MFA delete forces a user to generate a code on a MFA
device before doing important operations on S3.
To use MFA delete enable versioning on the bucket.

You will need MFA to permanently delete an object
version or suspend versioning on the bucket.

You won't need MFA for enabling versioning or listing
deleted versions.

Only the bucket owner can enable or disable MFA delete.

MFA delete can currently only be enabled using the CLI.


S3 Access Logs
--------------
You might want to enable server access logging, which
tracks requests for access to your bucket.

Each access log record provides details about a single
access request, such as the requester, bucket name,
request time, request action, response status, and
error code, if any.

To set this up, you need a target bucket. The target
bucket must not have any retention settings configured.

S3 uses a special log delivery account to write server
access logs. Be sure to update the bucket policy to
allow ``s3:PutObject`` from ``logging.s3.amazonaws.com``.

Docs: https://docs.aws.amazon.com/AmazonS3/latest/userguide/ServerLogs.html


S3 Replication
--------------
There are two types of replication for S3: Cross Region
Replication (CRR) and Same Region Replication (SRR).

CRR use cases: compliance, lower latency access,
replication across accounts.

SRR use cases: log aggregation, live replication
between production and test accounts.

Buckets can life in different accounts. Copying is
asynchronous. You must give IAM permissions to S3.

After activating, only new objects are replicated (not
retroactive).

For delete operations:

* If you delete without a version ID, it adds a delete marker, which is not replicated.
* If you delete with a version ID, it deletes in the source, not replicated.

You cannot "chain" replication, from bucket A to B to C, for example.
