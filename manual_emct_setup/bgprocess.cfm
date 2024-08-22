<!---
  Suite         : EMCT
  Purpose       : Manual EMCT Setup

  Version    Developer    		Date            Remarks
  1.0.00     Yusrah         	     			Initial Creation
  1.1.00	 Harris				15/03/2021		Fix SIT BUGS   
  1.2.00     Syahmi             19/08/2024      Gear Up Project
--->

<cfif parameterExists(target) AND target EQ "grid">
<cfsetting showdebugoutput="no"></cfif>
<cfif parameterExists(action_flag) > <!---action_flag--->

	 <cfif action_flag EQ "search_rt" >
    
    		<cfset pagenum = url.pagenum >
			<cfset pagesize = url.pagesize >
			<cfset fromrow = pagenum * pagesize >
			<cfset torow = fromrow + pagesize >
			
			<cfif parameterExists(url.sortdatafield) >	
				<cfset sortfield = url.sortdatafield >
				<cfset sortorder = url.sortorder >
			</cfif>
				
				 
			<cfset prevfilterdatafield = "" >
			<cfset cond = "" >
			<cfset filterscount = url.filterscount >
			<cfif filterscount GT 0 >
					<cfset filterindexing = filterscount - 1 >
					<cfset cond = " WHERE (" > 
					<cfloop from="0" to="#filterindexing#" index="i">  
				
						<cfset filtervalue = evaluate("url.filtervalue" & i) > 
						<cfset filtercondition = evaluate("url.filtercondition" & i) > 
						<cfset filterdatafield = evaluate("url.filterdatafield" & i) >  
						<cfif evaluate("url.filteroperator" & i) EQ 0 >
							<cfset filteroperator = " AND " >  
						<cfelse>
							<cfset filteroperator = " OR " >  
						</cfif> 
				 
						<cfif "#filtercondition#" EQ "CONTAINS" >
							<cfset tempcond = " " & filterdatafield & " LIKE '%" & filtervalue & "%'" > 
						<cfelseif "#filtercondition#" EQ "DOES_NOT_CONTAIN" >
							<cfset tempcond = " " & filterdatafield & " NOT LIKE '%" &  filtervalue & "%'" > 
						<cfelseif "#filtercondition#" EQ "EQUAL" >
							<cfset tempcond = " " & filterdatafield & " EQ '" & filtervalue & "'" >
						<cfelseif "#filtercondition#" EQ "NOT_EQUAL" >
							<cfset tempcond = " " & filterdatafield & " NEQ '" & filtervalue & "'" >
						<cfelseif "#filtercondition#" EQ "GREATER_THAN" >
							<cfset tempcond = " " & filterdatafield & " GT '" & filtervalue & "'" >
						<cfelseif "#filtercondition#" EQ "LESS_THAN" >
							<cfset tempcond = " " & filterdatafield & " LT '" & filtervalue & "'" >
						<cfelseif "#filtercondition#" EQ "GREATER_THAN_OR_EQUAL" >
							<cfset tempcond = " " & filterdatafield & " GTE '" & filtervalue & "'" >
						<cfelseif "#filtercondition#" EQ "LESS_THAN_OR_EQUAL" >
							<cfset tempcond = " " & filterdatafield & " LTE '" & filtervalue & "'" >
						<cfelseif "#filtercondition#" EQ "STARTS_WITH" >
							<cfset tempcond = " " & filterdatafield & " LIKE '" & filtervalue & "%'" >
						<cfelseif "#filtercondition#" EQ "ENDS_WITH" >
							<cfset tempcond = " " & filterdatafield & " LIKE '%" & filtervalue & "'" >
						</cfif> 
						 
						<cfif prevfilterdatafield EQ "" >
							<cfset cond = cond & tempcond >
							<cfif filterscount EQ 1 > <cfset cond = cond & ")" > </cfif>
						<cfelse>
						
							<cfif prevfilterdatafield EQ filterdatafield >
								<cfset cond = cond & filteroperator & tempcond >
							<cfelseif prevfilterdatafield NEQ filterdatafield >
								<cfset cond = cond & " ) AND ( " & tempcond > 
							</cfif>
						
							<cfif i EQ filterindexing >
								<cfset cond = cond & " ) " >  
							</cfif>	
							
						</cfif>
						 
						<cfset prevfilterdatafield = filterdatafield >
						 
					</cfloop>
			</cfif> 
				
				
				<cfquery name="mainQuery" datasource="#dswms#">  
					SELECT a.*, ROWNUM rnum FROM(
						SELECT * FROM (  
							<!-------------------------------- PUT YOUR QUERY HERE --------------------------->  
                                
                                SELECT
                                		a.setup_id,
                                		a.org_id, b.org_description, c.org_description ownership_name,
                                        a.ownership_id,
										a.category,
                                        a.purpose,
                                        a.do_number_flag,
                                        a.trip_flag,
                                        a.m3_flag,
                                    	DECODE(a.status, 'Y', 'ACTIVE', 'INACTIVE') status,
                                        a.creation_by,
                                        a.last_updated_by,
                                        a.status status_img,
                                        a.creation_date,
                                        a.last_updated_date
                                FROM EMCT_MANUAL_SETUP a, FRM_ORGANIZATIONS b, frm_organizations c
                                WHERE a.org_id = b.org_id
                                AND a.ownership_id = c.org_id
                                AND c.ownership_flag = 'Y'
                                <cfif org_id NEQ "" >
									AND a.org_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#org_id#">
								</cfif>
                                <cfif category NEQ "" >
									AND a.category = <cfqueryparam cfsqltype="cf_sql_varchar" value="#category#">
								</cfif>
                                <cfif status NEQ "" >
									AND a.status = <cfqueryparam cfsqltype="cf_sql_varchar" value="#status#">
								</cfif>
                                ORDER BY setup_id
  
                              
							<!-------------------------------------------------------------------------------->  
						) 
						<cfoutput>#PreserveSingleQuotes(cond)#</cfoutput> 
						<cfif parameterExists(url.sortdatafield) >	
							ORDER BY <cfoutput>#sortfield# #sortorder#</cfoutput>
						</cfif>	
					) a 
				</cfquery>
				
				<cfquery name="allrows" dbtype="query"> 
					SELECT COUNT(*) total FROM mainQuery
				</cfquery>
				
				<cfquery name="pagedrows" dbtype="query" >
					SELECT * FROM mainQuery 
					WHERE rnum <= <cfqueryparam cfsqltype="cf_sql_integer" value="#torow#"> 

					AND rnum > <cfqueryparam cfsqltype="cf_sql_integer" value="#fromrow#">
				</cfquery>
				 
				<cfset countRow = 0 >
				<cfset countCol = 0 >
				
				<cfset data = "[" >
				<cfset data = data & "{""TotalRows"":""#allrows.total#"", ""Rows"":["> 
				 
				<cfloop query="pagedrows">
					<cfset data = data & "{" >
					<cfloop list="#lcase(pagedrows.columnlist)#" index="col"> 
						<cfset data = data & """" & col & """" & ":" & """" & Evaluate("pagedrows." & col) & """" >
						<cfset countCol = countCol + 1 >
						<cfif countCol EQ listLen(pagedrows.columnlist) > <cfset countCol = 0 > <cfelse> <cfset data = data & "," >  </cfif>
					</cfloop>
					<cfset data = data & "}" >
					<cfset countRow = countRow + 1 >
					<cfif countRow NEQ pagedrows.recordCount ><cfset data = data & "," ></cfif>
				</cfloop> 
				
				<cfset data = data & "]}" >
				<cfset data = data & "]" >
				
				<cfoutput>#data#</cfoutput> 
     
  	<cfelseif action_flag EQ "Add" > <!---action_flag define--->
    	
		<cfset trx_status = "failed" >
        <cfset trx_error = "" >
        <cfset trx_counter = 1 >
            
            <cftransaction action="begin">
                <cftry>
   					<cfif newRowList NEQ 0>
					<!---	 INSERT NEW ROWS IF AVAILABLE (START) --->
                        <cfloop list="#newRowList#" index="x" delimiters="," >
                            <cfset purpose = evaluate("purpose_#x#")>
                            <cfset do_number_flag = evaluate("do_number_flag_#x#")>
                            <cfset trip_flag = evaluate("trip_flag_#x#")>
                            <cfset m3_flag = evaluate("m3_flag_#x#")>
                            <cfset status = evaluate("status_#x#")>
                                                
                              <cfquery name="insertSetup" datasource="#dswms#">
                              INSERT INTO EMCT_MANUAL_SETUP
                              (
                                 setup_id, org_id, category, purpose, do_number_flag, trip_flag, m3_flag, status, creation_date, creation_by,ownership_id
                              )
                              VALUES
                              (
                                EMCT_MANUAL_SETUP_SEQ.NEXTVAL,
                                <cfqueryparam cfsqltype="cf_sql_integer" value="#org_id#">,
                                <cfqueryparam cfsqltype="cf_sql_varchar" value="#category#">,
                                replace(replace(replace(<cfqueryparam cfsqltype="cf_sql_varchar" value="#purpose#">,chr(9),' '),chr(10),' '),chr(13),' '),
                                <cfqueryparam cfsqltype="cf_sql_varchar" value="#do_number_flag#">,
                                <cfqueryparam cfsqltype="cf_sql_varchar" value="#trip_flag#">,
                                <cfqueryparam cfsqltype="cf_sql_varchar" value="#m3_flag#">,
                                <cfqueryparam cfsqltype="cf_sql_varchar" value="#status#">,
                                sysdate,
                                <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.user_code#">,
                                <cfqueryparam cfsqltype="cf_sql_integer" value="#ownership_id#">
                              )
                              </cfquery>
                        </cfloop>	
                        <!--- END --->
                        <cfset trx_counter = 1>
                    </cfif>
                    
                    <cftransaction action="commit">  
                    	<cfset trx_status = "success" >					
                                
                        <cfcatch type="database">
                            <cftransaction action="rollback"> 
                            <cfset trx_status = "failed" > 
                            <cfset trx_error = "<b>Message:</b> #CFCATCH.Message#<br>
                                                <b>Native error code:</b> #CFCATCH.NativeErrorCode#<br>
                                                <b>SQLState:</b> #CFCATCH.SQLState#<br>
                                                <b>Detail:</b> #CFCATCH.Detail#<br> " >   
						</cfcatch>	
                </cftry>	
            </cftransaction>
            
           <cfif trx_counter EQ 0>
				<cfset trx_status = "nodata" >
                <cfset trx_error = "No Data to be added!" >
           </cfif>
            
            <cfoutput>~~#trx_status#~~#trx_error#~~</cfoutput>
        
     <cfelseif action_flag EQ "edit" > <!---action_flag define--->
    	
		<cfset trx_status = "failed" >
        <cfset trx_error = "" >
        <cfset trx_counter = 0 >
            
            <cftransaction action="begin">
                <cftry>
   					<cfif newRowList NEQ 0>
					<!---	 INSERT NEW ROWS IF AVAILABLE (START) --->
                        <cfloop list="#newRowList#" index="x" delimiters="," >
                            <cfset purpose = evaluate("purpose_#x#")>
                            <cfset do_number_flag = evaluate("do_number_flag_#x#")>
                            <cfset trip_flag = evaluate("trip_flag_#x#")>
                            <cfset m3_flag = evaluate("m3_flag_#x#")>
                            <cfset status = evaluate("status_#x#")>
                                                
                              <cfquery name="insertSetup" datasource="#dswms#">
                              INSERT INTO EMCT_MANUAL_SETUP
                              (
                                 setup_id, org_id, category, purpose, do_number_flag, trip_flag, m3_flag, status, creation_date, creation_by
                              )
                              VALUES
                              (
                                EMCT_MANUAL_SETUP_SEQ.NEXTVAL,
                                <cfqueryparam cfsqltype="cf_sql_integer" value="#org_id#">,
                                <cfqueryparam cfsqltype="cf_sql_varchar" value="#category#">,
                                <cfqueryparam cfsqltype="cf_sql_varchar" value="#purpose#">,
                                <cfqueryparam cfsqltype="cf_sql_varchar" value="#do_number_flag#">,
                                <cfqueryparam cfsqltype="cf_sql_varchar" value="#trip_flag#">,
                                <cfqueryparam cfsqltype="cf_sql_varchar" value="#m3_flag#">,
                                <cfqueryparam cfsqltype="cf_sql_varchar" value="#status#">,
                                sysdate,
                                <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.user_code#">
                              )
                              </cfquery>
                        </cfloop>	
                        <!--- END --->
                        <cfset trx_counter = 1>
                    </cfif>
             	
                    
                    <!--- UPDATE ACTIVE/INACTIVE ROWS IF CHANGES ARE MADE (START)--->
                	<cfloop index="r" from="1" to="#totalRows#" > 
                    
                    	<cfset setup_id = evaluate("setup_id_#r#")>
                        <cfset status = evaluate("status_#r#")>
                        
                    	<cfquery name="checkForChanges" datasource="#dswms#">
           	                 	SELECT status
                                FROM EMCT_MANUAL_SETUP
                                WHERE setup_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#setup_id#">
                        </cfquery>
                        
                        <cfif checkForChanges.status NEQ status>
                           
                            <cfquery name="UpdateChanges" datasource="#dswms#">
                                UPDATE EMCT_MANUAL_SETUP
                                SET status = <cfqueryparam cfsqltype="cf_sql_varchar" value="#status#">,
                                	last_updated_date = sysdate,
                            		last_updated_by = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.user_code#">
                                WHERE setup_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#setup_id#">
                            </cfquery>
								
                            <cfset trx_counter = 1> <!---Update value as transaction are made --->
                        </cfif>
                    </cfloop>
                    <!--- (END)--->
                    
                    <cftransaction action="commit">  
                    	<cfset trx_status = "success" >					
                                
                    <cfcatch type="database">
                        <cftransaction action="rollback"> 
                        <cfset trx_status = "failed" > 
                        <cfset trx_error = "<b>Message:</b> #CFCATCH.Message#<br>
                                            <b>Native error code:</b> #CFCATCH.NativeErrorCode#<br>
                                            <b>SQLState:</b> #CFCATCH.SQLState#<br>
                                            <b>Detail:</b> #CFCATCH.Detail#<br> " >   
                    </cfcatch>	
                </cftry>	
            </cftransaction>
            
           <cfif trx_counter EQ 0>
				<cfset trx_status = "nodata" >
                <cfset trx_error = "No Data to be updated!" >
           </cfif>
            
            <cfoutput>~~#trx_status#~~#trx_error#~~</cfoutput>
        
     </cfif> <!---action_flag define--->   
    
    
 
</cfif> <!---action_flag--->


<cfif !parameterExists(target)>ENDOFREQUEST</cfif>
 
 


 
 
  
