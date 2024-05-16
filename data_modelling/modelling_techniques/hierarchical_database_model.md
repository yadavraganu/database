# HIERARCHICAL DATABASE MODEL

A hierarchical database model is a data model in which the data are organized into a tree-like structure. Hierarchical  
model is one of the oldest database models, dating from 1960's. The first Hierarchical database information management  
system was developed jointly by the North American Rockwell company and IBM.  

Hierarchy is an ordered tree and easy to understand. Data is represented in the form of records. The Relationship among  
the data is represented by records of links.Atree may be defined as a set of nodes. At the root of the tree is the  
single parent, the parent can have none, one or more children.  

As it is arranged based on the hierarchy, every record of the data tree should have at least one parent, except for  
the child records. The Data can be accessed by following through the classified structure, always initiated from  
the Root or the first parent. Hence, this model is named as Hierarchical Database Model.

Hierarchical model consists of the following :

 - It contains nodes which are connected by branches.
- The topmost node is called the root node.
If there are multiple nodes appear at the top level, then these can be called as root segments.
Each node has exactly one parent.
One parent may have many child.

## FEATURES OF HIERARCHICAL DATABASE MODEL:

- __One-to-many relationships:__ It only supports one–to–many relationships. Many-to-many relationships are not supported.

- __Problem in Deletion:__ If a parent is deleted, then the child automatically gets deleted.

- __Hierarchy of data:__ Data is represented in a hierarchical tree-like structure.

- __Parent-child relationship:__ Each child can have only one parent, but a parent can have more than one child.

- __Pointer:__ Pointers are used for linking records that tell which isa parent and which child record is.

- __Disk input and output are minimized:__ Parent and child records are placed or stored close to each other on the storage device which minimizes the hard disk input and output.

- __Fast navigation:__ As parent and child are stored close to each other, so access time is reduced, and navigation becomes faster.

- __Predefined relationship:__ All relations between root, parent and child nodes are predefined in the database schema.

- __Re-organization difficulty:__ Hierarchy prevents the re-organization of data.

- __Redundancy:__ One-to-many relationships increase redundancy in the data which leads to the retrieval of inaccurate data.


## Advantages

- Promotes data sharing
- Parent/child relationship promotes conceptual simplicity and data integrity
- Database security is provided and enforced by DBMS
- Efficient with 1: M relationships
## Disadvantages

- Requires knowledge of physical data storage characteristics
- Navigational system requires knowledge of hierarchical path
- Changes in structure require changes in all application programs
- Implementation limitations
- No data definition
- Lack of standards