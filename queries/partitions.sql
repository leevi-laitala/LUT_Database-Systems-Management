-- Creating a copy of the employee table to be partitioned into smaller parts
CREATE TABLE employee_partition (
    LIKE employee INCLUDING ALL
) PARTITION BY RANGE (e_id);

CREATE TABLE partition_employee_1 PARTITION OF employee_partition
    FOR VALUES FROM (MINVALUE) TO ('1000');

CREATE TABLE partition_employee_2 PARTITION OF employee_partition
    FOR VALUES FROM ('1000') TO ('2000');

CREATE TABLE partition_employee_3 PARTITION OF employee_partition
    FOR VALUES FROM ('2000') TO ('3000');

CREATE TABLE partition_employee_4 PARTITION OF employee_partition
    FOR VALUES FROM ('3000') TO ('4000');

CREATE TABLE partition_employee_5 PARTITION OF employee_partition
    FOR VALUES FROM ('4000') TO (MAXVALUE);

-- Inserting all the values from the employee table
INSERT INTO employee_partition SELECT * FROM employee;

SELECT * FROM employee_partition;

-- Creating a copy of a customer table to be partitioned into smaller parts
CREATE TABLE customer_partition(
    LIKE customer INCLUDING ALL
) PARTITION BY RANGE (c_id);

CREATE TABLE partition_customer_1 PARTITION OF customer_partition
    FOR VALUES FROM (MINVALUE) TO ('200');

CREATE TABLE partition_customer_2 PARTITION OF customer_partition
    FOR VALUES FROM ('200') TO ('400');

CREATE TABLE partition_customer_3 PARTITION OF customer_partition
    FOR VALUES FROM ('400') TO ('600');

CREATE TABLE partition_customer_4 PARTITION OF customer_partition
    FOR VALUES FROM ('600') TO ('800');

CREATE TABLE partition_customer_5 PARTITION OF customer_partition
    FOR VALUES FROM ('800') TO (MAXVALUE);

-- Inserting all the values from the customer table
INSERT INTO customer_partition SELECT * FROM customer;

SELECT * FROM employee_partition;

