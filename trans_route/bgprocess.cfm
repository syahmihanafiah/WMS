<!---
  Suite         : EMCT
  Purpose       : Initial Creation

  Version    Developer    		Date            Remarks
  1.0.00     Yusrah         	03/12/2020     	Transportaion Route
  1.1.00     Harris         	15/03/20210     	Fix SIT Bugs
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
                                        a.route_group_header_id,
                                        a.org_id,
                                        d.org_description,
                                        e.org_id ownership_id,
                                        e.org_description ownership_name,
                                        a.tpl_id,
                                        c.vendor_name tpl_name,
                                        a.route_group,
                                        a.creation_by,
                                        a.last_updated_by,
                                        a.tier, 
                                            COUNT(b.route_group_detail_id) total_sub_group,
                                            CASE WHEN a.tier = 1 THEN '1st Tier' ELSE  '2nd Tier' END trans_type,
                                            CASE WHEN a.status = 'Y' THEN 'ACTIVE' ELSE  'INACTIVE' END status,
                                            CASE WHEN a.status = 'Y' THEN 'ACTIVE' ELSE  'INACTIVE' END status_img,
                                            to_char(a.creation_date, 'dd/mm/yyyy hh:mi:ss AM') creation_date,
                                            to_char(a.last_updated_date, 'dd/mm/yyyy hh:mi:ss AM') updated_date
                                FROM GEN_ROUTE_GROUP_HEADER a, GEN_ROUTE_GROUP_DETAIL b, FRM_VENDORS c, FRM_ORGANIZATIONS d, FRM_ORGANIZATIONS e
                                WHERE a.route_group_header_id = b.route_group_header_id (+)
                                AND a.tpl_id = c.vendor_id (+)
                                AND b.status(+) = 'Y'
                                AND a.org_id = d.org_id
                                AND a.org_id = e.org_id
                                AND e.ownership_flag = 'Y'
                                <cfif org_id NEQ "" >
									AND a.org_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#org_id#">
								</cfif>
                                <cfif ownership_id NEQ "">
                                    AND e.org_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#ownership_id#">
                                </cfif>
                                <cfif tpl_id NEQ "" >
									AND a.tpl_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#tpl_id#">
								</cfif>
                                <cfif route_group NEQ "" >
									AND a.route_group = <cfqueryparam cfsqltype="cf_sql_varchar" value="#route_group#">
								</cfif>
                                <cfif status NEQ "" >
									AND a.status = <cfqueryparam cfsqltype="cf_sql_varchar" value="#status#">
								</cfif>
                                GROUP BY a.route_group_header_id, a.org_id, d.org_description,e.org_id, e.org_description,a.tpl_id, c.vendor_name, a.route_group,
                                		a.creation_by, a.last_updated_by, a.tier, a.status, a.creation_date, a.last_updated_date
                                ORDER BY d.org_description, a.tpl_id, a.route_group
  
                              
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
     
  	<cfelseif action_flag EQ "add" > <!---action_flag define--->
    	
		<cfset trx_status = "failed" >
        <cfset trx_error = "" >
        <cfset trx_counter = 0 >
        <cfset route_group_header_id = "">
        
        <cfset extract_emct_flag = 'N'>
        <cfif isDefined("emct_flag")>
        	<cfset extract_emct_flag = 'Y'>
        </cfif>
            
            <cftransaction action="begin">
                <cftry>
   					
					<!--- Check If Exist --->
                    <cfquery name="checkHeader" datasource="#dswms#">         
                         SELECT route_group_header_id, tier
                         FROM GEN_ROUTE_GROUP_HEADER
                         WHERE route_group = <cfqueryparam cfsqltype="cf_sql_varchar" value="#route_group#">
                         AND org_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#org_id#">
                         AND tpl_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#tpl_id#">
                         AND status = 'Y'
                    </cfquery>

					<cfif checkHeader.Recordcount EQ 0>
                        <cfquery name="insertHeader" datasource="#dswms#">
                        INSERT INTO GEN_ROUTE_GROUP_HEADER
                        (
                            route_group_header_id, org_id,ownership_id, tpl_id, route_group, tier, creation_by, creation_date, emct_flag
                        )
                        VALUES
                        (
                            GEN_ROUTE_GROUP_HEADER_SEQ.NEXTVAL,
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#org_id#">,
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#ownership_id#">,
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#tpl_id#">,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#route_group#">,
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#tier#">,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.user_code#">,
                            sysdate,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#extract_emct_flag#">
                        )
                        </cfquery>
                      
                       <cfquery name="getHeader" datasource="#dswms#">         
                           SELECT route_group_header_id
                           FROM GEN_ROUTE_GROUP_HEADER
                           WHERE tpl_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#tpl_id#">
                           AND org_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#org_id#">
                           AND route_group = <cfqueryparam cfsqltype="cf_sql_varchar" value="#route_group#">
                           AND status = 'Y'
                       </cfquery>
                        
                       <cfset route_group_header_id = getHeader.route_group_header_id>
                        
                        <!--- INSERT NEW ROWS IF AVAILABLE (START)--->
                          <cfloop list="#newRowList#" index="x" delimiters="," >
                              <cfset sub_route_group = evaluate("sub_route_group_#x#")>
                              
                               <!--- Check If Exist --->
                                <cfquery name="checkDetail" datasource="#dswms#">         
                                     SELECT b.route_group_detail_id, a.route_group
                                     FROM GEN_ROUTE_GROUP_HEADER a, GEN_ROUTE_GROUP_DETAIL b
                                     WHERE a.route_group_header_id = b.route_group_header_id
                                     	AND a.tpl_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#tpl_id#">
                         				AND a.org_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#org_id#">
                                     	AND b.sub_route_group = <cfqueryparam cfsqltype="cf_sql_varchar" value="#sub_route_group#">
                                     	AND b.status = 'Y'
                                </cfquery>
        
                                <cfif checkDetail.Recordcount EQ 0>
                                                  
                                    <cfquery name="InsertDetails" datasource="#dswms#">
                                    INSERT INTO gen_route_group_detail
                                    (
                                        route_group_header_id, tpl_id, sub_route_group, creation_by
                                    )
                                    VALUES
                                    (
                                      <cfqueryparam cfsqltype="cf_sql_integer" value="#route_group_header_id#">,
                                      <cfqueryparam cfsqltype="cf_sql_integer" value="#tpl_id#">,
                                      <cfqueryparam cfsqltype="cf_sql_varchar" value="#sub_route_group#">,
                                      <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.user_code#">
                                    )
                                    </cfquery>
                                  	<cfset trx_counter = 1>
                          		<cfelse>
                          
                              		<cfset trx_counter = 2>
                              
                          		</cfif>        
                          </cfloop>	
                          <!--- END --->
                       
					<cfelse>
                    	
                      <cfset trx_counter = 2>
                    
                    </cfif>
                    
                    <cftransaction action="commit">  
                    	<cfset trx_status = "success" >					
                                
                        <cfcatch type="database">
                      		<cfset trx_counter = 3>
                            <cftransaction action="rollback"> 
                            <cfset trx_status = "failed" > 
                            <cfset trx_error = "<b>Message:</b> #CFCATCH.Message#<br>
                                                <b>Native error code:</b> #CFCATCH.NativeErrorCode#<br>
                                                <b>SQLState:</b> #CFCATCH.SQLState#<br>
                                                <b>Detail:</b> #CFCATCH.Detail#<br> " >   
						</cfcatch>	
                </cftry>	
            </cftransaction>
            
           <cfif trx_counter EQ 2>
				<cfset trx_status = "error" > 
                <cfset trx_error = "<b>Message : </b>Route Group already exist in tier #checkHeader.tier#<br>">
           <cfelseif trx_counter EQ 0>
				<cfset trx_status = "nodata" >
                <cfset trx_error = "No Data to be added!" >
           </cfif>
            
            <cfoutput>~~#trx_status#~~#trx_error#~~#route_group_header_id#~~N~~#ownership_id#~~</cfoutput>
        
     <cfelseif action_flag EQ "edit" > <!---action_flag define--->
    	
		<cfset trx_status = "failed" >
        <cfset trx_error = "" >
        <cfset trx_counter = 0 >
        <cfset trx_group_inactive = 'N' >
        
        <cfset extract_emct_flag = 'N'>
        <cfif isDefined("emct_flag")>
        	<cfset extract_emct_flag = 'Y'>
        </cfif>
            
   
            <cfquery name="checkHeader" datasource="#dswms#">         
                     SELECT emct_flag
                     FROM GEN_ROUTE_GROUP_HEADER
                     WHERE route_group_header_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#route_group_header_id#">
             </cfquery>
             
            <cftransaction action="begin">
                <cftry>
                
                 <cfif group_status EQ 'N'>
                 	<cfquery name="updateheaders" datasource="#dswms#">
                    	UPDATE GEN_ROUTE_GROUP_HEADER
                        	SET status = 'N',
                            	last_updated_date = sysdate,
                                last_updated_by = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.user_code#">
                     	WHERE route_group_header_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#route_group_header_id#">
                    </cfquery>
                    
                    <cfquery name="updateDetails" datasource="#dswms#">
                    	UPDATE GEN_ROUTE_GROUP_DETAIL
                        	SET status = 'N',
                            	last_updated_date = sysdate,
                                last_updated_by = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.user_code#">
                     	WHERE route_group_header_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#route_group_header_id#">
                          AND status = 'Y'
                    </cfquery>
       				<cfset trx_group_inactive = 'Y' >
                    <cfset trx_counter = 1>
                 <cfelse>
					  <!--- INSERT NEW ROWS IF AVAILABLE (START)--->
                      <cfloop list="#newRowList#" index="x" delimiters="," >
                          <cfset sub_route_group = evaluate("sub_route_group_#x#")>
                          
                           <!--- Check If Exist --->
                            <cfquery name="checkDetail" datasource="#dswms#">         
                                 SELECT b.route_group_detail_id, a.route_group
                                 FROM GEN_ROUTE_GROUP_HEADER a, GEN_ROUTE_GROUP_DETAIL b
                                 WHERE a.route_group_header_id = b.route_group_header_id
                                    AND a.tpl_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#tpl_id#">
                                    AND a.org_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#org_id#">
                                    AND b.sub_route_group = <cfqueryparam cfsqltype="cf_sql_varchar" value="#sub_route_group#">
                                    AND b.status = 'Y'
                            </cfquery>
    
                            <cfif checkDetail.Recordcount EQ 0>
                                              
                                <cfquery name="InsertDetails" datasource="#dswms#">
                                INSERT INTO gen_route_group_detail
                                (
                                    route_group_header_id, tpl_id, sub_route_group, creation_by
                                )
                                VALUES
                                (
                                  <cfqueryparam cfsqltype="cf_sql_integer" value="#route_group_header_id#">,
                                  <cfqueryparam cfsqltype="cf_sql_integer" value="#tpl_id#">,
                                  <cfqueryparam cfsqltype="cf_sql_varchar" value="#sub_route_group#">,
                                  <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.user_code#">
                                )
                                </cfquery>
                                <cfset trx_counter = 1>
                            <cfelse>
                      
                                <cfset trx_counter = 2>
                          
                            </cfif>        
                      </cfloop>	
                      <!--- END --->
                        
                        <!--- UPDATE ACTIVE/INACTIVE ROWS IF CHANGES ARE MADE (START)--->
                        <cfloop index="r" from="1" to="#totalRows#" > 
                        
                            <cfset route_group_detail_id = evaluate("route_group_detail_id_#r#")>
                            <cfset status = evaluate("status_#r#")>
                            
                            <cfquery name="checkForChanges" datasource="#dswms#">
                                    SELECT
                                    CASE WHEN status = 'Y' THEN 'ACTIVE' 
                                             ELSE 'INACTIVE' END
                                             AS status
                                    FROM GEN_ROUTE_GROUP_DETAIL
                                    WHERE route_group_detail_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#route_group_detail_id#">
                            </cfquery>
                            
                            <cfif checkForChanges.status NEQ status>
                            
                               <cfif status EQ "ACTIVE">
                                  <cfset status = "Y">
                               <cfelse>
                                  <cfset status = "N">
                               </cfif>
                               
                                <cfquery name="UpdateChanges" datasource="#dswms#">
                                    UPDATE GEN_ROUTE_GROUP_DETAIL
                                    SET status = <cfqueryparam cfsqltype="cf_sql_varchar" value="#status#">,
                                        last_updated_date = sysdate,
                                        last_updated_by = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.user_code#">
                                    WHERE route_group_detail_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#route_group_detail_id#">
                                </cfquery>
                                    
                                <cfset trx_counter = 1> <!---Update value as transaction are made --->
                            </cfif>
                        </cfloop>
                        <!--- (END)--->
                        
                        
                        <!--- Added by harris --->
                         <cfif checkHeader.emct_flag NEQ extract_emct_flag >
                            <cfquery name="updateHeaders" datasource="#dswms#">
                                UPDATE GEN_ROUTE_GROUP_HEADER
                                    SET emct_flag = <cfqueryparam cfsqltype="cf_sql_varchar" value="#extract_emct_flag#">
                                WHERE route_group_header_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#route_group_header_id#">
                            </cfquery>
                            <cfset trx_counter = 1>
                         </cfif>
                  
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
            
           <cfif trx_counter EQ 2>
				<cfset trx_status = "error" > 
                <cfset trx_error = "<b>Message : </b>Sub Group already exist in '#checkDetail.route_group#'<br>">
           <cfelseif trx_counter EQ 0>
				<cfset trx_status = "nodata" >
                <cfset trx_error = "No Data to be updated!" & checkHeader.emct_flag & extract_emct_flag>
           </cfif>
            
            <cfoutput>~~#trx_status#~~#trx_error#~~#route_group_header_id#~~#trx_group_inactive#~~#ownership_id#~~</cfoutput>
            
     
     
     
     <cfelseif action_flag EQ "checkIfExist" > 
     
			<!--- Check If Exist --->
            <cfquery name="checkHeader" datasource="#dswms#">         
                 SELECT route_group_header_id, tier
                 FROM GEN_ROUTE_GROUP_HEADER
                 WHERE route_group_header_id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#route_group_header_id#">
                 AND org_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#org_id#">
                 AND tpl_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#tpl_id#">
            </cfquery>

            <cfoutput>~~#checkHeader.recordCount#~~#checkHeader.tier#~~</cfoutput>
     
        
     </cfif> <!---action_flag define--->   
    
    
 
</cfif> <!---action_flag--->


<cfif !parameterExists(target)>ENDOFREQUEST</cfif>
 
 


 
 
  
