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
# Gossip and Failure Detection
# Reversing Failure Detection Problem Statement
