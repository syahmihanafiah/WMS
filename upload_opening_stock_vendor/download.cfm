<!---
Version History
---------------

Version  Date        By       	Remarks
-------  ----------  -------  	-------------- 
1.0.0.1  12/01/2024  Syahmi     Upload Stock Vendor
--->

<cfset org_id = URL.org_id>
<cfset vendor_id = URL.vendor_id>   
<cfset vendor_name = URL.vendor_name>

<cfsetting showDebugOutput="yes">
<!---QUERY TO GET THE DATA--->
                    <cfquery name="getExceldetail" datasource="#dswms#">
                            SELECT BACK_NUMBER,CURR_QTY FROM 
                            (
                            SELECT HEADER_ID,ORG_DESCRIPTION,VENDOR_NAME,A.ORG_ID,A.VENDOR_ID 
                            FROM 
                                (SELECT HEADER_ID,ORG_ID,VENDOR_ID 
                                FROM LSP_VENDOR_STOCK_HEADER) A,
                                (SELECT ORG_ID,ORG_DESCRIPTION 
                                FROM FRM_ORGANIZATIONS) B,
                                (SELECT VENDOR_ID,VENDOR_NAME FROM 
                                FRM_VENDORS) C  
                            WHERE 
                            A.ORG_ID = B.ORG_ID
                            AND 
                            C.VENDOR_ID = A.VENDOR_ID ) X,
                            (
                            SELECT ID,HEADER_ID,ORG_ID,A.PART_NUMBER,A.PART_NAME,A.BACK_NUMBER,QTY_PER_BOX,PREV_QTY,CURR_QTY,UPDATE_BY,UPDATE_DATE
                            FROM 
                                (
                                SELECT * FROM GEN_PART_LIST_HEADERS
                                WHERE active_date <= sysdate and NVL(inactive_date,sysdate+1) > sysdate 
                                ) A,
                                (SELECT * FROM GEN_PART_LIST_PSI
                                WHERE active_date <= sysdate and NVL(inactive_date,sysdate+1) > sysdate
                                ) B,
                                (SELECT * FROM LSP_VENDOR_STOCK_DETAIL                       
                                ) C
                            WHERE 
                            A.PART_LIST_HEADER_ID = B.PART_LIST_HEADER_ID
                            AND 
                            A.BACK_NUMBER = C.BACK_NUMBER ) Y
                            WHERE 
                            X.ORG_ID = Y.ORG_ID
                            AND
                            X.HEADER_ID = Y.HEADER_ID    
                            AND
                            X.ORG_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#org_id#">                    
                            AND
                            X.VENDOR_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#vendor_id#">
                    </cfquery>

                        <cfset filename = expandPath("./temp_file_dl/upload_stock_vendor.xls")>
    
                        <cfset xl = spreadsheetNew()>

                        <!--- Add header row --->
                        <cfset spreadsheetAddRow(xl, "BACK NUMBER,CURRENT QTY")>
                        <!--- format header --->
                        <cfscript>
                            headerFormat.fontsize="10";
                            headerFormat.bold=true;
                            spreadsheetFormatRow(xl, headerFormat, 1)
                        </cfscript>

                        <!--- Add query --->
                        <cfset spreadsheetAddRows(xl, getExceldetail)>
                        <!---<cfset uniqueFileName = "uploadstockvendor_#vendor_name#_" & getTickCount() & ".xls">--->
                        <cfset timestamp = now()>
                        <cfset formattedDate = dateFormat(timestamp, "dd-mm-yyyy")>                      
                        <cfset uniqueFileName = "uploadstockvendor_#vendor_name# |" & "#formattedDate#" &".xls">

                        <cfheader name="Content-Disposition" value="inline; filename=#uniqueFileName#">
                        <cfcontent type="application/vnd.msexcel" variable="#SpreadSheetReadBinary(xl)#">


