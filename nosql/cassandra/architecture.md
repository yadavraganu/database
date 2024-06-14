# Data Centers and Racks
Cassandra is frequently used in systems spanning physically separate locations. Cassandra provides two  
levels of grouping that are used to describe the topology of a cluster: data center and rack.
## Rack
A rack is a logical set of nodes in close proximity to each other.
## Data Center
A data center is a logical set of racks, perhaps located in the same building and connected by reliable network

Cassandra comes with a simple default configuration of a single data center ("datacenter1") containing a single rack  
("rack1"). Cassandra leverages the information you provide about your cluster’s topology to determine where to store  
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
