# Heartbeats and Pings
We can query the state of remote processes by triggering one of two periodic processes:
- We can trigger a ping, which sends messages to remote processes,checking if they are still alive by expecting a response within a specified time period.
- We can trigger a heartbeat when the process is actively notifying its peers that it’s still running by sending messages to them.
### Example for Ping :
- Each process maintains a list of other processes (alive, dead, and suspected ones)
- Updates it with the last response time for each process.
- If a process fails to respond to a ping message for a longer time, it is marked as suspected.

![image](https://github.com/yadavraganu/databases/assets/77580939/253ca6cf-b19c-4bb2-8071-ce12cb1c6c16)

Many failure-detection algorithms are based on heartbeats and timeouts. This approach has several potential downsides, its precision relies on the careful selection of ping frequency and timeout, and it does not capture process visibility from the perspective of other processes
## Timeout-Free Failure Detector
Some algorithms avoid relying on timeouts for detecting failures.A timeout-free failure detector is an algorithm that only counts heartbeats and allows the application to detect process failures based on the data in the heartbeat counter vectors.
- Each process is aware of the existence of all other processes in the network
- Each process maintains a list of neighbors and counters associated with them.
- Processes start by sending heartbeat messages to their neighbors.
- Each message contains a path that the heartbeat has traveled so far.
- The initial message contains the first sender in the path and a unique identifier that can be used to avoid broadcasting the same message multiple times.
- When the process receives a new heartbeat message, it increments counters for all participants present in the path and sends the heartbeat to the ones that are not present there, appending itself to the path
- Processes stop propagating messages as soon as they see that all the known processes have already received it
- Since messages are propagated through different processes, and heartbeat paths contain aggregated information received from the neighbors.
- We can (correctly) mark an unreachable process as alive even when the direct link between the two processes is faulty
- One of the shortcomings of this approach is that interpreting heartbeat counters may be quite tricky: we need to pick a threshold that can yield reliable results.
- Unless we can do that, the algorithm will falsely mark active processes as suspected
## Outsourced Heartbeats
- This approach does not require processes to be aware of all other processes in the network, only a subset of connected peers.
- Process P1 sends a ping message to process P2 . P2 doesn’t respond to the message
- So P1 proceeds by selecting multiple random members (P3 and P4 ).
- These random members try sending heartbeat messages to P2 and, if it responds, forward acknowledgments back to P1.
![image](https://github.com/yadavraganu/databases/assets/77580939/40aa4bd1-c699-4e7b-b49c-a452de64abe6)
- This allows accounting for both direct and indirect reachability. For example, if we have processes P1 , P2 , and P3 , we can check the state of P3 from the perspective of both P1 and P2 .
- Outsourced heartbeats allow reliable failure detection by distributing responsibility for deciding across the group of members
- This approach does not require broadcasting messages to a broad group of peers
- Since outsourced heartbeat requests can be triggered in parallel, this approach can collect more information about suspected processes quickly, and allow us to make more accurate decisions
# Phi-Accural Failure Detector
- Instead of treating node failure as a binary problem, where the process can be only in two states: up or down, a phi-accrual (φ-accrual) failure detector has a continuous scale, capturing the probability of the monitored process’s crash
- It works by maintaining a sliding window, collecting arrival times of the most recent heartbeats from the peer processes
- This information is used to approximate arrival time of the next heartbeat, compare this approximation with the actual arrival time, and compute the suspicion level φ: how certain the failure detector is about the failure, given the current network conditions
- if phi value reaches a threshold, the node is marked as down
- This failure detector dynamically adapts to changing network conditions by adjusting the scale on which the node can be marked as a suspect
From the architecture perspective, a phi-accrual failure detector can be viewed as a combination of three subsystems:
### Monitoring
Collecting liveness information through pings, heartbeats, or requestresponse sampling. 
### Interpretation
Making a decision on whether or not the process should be marked as suspected.
### Action
A callback executed whenever the process is marked as suspected.

The monitoring process collects and stores data samples (which are assumed to follow a normal distribution) in a fixed-size window of heartbeat arrival times. Newer arrivals are added to the window, and the oldest heartbeat data points are discarded.
This information is used to compute the probability of arrival of the message within t time units after the previous one. Given this information, we compute φ, which describes how likely we are to make a correct decision about a process’s liveness. In other words, how likely it is to make a mistake and receive a heartbeat that will contradict the calculated assumptions.
# Gossip and Failure Detection
Another approach that avoids relying on a single-node view to make a decision is a gossip-style failure detection service, which uses gossip to collect and distribute states of neighboring processes.
- Each member maintains a list of other members, their heartbeat counters, and timestamps, specifying when the heartbeat counter was incremented for the last time.
- Periodically, each member increments its heartbeat counter and distributes its list to a random neighbor. Upon the message receipt, the neighboring node merges the list with its own, updating heartbeat counters for the other neighbors
- Nodes also periodically check the list of states and heartbeat counters. If any node did not update its counter for long enough, it is considered failed
- This timeout period should be chosen carefully to minimize the probability of falsepositives.

Shows three communicating processes sharing their heartbeat counters:
1. All three can communicate and update their timestamps.
2. P3 isn’t able to communicate with P1, but its timestamp t can still be propagated through P2.
3. P3 crashes. Since it doesn’t send updates anymore, it is detected as failed by other processes.
![image](https://github.com/yadavraganu/databases/assets/77580939/62c635e0-e194-42e1-be5c-2472bf8926f0)

# Reversing Failure Detection Problem Statement
Since propagating the information about failures is not always possible, and propagating it by notifying every member might be expensive, one of the approaches, called FUSE (failure notification service), focuses on reliable and cheap failure propagation that works even in cases of network partitions.
- To detect process failures, this approach arranges all active processes in groups. If one of the groups becomes unavailable, all participants detect the failure
- Every time a single process failure is detected, it is converted and propagated as a group failure.
- Processes in the group periodically send ping messages to other members, querying whether they’re still alive
- If one of the members cannot respond to this message because of a crash, network partition, or link failure, the member that has initiated this ping will, in turn, stop responding to ping messages itself
- All failures are propagated through the system from the source of failure to all other participants
- Participants gradually stop responding to pings, converting from the individual node failure to the group failure

Shows four communicating processes:
1. Initial state: all processes are alive and can communicate.
2. P2 crashes and stops responding to ping messages.
3. P4 detects the failure of P2 and stops responding to ping messages itself.
4. Eventually, P1 and P3 notice that both P1 and P2 do not respond, and process failure propagates to the entire group.
![image](https://github.com/yadavraganu/databases/assets/77580939/22cfd6aa-c455-42bf-9d6f-f87e2b47b08b)
