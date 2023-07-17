#!/usr/bin/env bash
# mod1lab1


# 1. Create an SNS topic and name it yt-instance-alarms.
aws sns create-topic --name yt-instance-alarms


# 2. Create an email subscription to the topic using yt-labs@yellowtail.tech.
aws sns subscribe \
  --protocol email \
  --topic-arn \
    "$(aws sns list-topics \
       --query "Topics[?ends_with(TopicArn, 'yt-instance-alarms')].TopicArn" \
       --output text)" \
  awsspam@proton.me


# 3. Create a log group, name it yt-instance-logs, and configure it to retain logs for 1 year.
aws logs create-log-group \
  --log-group-name yt-instance-logs \
  --query "logGroups[?logGroupName=='yt-instance-logs'].logGroupName" \
  --output text

aws logs put-retention-policy \
  --log-group-name yt-instance-logs \
  --retention-in-days 365


# 4.
aws logs put-metric-filter \
  #  Create a metric filter using the yt-instance-logs log group
  --log-group-name yt-instance-logs \
  --metric-transformations \
    "$(printf '%s' \
         # and name it yt-instance-http-5xx-metric
         metricName=yt-instance-http-5xx-sum, \
         metricNamespace=yt-instance-http-5xx-metric, \
         metricValue=1, \
         defaultValue=0)"
  # Create a filter pattern that monitors all of the HTTP 500-level errors
  --filter-pattern '[ip, id, user, timestamp, request, status_code=5*, size]' \
  # and name it yt-instance-http-5xx-filter.
  --filter-name yt-instance-http-5xx-filter

# Use these log events
read -r -d $'\0' test_log_events << "EOF"
127.0.0.1 - - [24/Sep/2013:11:49:52 -0700] "GET /index.html HTTP/1.1" 500 287
127.0.0.1 - - [24/Sep/2013:11:49:52 -0700] "GET /index.html HTTP/1.1" 500 287 3
127.0.0.1 - - [24/Sep/2013:11:50:51 -0700] "GET /~test/ HTTP/1.1" 200 3 4
127.0.0.1 - - [24/Sep/2013:11:50:51 -0700] "GET /favicon.ico HTTP/1.1" 501 308 5
127.0.0.1 - - [24/Sep/2013:11:50:51 -0700] "GET /favicon.ico HTTP/1.1" 503 308 6
127.0.0.1 - - [24/Sep/2013:11:51:34 -0700] "GET /~test/index.html HTTP/1.1" 200 3
EOF

# to test the pattern you created
aws logs test-metric-filter \
  --filter-pattern '[ip, id, user, timestamp, request, status_code=5*, size]' \
  --log-event-messages "$test_log_events"


# 5. Create an alarm using the custom metric filter you just created.
aws cloudwatch put-metric-alarm \
  --namespace yt-instance-http-5xx-metric \
#    Set the metric name to yt-instance-http-5xx-sum.
  --metric-name yt-instance-http-5xx-metric \
  --alarm-description "Count http 500 errors, a custom metric" \
# 6. Configure the alarm to evaluate every minute
  --evaluation-periods 1 `# DOC number of periods/data points to consider before alarm changes state` \
  --period 60            `# DOC seconds to evaulate the metric or expression` \
#    and set the total threshold to greater than 5.
  --comparison-operator GreaterThanThreshold \
  --threshold 5 \
#    Then set the alarm threshold to 3 units.
# 7. Publish a message to the yt-instance-alarms topic when ALARM state is triggered.
  --alarm-actions \
    "$(aws sns list-topics \
       --query "Topics[?ends_with(TopicArn, 'yt-instance-alarms')].TopicArn" \
       --output text)" \
#    Set the alarm name to yt-instance-5xx-alarm.
  --alarm-name yt-instance-http-5xx-alarm


# Test email notification when alarm is in ALARM state
aws cloudwatch set-alarm-state \
  --alarm-name yt-instance-5xx-alarm \
  --state-value ALARM \
  --state-reason testing
