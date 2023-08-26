***********************************
 Domain 5: Security and Compliance
***********************************


Shared responsibility model for RDS
-----------------------------------
AWS's responsibility:

* Hardware
* Underlying EC2 host
* OS patching
* DB patching

Your responsibility:

* Creating the DB with or without public access.
* Ensure parameter groups is configured to only allow TLS connections.
* Database encryption settings.
* Security group details.


Shared responsibility model for S3
----------------------------------
AWS's responsibility:

* Physical storage and scaling, the API, durability and availability.
* Making sure encryption mechanisms work as advertised.
* Ensure AWS employees can't access your data.

Your responsibility:

* Bucket configuration.
* Bucket policy / public setting.
* IAM users and roles.
* Enabling encryption.


Shield
------
AWS Shield is a DDoS protection service.
With it, you can automatically detect and mitigate network-level DDoS events.

Shield Standard
^^^^^^^^^^^^^^^
Shield Standard is a free service that is activated for every AWS customer by default.
It provides protection from attacks such as SYN/UDP floods, reflection attacks, and other layer 3/4 attacks.

Shield Advanced
^^^^^^^^^^^^^^^
Advanced is an optional DDoS mitigation service, which costs $3K per month per org.
It protects against more sophisticated attacks on CloudFront, Route53, ELB, and EC2.
When active, you have access to a DDoS Response Team (DRP).
It provides some protection agains higher fees during usage spikes due to DDoS.

Combined with AWS Shield, Route53 provides attack mitigation at the edge.

DDoS Protection on AWS
----------------------
Skim this: `Best Practices for DDoS Resiliency
<https://docs.aws.amazon.com/whitepapers/latest/
aws-best-practices-ddos-resiliency/
aws-best-practices-ddos-resiliency.html>`_.


Web Application Firewall
------------------------
WAFs operate at the application layer.

You can define web security rules with AWS WAF:

* Control which traffic to allow or block to your webapps.
* Rules can include IP addresses, HTTP headers, HTTP body, or URI strings.
* You can use WAS to protect against common attacks like SQL injection and Cross-Site Scripting.
* Protect against bots, bad user agents, etc.
* Size constraints. (On what?)
* Geo match.


Penetration Testing on your AWS Cloud
-------------------------------------
No permission is required for these services:

* EC2 instances
* NGWs
* RDS
* CloudFront
* Aurora
* API Gateway
* Lambda and Lambda@Edge
* Lightsail
* Elastic Beanstalk environments

Prohibited activities include, but are not limited to:

* DNS zone walking via Route53 Hosted Zones
* DoS, DDoS, simulated DoS, simulated DDoS

  * port flooding
  * protocol flooding
  * request flooding
  * should not test against t3.nano, t2.nano, t1.micro, m1.small.

* For any other simulated events contact aws-security-simultated-event@amazon.com

More info here:

* https://aws.amazon.com/security/penetration-testing/
* https://repost.aws/knowledge-center/penetration-testing
