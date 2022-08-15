/*Load this script in you Snowflake worksheets using Load Script or copy/Paste */
/*Snowpipes Demo Queries */

/*Start from Accessing CUSTOMER Table*/
select * from "TRAININGDB"."SALES"."CUSTOMER"

/*Sanatize the table by deleting the data from the table*/
truncate table "TRAININGDB"."SALES"."CUSTOMER"

/*Script to Create a Pipe*/
create or replace pipe trainingdb.sales.mypipe auto_ingest=true as
  copy into"TRAININGDB"."SALES"."CUSTOMER"
   from @SNOWFLAKE_Stage/Snowpipes 
   file_format = "CSV_FILE";
   
/*Retreive pipe information to obtain the SQS Queue ARN for use with your S3 Bucket.*/
show pipes; /* Use the notification_channel column for ARN*/
   
/*Paste your ARN here
ARN::                             


*/

/*To Check the status of the Pipe - For debugging and last reterived message - ensure notification settings are correct*/
select SYSTEM$PIPE_STATUS('mypipe');

/* Create Snowpipes subfolder under you stage's root directory. 
Set event notification for the bucket as demonstrate din the lecture 
Upload the 2 CSV files provided Customer_Data_1.csv and Customer_Data_2.csv
*/

/*Run Select again from Customer table to see. It may take upto 5 mins to actually load the data*/
select * from  "TRAININGDB"."SALES"."CUSTOMER"

/*Debug to see why only 10 records were loaded instead of 20 */
select *
from table(information_schema.copy_history(table_name=>'CUSTOMER', start_time=> dateadd(hours, -1, current_timestamp())));


/*Conclude Tutorial*/