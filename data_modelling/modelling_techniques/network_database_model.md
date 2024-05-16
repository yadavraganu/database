# NETWORK DATABASE MODEL

The network database model was invented by Charles Bachman in 1969 as an enhancement of the already existing database  
model, the hierarchical database model.A network database model is adata model that uses graph structure with pointers  
to represent relationship. The graph structures are similar to tree structures in terms of links or pointers, but  
they include cycles. The record structure of network model is based on graph and the relationships are based on pointers or links.

## FEATURES OF NETWORK DATABASE MODEL:

- It can represent redundancy in data more efficiently than that in the hierarchical model.
- There can be more than one path from a previous node to successor node/s.
- The operations of the network model are maintained by indexing structure of a linked list (circular) where a program   
  maintains a current position and navigates from one record to another by following the relationships in  
  which the record participates.
- Records can also be located by supplying key values.

## ADVANTAGES OF NETWORK DATABASE MODEL:

- __Simple Concept:__ Similar to the hierarchical model, this model is straightforward, and the implementation is effortless.
- __Ability to Manage More Relationship Types:__ The network model can manage one-to-one (1:1) as well as  
  many-to-many (N: N) relationships.
- __Easy Access to Data:__ Accessing the data is simpler when compared to the hierarchical model.
- __Data Integrity:__ In a network model, there's always a connection between the parent and the child segments because  
  it depends on the parent-child relationship.
- __Data Independence:__ Data independence is better in network models as opposed to the hierarchical models.

## DISADVANTAGES OF NETWORK DATABASE MODEL:

- __System Complexity:__ Navigational data access mechanism makes the system implementation more complex. Database  
   administrator, database designer, programmers and even end users should be familiar with the internal data  
   structure to access data.
- __Absence of structural independence:__ Updating inside this database is a tedious task. One cannot change a set  
  structure without affecting the application programs that use this structure to navigate through the data. If you 
  change a set structure, you must also modify all references made from within the application program to that structure.