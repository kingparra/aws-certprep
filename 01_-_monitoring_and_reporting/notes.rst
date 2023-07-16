************************************
 Module 1: Monitoring and Reporting
************************************

The SysOps Associate SOA-C02 Exam
---------------------------------
This course consists of preparation for the AWS SysOps
Associate exam. The SysOps Associate exam (SOA-C02) is
intended for "systems administrators in a cloud
operations role".

It's a timed test with no lab component. There are 65
questions, which are either in multiple-choice or
multiple-response format. 15 of those questions are
ungraded. The exam is 130 minutes long. The their
scale goes from 100 to 1,000. The minimum passing score
is 720.

There are six domains (or subjects) in the test:

+------------------------------------------------------+-----------+
| Domain                                               | % of Exam |
+======================================================+===========+
| Domain 1: Monitoring, Logging, and Remediation       |    20%    |
+------------------------------------------------------+-----------+
| Domain 2: Reliability and Business Continuity        |    16%    |
+------------------------------------------------------+-----------+
| Domain 3: Deployment, Provisioning, and Automation   |    18%    |
+------------------------------------------------------+-----------+
| Domain 4: Security and Compliance                    |    16%    |
+------------------------------------------------------+-----------+
| Domain 5: Networking and Content Delivery            |    18%    |
+------------------------------------------------------+-----------+
| Domain 6: Cost and Performance Optimization          |    12%    |
+------------------------------------------------------+-----------+
| TOTAL                                                |    100%   |
+------------------------------------------------------+-----------+

You can find a detailed break-down of these domains in
``objectives.rst``.


CloudWatch Concepts
-------------------
* Namespaces
* Metrics
* Dimensions
* Resolution
* Statistics
* Percentiles
* Alarms

Namespaces
^^^^^^^^^^
A namespace is a container for metrics. Metrics in
different namespaces are isolated from each other,
so that metrics from different applications are not
mistakenly aggregated into the same statistics.

Namespaces allow the following characters in their
name ``0-9A-Za-z.-_/#:``. The convention is to use
the following naming scheme: ``AWS/service``.

There is no default namespace. You must specify a
namespace for each data point you publish to
CloudWatch.

Metrics
^^^^^^^
A metric represents a time-ordered set of data points
that are published to CloudWatch. Think of a metric as
a variable to monitor, and the data points as
representing the values of that variable over time.

Metrics exist only in the region in which they are
created. Metrics cannot be deleted, but they
automatically expire after 15 months if no new data is
published to them. Data points older than 15 months
expire on a rolling basis; as new data points come in,
data older than 15 months is dropped.

Metrics retention
~~~~~~~~~~~~~~~~~

+----------------+-------------+
|  Period        |  Retention  |
+================+=============+
|  < 60 seconds  |  3 hours    |
+----------------+-------------+
|  1 minute      |  15 days    |
+----------------+-------------+
|  5 minutes     |  63 days    |
+----------------+-------------+
|  1 hour        |  15 months  |
+----------------+-------------+

Dimensions
~~~~~~~~~~
A dimension is a name/value pair that is part of the
identity of a metric. Because dimensions are part of
the unique identifier for a metric, whenever you add a
unique name/value pair to one of your metrics, you are
creating a new variation of that metric.


For example, suppose that you publish four distinct
metrics named ServerStats in the DataCenterMetric
namespace with the following properties.

* Dimensions: Server=Prod, Domain=Frankfurt, Unit: Count, Timestamp: 2016-10-31T12:30:00Z, Value: 105
* Dimensions: Server=Beta, Domain=Frankfurt, Unit: Count, Timestamp: 2016-10-31T12:31:00Z, Value: 115
* Dimensions: Server=Prod, Domain=Rio,       Unit: Count, Timestamp: 2016-10-31T12:32:00Z, Value: 95
* Dimensions: Server=Beta, Domain=Rio,       Unit: Count, Timestamp: 2016-10-31T12:33:00Z, Value: 97

If you publish only those four metrics, you can
retrieve statistics for these combinations of
dimensions.

* Server=Prod,Domain=Frankfurt
* Server=Prod,Domain=Rio
* Server=Beta,Domain=Frankfurt
* Server=Beta,Domain=Rio

You can't retrieve statistics for the following
dimensions or if you specify no dimensions. (The
exception is by using the metric math SEARCH function,
which can retrieve statistics for multiple metrics. For
more information, see Use search expressions in
graphs.)

* Server=Prod
* Server=Beta
* Domain=Frankfurt
* Domain=Rio

Resolution
^^^^^^^^^^
Each metric is one of the following:

* Standard resolution, with data having a one-minute granularity, or;
* High resolution, with data at a granularity of one second.

When you publish a high-resolution metric, CloudWatch
stores it with a resolution of 1 second, and you can
read and retrieve it with a period of 1 second, 5
seconds, 10 seconds, 30 seconds, or any multiple of 60
seconds.

Statistics
^^^^^^^^^^
Statistics are metric data aggregations over specified periods of time.
Aggregations are made using the namespace , metric name, dimensions, and the data point unit of
measure, within the time period you specify.



Amazon CloudWatch Logs - Components
-----------------------------------
Log stream: a sequence of log events that share the same source.

Log groups: are groups of log streams. All log streams in a log group
share the same retention, monitoring, and access control settings.
Each log stream has to belong to one log group.
Each log stream must be unique within a region for an AWS account.
`CW LogGroup Docs`_.

.. _CW LogGroup Docs: https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-logs-loggroup.htmlk

Log events: A record of activity submitted by the monitored resource. It contains a timestamp
and the raw event message.

Retention settings: Log expiration and rotation policies.


CloudWatch Alarms
-----------------
Components of a CloudWatch alarm:

* Metric: The thing we're measuring.
* Thresholds: Point at which we want a notification or action.
* Period: Length of time in seconds to evaluate the metric.
* Action: Changes the state of the alarm and then a notification is sent to Auto Scaling, EC2
  Actions, or SNS notifications.

CloudWatch alarm states:

* OK: within threshold
* INSUFFICIENT_DATA: metric not available, alarm started. Not enough data for the metric to determine the alarm state.
* ALARM: metric outside the defined threshold.

Things to consider about alarms

* alarms can be created based on log metrics filters
* alarms exist only in the region in which they're created and alarm actions must reside in the same
  region as the alarm
* CloudWatch doesn't test or validate the actions that are assigned to an alarm
* To test alarms and notification, set the alarm state to "ALARM" using the CLI

  ::

    aws cloudwatch set-alarm-state \
      --alarm-name "myalarm" \
      --state-value ALARM \
      --state-reason "testing purposes"

CloudWatch Events or EventBridge
---------------------------------
CloudWatch events delivers a near real-time stream of system events that describe changes in
resources. Using rules you set up, you can match events and route them to one or more target
functions or streams.

(Source + Rule) => Target

* Events: A event indicates a change in your environment. Resources can generate events when their
  state changes. Or you can set up a scheduled event.
* Rules: route matching events to targets.
* Target: The service that will react to the event. Can be more than one target.

