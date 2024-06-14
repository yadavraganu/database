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
4. When the initiator receives the ack message from the friend, it sends the friend a GossipDigestAck2 message to complete the round of gossip
When the gossiper determines that another endpoint is dead, it “convicts” that endpoint by marking it as dead in its local list and logging that fact
