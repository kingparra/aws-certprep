*****************************
 Module 2: High Availability
*****************************


Intro to HA in AWS
-------------------

EC2 HA and Scalability
----------------------
Vertical scaling means increasing the hardware specs of
an instance, by alter its *size*. It is more common for
systems that are not distributed, like a database. RDS
and ElastiCache are examples of services that can scale
vertically.

Horizontal scalability means increasing the number of
instances or nodes for your application. This is very
common for web apps. (Since the network is the slowest
part of the app.)

The goal of high availability is to survive a data
center loss. HA usually goes hand-in-hand with
horizontal scaling. HA means running your application
in multiple data centers (or AZs).


Auto Scaling
------------

What is auto scaling?
^^^^^^^^^^^^^^^^^^^^^
In real life, the load on your websites and apps can
change. You can create and destroy nodes quickly in the
cloud. The goal of an Auto Scaling Group (ASG) is to:

* Scale out (add instances) to match increased load
* Scale in (remove instances) to match a decreased load
* Ensure we have a minimum and maximum number of instances running.
* Automatically register new instances to a load balancer.

You can have as many instances in your ASG as you EC2
quota allows. They can span AZs, but not regions.

Auto scaling group attributes
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
What are the components of a working ASG?

* A *launch configuration* or *launch template* that
  contains parameters needed to set up a new instance.
  (Instance profile, instance size, security groups,
  AMI, key pair, etc.)

* A min/max size and initial capacity.

* Network and subnet information.

* Load balancer information.

* Scaling policies, which are instructions on how to
  scale your resources (dynamic vs predictive, etc).

It is possible to scale an ASG based on CloudWatch alarms.
An alarm monitors a metric (such as average CPU).
Metrics are computed for the overall ASG instances.
Based on the alarm, we can create scale-in and
scale-out policies.

Auto scaling group brain dump
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
ASGs are free. You pay for the underlying resources
being launched, but not the ASG itself. Having
instances under and ASG means that if they get
terminated for whatever reason, the ASG will restart
them. ASGs can terminate instances marked as unhealthy
by a load balancer (and hence replace them).

Scaling processes in auto scaling groups
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
``Launch``, ``Terminate`` ``HealthCheck``,
``ReplaceUnhealthy`` ``AZRebalance``,
``AlarmNotification`` ``ScheduledActions``,
``InstanceRefresh`` ``AddToLoadBalancer``

Note on ``AZRebalance``
^^^^^^^^^^^^^^^^^^^^^^^
``AZRebalance`` == launch a new instance then terminate the old instance.

If you suspend the ``Launch`` process, then ``AZRebalance`` won't launch or terminate instances.

If you suspend the ``Terminate`` process, then...

* The ASG can grow up to 10 of its size, and
* The ASG could remain at the increased capacity since it can't terminate instances.

Auto scaling groups for SysOps
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
To implement a HA configuration of your ASG, make sure
it's running across multiple AZs.

Health checks available:

* EC2 status checks
* ELB health checks

An ASG will not reboot unhealthy hosts for you.

Some good commands to know for troubleshooting::

  aws autoscaling set-instance-health --instance-id $x --health-status $y

  aws autoscaling terminate-instance-in-auto-scaling-group --instance-id $x

Troubleshooting auto scaling group issues
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Problem: "{x} instances are already running. Launching EC2 instance failed."
The ASG has reached ``DesiredCapacity``, update it.

Problem: Launching EC2 instances is failing.
Check that the parameters in the launch template are still valid.
If, for example, the security group and key pair don't exist,
or the EBS mapping is valid, the instance can't launch.

CloudWatch metrics for auto scaling groups
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
``GroupMinSize``, ``GroupMaxSize``,
``GroupDesiredCapacity``, ``GroupInServiceInstances``,
``GroupPendingInstances``, ``GroupStandbyInstances``,
``GroupTerminatingInstances``, ``GroupTotalInstances``

You should enable metric collection in the ASG to see
these metrics. Metrics are collected every 1 minute.
You can of course also monitor the underlying EC2
instances.

Basic monitoring: 5 minutes granularity.
Detailed monitoring: 1 minute granularity.

::

  aws cloudwatch list-metrics --namespace AWS/AutoScaling


Relational Database Service (RDS)
---------------------------------
* Managed service
* OS patching level
* Continuous backups and restore to specific timestamp
  (point-in-time restore)
* Monitoring dashboards
* Read replicas for improved read performance
* Multi-AZ setup for disaster recovery
* Maintenance windows for upgrades
* Scaling capability, both vertical and horizontal
* But you can't SSH into your instances

You can use the RDS migration service to replicate you existing DB to AWS.


RDS read replicas for read scalability
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
* Up to 5 read replicas.
* Within AZ, cross AZ, or cross region.
* Replication is asynchronous, so reads are eventually consistent.
* Replicas can be promoted to their own DB.
* Applications must update the connection string to leverage read replicas.

