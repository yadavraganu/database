# Data Centers and Racks
Cassandra is frequently used in systems spanning physically separate locations. Cassandra provides two levels of grouping that are used to describe the topology of a cluster: data center and rack.
## Rack
A rack is a logical set of nodes in close proximity to each other.
## Data Center
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
