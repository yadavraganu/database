# Star Schema
It represents the multidimensional model. In this model the data is Dimensional Modeling  
organized into facts and dimensions. The star model is the underlying structure for  
a dimensional model. It has one broad central table (fact table) and a set of smaller  
tables (dimensions) arranged in a star design.Below are the features of Star Schema  
- The data is in denormalized database.
- It provides quick query response
- Star schema is flexible can be changed or added easily.
- It reduces the complexity of metadata for developers and end users

# Star Schema Vs Snowflake Schema
| __Features__                | __Star Schema__                                                                                         | __Snowflake Schema__                                                                                                                                                    |
|-----------------------------|---------------------------------------------------------------------------------------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Normalized Dimension Tables | The dimension tables in star schema are not normalized so they may contain redundancies                 | This schema has normalized dimension tables                                                                                                                             |
| Queries                     | The execution of queries is relatively faster as there are less joins needed in forming a   query.      | The execution of snowflake schema complex queries is slower than star schema as many joins and foreign key relations are needed to form a query. Thus performance is affected. |
| Performance                 | Star schema model has faster execution and response time                                                | It has slow performance as compared to star schema                                                                                                                      |
| Storage Space               | This type of schema requires more storage space as compared to snowflake due to un normalised   tables. | Snowflake schema tables are easy to maintain and save storage space due to normalized tables.                                                                           |
| Usage                       | Star schema is preferred when the dimension tables have lesser rows                                     | If the dimension table contains large number of rows, snowflake schema is preferred                                                                                     |
| Type of DW                  | This schema is suitable for 1:1 or 1: many relationships such as data marts.                            | It is used for complex relationships such as many: many in enterprise Data warehouses.                                                                                  |
| Dimension  Tables           | Star schema has a  single table for each dimension                                                      | Snowflake schema may have more than one dimension table for each dimension.                                                                                             |