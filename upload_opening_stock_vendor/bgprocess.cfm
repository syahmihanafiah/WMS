<!---
  Suite         : LOCAL PART IMPROVEMENT
  Purpose       : 

  Version    Developer    		Date            Remarks
  1.0.00     Syahmi         	2/1/2024     	 
--->
<cfsetting showDebugOutput="yes">  
<cfif parameterExists(action_flag) >

    <cfif action_flag EQ "approve" >
     
        <cfset trx_status = "failed" >
        <cfset trx_error = ""> 
        <cfset headerArr = []>
        <cfset status = ''>
        <cfset msg = ''>
        <cfparam  name="correctFormat" default=false>
        <cfset header_row_start = 1 > 
        <cfset org_id = #organization#>          
        <cfset allData = []>   

            <cftransaction action="begin">
                <cftry>   
                                         
                    <cfset curr_file = #reupload_label#>
                    <cfset fullpath =  expandpath('./') & "temp_file\" & curr_file >  
                                    
                    <cfif IsSpreadsheetFile(fullpath)>
                        <cfspreadsheet action="read" src="#fullpath#" name="excel_file">
                        <!---<cffile action="delete" file="#fullpath#">--->
                        <cfset row_count = excel_file.rowCount>
                        <cfset col_count = spreadsheetGetColumnCount(excel_file)>
                        <cfloop index="i" from="#header_row_start#" to="#row_count#">
                            <cfif spreadsheetGetCellValue(excel_file,i,1) EQ 'BACK NUMBER' and (spreadsheetGetCellValue(excel_file, i, 2) eq 'CURRENT QTY'
                                 OR spreadsheetGetCellValue(excel_file, i, 2) EQ 'CURRENT QUANTITY')>
                                <cfset initial_header_pos = i>                            
                                <cfset correctFormat = true>
                            </cfif> 
                        </cfloop>

                        <cfif correctFormat>
                            <cfloop index="r" from="#header_row_start+1#" to="#row_count#">  
                                <cfset back_number = spreadsheetGetCellValue(excel_file, r, 1)>
                                <cfset current_qty = spreadsheetGetCellValue(excel_file, r, 2)>
                                <cfset arrayAppend(headerArr, { "Back Number": back_number, "Current_Qty": current_qty })>
                            </cfloop>

                            <cfloop array="#headerArr#" index="item">

                            <cfif  backNumberExists(#trim(item['Back Number'])#,'chkGenPart',0)>
                                <!---Check Header Existance--->
                                <cfquery name="chkHeaderExist" datasource="#dswms#">
                                    SELECT * FROM LSP_VENDOR_STOCK_HEADER
                                    WHERE ORG_ID =  <cfqueryparam cfsqltype="cf_sql_integer" value="#org_id#">
                                    AND VENDOR_ID =  <cfqueryparam cfsqltype="cf_sql_integer" value="#vendor_id#">
                                </cfquery>

                                <cfif chkHeaderExist.recordCount EQ 0>
                                    <!--- Loop through the array and insert data into the table --->
                                    <cfquery name="insertPartNumberHeader" datasource="#dswms#">
                                            INSERT INTO LSP_VENDOR_STOCK_HEADER
                                            (                                 
                                                ORG_ID,
                                                VENDOR_ID,
                                                CREATION_DATE,
                                                CREATION_BY
                                            )
                                            VALUES (
                                                <cfqueryparam cfsqltype="cf_sql_integer" value="#org_id#">,
                                                <cfqueryparam cfsqltype="cf_sql_integer" value="#vendor_id#">,
                                                sysdate,                  
                                                <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.user_code#">                      
                                            )
                                    </cfquery>  
                                </cfif>  
                                    <!---Get Current Seq Val
                                        <cfquery name="getHeaderID" datasource="#dswms#">
                                            SELECT LSP_VENDOR_STOCK_HEADER_SEQ.currval header_id FROM DUAL
                                        </cfquery> 
                                        <cfset header_id = getHeaderID.header_id>

                                        <cfquery name="getcurrheaderID" datasource="#dswms#">
                                            SELECT MAX(HEADER_ID) FROM LSP_VENDOR_STOCK_DETAIL
                                        </cfquery>
                                    --->
                                    <cfquery name="getExistingHeaderID" datasource="#dswms#">
                                        SELECT HEADER_ID FROM LSP_VENDOR_STOCK_HEADER 
                                        WHERE 
                                        ORG_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#org_id#">
                                        AND 
                                        VENDOR_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#vendor_id#">
                                    </cfquery>      
                                    <cfset header_id = #getExistingHeaderID.HEADER_ID#>                                     
                                    <cfif !backNumberExists(#trim(item['Back Number'])#,'chkPartNumDetail',#vendor_id#)>   
                    
                                        <cfquery name="insertPartNumberDetail" datasource="#dswms#">
                                            INSERT INTO LSP_VENDOR_STOCK_DETAIL
                                            (
                                                HEADER_ID,
                                                BACK_NUMBER,
                                                CURR_QTY,
                                                CREATION_BY,
                                                CREATION_DATE
                                            )
                                            VALUES (
                                                <cfqueryparam cfsqltype="cf_sql_integer" value="#header_id#">,
                                                <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(item['Back Number'])#">,
                                                <cfqueryparam cfsqltype="cf_sql_integer" value="#item['Current_Qty']#">,
                                                <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.user_code#">,
                                                sysdate 
                                            )
                                        </cfquery>

                                    <cfelse>
                                        <cfquery name="chkprevQty" datasource="#dswms#">
                                            SELECT B.BACK_NUMBER,B.CURR_QTY
                                            FROM LSP_VENDOR_STOCK_HEADER A, LSP_VENDOR_STOCK_DETAIL B
                                            WHERE A.HEADER_ID = B.HEADER_ID
                                            AND 
                                            A.VENDOR_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#vendor_id#">
                                            AND 
                                            B.BACK_NUMBER = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(item['Back Number'])#">
                                            AND B.HEADER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#header_id#">
                                        </cfquery>
                                        <cfquery name="updatePartNumberDetail" datasource="#dswms#">
                                            UPDATE LSP_VENDOR_STOCK_DETAIL
                                            SET 
                                            UPDATE_DATE = sysdate,
                                            UPDATE_BY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.user_code#">,
                                            PREV_QTY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#chkprevQty.curr_qty#">,
                                            CURR_QTY = <cfqueryparam cfsqltype="cf_sql_integer" value="#item['Current_Qty']#">
                                            WHERE 
                                            BACK_NUMBER = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(item['Back Number'])#">
                                            AND
                                            HEADER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#header_id#">
                                        </cfquery>
                                    </cfif>

                            </cfif><!---ENDING FOR PART EXISTANCE CHECKING--->
                        </cfloop>
                                <cffile action="delete" file="#fullpath#">
                        <cfelse> 
                            <cfset msg='Excel file data format is incorrect'>  
                        </cfif> 

                    </cfif>                               
                    <cftransaction action="commit">  
                    <cfset trx_status = "success" >                                      	                                          
                    <cfcatch type="database">
                        <cftransaction action="rollback"> 
                        <cfset trx_status = "failed" > 
                        <cfset trx_error = "	<b>Message:</b> #CFCATCH.Message#<br>
                                                <b>Native error code:</b> #CFCATCH.NativeErrorCode#<br>
                                                <b>SQLState:</b> #CFCATCH.SQLState#<br>
                                                <b>Detail:</b> #CFCATCH.Detail#<br>
                        " >     
                    </cfcatch>	                    
                </cftry>	
            </cftransaction> 
           
    
            <cfoutput>~~#trx_status#~~#trx_error#~~</cfoutput>

            <!--FUNCTION TO CHECK WHETHER THE PART NUMBER EXIST OR NOT---->
            <cffunction name="backNumberExists" returntype="boolean">
                <cfargument name="backNumber" type="any" required="true">
                <cfargument name="chkGenPart" type="any" required="true">
                <cfargument name="vendorID" type="any" required="true">

                <cfif chkGenPart EQ 'chkGenPart'>

                    <cfquery name="chkpartnumExist" datasource="#dswms#">
                        SELECT BACK_NUMBER FROM GEN_PART_LIST_HEADERS
                        WHERE BACK_NUMBER = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.backNumber#">
                    </cfquery>

                    <cfif chkpartnumExist.recordCount NEQ 0>
                        <cfreturn true>
                    <cfelse>
                        <cfreturn false>
                    </cfif>
                    
                <cfelse>

                     <cfquery name="chkpartnumDetail" datasource="#dswms#">
                        SELECT B.BACK_NUMBER
                        FROM LSP_VENDOR_STOCK_HEADER A, LSP_VENDOR_STOCK_DETAIL B
                        WHERE A.HEADER_ID = B.HEADER_ID
                        AND 
                        A.VENDOR_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.vendorID#">
                        AND 
                        B.BACK_NUMBER = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.backNumber#">                      
                     </cfquery>  
                    <cfif chkpartnumDetail.recordCount NEQ 0>
                        <cfreturn true>
                    <cfelse>
                        <cfreturn false>
                    </cfif>  

                </cfif>
            </cffunction>


    <cfelseif action_flag EQ 'loadDataGrid'>

            <cfquery name="getData" datasource="#dswms#" >
                SELECT rownum rnum, a.*
                	FROM(
                    	<!-------------------------------- PUT YOUR QUERY HERE --------------------------->                      
                SELECT ID,ORG_DESCRIPTION,VENDOR_NAME,PART_NAME,PART_NUMBER,BACK_NUMBER,QTY_PER_BOX,PREV_QTY,CURR_QTY,UPDATE_DATE,UPDATE_BY FROM 
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
                    SELECT ID,HEADER_ID,ORG_ID,A.PART_NUMBER,A.PART_NAME,A.BACK_NUMBER,B.QTY_PER_BOX,PREV_QTY,CURR_QTY,UPDATE_BY,UPDATE_DATE
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
                    <cfif org_id NEQ ''>    
                    AND
                    X.ORG_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#org_id#">
                    </cfif>
                    <cfif vendor_id NEQ ''> 
                    AND
                    X.VENDOR_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#vendor_id#">     
                    </cfif>
                    <cfif back_number NEQ ''>
                    AND 
                    Y.BACK_NUMBER = <cfqueryparam cfsqltype="cf_sql_varchar" value="#back_number#">
                    </cfif>  
                    <cfif part_number NEQ ''>
                    AND 
                    Y.PART_NUMBER = <cfqueryparam cfsqltype="cf_sql_varchar" value="#part_number#">
                    </cfif>    
                       <!-------------------------------------------------------------------------------->
				) a
            </cfquery>         
        <cfoutput>~~#serializeJSON(getData)#~~</cfoutput>


    <cfelseif action_flag EQ 'loadQuantity'>
        <cfquery name="loadQuantity" datasource="#dswms#">
                SELECT X.HEADER_ID, Y.ID, X.ORG_DESCRIPTION, X.VENDOR_NAME, Y.BACK_NUMBER, Y.PART_NUMBER, Y.PART_NAME, Y.PREV_QTY,Y.CURR_QTY
                FROM 
                    (SELECT A.HEADER_ID, B.ORG_DESCRIPTION, C.VENDOR_NAME
                    FROM LSP_VENDOR_STOCK_HEADER A, FRM_ORGANIZATIONS B, FRM_VENDORS C
                    WHERE A.ORG_ID = B.ORG_ID
                    AND A.VENDOR_ID = C.VENDOR_ID) X,
                    (SELECT A.HEADER_ID, A.ID, A.BACK_NUMBER, B.PART_NUMBER, B.PART_NAME, A.PREV_QTY,A.CURR_QTY
                    FROM LSP_VENDOR_STOCK_DETAIL A, GEN_PART_LIST_HEADERS B
                    WHERE A.BACK_NUMBER = B.BACK_NUMBER) Y
                WHERE X.HEADER_ID = Y.HEADER_ID(+)
                AND Y.ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#id#">       
        </cfquery>            
        <cfoutput>~~#loadQuantity.CURR_QTY#~~#loadQuantity.ID#~~#loadQuantity.ORG_DESCRIPTION#~~#loadQuantity.VENDOR_NAME#~~#loadQuantity.BACK_NUMBER#~~#loadQuantity.PART_NUMBER#~~#loadQuantity.PART_NAME#~~#loadQuantity.PREV_QTY#~~#loadQuantity.CURR_QTY#~~</cfoutput>

        <cfelseif action_flag EQ 'updateQuantity'>
            <cfset trx_status = "failed" >
            <cfset trx_error = ""> 
                
                <cftransaction action="begin">
                    <cftry>

                        <cfquery name="getPrevQty" datasource="#dswms#">
                            SELECT CURR_QTY FROM LSP_VENDOR_STOCK_DETAIL
                            WHERE ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#detail_id#">
                        </cfquery>

                        <cfquery name="updateQty" datasource="#dswms#">
                            UPDATE LSP_VENDOR_STOCK_DETAIL
                            SET 
                                PREV_QTY = <cfqueryparam cfsqltype="cf_sql_integer" value="#getPrevQty.CURR_QTY#">,
                                CURR_QTY = <cfqueryparam cfsqltype="cf_sql_integer" value="#updateQty#">,
                                UPDATE_BY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.user_code#">,
                                UPDATE_DATE = sysdate
                            WHERE ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#detail_id#">
                        </cfquery>
                            
                            <cftransaction action="commit">  
                            <cfset trx_status = "success" >	  
                                           
                        <cfcatch type="database">
                            <cftransaction action="rollback"> 
                            <cfset trx_status = "failed" > 
                            <cfset trx_error = "	<b>Message:</b> #CFCATCH.Message#<br>
                                                    <b>Native error code:</b> #CFCATCH.NativeErrorCode#<br>
                                                    <b>SQLState:</b> #CFCATCH.SQLState#<br>
                                                    <b>Detail:</b> #CFCATCH.Detail#<br>
                            " >   
                        </cfcatch>	
                        
                    </cftry>	
                </cftransaction>                        
                <cfoutput>~~#trx_status#~~#trx_error#~~</cfoutput>

    <cfelseif action_flag EQ 'delete_file'>
            <cfset trx_status = "failed" >
            <cfset trx_error = ""> 
            <cfset message = "">
                <cftransaction action="begin">
                    <cftry>
                            <cfset curr_file = #reupload_label#>         
                            <cfset filePath = expandPath('./temp_file') & '/' & curr_file>    

                            <!--- Check if the file exists before deleting it --->
                            <cfif fileExists(filePath)>
                                <cffile action="delete" file="#filePath#">
                                <cfif fileExists(filePath)>
                                    <cfset message = "Failed to delete file: #curr_file#">
                                <cfelse>
                                    <cfset message = "File Name: #curr_file# - Successfully Removed">   
                                </cfif>
                            <cfelse>
                                <cfset message = "Closing the tab.">
                            </cfif>                                                      
                            <cftransaction action="commit">  
                            <cfset trx_status = "success" >	  
                                           
                        <cfcatch type="database">
                            <cftransaction action="rollback"> 
                            <cfset trx_status = "failed" > 
                            <cfset trx_error = "	<b>Message:</b> #CFCATCH.Message#<br>
                                                    <b>Native error code:</b> #CFCATCH.NativeErrorCode#<br>
                                                    <b>SQLState:</b> #CFCATCH.SQLState#<br>
                                                    <b>Detail:</b> #CFCATCH.Detail#<br>
                            " >   
                        </cfcatch>	
                        
                    </cftry>	
                </cftransaction>   
                <cfoutput>~~#trx_status#~~#trx_error#~~#message#~~</cfoutput>

        <cfelseif action_flag EQ 'chkvendorstockData'>

            <cfset trx_status = "failed" >
            <cfset trx_error = ""> 
                
                <cftransaction action="begin">
                    <cftry>
                        <cfquery name="getData" datasource="#dswms#">
                            SELECT ID,ORG_DESCRIPTION,VENDOR_NAME,PART_NAME,PART_NUMBER,BACK_NUMBER,QTY_PER_BOX,PREV_QTY,CURR_QTY,UPDATE_DATE,UPDATE_BY FROM 
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

                            
                            <cftransaction action="commit">  
                            <cfset trx_status = "success" >	  
                                           
                        <cfcatch type="database">
                            <cftransaction action="rollback"> 
                            <cfset trx_status = "failed" > 
                            <cfset trx_error = "	<b>Message:</b> #CFCATCH.Message#<br>
                                                    <b>Native error code:</b> #CFCATCH.NativeErrorCode#<br>
                                                    <b>SQLState:</b> #CFCATCH.SQLState#<br>
                                                    <b>Detail:</b> #CFCATCH.Detail#<br>
                            " >   
                        </cfcatch>	
                        
                    </cftry>	
                </cftransaction>           
                             
                <cfoutput>~~#trx_status#~~#trx_error#~~#getData.recordCount#~~</cfoutput>    
      
            <cfelseif action_flag eq "load_warehouse">
        
                <cfquery name ="load_warehouse" datasource="#dswms#">
                    <!---THIS IS A PLACEHOLDER, WAITING FOR REAL WAREHOUSE TABLE--->
                    SELECT A.VENDOR_ID, VENDOR_NAME FROM 
                        (SELECT * FROM GEN_WHOUSE WHERE STATUS = 'ACTIVE') A,
                        (SELECT * FROM FRM_VENDORS ) B
                        WHERE A.VENDOR_ID = B.VENDOR_ID   
                        ORDER BY VENDOR_NAME ASC  
                </cfquery>
        
                <cfif load_warehouse.recordCount EQ 0 >
                    <cfset optionList = "<option value=''>-- No record found --</option>" > 
                <cfelse>
                    <cfset optionList = "<option value=''>-- Please Select --</option>">
                </cfif>
        
                <cfloop query="load_warehouse">            
                    <cfset optionList = optionList & "<option value='" & vendor_id & "'>" & vendor_name & "</option>" >
                </cfloop>
                    
                <cfoutput>~~#load_warehouse.recordCount#~~#optionList#~~</cfoutput>  
                                        
    </cfif> 
</cfif>
