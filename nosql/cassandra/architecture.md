# Data Centers and Racks
Cassandra is frequently used in systems spanning physically separate locations. Cassandra provides two levels of grouping that are used to describe the topology of a cluster: data center and rack.
### Rack
A rack is a logical set of nodes in close proximity to each other.
### Data Center
A data center is a logical set of racks, perhaps located in the same building and connected by reliable network.

Cassandra comes with a simple default configuration of a single data center ("datacenter1") containing a single rack ("rack1").Cassandra leverages the information you provide about your cluster’s topology to determine where to store  
data, and how to route queries efficiently. Cassandra stores copies of your data in the data centers you request to  
maximize availability and partition tolerance, while preferring to route queries to nodes in the local data center  
to maximize performance.

# Gossip and Failure Detection
To support decentralization and partition tolerance, Cassandra uses a gossip protocol that allows each node to keep track  
of state information about the other nodes in the cluster. The gossiper runs every second on a timer.  
The gossip protocol in Cassandra is primarily implemented by the org.apache.cassandra.gms.Gossiper class, which is  
responsible for managing gossip for the local node. When a server node is started, it registers itself with the gossiper to    
receive endpoint state information.  
Because Cassandra gossip is used for failure detection, the Gossiper class maintains a list of nodes that are alive and dead.  
Here is how the gossiper works
1. Once per second, the gossiper will choose a random node in the cluster and initialize a gossip session with it. Each round of gossip requires three messages.
2. The gossip initiator sends its chosen friend a GossipDigestSyn message.
3. When the friend receives this message, it returns a GossipDigestAck message.
4. When the initiator receives the ack message from the friend, it sends the friend a GossipDigestAck2 message to complete the round of gossip.  
When the gossiper determines that another endpoint is dead, it “convicts” that endpoint by marking it as dead in its local list and logging that fact

# Snitches
The job of a snitch is to provide information about your network topology so that Cassandra can efficiently route requests. The snitch will figure out where nodes are in relation to other nodes. The snitch will determine relative host proximity for each node in a cluster, which is used to determine which nodes to read and write from.

# Rings and Tokens
Cassandra represents the data managed by a cluster as a ring. Each node in the ring is assigned one or more ranges of data described by a token, which determines its position in the ring. For example, in the default configuration, a token is a 64-bit integer ID used to identify each partition. This gives a possible range for tokens from −2^63 to
2^63 −1.  
- A node claims ownership of the range of values less than or equal to each token and greater than the last token of the previous node, known as a token range.
- The node with the lowest token owns the range less than or equal to its token and the range greater than the highest token, which is also known as the wrapping range. In this way, the tokens specify a complete ring.

Data is assigned to nodes by using a hash function to calculate a token for the partition key. This partition key token is compared to the token values for the various nodes to identify the range, and therefore the node, that owns the data.

# Virtual Nodes
Early versions of Cassandra assigned a single token range to each node, in a fairly static manner, requiring you to calculate tokens for each node. Although there
are tools available to calculate tokens based on a given number of nodes, it was still a manual process to configure the initial_token property for each node in the cassandra.yaml file. This also made adding or replacing a node an expensive operation, as rebalancing the cluster required moving a lot of data.  
Cassandra’s 1.2 release introduced the concept of virtual nodes, also called vnodes for short. Instead of assigning a single token to a node, the token range is broken up into multiple smaller ranges. Each physical node is then assigned multiple tokens. Virtual nodes have been enabled by default since 2.0.  
Vnodes make it easier to maintain a cluster containing heterogeneous machines. For nodes in your cluster that have more computing resources available to them, you can increase the number of vnodes by setting the num_tokens property in the cassandra.yaml file. Conversely, you might set num_tokens lower to decrease the number of vnodes for less capable machines.  
Cassandra automatically handles the calculation of token ranges for each node in the cluster in proportion to their num_tokens value.
A further advantage of virtual nodes is that they speed up some of the more heavyweight Cassandra operations such as bootstrapping a new node, decommissioning a node, and repairing a node. This is because the load associated with operations on multiple smaller ranges is spread more evenly across the nodes in the cluster

# Partitioners
A partitioner determines how data is distributed across the nodes in the cluster. A partitioner is a hash function for computing the token of a partition key. Each row of data is distributed within the ring according to the value of the partition key token. The role of the partitioner is to compute the token based on the partition key columns. Any clustering columns that may be present in the primary key are used to determine the ordering of rows within a given node that owns the token representing that partition.

# Memtables, SSTables, and Commit Logs
### Commit Logs
- When a node receives a write operation, it immediately writes the data to a commit log. The commit log is a crash-recovery mechanism that supports Cassandra’s durability goals.
- A write will not count as successful on the node until it’s written to the commit log, to ensure that if a write operation does not make it to the in-memory store , it will still be possible to recover the data.
- If you shut down the node or it crashes unexpectedly, the commit log can ensure that data is not lost. That’s because the next time you start the node, the commit log gets replayed. In fact, that’s the only time the commit log is read; clients never read from it.
- The __durable_writes__ property controls whether Cassandra will use the commit log for writes to the tables in the keyspace. This value defaults to true, meaning that the commit log will be updated on modifications. Setting the value to false increases the speed of writes, but also risks losing data if the node goes down before the data is flushed from memtables into SSTables
### Memtables
- After it’s written to the commit log, the value is written to a memory resident data structure called the memtable. 
- Each memtable contains data for a specific table. In early implementations of Cassandra, memtables were stored on the JVM heap, but improvements starting with the 2.1 release have moved some memtable data to native memory, with configuration options to specify the amount of on-heap and native memory available.
- This makes Cassandra less susceptible to fluctuations in performance due to Java garbage collection.
- Optionally,Cassandra may also write data to in memory caches
- Multiple memtables may exist for a single table, one current and the rest waiting to be flushed.

