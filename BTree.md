# B-Tree
B-Trees consist of multiple nodes. Each node holds up to N keys and N + 1 pointers to the child nodes. These nodes are logically grouped into three groups:  
### Root node
This has no parents and is the top of the tree.
### Leaf nodes
These are the bottom layer nodes that have no child nodes.
### Internal nodes
These are all other nodes, connecting root with leaves. There is usually more than one level of internal nodes.
![image](https://github.com/yadavraganu/databases/assets/77580939/8548a111-8b4d-4b96-9123-c9ee9a9188a2)
- __B Trees__ allow storing values on any level: in root, internal, and leaf nodes.
- __B+ Trees__ store values only in leaf nodes. Internal nodes store only separator keys used to guide the search algorithm to the associated value stored on the leaf level.Since values in B+ Trees are stored only on the leaf level, all operations(inserting, updating, removing, and retrieving data records) affect only leaf nodes and propagate to higher levels only during splits and merges.

### Separator Keys
Keys stored in B-Tree nodes are called index entries, separator keys, or divider cells. They split the tree into subtrees (also called branches or subranges), holding corresponding key ranges. Keys are stored in sorted order to allow binary search. A subtree is found by locating a key and following a corresponding pointer from the higher to the lower level.  
The first pointer in the node points to the subtree holding items less than the first key, and the last pointer in the node points to the subtree holding items greater than or equal to the last key. Other pointers are reference subtrees between the two keys.
![image](https://github.com/yadavraganu/databases/assets/77580939/6c218ae5-e5d0-42b9-aca8-322017fc02e2)
 - Some B-Tree variants also have sibling node pointers, most often on the leaf level, to simplify range scans. These pointers help avoid going back to the parent to find the next sibling.
 - Some implementations have pointers in both directions, forming a double-linked list on the leaf level, which makes the reverse iteration possible
