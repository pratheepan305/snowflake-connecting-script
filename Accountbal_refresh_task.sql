CREATE OR REPLACE TASK Accountbal_refresh_task
  WAREHOUSE = compute_wh,
  SCHEDULE = '60 MINUTE'
  
AS
 call ACCOUNTBAL_REFRESH();

/*Verify if the Tasks was created propertly*/
show tasks 
describe task Accountbal_refresh_task;