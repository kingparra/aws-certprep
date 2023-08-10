**********************
 AWS Well-Architected
**********************


The Six Pillars
---------------

Operational excellence
^^^^^^^^^^^^^^^^^^^^^^
The ability to support development
and run workloads effectively,
gain insight into their operations,
and to continuously improve supporting process and procedures to deliver business value.

Design principles:

* Perform operations as code.
* Make frequent, small, reversible changes.
* Refine operations procedures frequently.
* Anticipate failure.
* Learn from all operational failure.

Organization Questions:

* OPS1: How do you determine what your priorities are?
* OPS2: How do you structure your organization to support your business outcomes?
* OPS3: How does your organizational culture support your business outcomes?

Prepare Questions:

"Adopt approaches that improve the flow of changes into prod and that achieves refactoring, fast
feedback on quality, and bug fixing." ... "Be aware of planned activities in your environments so
that you can manage the risk of changes impacting planned activities. Emphasize frequent,
small, reversible changes to limit the scope of changes. This results in faster troubleshooting and
remediation with the option to roll back a change. It also means you are able to get the benefit of
valuable changes more frequently."

* OPS4:

Security
^^^^^^^^
The security pillar describes
how to take advantage of cloud technologies to protect data,
systems,
and assets
in a way that can improve your security posture.

Reliability
^^^^^^^^^^^
The reliability pillar encompasses the ability of a workload to perform its intended function
correctly and consistently when it's expected to.
This includes the ability to operate and test the workload through its total lifecycle.
This paper provides in-depth, best practice guidance for implementing reliable workloads on AWS.

Performance efficiency
^^^^^^^^^^^^^^^^^^^^^^
The ability
to use computing resources efficiently
to meet system requirements,
and to maintain that efficiency
as demand changes and technologies evolve.

Cost optimization
^^^^^^^^^^^^^^^^^
The ability to run systems to deliver business value at the lowest price point.

Sustainability
^^^^^^^^^^^^^^
The ability to continually improve sustainability impacts by reducing energy consumption and
increasing efficiency across all components of a workload by maximizing the benefits from the
provisioned resources and minimizing the total resources required.


Terms
-----
* Component: The code, configuration, and resources that together deliver against a requirement.
* Workload: A set of components that together deliver business value.
* Architecture: How components fit together.
* Milestones: mark key changes in your architectures as it evolves throughout the product lifecycle.
* Technology portfolio: the collection of workloads that are required for the business to operate.
* Level of effort:

  * High: weeks to months
  * Medium: days or weeks
  * Low: hours or days


General design principles
-------------------------
* Stop guessing your capacity needs.
* Test systems at production scale.
* Automate with architectural experimentation in mind.
* Consider evolutionary architectures. In other words, don't be
  afraid to redesign your architecture as you learn more and time goes on.
* Drive architectures using data. You have monitoring, use it.
* Improve through game days. Game days are like fire drills. They
  simulate events in production.

