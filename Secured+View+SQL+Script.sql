--------------------- Create View - Prepare Customer Table -------------------

TRUNCATE TABLE CUSTOMER
INSERT INTO CUSTOMER
SELECT * FROM CUSTOMER_SCRIPT_CTA

--------------------- Create View - Create Customer_View View -------------------

CREATE OR REPLACE VIEW CUSTOMER_VIEW AS
select
C_CUSTKEY,
C_NAME,
C_ADDRESS,
C_NATIONKEY	,
C_PHONE	,
C_ACCTBAL,
C_MKTSEGMENT,
C_COMMENT
from "TRAININGDB"."SALES"."CUSTOMER"
WHERE C_MKTSEGMENT = iff(CURRENT_ROLE() = 'PUBLIC', 'AUTOMOBILE', 'FURNITURE')


---------- Create Secure Views ------------------------
CREATE OR REPLACE SECURE VIEW CUSTOMER_VIEW_SECURE AS
select
C_CUSTKEY,
C_NAME,
C_ADDRESS,
C_NATIONKEY	,
C_PHONE	,
C_ACCTBAL,
C_MKTSEGMENT,
C_COMMENT
from "TRAININGDB"."SALES"."CUSTOMER"
WHERE C_MKTSEGMENT = iff(CURRENT_ROLE() = 'PUBLIC', 'AUTOMOBILE', 'FURNITURE')

------------------Check View as Public user and Sys Admin ------------------

use role public

show views like 'customer%'

use role sysadmin

show views like 'customer%'

----------------------------Grant Public Select ----------------------------

Grant Select on all Views in schema TRAININGDB.SALES to PUBLIC 

-----------------------------