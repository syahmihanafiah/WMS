<cfif parameterExists(target) AND target EQ "grid">
<cfsetting showdebugoutput="no"></cfif>
<cfif parameterExists(action_flag) > <!---action_flag--->

	 <cfif action_flag EQ "search_rt" > <!---action_flag define--->
    
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
                               
							SELECT * FROM (	

                                SELECT h.tpl_concept_header_id AS tpl_id,
                                	   h.group_code,
                                       h.group_desc,
                                       h.tier,
                                       h.creation_date,
                                       h.creation_by,
                                       h.last_updated_date AS updated_date,
                                       h.last_updated_by AS updated_by,
                                       o.org_description,
                                       o.org_id,
                                       p.org_description ownership_name,
                                       p.org_id ownership_id,
                                           CASE WHEN h.inactive_date IS NULL THEN 'ACTIVE' 
                                           WHEN h.inactive_date > sysdate THEN 'ACTIVE'
                                           ELSE 'INACTIVE' END
                                           AS status,
                                                    CASE WHEN h.inactive_date IS NULL THEN 'ACTIVE' 
                                                    WHEN h.inactive_date > sysdate THEN 'ACTIVE'
                                                    ELSE 'INACTIVE' END
                                                    AS status_img
<!---                                                   
                                          CASE WHEN(h.active_date <= sysdate AND h.inactive_date IS NULL) THEN 'ACTIVE' 
                                           WHEN (h.active_date <= sysdate AND h.inactive_date > sysdate)  THEN 'ACTIVE'
                                           ELSE 'INACTIVE' END
                                           AS status,
                                                   CASE WHEN (h.active_date <= sysdate AND h.inactive_date IS NULL) THEN 'ACTIVE' 
                                                   WHEN (h.active_date <= sysdate AND h.inactive_date > sysdate) THEN 'ACTIVE'
                                                   ELSE 'INACTIVE' END
                                                   AS status_img  --->       
                                  FROM gen_tpl_concept_headers h, frm_organizations o, frm_organizations p
                                 WHERE o.org_id = h.org_id
                                 AND h.ownership_id = p.org_id
                                 AND p.ownership_flag = 'Y' 
                                 AND o.org_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#org_id#">
                                 
                                 <cfif group_code neq ""> 
                                	 AND h.group_code = <cfqueryparam cfsqltype="cf_sql_varchar" value="#group_code#">
                     			 </cfif>                                  
                                 <cfif tier neq ""> 
                                 AND h.tier = <cfqueryparam cfsqltype="cf_sql_integer" value="#tier#">
                     			 </cfif> 
                                 <cfif ownership_id NEQ "">
                                 AND h.ownership_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#ownership_id#">
                                 </cfif>
                              	)
                                 <cfif status neq ""> 
                                 WHERE status = <cfqueryparam cfsqltype="cf_sql_varchar" value="#status#">
                     			 </cfif>
                                 
                                ORDER BY group_code, tier
                              
                              
                          
                         
                              
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
     
 <cfelseif action_flag EQ "add" ><!---action_flag define--->
 
	 <cfset trx_status = "success" >
      <cfset errorMsg = "" >
         
        <cftransaction action="begin">
            <cftry>
               <!--- update statment parents --->
               <cfset counter = 1> 					  	
                     <cfloop index="r" from="1" to="#actRowID#" > 
                        <cfset tpl_id = evaluate("TPL_ID_#r#") >  
                        <cfset inactive_date = evaluate("INACTIVE_DATE_PICKER_#r#") >
							
                       			<cfif #inactive_date# neq "">
                                    <cfquery name="checkForChanges" datasource="#dswms#">
                                        SELECT
                                            tpl_concept_header_id, active_date, inactive_date
                                        FROM
                                            gen_tpl_concept_headers
                                        WHERE
                                            tpl_concept_header_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#tpl_id#">
                                        AND inactive_date IS NULL
                                    </cfquery>
                                                              
                                    <cfif checkForChanges.Recordcount gt 0>                    
                                        <cfquery name="updateTPL" datasource="#dswms#" >
                                            UPDATE gen_tpl_concept_headers
                                            SET inactive_date = 
                                                        to_date(<cfqueryparam cfsqltype="cf_sql_varchar" value="#inactive_date#">,'dd/mm/rrrr'),
                                            last_updated_date = sysdate,
                                            last_updated_by = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.user_code#">
                                            WHERE tpl_concept_header_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#tpl_id#">
                                       </cfquery>
                                       
                                       		<cfquery name="checkIfGotChild" datasource="#dswms#">
                                                SELECT
                                                    tpl_concept_header_id, inactive_date
                                                FROM
                                                    gen_tpl_concept_details
                                                WHERE
                                                    tpl_concept_header_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#tpl_id#">
                                                AND inactive_date IS NULL
                                            </cfquery>
                                            
                                            <cfif checkIfGotChild.recordcount gt 0>
                                                <cfquery name="updateChildTPL" datasource="#dswms#">
                                                    UPDATE gen_tpl_concept_details
                                                    SET inactive_date = 
                                                                to_date(<cfqueryparam cfsqltype="cf_sql_varchar" value="#inactive_date#">,'dd/mm/rrrr'),
                                                    last_updated_date = sysdate,
                                                    last_updated_by = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.user_code#">
                                                    WHERE tpl_concept_header_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#tpl_id#">
                                                
                                                </cfquery>
                                            </cfif>
                                       
                                            <cfset counter = 403>  
                                    </cfif>
                               </cfif>     
                         
                     </cfloop>
                     
                     
                     <!--- update statment child--->
                      <cfloop index="r" from="1" to="#actRowID#" >
                      	<cfset childrowid = evaluate("childrowid_#r#") > 
                        
                      		 <cfloop index="x" from="1" to="#childrowid#" >
								<cfset detail_id = evaluate("detail_id_#r#_#x#") >  
                                <cfset status = evaluate("status_#r#_#x#") >
                                
                                <cfquery name="checkChildChange" datasource="#dswms#">
                                    SELECT * FROM(
                                    SELECT
                                         CASE WHEN inactive_date IS NULL THEN 'Y' 
                                         ELSE 'N' END
                                         AS status
                                    FROM gen_tpl_concept_details
                                    WHERE tpl_concept_detail_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#detail_id#">
                                    )
                                    WHERE status = 'Y'
                                </cfquery>
                                                          
                                <cfif #checkChildChange.status# NEQ #status#>                    
                                    <cfquery name="updateDetails" datasource="#dswms#" >
                                        UPDATE gen_tpl_concept_details
                                        SET inactive_date = sysdate,
                                        last_updated_date = sysdate,
                                        last_updated_by = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.user_code#">
                                        WHERE tpl_concept_detail_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#detail_id#" >
                                   </cfquery>
                                        <cfset counter = 403>  
                                </cfif>   
							
                       		 </cfloop>		
                         
                     </cfloop>
                                
          <!--- insert and update statment --->
        
           <cfif new_row_id NEQ "">
           
           		 <cfloop list="#new_row_id#" index="r" delimiters="," >
	
                    <cfset group_code = evaluate("group_code_#r#") >
                    <cfset get_desc = evaluate("get_desc_#r#") >
                    <cfset get_collection = evaluate("get_collection_#r#") >
                    <cfset get_handling = evaluate("get_handling_#r#") >
                    <cfset get_delivery = evaluate("get_delivery_#r#") >
                    <cfset start_date = evaluate("start_date_#r#") >
                    <cfset end_date = evaluate("end_date_#r#") >
                    
             		<!--- Check If Exist --->
                 <cfquery name="checkIfExist" datasource="#dswms#">         
                        SELECT
						 	h.group_code, h.active_date, h.inactive_date, h.tier
                         FROM
                         	gen_tpl_concept_headers h
                         WHERE
                         UPPER(h.group_code) = UPPER(<cfqueryparam cfsqltype="cf_sql_varchar" value="#group_code#">)
                         AND h.tier = <cfqueryparam cfsqltype="cf_sql_integer" value="#tier#">                      
                         AND h.org_id =  <cfqueryparam cfsqltype="cf_sql_integer" value="#org_id#">
                 </cfquery>

						<cfif checkIfExist.Recordcount GT 0>
                        <cfset counter = 404>    
                                         <cfset trx_status = "error" > 
                                         <cfset errorMsg = "<b>Message:</b> Group Code Used at Transporter #checkIfExist.tier#<br>">
                     		<cfquery name="checkForActive" datasource="#dswms#">         
                                    SELECT
                                        h.group_code, h.active_date, h.inactive_date, h.tier
                                     FROM
                                        gen_tpl_concept_headers h
                                     WHERE
                                     UPPER(h.group_code) = UPPER(<cfqueryparam cfsqltype="cf_sql_varchar" value="#group_code#">)
                                     AND h.inactive_date IS NULL
                                     AND h.tier = <cfqueryparam cfsqltype="cf_sql_integer" value="#tier#">                        
                            </cfquery>
                             		
                                    <cfif checkForActive.Recordcount GT 0>
                                   		 <cfset counter = 404>    
                                         <cfset trx_status = "error" > 
                                         <cfset errorMsg = "<b>Message:</b>Group Code Still Active at Transporter #checkForActive.tier#, Please set inactive date<br>">
                                         
                                    <cfelse>
                                    	 
                                          <cfquery name="checkForExpired" datasource="#dswms#">         
                                                SELECT
                                                    h.group_code, h.active_date,
                                                    to_char(h.inactive_date,'dd/mm/rrrr') as inactive_date,
                                                    h.tier
                                                 FROM
                                                    gen_tpl_concept_headers h
                                                 WHERE
                                                 UPPER(h.group_code) = UPPER(<cfqueryparam cfsqltype="cf_sql_varchar" value="#group_code#">)
                                                 AND h.inactive_date >
                                                 to_date(<cfqueryparam cfsqltype="cf_sql_varchar" value="#start_date#">,'dd/mm/rrrr')
                                                 AND h.tier = <cfqueryparam cfsqltype="cf_sql_integer" value="#tier#">   
                                                 AND h.org_id =  <cfqueryparam cfsqltype="cf_sql_integer" value="#org_id#">                          
                                         </cfquery>
                                         
                                   		 <cfif checkForExpired.Recordcount GT 0>
                                         		
                                             <cfset counter = 404>    
                                             <cfset trx_status = "error" > 
                                             <cfoutput>
                                             <cfset errorMsg = "<b>Message:</b>Group Code Still Active at Transporter #checkForExpired.tier#<br>
                                                                <b>Detail:</b> Expired on #checkForExpired.inactive_date#<br>" >
                                             </cfoutput>
                                          <cfelse>
                                          	  
                                              
                                               <cfquery name="InsertRecord" datasource="#dswms#">
                                                INSERT INTO gen_tpl_concept_headers
                                                (TPL_CONCEPT_HEADER_ID,ORG_ID,GROUP_CODE,GROUP_DESC,COLLECTION,HANDLING,
                                                 DELIVERY,ACTIVE_DATE,
                                                 <cfif #end_date# neq ''>
                                                	 INACTIVE_DATE,
                                                 </cfif>                                                
                                                 CREATION_DATE,CREATION_BY,TIER,OWNERSHIP_ID)
                                                    VALUES
                                                    (GEN_TPL_CONCEPT_HEADERS_SEQ.NEXTVAL,
                                                    <cfqueryparam cfsqltype="cf_sql_integer" value="#org_id#">,
                                                    UPPER(<cfqueryparam cfsqltype="cf_sql_varchar" value="#group_code#">),
                                                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#get_desc#">,
                                                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#get_collection#">,
                                                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#get_handling#">,
                                                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#get_delivery#">,
                                                    to_date(<cfqueryparam cfsqltype="cf_sql_varchar" value="#start_date#">,'dd/mm/rrrr'),
                                                        <cfif #end_date# neq ''>
                                                            to_date(<cfqueryparam cfsqltype="cf_sql_varchar" value="#end_date#">,'dd/mm/rrrr'),
                                                        </cfif>
                                                    sysdate,
                                                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.user_code#">,
                                                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#tier#">,
                                                    <cfqueryparam cfsqltype="cf_sql_integer" value="#ownership_id#">
                                                    )
                                                  </cfquery>
                                                  <cfset counter = 401>
                                                   <cfset trx_status = "success" > 
                                                  <cfset errorMsg = "<b>Message:</b> Group Code Updated<br>" >
                                          	  
                                                                
                                          </cfif>
											 
                                         
                                  	</cfif>                   
 						<cfelse>	
                              <cfquery name="InsertRecord2" datasource="#dswms#">
                              INSERT INTO gen_tpl_concept_headers
                              (TPL_CONCEPT_HEADER_ID,ORG_ID,GROUP_CODE,GROUP_DESC,COLLECTION,HANDLING,
                               DELIVERY,ACTIVE_DATE,
                               <cfif #end_date# neq ''>
                                   INACTIVE_DATE,
                               </cfif>
                               
                               CREATION_DATE,CREATION_BY,TIER,OWNERSHIP_ID)
                                  VALUES
                                  (GEN_TPL_CONCEPT_HEADERS_SEQ.NEXTVAL,
                                  <cfqueryparam cfsqltype="cf_sql_integer" value="#org_id#">,
                                  UPPER(<cfqueryparam cfsqltype="cf_sql_varchar" value="#group_code#">),
                                  <cfqueryparam cfsqltype="cf_sql_varchar" value="#get_desc#">,
                                  <cfqueryparam cfsqltype="cf_sql_varchar" value="#get_collection#">,
                                  <cfqueryparam cfsqltype="cf_sql_varchar" value="#get_handling#">,
                                  <cfqueryparam cfsqltype="cf_sql_varchar" value="#get_delivery#">,
                                  to_date(<cfqueryparam cfsqltype="cf_sql_varchar" value="#start_date#">,'dd/mm/rrrr'),
                                      <cfif #end_date# neq ''>
                                          to_date(<cfqueryparam cfsqltype="cf_sql_varchar" value="#end_date#">,'dd/mm/rrrr'),
                                      </cfif>
                                  sysdate,
                                  <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.user_code#">,
                                  <cfqueryparam cfsqltype="cf_sql_varchar" value="#tier#">,
                                  <cfqueryparam cfsqltype="cf_sql_integer" value="#ownership_id#">
                                  )
                                </cfquery>
                                  <cfset counter = 401>
                                  <cfset trx_status = "success" > 
                            	  <cfset errorMsg = "<b>Message:</b> Group Code Updated<br>" >
                        </cfif>
                 </cfloop>
 		   </cfif>
           
           <!--- CHILD INSEERT --->
           <cfif new_child_row neq "">
           
           		 <cfloop list="#new_child_row#" index="r" delimiters="," >
	
                    <cfset vendor_id = evaluate("vendor_id_#r#") >
                    <cfset d_category = evaluate("d_category_#r#") >
                    <cfset get_route = evaluate("get_route_#r#") >
                    <cfset d_type = evaluate("d_type_#r#") >
                    <cfset getDetailsID = evaluate("getDetailsID_#r#") >
                    <cfset tplID = evaluate("tplID_#r#") >
                    <cfset deliveryID = evaluate("deliveryID_#r#") >
                    <cfset lookupID = evaluate("lookupID_#r#") >
                    
                   
                    
                    <cfquery name="checkIfChildExist" datasource="#dswms#">         
                        SELECT
						 	a.tpl_concept_detail_id, b.group_code, a.delivery_category_desc
                         FROM
                         	gen_tpl_concept_details a, gen_tpl_concept_headers b
                         WHERE
                         	a.tpl_concept_header_id = b.tpl_concept_header_id
                        	AND b.org_id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#org_id#">
                            AND a.vendor_id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#vendor_id#">
                            AND a.tpl_id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#tplID#">
                            AND a.delivery_category = <cfqueryparam cfsqltype="cf_sql_varchar" value="#d_category#">
                            <cfif get_route neq ""> 
                           		AND UPPER(a.delivery_category_desc) = UPPER(<cfqueryparam cfsqltype="cf_sql_varchar" value="#get_route#">)
                            </cfif>
                            AND a.delivery_type_id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#deliveryID#">
                            AND (a.inactive_date is null OR a.inactive_date > sysdate)       
                 	</cfquery>
                    
                   <cfquery name="checkforInactiveDate" datasource="#dswms#"> 
                   		   SELECT to_char(inactive_date,'dd/mm/rrrr') as inactive_date FROM
                           gen_tpl_concept_headers
                           WHERE TPL_CONCEPT_HEADER_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#getDetailsID#">
				   </cfquery>
                    
                 	<cfif checkIfChildExist.recordcount eq 0>
                    	<cfquery name="insertChild" datasource="#dswms#">
                              INSERT INTO gen_tpl_concept_details
                              (TPL_CONCEPT_DETAIL_ID,TPL_CONCEPT_HEADER_ID,VENDOR_ID,TPL_ID,DELIVERY_CATEGORY,vendor_setting_header_id,
								  <cfif get_route neq "">
                                    DELIVERY_CATEGORY_DESC,
                                  </cfif>
                                  <cfif checkforInactiveDate.inactive_date neq "">
                                    inactive_date,
                                  </cfif>
                              DELIVERY_TYPE_ID,CREATION_BY,CREATION_DATE)
                                  VALUES
                                  (GEN_TPL_CONCEPT_DETAILS_SEQ.NEXTVAL,
                                  <cfqueryparam cfsqltype="cf_sql_varchar" value="#getDetailsID#">,
                                   <cfqueryparam cfsqltype="cf_sql_varchar" value="#vendor_id#">,
                                  <cfqueryparam cfsqltype="cf_sql_varchar" value="#tplID#">,
                                  <cfqueryparam cfsqltype="cf_sql_varchar" value="#d_category#">,
                                  <cfqueryparam cfsqltype="cf_sql_integer" value="#lookupID#">,
                                  <cfif get_route neq ""> 
                                  	<cfqueryparam cfsqltype="cf_sql_varchar" value="#get_route#">,
                                  </cfif>
                                  <cfif checkforInactiveDate.inactive_date neq ""> 
                                  	to_date(<cfqueryparam cfsqltype="cf_sql_varchar" value="#checkforInactiveDate.inactive_date#">,'dd/mm/rrrr'),
                                  </cfif>
                                  <cfqueryparam cfsqltype="cf_sql_varchar" value="#deliveryID#">,
                                  <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.user_code#">,
                                  sysdate
                                  )
                          </cfquery>
                          
                          <cfset counter = 401>
                             <cfset trx_status = "success" > 
                             <cfset errorMsg = "<b>Message:</b> Vendor Added<br>" >
                             
                          <cfelse>
                          	 <cfset trx_status = "error" > 
                             <cfset errorMsg = "<b>Message:</b> Route: '#checkIfChildExist.delivery_category_desc#' Already Exist in Group Code '#checkIfChildExist.group_code#'<br>" >
                              <cfset counter = 404>
                    </cfif>	
                    
                 </cfloop>  
           		
           
           </cfif>
           	   			
			   <cfif counter EQ 1> 
                 <cfset trx_status = "error" >
                 <cfset errorMsg = "<b>Message:</b> No Data to be Updated!<br>" >
               </cfif> 
            
        <cftransaction action="commit" />
                      <cfcatch type="database">
                          <cftransaction action="rollback"/> 
                          <cfset trx_status = "error" > 
                          <cfset errorMsg = " <b>Message:</b> #CFCATCH.Message#<br>
                                              <b>Native error code:</b> #CFCATCH.NativeErrorCode#<br>
                                              <b>SQLState:</b> #CFCATCH.SQLState#<br>
                                              <b>Detail:</b> #CFCATCH.Detail#<br>" > 
                      </cfcatch>
            </cftry>
        </cftransaction>
