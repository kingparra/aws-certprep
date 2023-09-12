Route 53
********
Route 53 is a highly-available fully managed DNS service.

Why send a high TTL? To reduce the number of lookups, reducing traffic.

Zone files
----------

+-------------+-----------------------------+
| Record Type |  Purpose                    |
+=============+=============================+
|  A          |  Hostname to IPv4           |
+-------------+-----------------------------+
|  AAAA       |  Hostname to IPv6           |
+-------------+-----------------------------+
|  CNAME      |  Hostname to hostname       |
+-------------+-----------------------------+
|  alias      |  hostname to AWS resource   |
+-------------+-----------------------------+

Use an alias record to point your domain name to a load balancer endpoint.

Route53 can use public or private domains.
It has advanced features such as DNS based client load balancing.

When do you use a CNAME vs an alias?
Use a CNAME only for non-root domains (subdomains, etc.)
Alias works for root domain and non-root domains.


Routing policies
----------------

Simple routing policy
^^^^^^^^^^^^^^^^^^^^^
* Map a hostname to another hostname
* Use a simple routing policy when you need to redirect to a single resource.
* You can't attach health checks to simple routing policies.
* If multiple values are returned (by what?), a random one is chosen by the client.

Weighted routing policy
^^^^^^^^^^^^^^^^^^^^^^^
With a weighted routing policy, you can control the percentage of requests that go to specific a endpoint.
This can be helpful to

* test 1% traffic on a new app version
* split traffic between two regions

Weighted policies can be associated with health checks.

Latency routing policy
^^^^^^^^^^^^^^^^^^^^^^
* Redirect to the server that has the least latency close to us.
* Latency is evaluated in terms of user to designated region.

Failover routing policy
^^^^^^^^^^^^^^^^^^^^^^^
You can have a backup route if your primary route does not pass a health check.

Geolocation routing policy
^^^^^^^^^^^^^^^^^^^^^^^^^^
This is routing based on user location.
We should create a default policy in case there's no match on location.

Geoproximity routing policy
^^^^^^^^^^^^^^^^^^^^^^^^^^^
This type of policy lets Route 53 route traffic to your resources based on geographic location of
your users and resources. You can assign a bias to a resource, which will cause more or less traffic
to be routed to it. In order to use this type of routing policy, you must use Route 53 traffic flow.


VPC
---
There is a soft limit of 5 VPCs per region.


VPC Endpoints
-------------
Endpoints allow you to connect to AWS services using a private network instead of the public
internet.

They scale horizontally and are redundant.

They remove the need of IGW, NAT, etc to access AWS services.

Interface: provisions an ENI (private IP addr) as an entry point (must attach security group) --
most AWS services.

Gateway: provisions a target and must be used in a route table -- S3 and DynamoDB.

In case of issues:
Check DNS resolution setting in your VPC.
Check route table.


Site-to-Site VPN
----------------
I'm not sure if this is correct.

Virtual Private GW ---> Virtual GW ---> Customer GW
