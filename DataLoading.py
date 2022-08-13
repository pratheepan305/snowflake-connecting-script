## Ensure you have imported the required packages for this to work
import snowflake.connector
import pymysql
import pandas

## Create a MYSQL Coonection - This should be Step 0
mysqlconn = pymysql.connect(host='mysql-rfam-public.ebi.ac.uk', port=4497, user='rfamro',  database='Rfam')
cursor = mysqlconn.cursor()
query = 'select * from family'


###give location value to a easy way to get###
results = pandas.read_sql_query(query, mysqlconn)
results.to_csv("C:/Users/Hi/Desktop/python/snowflake/data loading/output.csv", index=False, header=False) ## Toggle header as necessary.

##Snowflake
#Step 1 #Create Connection --- #########
conn = snowflake.connector.connect( ##Disclaimer!! - Never use account and password information in code this way. This is for demonstrationj purpose only. for real iomplementations, please add this to your config file/environment file
    user="<your_user_name>",
    password="<you_passowrd>",
    account="<your_accound>",
    warehouse="<your Warehouse>",
    database="TRAININGDB"
    )

#Step 2 #Create DB if not exists--- #########
conn.cursor().execute("CREATE DATABASE IF NOT EXISTS TRAININGDB")

#Step 3 #Create Schema if not existsexit --- #########
conn.cursor().execute("USE DATABASE TRAININGDB")
conn.cursor().execute("CREATE SCHEMA IF NOT EXISTS RFAM")

#Step 4 #Create Table if not exists --- #########
conn.cursor().execute("USE SCHEMA TRAININGDB.RFAM") #Ensure we are using the right Schema
conn.cursor().execute( """ CREATE TABLE IF NOT EXISTS FAMILY(
                        rfam_acc Varchar(8) Not Null,
                        rfam_id varchar(40) Not Null,
                        auto_wiki NUMBER(10,0) ,
                        description Varchar(75) ,
                        author VARCHAR(100) ,
                        seed_source VARCHAR(100) ,
                        gathering_cutoff NUMBER(5, 2) ,
                        trusted_cutoff NUMBER(5, 2) ,
                        noise_cutoff NUMBER(5, 2) ,
                        comment VARCHAR(10000) ,
                        previous_id VARCHAR(100) ,
                        cmbuild VARCHAR(100) ,
                        cmcalibrate VARCHAR(100) ,
                        cmsearch VARCHAR(100) ,
                        num_seed NUMBER(38, 0) ,
                        num_full NUMBER(38, 0) ,
                        num_genome_seq NUMBER(38, 0) ,
                        num_refseq NUMBER(38, 0) ,
                        type VARCHAR(100) ,
                        structure_source VARCHAR(100) ,
                        number_of_species NUMBER(38, 0) ,
                        number_3d_structures NUMBER(10,0) ,
                        num_pseudonokts NUMBER(10,0) ,
                        tax_seed VARCHAR(500) ,
                        ecmli_lambda NUMBER(10, 2) ,
                        ecmli_mu NUMBER(10, 2) ,
                        ecmli_cal_db NUMBER(10,0) ,
                        ecmli_cal_hits NUMBER(10,0) ,
                        maxl NUMBER(10,0) ,
                        clen NUMBER(10,0) ,
                        match_pair_node BOOLEAN ,
                        hmm_tau NUMBER(10, 2) ,
                        hmm_lambda NUMBER(10, 2) ,
                        created DATETIME ,
                        updated TIMESTAMP
                        ) """  ) 

#Step 5 #CLEAN TABLE  AND COPY DATA--- #########
conn.cursor().execute("use warehouse compute_wh")
conn.cursor().execute(r"put file://c:/temp/output.csv @%Family")###giva the location data correctly only then it will load the data correctly###
conn.cursor().execute("COPY INTO FAMILY file_format = TrainingDB.SALES.CSV_FILE")





