# JMeter tests

## Load Test:
- Description: Determines how the system behaves under normal load conditions.
- Parameters: Number of Threads (users), Ramp-up Period, Loop Count, Target Server URL.
- Assertions: Response Time, Throughput, Error Rate.

## Stress Test:
- Description: Evaluates system performance at or beyond its maximum capacity to identify its breaking point.
- Parameters: Maximum Number of Threads (users), Ramp-up Period, Loop Count, Target Server URL.
- Assertions: Response Time, Error Rate, Server Resource Utilization.

## Spike Test:
- Description: Measures system response to sudden spikes in user traffic.
- Parameters: Number of Threads (users), Spike Duration, Spike Threads.
- Assertions: Response Time, Error Rate, Server Stability.

## Endurance Test:
- Description: Checks system stability over an extended period under normal load conditions.
- Parameters: Number of Threads (users), Duration, Target Server URL.
- Assertions: Memory Consumption, CPU Utilization, Response Time.

## Peak Test:
- Description: Assesses system performance at peak load times to ensure it can handle maximum traffic.
- Parameters: Number of Threads (users), Duration, Target Server URL.
- Assertions: Response Time, Throughput, Error Rate.

## Concurrency Test:
- Description: Measures how well the system performs when multiple users access it simultaneously.
- Parameters: Number of Threads (users), Duration, Target Server URL.
- Assertions: Concurrent Users, Response Time, Error Rate.

## Breakpoint Test:
- Description: Identifies the point at which system performance begins to degrade under increasing load.
- Parameters: Number of Threads (users), Ramp-up Period, Loop Count, Target Server URL, Breakpoint.
- Assertions: Response Time, Error Rate, Server Stability.

## Capacity Test:
- Description: Determines the maximum load the system can handle before performance degrades significantly.
- Parameters: Maximum Number of Threads (users), Duration, Target Server URL.
- Assertions: System Resource Utilization, Response Time, Error Rate.

## Scalability Test:
- Description: Evaluates how well the system scales with increasing load or resources.
- Parameters: Number of Servers, Number of Threads (users), Ramp-up Period, Loop Count, Target Server URL.
- Assertions: Response Time, Throughput, Scalability Factor.

## Failover Test:
- Description: Checks the system's ability to recover and maintain functionality after a failure or interruption.
- Parameters: Number of Threads (users), Duration, Target Server URL, Failover Trigger.
- Assertions: Response Time, Error Rate, Failover Recovery Time.
