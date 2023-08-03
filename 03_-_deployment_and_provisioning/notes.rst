***************************************
 Module 3: Deployment and Provisioning
***************************************


EC2 Placement Groups
--------------------
https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/placement-groups.html

When creating EC2 instances, you can control how they are
distributed among hardware servers using placement groups.

**Cluster**: packs instances close together inside an AZ.
Useful for workloads that need low-latency node-to-node communication.

**Partition**:
spreads your instances across logical partitions
such that groups of instances in one partition
do not share the underlying hardware
with groups of instances in different partitions.
Up to 7 partitions per AZ.
Scales to hundreds of instances per group.
EC2 instances get access to the partition info as metadata.

**Spread**:
strictly places a small group of instances
across distinct underlying hardware to
reduce correlated failures.
Max 7 instances per group per AZ.

There is no charge for creating a placement group.
You cannot launch dedicated hosts in placement groups.

We recommend that you launch your instances in the following way:

* Use a single launch request to launch the number of instances that you need in the placement group.
* Use the same instance type for all instances in the placement group.

EC2 Launch Troubleshooting
--------------------------
**InstanceLimitExceeded**: up your limit.

**InsufficientInstanceCapacity**: wait and retry.

**Instance terminates immediately (pending -> terminated)**:
This may be caused by an EBS volume issue. For example, your EBS root volume may be encrypted with
a KMS key you don't have access to. To find the exact reason check the reason next to the "State
Transition Reason" label.

What if I lose my SSH key for an instance?
------------------------------------------
Either attach the instances root volume to another instance and replace the key/config files, or run
a systems manager document named ``AWSSupport-ResetAccess``. For instance store backed EC2 instances,
you have to terminate the instance.

EC2 Purchase Options and Tenancy
--------------------------------
**On-demand instances**: what you're used to.

**Spot instances**: short workloads for cheap can-lose instances.
Can get a discount of up to 90% compared to on-demand.
Instances that you lose at any point of time if your max price is less than the current spot price.
The most cost-efficient EC2 instances in AWS.
Useful for workloads that are resilient to failure.
Not suitable for critical jobs or databases.
Great combo: Reserved instances for baseline + on-demand and spot for peaks.

**Dedicated instances**:
Instances running on hardware that's dedicated to you.
May share hardware with other instances in the same account.
No control over instance placement (can move hardware after stop/start).

**Dedicated hosts**:
Book an entire physical server, full control over instance placement.
Visibility into the underlying physical cpu sockets and cores of the hardware.
Allocated to your account for a 3 year period reservation.
Very expensive.
Useful for software that has a complicated licensing model.
Or for companies that have strong regulatory or compliance needs.
(But also, look at other providers for stuff like this -- some do Metal as a Service, and have
Terraform providers, like Hivelocity.)


Choosing an EC2 instance family
-------------------------------

EC2 Instance Types -> Main Ones
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Use https://www.ec2instances.info to find the right instance type.
Here's a quick summary of the main ones you should be aware of:

+----------+-----------------------------------------+
|  family  |  purpose                                |
+==========+=========================================+
|  R       |   ram optimized                         |
+----------+-----------------------------------------+
|  C       |   cpu optimized                         |
+----------+-----------------------------------------+
|  M       |   balanced (think "medium")             |
+----------+-----------------------------------------+
|  I       |   I/O optimized                         |
+----------+-----------------------------------------+
|  G       |   GPU optimized                         |
+----------+-----------------------------------------+
|  T2/T3   |  burstable instances (up to a capcity)  |
+----------+-----------------------------------------+
|  T2/T3   |  unlimited burst (optional)             |
+----------+-----------------------------------------+

Burstable Instances
^^^^^^^^^^^^^^^^^^^
If the machine bursts, it utilized "burst credits".
If the machine stops bursting, it accumulates "burst credits" over time.
There are limits on how far your CPU can burst to,
unless you use a particular instance type that allows unlimited bursting.


Elastic IPs
-----------
A public IP address that is reachable from the internet.
Can be remapped across instances.
You can only have 5 EIPs per account (soft limit, can be adjusted).
You pay for the EIP even if it isn't attached to anything.

Overall try to avoid using EIPs. Alternatives include

* DNS endpoints (route53)
* Dynamic DNS
* load balancers with a static hostname

EIPs are regional.
EIPs are for use in a specific network border group only.


Resource Groups
---------------
In general, there are two ways: Choose resource by tag, or choose resource by tag.
AWS Resource Groups is a service that lets you tag resources and group them.
There are a relatively small number of resource types that cannot be tagged.
What do you do about that?

Reserved instances
------------------
Minimum 1 year commitment.
Up to 75% discont compared to on-demand.
Pay upfront for what you use with long term commitment.
Reservation period can be 1 or 3 year.s
Reserve a specific instance type.
Recommended for steady state usage applications (think databases).

Convertable reserved instance
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
* Can change the EC2 instance type.
* Up to 54% discount.


Spot instances
--------------
Short workloads, for cheap, can lose instances (less reliable)
* Can get a discount of up to 90% compared to on-demand
* Instances that you can "lose" at any point of time if your max price is less than the current spot
  price.
* The MOST cost-efficient instances in AWS.
* Useful for workloads that are resilient to failure.

  * Batch jobs.
  * Data analysis.
  * Image processing...

* Not suitable for critical jobs or databases.
* Great combo: Reserved instances for baseline and on-demand and spot for peaks.


Whats included in an AMI?
-------------------------
* EBS snapshots, or or instance-store backed AMIs, a template for the root volume of the instance.
* Launch permissions that control which AWS accounts can use the AMI to launch instances.
* A block device mapping that specified tha volumes to attach to the instances when it's launched.


AMI Storage and Pricing
-----------------------
Your AMI takes space and lives in S3, but you won't see the AMI in the S3 console.
By default your AMIs are private, and locked for your account/region.
You can also make your AMIs public, share them, or sell them on the AMI marketplace.

AMIs live in S3, so you you get charged for the actual space it takes.
Overall it is quite inexpensive to store private AMIs, but do make
sure to remove AMIs that you don't use.