<cfoutput>~~#trx_status#~~#errorMsg#~~</cfoutput> 


<cfelseif action_flag EQ "getGroupCode" >
    
    	<cfquery name="getGCode" datasource="#dswms#">
            SELECT DISTINCT group_code
            FROM gen_tpl_concept_headers
            WHERE (inactive_date is null OR inactive_date > sysdate)
            AND active_date <= sysdate
            AND org_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#org_id#">
            ORDER BY group_code ASC
        </cfquery>
	
        
       
       
       		 
             
             	<cfoutput>
                ~~
                <cfif getGCode.recordcount NEQ 0>
                
                      <select name="group_code" id="group_code" class="formStyle tips" >
                           <option value="">-- Please Select --</option>
                                           
                              <cfloop query="getGCode">
                              	<option value="#group_code#">#group_code#</option>
                              </cfloop>
                       </select>
                      
               <cfelse>
                       <select name="group_code" id="group_code" class="formStyle tips" disabled>
                           <option value="">-- No Data --</option>
                       </select>
               
        	 	</cfif>
                 ~~    
              	</cfoutput>
                





<!---
	<cfelseif action_flag eq "getChildRow">

		<cfquery name="getChildActive" datasource="#dswms#">
                                		  SELECT b.vendor_name,
                                                 a.delivery_category,
                                                 a.delivery_category_desc AS route,
                                                 d.delivery_type,
                                                 a.status
                                            FROM gen_tpl_concept_details a,
                                                 frm_vendors b,
                                                 gen_vendor_setting_details c,
                                                 lsp_delivery_type d,
                                                 gen_tpl_concept_headers e
                                           WHERE     a.vendor_id = b.vendor_id
                                                 AND a.delivery_type_id = d.delivery_type_id
                                                 AND e.tpl_concept_header_id = a.tpl_concept_header_id
                                                 AND d.org_id = e.org_id
                                                 AND c.delivery_type_id = d.delivery_type_id
                                                 AND c.tier = e.tier
                                                 AND e.org_id = 1
                                                 AND e.tier = 1
                                        GROUP BY b.vendor_name,
                                                 a.delivery_category,
                                                 delivery_category_desc,
                                                 d.delivery_type,
                                                 a.status
                                </cfquery>--->
      

      
 
     </cfif> <!---action_flag define--->  
    
    
    
 
</cfif> <!---action_flag--->







<cfif !parameterExists(target)>ENDOFREQUEST</cfif>
 
 


 
 
  
