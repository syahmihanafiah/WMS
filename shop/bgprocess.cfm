<!---
  Suite         : SETUP
  Purpose       : NEW ACCESSORY CENTRE

  Version    Developer    		Date            Remarks
  v1.1.00     Syahmi         	9/08/2024   	1. Add Ownership for Gear Up

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
                            SELECT * FROM (
								SELECT b.org_description, a.shop_id, a.shop_name, a.description,a.ownership_id,b.org_description ownership_name,
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
								FROM gen_shop a, frm_organizations b
								WHERE a.org_id = b.org_id											
								<cfif org_id NEQ "" >
									AND b.org_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#org_id#">
								</cfif> 
								<cfif ownership_id NEQ "">
									AND a.ownership_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#ownership_id#">
								</cfif>  
                                )
								<cfif status NEQ "" >
								WHERE status = <cfqueryparam cfsqltype="cf_sql_varchar" value="#status#">
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
            	<cfquery name="checkIfExist" datasource="#dswms#">
                	SELECT count(1) as count from  gen_shop
                    WHERE UPPER(shop_name) = UPPER(<cfqueryparam cfsqltype="cf_sql_varchar" value="#shop_name#">)
                    AND org_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#org_id#">
                    AND (inactive_date is null or inactive_date >= sysdate)
                    AND rownum = 1
                </cfquery>
		 	  	 
                <cfif checkIfExist.count EQ 0> 
		 	  	 
                    <cfquery name="shopInfo" datasource="#dswms#">
                        SELECT gen_shop_id_seq.nextval newid FROM dual
                    </cfquery>
                    
                    <cfquery name="addShop" datasource="#dswms#">
                        INSERT INTO gen_shop
                        (
                        shop_id, org_id, plant_code, shop_name, description, 
                        active_date, <cfif inactive_date NEQ ""> inactive_date, </cfif>
                        ownership_id,creation_date, creation_by
                        )
                        VALUES
                        (
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#shopInfo.newid#">,
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#org_id#">,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="B">,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#shop_name#">, 
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#description#">, 
                            to_date(<cfqueryparam cfsqltype="cf_sql_varchar" value="#active_date#">,'dd/mm/yyyy'),
                            <cfif inactive_date NEQ "">
                                to_date(<cfqueryparam cfsqltype="cf_sql_varchar" value="#inactive_date#">,'dd/mm/yyyy'),
                            </cfif>
							<cfqueryparam cfsqltype="cf_sql_integer" value="#ownership_id#">,
                            sysdate,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.user_code#">
                        )
                        
               
                    </cfquery>
			  		 <cfset trx_status = "success" >	
                <cfelse>
                	 <cfset trx_status = "failed" >	
                     <cfset errorMsg = "Shop Existed" >  
                </cfif>    
              
				<cftransaction action="commit">  			
				 			
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
		  
				<cfquery name="updateShop" datasource="#dswms#">
					UPDATE gen_shop
					SET description = <cfqueryparam cfsqltype="cf_sql_varchar" value="#description#">, 
			<!---	    ownership_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#ownership_id#">, --->
						active_date = to_date(<cfqueryparam cfsqltype="cf_sql_varchar" value="#active_date#">,'dd/mm/yyyy'), 
						<cfif inactive_date NEQ ""> 
							inactive_date = to_date(<cfqueryparam cfsqltype="cf_sql_varchar" value="#inactive_date#">,'dd/mm/yyyy'),
						<cfelse>
							inactive_date = NULL,
						</cfif>
						last_updated_date = sysdate,
						last_updated_by = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.user_code#">
					WHERE shop_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#shop_id#"> 
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

		<cfoutput>~~#trx_status#~~#errorMsg#~~</cfoutput>
		
		
		
	</cfif>
	
	
</cfif>

 
 
 
  

 


 
 
  
