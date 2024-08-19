<!---
  Suite         : SETUP
  Purpose       : NEW ACCESSORY CENTRE

  Version    Developer    		Date            Remarks
  v1.1.00     Syahmi         	13/08/2024   	1. Add Ownership for Gear Up

--->
<cfsetting showDebugOutput="No"> 
<cfif parameterExists(action_flag) >

	<cfif action_flag EQ "load_data_grid" >

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
							<!-------------------------------- PUT YOUR QUERY HERE ------------------------------->
								SELECT * FROM 
                                (SELECT a.box_id, a.box_code, a.box_name, 
									   a.length || ' x ' || a.width || ' x ' || a.height measurement, a.weight,
								       b.org_description, 
									   <!---ADDED BY SYAHMI FOR GEAR UP PROJECT(START)--->
									   c.org_description ownership_name,
									   <!---ADDED BY SYAHMI FOR GEAR UP PROJECT(END)--->
								       a.creation_date, a.creation_by, a.last_updated_date, a.last_updated_by,
                                            CASE WHEN a.inactive_date IS NULL THEN
                                                     CASE WHEN a.active_date <= to_date(sysdate,'dd/mm/yy') 
                                                     THEN 'ACTIVE' ELSE 'INACTIVE' END
                                            ELSE  
                                                    CASE WHEN a.active_date <= to_date(sysdate,'dd/mm/yy') AND a.inactive_date > to_date(sysdate,'dd/mm/yy')
                                                    THEN 'ACTIVE' ELSE 'INACTIVE' END 
                                            END status,
                                            CASE WHEN a.inactive_date IS NULL THEN
                                                     CASE WHEN a.active_date <= to_date(sysdate,'dd/mm/yy') 
                                                     THEN 'ACTIVE' ELSE 'INACTIVE' END
                                            ELSE  
                                                    CASE WHEN a.active_date <= to_date(sysdate,'dd/mm/yy') AND a.inactive_date > to_date(sysdate,'dd/mm/yy')
                                                    THEN 'ACTIVE' ELSE 'INACTIVE' END 
                                            END edit
                                FROM gen_box a, frm_organizations b, frm_ownership c
                                WHERE a.org_id = b.org_id
								AND a.ownership_id = c.ownership_id
								<cfif org_id NEQ "" >
									AND a.org_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#org_id#">
								</cfif>
								<cfif ownership_id NEQ "">
									AND a.ownership_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#ownership_id#">
								</cfif>  
								)
								<cfif status NEQ "" >
									where status = <cfqueryparam cfsqltype="cf_sql_varchar" value="#status#">
								</cfif>    
							<!----------------------------------------------------------------------------------->  
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
 	
	<cfelseif action_flag EQ "add" > 
		
		<cfset trx_status = "failed" >
		<cfset errorMsg = "" >
		
		<cftransaction action="begin">
			<cftry> 
		 	  	 
			  	<cfquery name="boxInfo" datasource="#dswms#">
					SELECT gen_box_id_seq.nextval newid FROM dual
				</cfquery>
				
				<cfquery name="addBox" datasource="#dswms#">
					INSERT INTO gen_box
					(
					box_id, org_id, box_code, box_name,
					length, width, height, weight, ownership_id, 
					active_date, <cfif inactive_date NEQ ""> inactive_date, </cfif>
					creation_date, creation_by
					)
					VALUES
					(
						<cfqueryparam cfsqltype="cf_sql_integer" value="#boxInfo.newid#">, 
						<cfqueryparam cfsqltype="cf_sql_integer" value="#org_id#">, 
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#box_code#">,  
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#box_name#">,  
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#length#">,   
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#width#">,   
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#height#">,   
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#weight#">, 
						<cfqueryparam cfsqltype="cf_sql_integer" value="#ownership_id#">,  
						to_date(<cfqueryparam cfsqltype="cf_sql_varchar" value="#active_date#">,'dd/mm/yyyy'),
						<cfif inactive_date NEQ "">
							to_date(<cfqueryparam cfsqltype="cf_sql_varchar" value="#inactive_date#">,'dd/mm/yyyy'),
						</cfif>
						sysdate,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.user_code#">
					)
					
		   
				</cfquery>
			  
				<cftransaction action="commit">  
				<cfset trx_status = "success" >					
				 			
				<cfcatch type="database">
					<cftransaction action="rollback"> 
					<cfset trx_status = "failed" > 
					<cfset errorMsg = "	<b>Message:</b> #CFCATCH.Message#<br>
										<b>Native error code:</b> #CFCATCH.NativeErrorCode#<br>
										<b>SQLState:</b> #CFCATCH.SQLState#<br>
										<b>Detail:</b> #CFCATCH.Detail#<br>
						  " >   
				</cfcatch>	
			</cftry>	
		</cftransaction>

		<cfoutput>~~#trx_status#~~#errorMsg#~~#box_code#~~#boxInfo.newid#~~</cfoutput>
		
		
		
	<cfelseif action_flag EQ "edit" > 
		
		<cfset trx_status = "failed" >
		<cfset errorMsg = "" >
		
		<cftransaction action="begin">
			<cftry> 
		  
				<cfquery name="updateBox" datasource="#dswms#">
					UPDATE gen_box
					SET box_name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#box_name#">, 
						length = <cfqueryparam cfsqltype="cf_sql_varchar" value="#length#">,   
						width = <cfqueryparam cfsqltype="cf_sql_varchar" value="#width#">,   
						height = <cfqueryparam cfsqltype="cf_sql_varchar" value="#height#">,   
						weight = <cfqueryparam cfsqltype="cf_sql_varchar" value="#weight#">,   
						active_date = to_date(<cfqueryparam cfsqltype="cf_sql_varchar" value="#active_date#">,'dd/mm/yyyy'), 
						<cfif inactive_date NEQ ""> 
							inactive_date = to_date(<cfqueryparam cfsqltype="cf_sql_varchar" value="#inactive_date#">,'dd/mm/yyyy'),
						<cfelse>
							inactive_date = NULL,
						</cfif>
						last_updated_date = sysdate,
						last_updated_by = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.user_code#">
					WHERE box_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#box_id#"> 
				</cfquery>
			  
				<cftransaction action="commit">  
				<cfset trx_status = "success" >					
				 			
				<cfcatch type="database">
					<cftransaction action="rollback"> 
					<cfset trx_status = "failed" > 
					<cfset errorMsg = "	<b>Message:</b> #CFCATCH.Message#<br>
										<b>Native error code:</b> #CFCATCH.NativeErrorCode#<br>
										<b>SQLState:</b> #CFCATCH.SQLState#<br>
										<b>Detail:</b> #CFCATCH.Detail#<br>
						  " >   
				</cfcatch>	
			</cftry>	
		</cftransaction>

		<cfoutput>~~#trx_status#~~#errorMsg#~~#box_code#~~#box_id#~~</cfoutput>
	
    <cfelseif action_flag EQ "validateBoxCode" >
		
        <cfset currStatus = "but its INACTIVE" >
        
        <!--- PLANE PMSB PROJECT ---> 
        <cfquery name="validateBoxCode" datasource="#dswms#" >
            SELECT box_code,
            CASE WHEN a.inactive_date IS NULL THEN
                 CASE WHEN a.active_date <= to_date(sysdate,'dd/mm/yy') 
            THEN 'ACTIVE' ELSE 'INACTIVE' END
            ELSE  
                 CASE WHEN a.active_date <= to_date(sysdate,'dd/mm/yy') AND a.inactive_date > to_date(sysdate,'dd/mm/yy')
            THEN 'ACTIVE' ELSE 'INACTIVE' END 
            END status  
            FROM gen_box a
            WHERE UPPER(box_code) = UPPER('#box_code#')
            AND org_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#org_id#"> <!---add org_id 11/05/2018--->
		</cfquery>
        
        <cfif validateBoxCode.recordCount GT 0 >
        	<cfif validateBoxCode.status EQ 'ACTIVE' > <cfset currStatus = "and is currently ACTIVE" > </cfif>
        </cfif>
        
        <cfoutput>~~#validateBoxCode.recordCount#~~#currStatus#~~</cfoutput>
        
	</cfif>
	
	
</cfif>

 
 
 
  

 


 
 
  
