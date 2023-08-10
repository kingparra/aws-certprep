How do I send a custom metric using the CLI, Terraform, and CloudFormation?

How do I search for metrics by dimensions which are a subset of the metrics total dimensions?

What is a log group?

  https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-logs-loggroup.html

  A log group defines common properties for log streams,
  such as their retention and access control rules. Each
  log stream must belong to one log group.

What are you charged for when using CloudWatch?

  https://aws.amazon.com/cloudwatch/pricing/

  * log retention past a certain point
  * dashboards (first 3 are free, $3 per dashboard after that)
  * detailed monitoring
  * every ``PutMetricData`` API call for a custom metric is charged.

Show an example of sending a custom metric with the namespace AWS/CustomService.

What are some useful examples of queries for the Logs Insights feature of CloudWatch?

What services can CloudWatch logs be exported to?
