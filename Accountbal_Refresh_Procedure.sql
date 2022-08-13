CREATE OR REPLACE PROCEDURE ACOUNTBAL_REFRESH()
    returns float not null
    language javascript
    as
    $$    
    var query = ` 
                Create or Replace table AccountBalance_MktSegment_Nation as
                select t.$4 C_NAtionKey, sum(t.$6) as C_Acctbal, t.$7 as C_MAKSEGMENT                            
                            from @SNOWFLAKE_Stage/Customer_data.csv (file_format => "CSV_FILE" ) t  group by t.$4, t.$7;                       `

    var statement = snowflake.createStatement(
         {
            sqlText: query
         }
      );
  
    var response = statement.execute();
    response.next();
    row_count = response.getColumnValue(1);
    return row_count;z
    $$
    ;