RDS Multi-AZ (Disaster Recovery)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
* Synchronous replication
* One DNS name - automatic app failover to standby
* Increase availability
* Failover in case of loss of AZ, loss of network, instance or storage failure
* No manual intervention in apps
* Not used for scaling

RDS Multi AZ in depth
^^^^^^^^^^^^^^^^^^^^^
The failover happens only in the following conditions:

* When the primary DB instance fails
* or in the event of an AZ outage
* the DB instance server type is changed
* the operating system of the Db instance is undergoing
  software patching
* a manual failover of the DB instance was initiated
  using "Reboot with failover".

There is no failover for: long-running queries, deadlocks, or database corruption errors.

The endpoint is the same after a failover (no URL
change in the application is needed).

To lower maintenance impact patching/failover happens on the standby,
which is then promoted to master.

Backups are created from the standby.

Multi AZ is only within a single region, not cross
region. Region outages impact availability.

RDS Backups
^^^^^^^^^^^
Backups are automatically enabled in RDS.

Automated backups:

* Daily full snapshot of the DB
* Capture transaction logs in real time
* => ability to restore to any point in time
* 7 days retention (can be increased to 35 days)

DB snapshots:

* manually triggered by the user
* retention of backup for as long as you want

RDS Encryption
^^^^^^^^^^^^^^
Encryption at rest capability with AWS KMS.
SSL cert to encrypt data to RDS in flight.

To enforce SSL:

* PostgreSQL ``rds.force_ssl=1`` in the parameter group.
* MySQL: Within the DBMS, run ``GRANT USAGE ON *.* TO 'mysqluser'@% REQUIRE SSL;``.

To connect to ssl download the SSL trust cert and
provide ssl confi options to your client.

RDS Security
^^^^^^^^^^^^
DB is usually in s private subnets. It leverages
security groups. You can set up IAM policies to manage
access to the RDS resources. The database itself also
has its own permissions system. A new feature is that
IAM users can be used to login to a MySQL or Aurora DB.

