Why do I want this?
===================

You run some or all of your environment in Amazon Web Services, want to enable
CloudTrail to maintain audit logs of what is going on, and want those logs to
(almost) magically appear in logstash.

How does it work?
-----------------

Amazon has added the ability to log all API calls via the  CloudTrail service.
When CloudTrail is enabled, it writes log files to a S3 bucket with the option
of adding a notification via SNS when new logs are dropped.  Adding a SQS
receiver to the SNS topic allows you to poll for new log files that have been
dropped.

A simple script included with this puppet module subscribes to the SQS queue,
grabs the referenced log file from S3, formats the log messages for logstash
and adds them to a redis list for consumption by logstash.

A sample AWS policy would look like this:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "Stmt1400869009000",
      "Effect": "Allow",
      "Action": [
        "sqs:GetQueueUrl",
        "sqs:ReceiveMessage",
        "sqs:DeleteMessage"
      ],
      "Resource": [
        "arn:aws:sqs:<region>:<account_ID>:<queue_name>"
      ]
    }, {
      "Sid": "Stmt1400852117000",
      "Effect": "Allow",
      "Action": [
        "s3:DeleteObject",
        "s3:GetObject",
        "s3:ListBucket"
      ],
      "Resource": [
        "arn:aws:s3:::<bucket_name>/*"
      ]
    }
  ]
}
````

Usage
-----

This script is conveniently wrapped in a puppet module to simplify installation.

<pre>
  class { 'ct2ls':
    access_key_id     = 'ABCDEFGHI',
    secret_access_key = '123456789',
  }
</pre>


Known Issues:
-------------
Only tested on CentOS 6

TODO:
____
[ ] Make evenup/ruby module optional

License:
_______

Released under the Apache 2.0 licence


Contribute:
-----------
* Fork it
* Create a topic branch
* Improve it with your awesome ideas or fix my dumb bugs
* Push new topic branch
* Submit a PR
