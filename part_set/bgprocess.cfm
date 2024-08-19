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
								 SELECT DISTINCT org_id, mother_part_number, 
                                 LISTAGG(part_number, ', ') WITHIN GROUP (ORDER BY part_number) child_part_number_list,
                                 part_name, back_number, vendor_id, vendor_name, org_description,ownership_name, status,
                                 MIN(creation_date) creation_date, MIN(creation_by)creation_by, MAX(last_updated_date) last_updated_date, MAX(last_updated_by) last_updated_by
                                 FROM (
                                    SELECT a.org_id, a.mother_part_number, a.part_number, 
                                    b.part_name, b.back_number, c.vendor_id, c.vendor_name, d.org_description,
                                    CASE WHEN a.active_date <= sysdate AND NVL(a.inactive_date,sysdate+1) > sysdate THEN 'ACTIVE'
                                    ELSE 'INACTIVE' END status,
									e.org_description ownership_name,
                                    a.creation_date, a.creation_by, a.last_updated_date, a.last_updated_by
                                    FROM gen_part_set a, gen_part_list_headers b, frm_vendors c, frm_organizations d,frm_organizations e									
                                    WHERE a.mother_part_number = b.part_number  
                                    AND b.vendor_id = c.vendor_id
									AND e.ownership_flag = 'Y'
									AND a.ownership_id = e.org_id
                                    AND a.org_id = d.org_id   									
									<cfif org_id NEQ "" >
										AND a.org_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#org_id#">
									</cfif> 
									<cfif mother_part_number NEQ "" >
										AND a.mother_part_number = <cfqueryparam cfsqltype="cf_sql_varchar" value="#mother_part_number#">
									</cfif>  
									<cfif mother_back_number NEQ "" >
										AND b.back_number = <cfqueryparam cfsqltype="cf_sql_varchar" value="#mother_back_number#">
									</cfif>
									<cfif mother_vendor_id NEQ "" >
										AND c.vendor_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#mother_vendor_id#">
									</cfif>
									<cfif mother_vendor_code NEQ "" >
										AND c.vendor_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#mother_vendor_code#">
									</cfif>
									<cfif part_number NEQ "" >
										AND a.part_number = <cfqueryparam cfsqltype="cf_sql_varchar" value="#part_number#">
									</cfif> 
									<cfif status NEQ "" >
										AND CASE WHEN a.active_date <= sysdate AND NVL(a.inactive_date,sysdate+1) > sysdate THEN 'ACTIVE'
                                        ELSE 'INACTIVE' END = <cfqueryparam cfsqltype="cf_sql_varchar" value="#status#">
									</cfif>  									 								  
                                  ) GROUP BY org_id, mother_part_number, part_name, back_number, vendor_id, vendor_name, org_description, ownership_name,status
								
								
  
								 
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
 	
	<cfelseif action_flag EQ "next"> 
	 
		<cfquery name="validateSelectedPartNumber" datasource="#dswms#">
			SELECT part_set_id FROM gen_part_set
			WHERE mother_part_number = <cfqueryparam cfsqltype="cf_sql_varchar" value="#mother_part_number#">  
			AND org_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#org_id#">  
		</cfquery> 
  
		<cfoutput>~~#validateSelectedPartNumber.recordCount#~~</cfoutput> 
	
	
	<cfelseif action_flag EQ "add" >
	
		<cfset trx_status = "failed" >
		<cfset errorMsg = "" >
		
		<cftransaction action="begin">
			<cftry> 
		 	  	   
				<cfloop list="#new_row_id#" index="x" >
				
					<cfquery name="dataInfo" datasource="#dswms#">
						SELECT gen_part_set_id_seq.nextval newid FROM dual
					</cfquery> 
					
					<cfset part_number = evaluate("part_number_" & x) > 
					<cfset active_date = evaluate("active_date_" & x) >
					<cfset inactive_date = evaluate("inactive_date_" & x) >
					
					<cfquery name="addPartSet" datasource="#dswms#">
						INSERT INTO gen_part_set
						(
						part_set_id, org_id, mother_part_number, part_number,  
						active_date, <cfif inactive_date NEQ ""> inactive_date, </cfif>
						creation_date, creation_by, ownership_id
						)
						VALUES
						(
							<cfqueryparam cfsqltype="cf_sql_integer" value="#dataInfo.newid#">, 
							<cfqueryparam cfsqltype="cf_sql_integer" value="#org_id#">, 
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#mother_part_number#">,    
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#part_number#">,   
							to_date(<cfqueryparam cfsqltype="cf_sql_varchar" value="#active_date#">,'dd/mm/yyyy'),
							<cfif inactive_date NEQ "">
								to_date(<cfqueryparam cfsqltype="cf_sql_varchar" value="#inactive_date#">,'dd/mm/yyyy'),
							</cfif>
							sysdate,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.user_code#">,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#ownership_id#">
						) 
					</cfquery>
				
				</cfloop>
				 
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

		<cfoutput>~~#trx_status#~~#errorMsg#~~</cfoutput>
	
		
		<cfelseif action_flag EQ "edit" >
	
		<cfset trx_status = "failed" >
		<cfset errorMsg = "" >
		
		<cftransaction action="begin">
			<cftry> 
		 	  	
				<cfloop list="#old_row_id#" index="x" > 
					
					<cfset part_set_id = evaluate("part_set_id_" & x) >  
					<cfset inactive_date = evaluate("old_inactive_date_" & x) >
					
					<cfquery name="updatePartSet" datasource="#dswms#">
						UPDATE gen_part_set
						SET 
						<cfif inactive_date NEQ ""> 
							inactive_date = to_date(<cfqueryparam cfsqltype="cf_sql_varchar" value="#inactive_date#">,'dd/mm/yyyy'),
						<cfelse>
							inactive_date = NULL,
						</cfif>
						last_updated_date = sysdate,
						last_updated_by = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.user_code#"> 
						WHERE part_set_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#part_set_id#"> 
					</cfquery>
				
				</cfloop>
				
				  
				<cfloop list="#new_row_id#" index="x" >
				
					<cfquery name="dataInfo" datasource="#dswms#">
						SELECT gen_part_set_id_seq.nextval newid FROM dual
					</cfquery> 
					
					<cfset part_number = evaluate("part_number_" & x) > 
					<cfset active_date = evaluate("active_date_" & x) >
					<cfset inactive_date = evaluate("inactive_date_" & x) >
					
					<cfquery name="addPartSet" datasource="#dswms#">
						INSERT INTO gen_part_set
						(
						part_set_id, org_id, mother_part_number, part_number,  
						active_date, <cfif inactive_date NEQ ""> inactive_date, </cfif>
						creation_date, creation_by
						)
						VALUES
						(
							<cfqueryparam cfsqltype="cf_sql_integer" value="#dataInfo.newid#">, 
							<cfqueryparam cfsqltype="cf_sql_integer" value="#org_id#">, 
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#mother_part_number#">,    
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#part_number#">,   
							to_date(<cfqueryparam cfsqltype="cf_sql_varchar" value="#active_date#">,'dd/mm/yyyy'),
							<cfif inactive_date NEQ "">
								to_date(<cfqueryparam cfsqltype="cf_sql_varchar" value="#inactive_date#">,'dd/mm/yyyy'),
							</cfif>
							sysdate,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.user_code#">
						) 
					</cfquery>
				
				</cfloop>
				 
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

		<cfoutput>~~#trx_status#~~#errorMsg#~~</cfoutput>
		
	
	</cfif>
	
	
	
	
</cfif>

 
 
 
  

 


 
 
  
