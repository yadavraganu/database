# What is multi-valued dependency?
A relation is said to be in multi-valued dependency, if it satisfies the following conditions:

- For a multi-valued dependency to occur there must be at least 3 columns in the relation, for example R(X, Y, Z).
- X -> Y (Y is dependant on X), for a single value of X, there are multiple values of Y.
- If X -> Y exists in a relation R(X, Y, Z) then Y and Z should be independent of each other.
