******
 TODO
******

* The test has a lot of questions on services that I haven't encountered yet,
  so I should familiarize myself with

  * CloudFront
  * Route53
  * ECS

* Questions

  * RDS: Why can't I set the backup retention period to 0?

    There are several reasons why you might need to set
    the backup retention period to 0. For example, you
    can disable automatic backups immediately by
    setting the retention period to 0.

    In some cases, you might set the value to 0 and
    receive a message saying that the retention period
    must be between 1 and 35. In these cases, check to
    make sure that you haven't set up a read replica
    for the instance. Read replicas require backups for
    managing read replica logs, and therefore you can't
    set a retention period of 0.