# Replication Strategies
A node serves as a replica for different ranges of data. If one node goes down, other replicas can respond to queries for that range of data. Cassandra replicates data across nodes in a manner transparent to the user, and the replication factor is the number of nodes in your cluster that will receive copies (replicas) of the same data.  
If your replication factor is 3, then three nodes in the ring will have copies of each row. The first replica will always be the node that claims the range in which the token falls, but the remainder of the replicas are placed according to the replication strategy (sometimes also referred to as the replica placement strategy).

# Consistency Levels
Cassandra provides tuneable consistency levels that allow you to make these trade-offs at a fine-grained level. You specify a consistency level on each read or write query that indicates how much consistency you require.  
A higher consistency level means that more nodes need to respond to a read or write query, giving you more assurance that the values present on each replica are the same.  
- For read queries, the consistency level specifies how many replica nodes must respond to a read request before returning the data.
- For write operations, the consistency level specifies how many replica nodes must respond for the write to be reported as successful to the client.
- Because Cassandra is eventually consistent, updates to other replica nodes may continue in the background
## Available Consistency Levels
### ONE, TWO, and THREE
Each of which specifies an absolute number of replica nodes that must respond to a request.
### QUORUM 
The QUORUM consistency level requires a response from a majority of the replica nodes. This is sometimes expressed as:  

`Q = floor(RF/2 + 1)`  

In this equation, Q represents the number of nodes needed to achieve quorum for a replication factor RF.
### LOCAL_QUORUM
### ALL
The ALL consistency level requires a response from all of the replicas.  

Consistency is tuneable in Cassandra because clients can specify the desired consistency level on both reads and writes. There is an equation that is popularly used to represent the way to achieve strong consistency in Cassandra:  

`R + W > RF = strong consistency`  

In this equation, R, W, and RF are the read replica count, the write replica count, and the replication factor, respectively.  
All client reads will see the most recent write in this scenario, and you will have strongconsistency.

# Queries and Coordinator Nodes
A client may connect to any node in the cluster to initiate a read or write query. This node is known as the coordinator node. The coordinator identifies which nodes are replicas for the data that is being written or read and forwards the queries to them.
- For a write, the coordinator node contacts all replicas, as determined by the consistency level and replication factor, and considers the write successful when a number of replicas commensurate with the consistency level acknowledge the write.
- For a read, the coordinator contacts enough replicas to ensure the required consistency level is met, and returns the data to the client.

# Hinted Handoff
- A write request is sent to Cassandra, but a replica node where the write properly belongs is not available due to network partition, hardware failure, or some other reason.
- In order to ensure general availability of the ring in such a situation, Cassandra implements a feature called hinted handoff.
- A hint is like a a little Post-it Note that contains the information from the write request. If the replica node where the write belongs has failed, the coordinator will create a hint, which is a small reminder that says, “I have the write information that is intended for node B. I’m going to hang on to thiswrite, and I’ll notice when node B comes back online; when it does, I’ll send it the write request.”
- That is, once it detects via gossip that node B is back online, node A will “hand off” to node B the “hint” regarding the write.
- Cassandra holds a separate hint for each partition that is to be written
- This allows Cassandra to be always available for writes, and generally enables a cluster to sustain the same write load even when some of the nodes are down.
- It also reduces the time that a failed node will be inconsistent after it does come back online.
- In general, hints do not count as writes for the purposes of consistency level.
- In the consistency level ANY. This consistency level means that a hinted handoff alone will count as sufficient toward the success of a write operation
- That is, even if only a hint was able to be recorded, the write still counts as successful.Note that the write is considered durable, but the data may not be readable until the hint is delivered to the target replica
- If a node is offline for some time, the hints can build up considerably on other nodes.
- When the other nodes notice that the failed node has come back online, they tend to flood that node with requests, just at the moment it is most vulnerable
- To address this problem, Cassandra limits the storage of hints to a configurable time window. It is also possible to disable hinted handoff entirely.

# Anti-Entropy, Repair, and Merkle Trees
### Anti-Entropy
Cassandra uses an anti-entropy protocol as an additional safeguard to ensure consistency. Anti-entropy protocols are a type of gossip protocol for repairing replicated data. They work by comparing replicas of data and reconciling differences observed between the replicas. Anti-entropy is used in Amazon’s Dynamo, and Cassandra’s implementation is modeled on that.
### Read Repair
Read repair refers to the synchronization of replicas as data is read. Cassandra reads data from multiple replicas in order to achieve the requested consistency level, and detects if any replicas have out-of-date values. If an insufficient number of nodes have the latest value, a read repair is performed immediately to update the out-of-date replicas. Otherwise, the repairs can be performed in the background after the read returns.  
Anti-entropy repair (sometimes called manual repair) is a manually initiated operation performed on nodes as part of a regular maintenance process. This type of repair is executed by using a tool called nodetool, Running nodetool repair causes Cassandra to execute a validation compaction. During a validation compaction, the server initiates a TreeRequest/TreeReponse conversation to exchange Merkle trees with neighboring replicas.  
The Merkle tree is a hash representing the data in that table. If the trees from the different nodes don’t match, they have to be reconciled (or “repaired”) to determine the latest data values they should all be set to.
### Merkle Trees
A Merkle tree, named for its inventor, Ralph Merkle, is also known as a hash tree. It’s a data structure represented as a binary tree, and it’s useful because it summarizes in short form the data in a larger data set. In a hash tree, the leaves are the data blocks (typically files on a filesystem) to be summarized. Every parent node in the tree is a hash of its direct child nodes, which tightly compacts the summary.
