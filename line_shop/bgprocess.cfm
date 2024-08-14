<!---
Version History
---------------

Version  Date        By       			Remarks
-------  ----------  ---------------  	-------------- 
1.0.0.1  17/03/2021  Nawawi Nasrudin    Add ratio configuration
2.0.0.0  13/08/2024  Syahmi Hanafiah    Gear Up 
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
								SELECT a.line_shop_id, a.line_shop, b.shop_name, c.org_description, a.creation_date, a.creation_by, a.last_updated_date, 
                                a.last_updated_by, a.jit_flag,
								<!---ADDED BY SYAHMI(START)---> 
								d.org_description ownership_name,
								<!---ADDED BY SYAHMI(START)--->
                                (SELECT DISTINCT org_nick_name FROM
                                frm_organizations WHERE
                                org_id = a.volume_source_org_id) AS volume_source,
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
											END status2 
								FROM gen_line_shop a, gen_shop b, frm_organizations c, frm_ownership d
								WHERE a.shop_id = b.shop_id
								AND a.org_id = c.org_id
								<!---ADDED BY SYAHMI(START)--->
								AND a.ownership_id = d.ownership_id
								<!---ADDED BY SYAHMI(END)--->
								<cfif org_id NEQ "" >
									AND c.org_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#org_id#">
								</cfif>  
								<cfif shop_id NEQ "" >
									AND b.shop_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#shop_id#">
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
		<cfset getLineShopID = ''>
        
		<cftransaction action="begin">
			<cftry> 
		 	  	 
                <cfquery name="checkIfExist" datasource="#dswms#">
                	SELECT count(1) as count FROM
                    gen_line_shop
                    WHERE shop_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#shop_id#">
                    AND UPPER(line_shop) = UPPER(<cfqueryparam cfsqltype="cf_sql_varchar" value="#line_shop#">)
                    AND org_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#org_id#">
                    AND (inactive_date is null OR inactive_date > sysdate)
                </cfquery>
				
                <cfif checkIfExist.count eq 0>
                    <cfquery name="lineShopInfo" datasource="#dswms#">
                        SELECT gen_line_shop_id_seq.nextval newid FROM dual
                    </cfquery>
                    
                    <cfset getLineShopID = #lineShopInfo.newid#>
                    
                    <!---Nawawi Nasrudin -- Add ratio Flag -- 17032021--->
                    <cfquery name="addLineShop" datasource="#dswms#">
                        INSERT INTO gen_line_shop
                        (
                        line_shop_id, shop_id, org_id, line_shop, 
                        active_date, <cfif inactive_date NEQ ""> inactive_date, </cfif>
                        creation_date, creation_by,
                        volume_source_org_id,
                        jit_flag, <!---PLANE PMSB PROJECT--->
						ownership_id, <!---GEAR UP PROJECT--->
                        ratio_flag
                        )
                        VALUES
                        (
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#getLineShopID#">,
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#shop_id#">,
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#org_id#">, 
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#line_shop#">,  
                            to_date(<cfqueryparam cfsqltype="cf_sql_varchar" value="#active_date#">,'dd/mm/yyyy'),
                            <cfif inactive_date NEQ "">
                                to_date(<cfqueryparam cfsqltype="cf_sql_varchar" value="#inactive_date#">,'dd/mm/yyyy'),
                            </cfif>
                            sysdate,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.user_code#">,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#volume_source#">,
                            <cfif #jit_flag_val# EQ 'Y'>
                            	'#jit_flag_val#',
                            <cfelse>
                            	'N',
                            </cfif>
							<cfqueryparam cfsqltype="cf_sql_integer" value="#ownership_id#">, <!---GEAR UP PROJECT--->
                            <cfif isDefined ('ratio_flag')> 
	                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#ratio_flag#">
                            <cfelse>
                            	<cfqueryparam cfsqltype="cf_sql_varchar" value="N">
                            </cfif>
                        )
                     </cfquery>
                     
                     <cfloop list="#newRowList#" index="r" delimiters="," >
                     	<cfset dpi_source = evaluate("dpi_source_#r#") >
                        <cfset do_start_date = evaluate("do_start_date_#r#") > 
                        <cfset do_end_date = evaluate("do_end_date_#r#") > 
                        
                         <cfquery name="assignDPISource" datasource="#dswms#">
                            INSERT INTO GEN_DPI_SOURCE
                            (DPI_SOURCE,LINE_SHOP_ID,START_DO_DATE,END_DO_DATE,CREATION_BY)
                            VALUES(
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#dpi_source#">,  
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#getLineShopID#">,
                            to_date(<cfqueryparam cfsqltype="cf_sql_varchar" value="#do_start_date#">,'dd/mm/yyyy'),
                            <cfif do_end_date NEQ "">
                                to_date(<cfqueryparam cfsqltype="cf_sql_varchar" value="#do_end_date#">,'dd/mm/yyyy'),
                            <cfelse>
                            	'',    
                            </cfif>
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.user_code#">
                            )
                         </cfquery>
                     </cfloop>
                     
                     <cfset trx_status = "success" >
                <cfelse>
               		 <cfset trx_status = "failed" >		
                     <cfset errorMsg = "Line Shop '#line_shop#' already exist" >   
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

		<cfoutput>~~#trx_status#~~#errorMsg#~~#line_shop#~~#getLineShopID#~~</cfoutput>
		
		
		
	<cfelseif action_flag EQ "edit" > 
		
		<cfset trx_status = "failed" >
		<cfset errorMsg = "" >
		
		<cftransaction action="begin">
			<cftry> 
		  		
                <!---Nawawi Nasrudin -- Add ratio Flag -- 17032021--->
				<cfquery name="updateLineShop" datasource="#dswms#">
					UPDATE gen_line_shop
					SET active_date = to_date(<cfqueryparam cfsqltype="cf_sql_varchar" value="#active_date#">,'dd/mm/yyyy'), 
						<cfif inactive_date NEQ ""> 
							inactive_date = to_date(<cfqueryparam cfsqltype="cf_sql_varchar" value="#inactive_date#">,'dd/mm/yyyy'),
						<cfelse>
							inactive_date = NULL,
						</cfif>
                        <cfif isDefined ('ratio_flag')> 
                            ratio_flag = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ratio_flag#">,
                        <cfelse>
                            ratio_flag = <cfqueryparam cfsqltype="cf_sql_varchar" value="N">,
                        </cfif>
						last_updated_date = sysdate,
						last_updated_by = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.user_code#">
					WHERE line_shop_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#line_shop_id#"> 
				</cfquery>
                
                
                <!--- UPDATE EXISTING DPI SOURCE --->
                <cfloop index="r" from="1" to="#actRowID#" >
                	<cfset dpi_source = evaluate("act_dpi_source_#r#") >
                    <cfset do_start_date = evaluate("act_do_start_date_#r#") > 
                    <cfset do_end_date = evaluate("act_do_end_date_#r#") > 
                    <cfset dpi_source_id = evaluate("dpi_source_id_#r#") > 
                    
                    <cfquery name="updateLineShop" datasource="#dswms#">
                        UPDATE GEN_DPI_SOURCE
                        	SET DPI_SOURCE =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#dpi_source#">,
                            	START_DO_DATE =  to_date(<cfqueryparam cfsqltype="cf_sql_varchar" value="#do_start_date#">,'dd/mm/yyyy'),
                                END_DO_DATE =   <cfif do_end_date NEQ "">
                                                    to_date(<cfqueryparam cfsqltype="cf_sql_varchar" value="#do_end_date#">,'dd/mm/yyyy'),
                                                <cfelse> '', </cfif>
                                LAST_UPDATED_BY =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.user_code#">,
                                LAST_UPDATED_DATE = SYSDATE
                        WHERE dpi_source_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#dpi_source_id#"> 
                    </cfquery>
                    
                </cfloop>

                
                 <!--- ADD NEW DPI SOURCE --->
                 <cfloop list="#newRowList#" index="r" delimiters="," >
					<cfset dpi_source = evaluate("dpi_source_#r#") >
                    <cfset do_start_date = evaluate("do_start_date_#r#") > 
                    <cfset do_end_date = evaluate("do_end_date_#r#") > 
                    
                     <cfquery name="assignDPISource" datasource="#dswms#">
                        INSERT INTO GEN_DPI_SOURCE
                        (DPI_SOURCE,LINE_SHOP_ID,START_DO_DATE,END_DO_DATE,CREATION_BY)
                        VALUES(
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#dpi_source#">,  
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#line_shop_id#">,
                        to_date(<cfqueryparam cfsqltype="cf_sql_varchar" value="#do_start_date#">,'dd/mm/yyyy'),
                        <cfif do_end_date NEQ "">
                            to_date(<cfqueryparam cfsqltype="cf_sql_varchar" value="#do_end_date#">,'dd/mm/yyyy'),
                        <cfelse>
                            '',    
                        </cfif>
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

		<cfoutput>~~#trx_status#~~#errorMsg#~~#line_shop#~~#line_shop_id#~~</cfoutput>
		
    <!--- PLANE PMSB PROJECT --->    
	<cfelseif action_flag EQ "fillShop" >
 
			<cfinvoke component="#session.component_path#.shop" method="retrieveShops" dsn="#dswms#" org_id="#org_id#" returnvariable="registeredShop" ></cfinvoke>
			<cfoutput>
				~~
				<cfif registeredShop.recordCount EQ 0 >
					<select class="formStyle" disabled="disabled"  name="shop_id" id="shop_id">
						<option value="">-- No shop found --</option>  
					</select> 
				<cfelse>
					<select name="shop_id" id="shop_id" class="formStyle"  onChange="clear_tooltips();">
						<option value="">-- Please Select --</option>
						<cfloop query="registeredShop">
							<option value="#shop_id#">#shop_name#</option>
						</cfloop> 
					</select> 
				</cfif>
				~~
			</cfoutput>
            
    <!--- PLANE PMSB PROJECT --->    
	<cfelseif action_flag EQ "fillJITFlag" >
 
        <cfquery name="fillJITFlag" datasource="#dswms#">
            SELECT jit_flag FROM gen_line_shop
            WHERE org_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#org_id#">
            AND jit_flag = 'Y'          
        </cfquery>
        
        <cfif fillJITFlag.recordCount EQ 0 >
            <cfset trx_status = "N">
        <cfelse>
            <cfset trx_status = "Y">
        </cfif>
    
    	<cfoutput>~~#trx_status#~~</cfoutput>
          

	</cfif>
	
	
</cfif>

 
 
 
  

 


 
 
  
