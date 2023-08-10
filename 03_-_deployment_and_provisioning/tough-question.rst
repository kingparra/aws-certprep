Question
--------
"A leading commercial bank discovered an issue with
their online banking system that is hosted on their
Auto Scaling group and scaled out to over 60 EC2
instances.

The Auto Scaling group is taking multiple nodes offline
at the same time whenever you update the Launch
Configuration.

To update the system, the development team decided to
use AWS CloudFormation by changing a parameter to the
latest version of the code.

What can you do to limit the impact on customers while
the update is being performed?"

Answer
------
"In the CloudFormation template, add the UpdatePolicy
attribute and then enable the WaitOnResourceSignals
property. In the user data script, append a health
check to signal CloudFormation that the update has been
successfully completed."