RDS vs Amazon Aurora
^^^^^^^^^^^^^^^^^^^^
* Aurora is proprietary tech from AWS, not open source :(
* PostgreSQL and MySQL are both supported as Aurora DB.
* Aurora is "cloud optimized" and claims 5x performance
  improvement over MySQL on RDS, and over 3x the
  performance of PostgreSQL on RDS.
* Aurora storage automatically grows in increments of
  10GB up to 64TB.
* Aurora can have 15 replicas while MySQL has 5, and
  the replication proces sis faster (sub 10 ms replica
  lag)
* Failover in Aurora is instantaneous. It's HA native.
* Aurora costs more than RDS (20% more) -- but is more
  efficient.

RDS Parameter Groups
^^^^^^^^^^^^^^^^^^^^
You can configure the DB engine using parameter groups.
Dynamica parameteres are applied immediately.
Static parameters are applied after instance reboot.
You can modify parameter group associated with a DB
(must reboot). See the docs for a list of parameters
for a DB technology.

RDS Backup vs Snapshot
^^^^^^^^^^^^^^^^^^^^^^
Backups
~~~~~~~
* Backups are "continuous" and allow point-in-time recovery.
* Backups happen during maintenance windows.
* When you delete a DB instance, you can retain automated backups.
* Backups have a retention period you set between 0 and 35 days.

Snapshots
~~~~~~~~~
* Snapshots takes IO operations and can stop the
  database from seconds to minutes.
* Snapshots taken on multi-AZ DBs don't impact the
  master -- just the standby.
* Snapshots are incremental after the first snapshot
  (which is a full copy).
* You can copy and share DB snapshots.
* Manual snapshots don't expire.
* You can take a final snapshot when you delete your DB.

RDS Security for SysOps
^^^^^^^^^^^^^^^^^^^^^^^
What are your responsibilities?

* Check the ports / IP / security group
* In-DB user creation and permissions
* Set up the parameter group how you want it
* Set up TLS for in-flight encryption

RDS API methods for SysOps
^^^^^^^^^^^^^^^^^^^^^^^^^^
``DescribeDBInstances``, ``CreateDBSnapshot``,
``DescribeEvents``, ``RebootDBInstance``

RDS with Amazon CloudWatch
^^^^^^^^^^^^^^^^^^^^^^^^^^
Here are some metrics associated with RDS

``DatabaseConnections``, ``SwapUsage``, ``ReadIOPS``,
``WriteIOPS``, ``ReadLatency``, ``WriteLatency``,
``ReadThroughPut``, ``WriteThroughPut``,
``DisqQueueDepth``, ``FreeStorageSpace``

Enhances monitoring is useful when you need to see how
different processes or threads use the CPU. There are
over 50 new metrics in enhanced monitoring.

RDS Performance Insights
^^^^^^^^^^^^^^^^^^^^^^^^
* Visualize your database performance and analyze any issues that affect it.
* With the performance insights dashboard, you can
  visualize the database load and filter the load by:

  * Waits => find the bottleneck (CPU, IO, lock, etc...)
  * SQL statements => find the SQL statement that is the problem
  * Hosts => find the server that is using the most of our DB
  * Users => find the user that is using the most of our DB


Amazon Aurora
-------------

Aurora HA and read scaling
^^^^^^^^^^^^^^^^^^^^^^^^^^
* Automatically divides your DB volume into 10GB chunks spread across many disks.
* Each chunk of your database volume is replicated six ways, across three AZs.
* Aurora storage is "self healing" -- data blocks and
  disks are continuously scanned for errors and
  repaired automatically. I'm not sure what this means,
  honestly, does it have checksumming like ZFS?
* Can have a master + up to 15 aurora read replicas.
* Support for corss-region replication.

Interesting feature: Backtrack -- inspect the DB at any
point in time without using backups.


Amazon ElastiCache
------------------
ElastiCache is a fully managed service for caching
databases. The backend is Redis or Memcached. These
DBs run in memory.

Redis
^^^^^
* Multi AZ with auto-failover
* Read replicas to scale reads and have HA
* Data durability using AOF (append only file)
  persistence.
* Backup and restore features

Memcached
^^^^^^^^^
* Multi-node for partitioning of data (sharding)
* Non persistent
* No backup and restore
* Multi-threaded architecture

.. topic:: What the heck is AOF persistence?

   AOF persistence logs every write operation received
   by the server. These operation can then be replayed
   again at server startup, reconstructing the original
   dataset. Commands are logged using the same format as
   the redis protocol itself.

There are some slides with just pages of metric names
related to memcached. What the hell am I supposed to do
with that? Skipped.


DynamoDB
--------
* NoSQL database tables
* Virtually unlimited storage
* Items can have different attributes
* Low-latency queries
* Scalable read/write throughput
* SSD only, no HDDs

QUERY by key to find items efficiently.

SCAN to find items by any attribute. This is much slower.

When to use DynamoDB
^^^^^^^^^^^^^^^^^^^^
You need speed, consistent, single-digit millisecond
response times at any scale.

To build application with virtually unlimited
throughput and storage.

When you need to replicate you data across multiple AWS
regions for a distributed app.

When you want to use the API integrations that it
provides with other AWS services.

Core components
^^^^^^^^^^^^^^^
Tables, items, and attributes are the core components.

DynamoDB supports two different kinds of primary keys:
partition key and partition and sort key.


CloudFront
----------
CloudFront is a content delivery network, or CDN.

It improves read performance by caching content at the
edge of the network, close to the client.

There are 230+ points of presence globally (218+ edge
locations and 12 regional edge caches)

DDoS protection, integration with shield, web application framework.

Can expose external HTTPS and can talk to internal HTTPS back-ends.

CloudFront - Origins
^^^^^^^^^^^^^^^^^^^^
S3 bucket:

* For distributing files and caching them at the edge.
* Enhanced security with CloudFront Origin Access Identity (OAI).
* CloudFront can be used as an ingress (to upload files to S3).

Custom origin (HTTP):

* Application load balancer
* EC2 instance
* S3 website
* Any HTTP backend you want

**What is OAI, and how can I use it to restrict access to files?**


CloudFront Geo Restriction
^^^^^^^^^^^^^^^^^^^^^^^^^^
You can restrict who can access your distribution:
* Whitelist: Allow users only from approved countries
* Blacklist: Prevent access from disapproved countries

The country is determined using a 3rd party geo-IP database.

Use case: Copyright Laws to control access to content.

CloudFront Access Logs
^^^^^^^^^^^^^^^^^^^^^^
CloudFront access logs: logs every request made to CloudFront into a logging S3 bucket.

CloudFront Reports
^^^^^^^^^^^^^^^^^^
It's possible to generate reports on **cache statistics**, **popular objects**, **top referrers**,
**usage**, and **viewers**.

* Cache statistics report: Total requests, percentage of viewer requests by result type, bytes
  transferred to viewers, HTTPD status codes, percentage of GET requests that did not finish
  downloading.
* Popular objects report: Lists the 50 most popular objects and stats about them, including the
  number of hits and misses, the hit ratio, the number of bytes served for misses, the total bytes
  served, the number of incomplete downloads and the number of requests by HTTP status code.
* Top referrers report: The CloudFront top referrers report includes the top 25 referrers, the
  number of requests from a referrer, and the number of requests from a referrer as a percentage of
  the total number of request during the specified period.
* Usage reports: number of requests, data transferred by protocol and data transferred by
  destination.
* Viewers report: devices, browsers, OSs, locations.

CloudFront - Good to know
^^^^^^^^^^^^^^^^^^^^^^^^^
* You can configure min TTL, default TTL, and max TTL, which controls how long objects are cached at the edge.
* Some web apps use URL query strings to send info to the origin. You can rewrite these with
  CloudFront.
* CloudFront signed cookies allow you to control who can access your content.
* You can configure CloudFront to add custom headers to the requests that it sends to your origin.

THINGS TO REMEMBER
------------------
"single digit millisecond response time" --> DynamoDB

Aurora has six read replicas across three AZs.

"millions of requests per second" --> network load balancer
