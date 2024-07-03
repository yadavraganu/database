![image](https://github.com/yadavraganu/databases/assets/77580939/257b72ae-9f78-4f79-b438-a7b997b287d5)![image](https://github.com/yadavraganu/databases/assets/77580939/7abafbaa-454e-4af1-b6ff-f98dcbcd6990)Synchronization can be quite costly: if each algorithm step involves contacting each other participant, we can end up with a significant communication overhead. This is particularly true in large and geographically distributed networks. To reduce synchronization overhead and the number of message round-trips required to reach a decision, some algorithms rely on the existence of the leader (sometimes called coordinator) process, responsible for executing or coordinating steps of a distributed algorithm.
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
# Candidate/Ordinary Optimization
This algo splits the nodes into two subsets, candidate and ordinary, where only one of the candidate nodes can eventually become a leader. The ordinary process initiates election by contacting candidate nodes, collecting responses from them, picking the highest-ranked alive candidate as a new leader, and then notifying the rest of the nodes about the election results  
To solve the problem with multiple simultaneous elections, the algorithm proposes to use a tiebreaker variable δ, a process-specific delay, varying significantly between the nodes, that allows one of the nodes to initiate the election before the other ones. The tiebreaker time is generally greater than the message round-trip time
- Process 4 from the ordinary set notices the failure of leader process 6.
- It starts a new election round by contacting all remaining processes from the candidate set.
- Candidate processes respond to notify 4 that they’re still alive.
- 4 notifies all processes about the new leader: 2
![image](https://github.com/yadavraganu/databases/assets/77580939/d8ae64c3-e1d3-4b99-b715-036a87e0d2c7)  
# Invitation Algorithm
An invitation algorithm allows processes to “invite” other processes to join their groups instead of trying to outrank them. This algorithm allows multiple leaders by definition, since each group has its own leader.
- Each process starts as a leader of a new group, where the only member is the process itself
- Group leaders contact peers that do not belong to their groups, inviting them to join.
- Group leaders contact peers that do not belong to their groups, inviting them to join.
- Otherwise, the contacted process responds with a group leader ID, allowing two group leaders to establish contact and merge groups in fewer steps
![image](https://github.com/yadavraganu/databases/assets/77580939/8eeb7d0c-6ed3-445d-b2ae-feef185e6030)
1. Four processes start as leaders of groups containing one member each. 1 invites 2 to join its group, and 3 invites 4 to join its group.
2. 2 joins a group with process 1, and 4 joins a group with process 3. 1, the leader of the first group, contacts 3, the leader of the other group. Remaining group members (4, in this case) are notified about the new group leader.
3. Two groups are merged and 1 becomes a leader of an extended group.

Since groups are merged, it doesn’t matter whether the process that suggested the group merge becomes a new leader or the other one does. To keep thenumber of messages required to merge groups to a minimum, a leader of a largergroup can become a leader for a new group. This way only the processes from the smaller group have to be notified about the change of leader.
# Ring Algorithm
In the ring algorithm, all nodes in the system form a ring and are aware of the ring topology (i.e., their predecessors and successors in the ring)
- When the process detects the leader failure, it starts the new election
- The election message is forwarded across the ring: each process contacts its successor (the next node closest to it in the ring).
- If this node is unavailable, the process skips the unreachable node and attempts to contact the nodes after it in the ring, until eventually one of them responds
- Nodes contact their siblings, following around the ring and collecting the live node set, adding themselves to the set before passing it over to the next node
- The algorithm proceeds by fully traversing the ring. When the message comes back to the node that started the election, the highest-ranked node from the live set is chosen as a leader
![image](https://github.com/yadavraganu/databases/assets/77580939/c3b26ab4-eff8-449c-8ec5-77e871b842ee)
1. Previous leader 6 has failed and each process has a view of the ring from its perspective.
2. 3 initiates an election round by starting traversal. On each step, there’s a set of nodes traversed on the path so far. 5 can’t reach 6, so it skips it and goes straight to 1.
3. Since 5 was the node with the highest rank, 3 initiates another round of messages, distributing the information about the new leader.


All the algorithms we’ve discussed in this chapter are prone to the split brain problem: we can end up with two leaders in independent subnets that are not aware of each other’s existence. To avoid split brain, we have to obtain a cluster-wide majority of votes.
