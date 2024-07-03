Synchronization can be quite costly: if each algorithm step involves contacting each other participant, we can end up with a significant communication overhead. This is particularly true in large and geographically distributed networks. To reduce synchronization overhead and the number of message round-trips required to reach a decision, some algorithms rely on the existence of the leader (sometimes called coordinator) process, responsible for executing or coordinating steps of a distributed algorithm.
- Any process can take over the leadership role.
- Usually, the process remains a leader until it crashes and Election is triggered when the system initializes
- After the crash, any other process can start a new election round, assume leadership
- The liveness of the election algorithm guarantees that most of the time there will be a leader, and the election will eventually complete there may be at most one leader at a time, and completely eliminate the possibility of a split brain situation (when two leaders serving the same purpose are elected but unaware of each other).
- Election has to be deterministic: exactly one leader has to emerge from the process

One of the potential problems in systems with a notion of leadership is that the leader can become a bottleneck. To overcome that, many systems partition data in non-intersecting independent replica sets (see “Database Partitioning”). Instead of having a single system-wide leader, each replica set has its own leader
# Bully Algorithm
One of the leader election algorithms, known as the bully algorithm, uses process ranks to identify the new leader. Each process gets a unique rank assigned to it. During the election, the process with the highest rank becomes a leader
Election starts if one of the processes notices that there’s no leader in the system (it was never initialized) or the previous leader has stopped responding to requests, and proceeds in three steps\
1. The process sends election messages to processes with higher identifiers.
2. The process waits, allowing higher-ranked processes to respond. If no higher-ranked process responds, it proceeds with step 3. Otherwise, the process notifies the highest-ranked process it has heard from, and allows it to proceed with step 3.
3. The process assumes that there are no active processes with a higher rank, and notifies all lower-ranked processes about the new leader
![image](https://github.com/yadavraganu/databases/assets/77580939/1f227bd4-560a-48dc-aab8-a9dafde80d99)
-  Process 3 notices that the previous leader 6 has crashed and starts a new election by sending Election messages to processes with higher identifiers.
- 4 and 5 respond with Alive, as they have a higher rank than 3.
- 3 notifies the highest-ranked process 5 that has responded during this round.
- 5 is elected as a new leader. It broadcasts Elected messages, notifying lower-ranked processes about the election results.
### Problems 
- One of the apparent problems with this algorithm is that it violates the safety guarantee (that at most one leader can be elected at a time) in the presence of network partitions. It is quite easy to end up in the situation where nodes get split
into two or more independently functioning subsets, and each subset elects its leader. This situation is called split brain.
- Another problem with this algorithm is a strong preference toward high-ranked nodes, which becomes an issue if they are unstable and can lead to a permanent state of reelection
# Next-In-Line Failover
Each elected leader provides a list of failover nodes. When one of the processes detects a leader failure, it starts a new election round by sending a message to the highest-ranked alternative from the list provided by the failed leader.Each elected leader provides a list of failover nodes. When one of the processes detects a leader failure, it starts a new election round by sending a message to the highest-ranked alternative from the list provided by the failed leader  
If the process that has detected the leader failure is itself the highest ranked process from the list, it can notify the processes about the new leader right away  
![image](https://github.com/yadavraganu/databases/assets/77580939/2595c827-7d0f-415e-b811-d5509140d3da)  
- 6, a leader with designated alternatives {5,4}, crashes. 3 notices this failure and contacts 5, the alternative from the list with the highest rank.
- 5 responds to 3 that it’s alive to prevent it from contacting other nodes from the alternatives list.
- 5 notifies other nodes that it’s a new leader.

