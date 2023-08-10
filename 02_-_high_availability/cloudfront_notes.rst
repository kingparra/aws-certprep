******************
 CloudFront Notes
******************


Primary Sources
---------------
* The Practice of Cloud Systems Administration by Thomas A. Limoncelli, Chapter 5: Design Patterns for Scaling.
* `CloudFront Documentation <https://docs.aws.amazon.com/cloudfront/index.html>`_.
* Unix and Linux System Administration Handbook 5th Edition,


Questions
---------
* What telemetry information does CloudFront provide?
* How do I set up restricted access to files in a S3 bucket based on referring URL?

* Where can I find labs to learn CloudFront?

  https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/IntroductionUseCases.html


What is a CDN?
--------------
A content delivery network, or CDN,
is a geographically distributed network of servers
that caches content close to end users,
at the networks edge.
Geolocation techniques are used to identify the network location
of the requesting web browser.
CDNs do not copy all content to all caches.
Instead, they notice usage trends and determine where to cache certain content.

A link to the original content, before being sent to the CDN, is called a *native URL*.
To activate the CDN,
you replace the native URL with URLs that point to the CDNs servers
when you generate the HTML of your site.
It's useful to have a mechanism to turn this link generation on or off,
since you may want to switch CDNs.

The current generation of CDN products can act as a proxy.
All requests go through the CDN,
which acts as a middle man,
performing caching services,
rewriting HTML to be more efficient,
and supporting other features.

CDNs typically offer additional services,
like DDoS protection
and analytics based on the HTTP[s]
requests they've intercepted.


How does CloudFront work?
-------------------------
1. Specify origin servers.

2. Upload files to the origin servers.

3. Create a distribution.
   The distribution tells CloudFront which origin server
   to get your files from
   when your users request the files
   through your web site or application.

4. CloudFront assigns a domain name
   to your new distribution.

5. CloudFront sends your distributions configuration
   (but not your content)
   to all of its edge locations or points of presence.


How CloudFront delivers content
-------------------------------
1. User requests an object.

2. DNS routes the request to the nearest CloudFlare POP (edge location).

3. CloudFront checks its cache for the requested object.
   If present, CloudFront returns it to the user. This is a cache hit.
   Otherwise, CloudFront does the following:

   a. Compares the request with your distribution settings
      and then forwards the request to your origin server.

   b. The origin server sends the object back to the edge.

   c. As soon as the first byte arrives from the origin,
      CloudFront begins to forward the object to the user.
      CloudFront also adds the object to the cache.


CloudFront Components
---------------------
What is an origin server?

  An origin server stores the original, definitive version of your objects.
  If you're serving content over HTTP, you origin server is either an S3 bucket or an HTTP server.
  Your HTTP server can run on an EC2 instance or on a server you manage; these servers are also known as custom origins.

What is a distribution?

  A distribution tells CloudFront where you want content to be delivered from, and the details about
  how to track and manage content delivery.

What is a point of presence?

  The edge cache closest to the customer.

What is a regional edge cache, and how does it differ from a point of presence?

  Regional edge caches are located between your origin server and the POP.
  As objects become less popular, individual POPs might remove those objects to make room for more popular content.
  Regional edge caches have a larger cache that an individual POP,
  so objects remain in the cache longer at the nearest regional edge cache location.
  A cache invalidation request removes an object from both POP caches and regional edge caches before it expires.

What is field-level encryption? What is a field?

What is origin shield?

What is Origin Access Control (OAC)?

What is Origin Access Identity (OAI)?

What is the difference between OAC and OAI?

What is a policy?

What is a function?
