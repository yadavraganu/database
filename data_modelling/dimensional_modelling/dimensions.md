# Dimension Table Structure
Every dimension table has a single primary key column. This primary key is embedded 
as a foreign key in any associated fact table where the dimension row’s descriptive 
context is exactly correct for that fact table row. Dimension tables are usually wide, flat and
denormalized tables with many low-cardinality text attributes. While operational codes 
and indicators can be treated as attributes, the most powerful dimension attributes 
are populated with verbose descriptions.

# Dimension Surrogate Keys
A dimension table is designed with one column serving as a unique primary key. 
This primary key cannot be the operational system’s natural key because there will 
be multiple dimension rows for that natural key when changes are tracked over time. 
Rather than using explicit natural keys or natural keys with appended dates, you should 
create anonymous integer primary keys for every dimension. These dimension surrogate keys  
are simple integers, assigned in sequence, starting with the value 1, 
every time a new key is needed. The date dimension is exempt from the surrogate 
key rule, this highly predictable and stable dimension can use a more meaningful 
primary key.

# Degenerate Dimensions
Sometimes a dimension is defined that has no content except for its primary key. 
For example, when an invoice has multiple line items, the line item fact rows inherit 
all the descriptive dimension foreign keys of the invoice, and the invoice is left with 
no unique content. But the invoice number remains a valid dimension key for fact 
tables at the line item level. This degenerate dimension is placed in the fact table with 
the explicit acknowledgment that there is no associated dimension table. Degenerate 
dimensions are most common with transaction and accumulating snapshot fact tables.

# Role-Playing Dimensions
A single physical dimension can be referenced multiple times in a fact table, with 
each reference linking to a logically distinct role for the dimension. For instance, a 
fact table can have several dates, each of which is represented by a foreign key to the 
date dimension. It is essential that each foreign key refers to a separate view of 
the date dimension so that the references are independent. These separate dimension   
views (with unique attribute column names) are called roles

# Junk Dimensions
Transactional business processes typically produce a number of miscellaneous, low   
cardinality flags and indicators. Rather than making separate dimensions for each 
flag and attribute, you can create a single junk dimension combining them together. 
This dimension, frequently labeled as a transaction profile dimension in a schema, 
does not need to be the Cartesian product of all the attributes’ possible values, but 
should only contain the combination of values that actually occur in the source data.

# Snowflaked Dimensions
When a hierarchical relationship in a dimension table is normalized, low-cardinality  
attributes appear as secondary tables connected to the base dimension table by 
an attribute key. When this process is repeated with all the dimension table’s hierarchies,  
a characteristic multilevel structure is created that is called a snowflake. 
Although the snowflake represents hierarchical data accurately, you should avoid 
snowflakes because it is difficult for business users to understand and navigate 
snowflakes. They can also negatively impact query performance. A flattened denormalized dimension  
table contains exactly the same information as a snowflaked dimension.

# Outrigger Dimensions
A dimension can contain a reference to another dimension table. For instance, a 
bank account dimension can reference a separate dimension representing the date 
the account was opened. These secondary dimension references are called outrigger 
dimensions. Outrigger dimensions are permissible, but should be used sparingly. In 
most cases, the correlations between dimensions should be demoted to a fact table, 
where both dimensions are represented as separate foreign keys.

# Conformed Dimensions
Dimension tables conform when attributes in separate dimension tables have the 
same column names and domain contents. Information from separate fact tables 
can be combined in a single report by using conformed dimension attributes that 
are associated with each fact table. When a conformed attribute is used as the 
row header (that is, the grouping column in the SQL query), the results from the 
separate fact tables can be aligned on the same rows in a drill-across report. 

# Shrunken Dimensions
Shrunken dimensions are conformed dimensions that are a subset of rows and/or 
columns of a base dimension. Shrunken rollup dimensions are required when constructing  
aggregate fact tables. They are also necessary for business processes that 
naturally capture data at a higher level of granularity, such as a forecast by month 
and brand (instead of the more atomic date and product associated with sales data). 
Another case of conformed dimension subsetting occurs when two dimensions are 
at the same level of detail, but one represents only a subset of rows.
