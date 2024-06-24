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
# BTree LookUp Algo
- To find an item in a B-Tree, we have to perform a single traversal from root to leaf.
- The objective of this search is to find a searched key or its predecessor
- Finding an exact match is used for point queries, updates, and deletions; finding its predecessor is useful for range scans and inserts.
- The algorithm starts from the root and performs a binary search, comparing the searched key with the keys stored in the root node until it finds the first separator key that is greater than the searched value
- This locates a searched subtree. Index keys split the tree into subtrees with boundaries between two neighboring keys
- As soon as we find the subtree, we follow the pointer that corresponds to it and continue the same search process (locate the separator key, follow the pointer) until we reach a target leaf node
- Where we either find the searched key or conclude it is not present by locating its predecessor.
- During the point query, the search is done after finding or failing to find the searched key. During the range scan, iteration starts from the closest found keyvalue pair and continues by following sibling pointers until the end of the range is reached or the range predicate is exhausted
