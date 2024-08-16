<!---
  Version    Developer    		Date            Remarks
  -------	 ---------------	----------		----------------------------------
  1.0.0.1    Nawawi Nasrudin 	18/08/2013      Add remark maintenance for Change Order 2022/17184
--->

<cfif parameterExists(target) AND target EQ "grid"><cfsetting showdebugoutput="no"></cfif>
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
								<!---SELECT a.part_list_header_id, a.part_number, a.part_name, c.vendor_id, c.vendor_name, a.back_number, a.color,  b.org_description,
								 
                                CASE WHEN a.inactive_date IS NULL THEN 
                                     CASE WHEN a.active_date <= to_date(sysdate,'dd/mm/yy') THEN 'ACTIVE' ELSE 'INACTIVE' END
                                ELSE  
                                     CASE WHEN a.active_date = a.inactive_date THEN 'INACTIVE'
                                     WHEN a.active_date <= to_date(sysdate,'dd/mm/yy') AND a.inactive_date > to_date(sysdate,'dd/mm/yy') THEN 'ACTIVE'   
                                     ELSE 'INACTIVE' END 
                                END status,
    
								a.creation_date, a.creation_by, a.last_updated_date, a.last_updated_by
								FROM gen_part_list_headers a, frm_organizations b, frm_vendors c
								WHERE a.org_id = b.org_id
								AND a.vendor_id = c.vendor_id  
								<cfif org_id NEQ "" >
									AND a.org_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#org_id#">
								</cfif>    
								<cfif part_number NEQ "" >
									AND a.part_number = <cfqueryparam cfsqltype="cf_sql_varchar" value="#part_number#">
								</cfif>  
								<cfif back_number NEQ "" >
									AND a.back_number = <cfqueryparam cfsqltype="cf_sql_varchar" value="#back_number#">
								</cfif>
								<cfif vendor_id NEQ "" >
									AND a.vendor_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#vendor_id#">
								</cfif>  
								<cfif vendor_code NEQ "" >
									AND a.vendor_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#vendor_code#">
								</cfif> 
								<cfif status NEQ "" >
									AND 
                                    CASE WHEN a.inactive_date IS NULL THEN 
                                     CASE WHEN a.active_date <= to_date(sysdate,'dd/mm/yy') THEN 'ACTIVE' ELSE 'INACTIVE' END
                                ELSE  
                                     CASE WHEN a.active_date = a.inactive_date THEN 'INACTIVE'
                                     WHEN a.active_date <= to_date(sysdate,'dd/mm/yy') AND a.inactive_date > to_date(sysdate,'dd/mm/yy') THEN 'ACTIVE'   
                                     ELSE 'INACTIVE' END 
                                END = <cfqueryparam cfsqltype="cf_sql_varchar" value="#status#">
								</cfif>    
                                ORDER BY a.part_number ASC--->
                                
                                         <!---comment by syafiqah on 27/05/2019--->
                                   		<!---SELECT DISTINCT a.part_list_header_id,
                                   			   a.vendor_id,
                                               g.vendor_name,
                                               a.part_number,
                                               a.part_name,
                                               a.back_number,
                                               b.qty_per_box,
                                               h.box_code,
                                               a.color,
                                               h.LENGTH,
                                               h.width,
                                               h.height,
                                               h.weight,
                                               c.delivery_category,
                                               (SELECT DISTINCT s.shop_name
                                               FROM gen_shop s, gen_line_shop l
                                               WHERE s.shop_id = l.shop_id
                                               AND s.active_date <= sysdate
                                               AND (s.inactive_date is null or s.inactive_date > sysdate)
                                               AND l.active_date <= sysdate
                                               AND (l.inactive_date is null or l.inactive_date > sysdate)
                                               AND l.line_shop_id = d.line_shop_id)
                                               shop_name,
                                               (SELECT DISTINCT line_shop
                                               FROM gen_line_shop 
                                               WHERE line_shop_id = d.line_shop_id
                                               AND active_date <= sysdate
                                               AND NVL(inactive_date, sysdate+1) > sysdate)
                                               line_shop,
                                               d.dock_code,
                                               e.order_type,
                                               f.vendor_category,
                                               TO_CHAR (a.active_date, 'dd/mm/yyyy') part_active_date,
                                               TO_CHAR (a.inactive_date, 'dd/mm/yyyy') part_inactive_date,
                                               TO_CHAR (h.active_date, 'dd/mm/yyyy') box_active_date,
                                               TO_CHAR (h.inactive_date, 'dd/mm/yyyy') box_inactive_date,
                                               TO_CHAR (c.active_date, 'dd/mm/yyyy') delinfo_active_date,
                                               TO_CHAR (c.inactive_date, 'dd/mm/yyyy') delinfo_inactive_date,
                                               i.tpl_name,
                                               i.tpl_delivery_category,
                                               o.org_description,
                                               TO_CHAR(a.creation_date, 'dd/mm/yyyy hh:mm:ss AM') as creation_date, 
                                               a.creation_by, 
                                               TO_CHAR(a.last_updated_date, 'dd/mm/yyyy hh:mm:ss AM') as last_updated_date,
                                               a.last_updated_by
                                          FROM gen_part_list_headers a,
                                               gen_part_list_psi b,
                                               gen_part_list_delivery_info c,
                                               lsp_dock d,
                                               lsp_order_type e,
                                               gen_vendor_category f,
                                               frm_vendors g,
                                               gen_box h,
                                               frm_organizations o,
                                               (SELECT part_list_header_id,
                                                       b.vendor_name tpl_name,
                                                       delivery_category tpl_delivery_category
                                                  FROM gen_part_list_tpl a, frm_vendors b
                                                 WHERE     a.tpl_id = b.vendor_id
                                                       AND a.active_date <= SYSDATE
                                                       AND NVL (a.inactive_date, SYSDATE + 1) > SYSDATE) i
                                         WHERE     a.part_list_header_id = b.part_list_header_id
                                               AND a.part_list_header_id = c.part_list_header_id
                                               AND c.dock_id = d.dock_id
                                               AND c.order_type_id = e.order_type_id
                                               AND c.vendor_category_id = f.vendor_category_id
                                               AND a.vendor_id = g.vendor_id
                                               AND b.box_id = h.box_id
                                               AND a.org_id = o.org_id
                                               AND a.part_list_header_id = i.part_list_header_id(+)
                                               AND b.active_date <= SYSDATE
                                               AND NVL (b.inactive_date, SYSDATE + 1) > SYSDATE 
                                               AND c.active_date <= SYSDATE
                                               AND NVL (c.inactive_date, SYSDATE + 1) > SYSDATE 
                                               AND d.active_date <= SYSDATE
                                               AND NVL (d.inactive_date, SYSDATE + 1) > SYSDATE
                                               AND e.active_date <= SYSDATE
                                               AND NVL (e.inactive_date, SYSDATE + 1) > SYSDATE
                                               AND f.active_date <= SYSDATE
                                               AND NVL (f.inactive_date, SYSDATE + 1) > SYSDATE
                                               AND g.active_date <= SYSDATE
                                               AND NVL (g.inactive_date, SYSDATE + 1) > SYSDATE
                                               AND h.active_date <= SYSDATE
                                               AND NVL (h.inactive_date, SYSDATE + 1) > SYSDATE
                                             
                                               <cfif org_id NEQ "" >
                                                    AND a.org_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#org_id#">
                                                </cfif>    
                                                <cfif part_number NEQ "" >
                                                    AND a.part_number = <cfqueryparam cfsqltype="cf_sql_varchar" value="#part_number#">
                                                </cfif>  
                                                <cfif back_number NEQ "" >
                                                    AND a.back_number = <cfqueryparam cfsqltype="cf_sql_varchar" value="#back_number#">
                                                </cfif>
                                                <cfif vendor_id NEQ "" >
                                                    AND a.vendor_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#vendor_id#">
                                                </cfif>  
                                                <cfif vendor_code NEQ "" >
                                                    AND a.vendor_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#vendor_code#">
                                                </cfif> 
                                                <cfif status NEQ "" >
                                                AND 
                                                CASE WHEN a.inactive_date IS NULL THEN 
                                                     CASE WHEN a.active_date <= to_date(sysdate,'dd/mm/yy') THEN 'ACTIVE' ELSE 'INACTIVE' END
                                                ELSE  
                                                     CASE WHEN a.active_date = a.inactive_date THEN 'INACTIVE'
                                                     WHEN a.active_date <= to_date(sysdate,'dd/mm/yy') 
                                                     		AND a.inactive_date > to_date(sysdate,'dd/mm/yy') THEN 'ACTIVE'   
                                                     ELSE 'INACTIVE' END 
                                                END = <cfqueryparam cfsqltype="cf_sql_varchar" value="#status#">
                                                </cfif>    
                                                ORDER BY a.part_number ASC--->
                                                
                                                <!---change code by syafiqah on 27/05/2019 for incident 1903/5663--->
                                                SELECT distinct a.part_list_header_id, 
                                                a.vendor_id,
                                                d.vendor_name,
                                                a.part_number,
                                                a.part_name,
                                                a.back_number,
                                                b.qty_per_box,
                                                b.box_code,
                                                a.color,
                                                b.LENGTH,
                                                b.width,
                                                b.height,
                                                b.weight,
                                                to_char(c.delivery_category) delivery_category,
                                                 (SELECT distinct delivery_category_desc 
                                                    FROM gen_vendor_setting_headers 
                                                    WHERE org_id = a.org_id
                                                    AND vendor_id =a.vendor_id
                                                    and delivery_category = c.delivery_category
                                                    AND active_date != NVL(inactive_date,active_date+1)) routes,
                                                    (SELECT DISTINCT s.shop_name
                                                   FROM gen_shop s, gen_line_shop l
                                                   WHERE s.shop_id = l.shop_id
                                                   AND s.active_date <= sysdate
                                                   AND (s.inactive_date is null or s.inactive_date > sysdate)
                                                   AND l.active_date <= sysdate
                                                   AND (l.inactive_date is null or l.inactive_date > sysdate)
                                                   AND l.line_shop_id = c.line_shop_id)shop_name,
                                                    (SELECT DISTINCT line_shop
                                                   FROM gen_line_shop 
                                                   WHERE line_shop_id = c.line_shop_id
                                                   AND active_date <= sysdate
                                                   AND NVL(inactive_date, sysdate+1) > sysdate) line_shop,
                                                   c.dock_code,
                                                   c.order_type,
                                                   c.vendor_category,
                                                   TO_CHAR (a.active_date, 'dd/mm/yyyy') part_active_date,
                                                   TO_CHAR (a.inactive_date, 'dd/mm/yyyy') part_inactive_date,
                                                   b.box_active_date,
                                                   b.box_inactive_date,
                                                   c.delinfo_active_date,
                                                   c.delinfo_inactive_date,
                                                   NVL(f.tpl_name,
                                                   (SELECT distinct z.vendor_name  
                                                    FROM gen_vendor_setting_headers x, gen_vendor_setting_details y, frm_vendors z
                                                    WHERE x.org_id = a.org_id
                                                    AND x.vendor_id =a.vendor_id
                                                    and x.delivery_category = c.delivery_category
                                                    AND x.active_date != NVL(x.inactive_date,x.active_date+1)
                                                     AND y.active_date != NVL(y.inactive_date,y.active_date+1)
                                                    AND y.tpl_id = z.vendor_id
                                                    AND y.tpl_id IS NOT NULL 
                                                    AND x.vendor_setting_header_id = y.vendor_setting_header_id
                                                    AND y.vendor_setting_detail_id = 
                                                                                    (SELECT MAX(vendor_setting_detail_id) 
                                                                                     FROM gen_vendor_setting_details 
                                                                                     WHERE tpl_id = z.vendor_id 
                                                                                     AND vendor_setting_header_id = x.vendor_setting_header_id
                                                                                     AND tpl_id is not null
                                                                                     AND active_date <= sysdate 
                                                                                     AND NVL(inactive_date, sysdate+1) > sysdate)
                                                    )) tpl_name,
                                                f.tpl_delivery_category,
                                                e.org_description,
                                                TO_CHAR(a.creation_date, 'dd/mm/yyyy hh:mm:ss AM') as creation_date, 
                                                a.creation_by, 
                                                TO_CHAR(a.last_updated_date, 'dd/mm/yyyy hh:mm:ss AM') as last_updated_date,
                                                a.last_updated_by
                                               <!--- GEN_GET_PART_MODEL(4,a.org_id,a.part_number,sysdate, sysdate) model_info--->
                                                FROM gen_part_list_headers a, 
                                                ( 
                                                    SELECT a.part_list_header_id,a.qty_per_box,b.box_code,b.LENGTH,b.width,b.height,b.weight,
                                                    TO_CHAR (b.active_date, 'dd/mm/yyyy') box_active_date,
                                                    TO_CHAR (b.inactive_date, 'dd/mm/yyyy') box_inactive_date
                                                    FROM gen_part_list_psi a,gen_box b
                                                    where a.box_id = b.box_id
                                                    and a.active_date <= sysdate AND NVL(a.inactive_date, sysdate+1) > sysdate 
                                                    AND b.active_date <= SYSDATE
                                                    AND NVL (b.inactive_date, SYSDATE + 1) > SYSDATE 
                                                ) b , 
                                                ( 
                                                    SELECT a.part_list_header_id,to_char(a.delivery_category) delivery_category,
                                                    b.line_shop_id,b.dock_code,c.order_type,d.vendor_category,
                                                    TO_CHAR (a.active_date, 'dd/mm/yyyy') delinfo_active_date,
                                                    TO_CHAR (a.inactive_date, 'dd/mm/yyyy') delinfo_inactive_date,
                                                    TO_CHAR (a.active_date, 'dd/mm/yyyy') box_active_date,
                                                    TO_CHAR (a.inactive_date, 'dd/mm/yyyy') box_inactive_date
                                                    FROM gen_part_list_delivery_info a, lsp_dock b,lsp_order_type c,gen_vendor_category d
                                                    WHERE a.dock_id=b.dock_id
                                                    and a.order_type_id = c.order_type_id
                                                    and a.vendor_category_id = d.vendor_category_id
                                                    AND a.active_date <= sysdate AND NVL(a.inactive_date, sysdate+1) > sysdate  
                                                    AND b.active_date <= SYSDATE
                                                    AND NVL (b.inactive_date, SYSDATE + 1) > SYSDATE
                                                    AND c.active_date <= SYSDATE
                                                    AND NVL (c.inactive_date, SYSDATE + 1) > SYSDATE
                                                    AND d.active_date <= SYSDATE
                                                    AND NVL (d.inactive_date, SYSDATE + 1) > SYSDATE
                                                ) c,
                                                frm_vendors d,frm_organizations e,
                                                (SELECT part_list_header_id,
                                                    b.vendor_name tpl_name,
                                                    delivery_category tpl_delivery_category
                                                    FROM gen_part_list_tpl a, frm_vendors b
                                                    WHERE     a.tpl_id = b.vendor_id
                                                    AND a.active_date <= SYSDATE
                                                    AND NVL (a.inactive_date, SYSDATE + 1) > SYSDATE) f
                                                WHERE a.part_list_header_id = b.part_list_header_id(+) 
                                                AND a.part_list_header_id = c.part_list_header_id(+)  
                                                 AND a.part_list_header_id = f.part_list_header_id(+)
                                                AND a.vendor_id = d.vendor_id
                                                AND a.org_id = e.org_id
                                                AND d.active_date <= SYSDATE
                                                AND NVL (d.inactive_date, SYSDATE + 1) > SYSDATE
                                                <cfif org_id NEQ "" >
                                                    AND a.org_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#org_id#">
                                                </cfif>    
                                                <cfif part_number NEQ "" >
                                                    AND a.part_number = <cfqueryparam cfsqltype="cf_sql_varchar" value="#part_number#">
                                                </cfif>  
                                                <cfif back_number NEQ "" >
                                                    AND a.back_number = <cfqueryparam cfsqltype="cf_sql_varchar" value="#back_number#">
                                                </cfif>
                                                <cfif vendor_id NEQ "" >
                                                    AND a.vendor_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#vendor_id#">
                                                </cfif>  
                                                <cfif vendor_code NEQ "" >
                                                    AND a.vendor_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#vendor_code#">
                                                </cfif> 
                                                <cfif status NEQ "" >
                                                    AND 
                                                    CASE WHEN a.inactive_date IS NULL THEN 
                                                         CASE WHEN a.active_date <= to_date(sysdate,'dd/mm/yy') THEN 'ACTIVE' ELSE 'INACTIVE' END
                                                    ELSE  
                                                         CASE WHEN a.active_date = a.inactive_date THEN 'INACTIVE'
                                                         WHEN a.active_date <= to_date(sysdate,'dd/mm/yy') 
                                                                AND a.inactive_date > to_date(sysdate,'dd/mm/yy') THEN 'ACTIVE'   
                                                         ELSE 'INACTIVE' END 
                                                    END = <cfqueryparam cfsqltype="cf_sql_varchar" value="#status#">
                                                </cfif>    
                                                ORDER BY a.part_number ASC
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
                
    <cfelseif action_flag EQ "getBoxSettings" > 
		
		<cfquery name="getBoxSettings" datasource="#dswms#" >
            SELECT a.length || ' x ' || a.width || ' x ' || a.height measurement, a.weight 
            FROM gen_box a
            WHERE a.active_date != NVL(a.inactive_date, a.active_date+1)
            AND a.active_date <= sysdate AND NVL(a.inactive_date,sysdate+1) > sysdate
            AND a.org_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#org_id#">
            AND a.box_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#box_id#">
            ORDER BY a.box_code ASC
        </cfquery> 
        
		<cfoutput>~~#getBoxSettings.measurement#~~#getBoxSettings.weight#~~</cfoutput>


    <!--------------------------------arina change start----------------------------------------->
    <cfelseif action_flag EQ "updateWeight" > 
		
		<cfquery name="updateWeight" datasource="#dswms#" >
            UPDATE gen_box
            SET <cfif updated_weight NEQ ""> 
                weight = <cfqueryparam cfsqltype="cf_sql_numeric" value="#updated_weight#">,
                </cfif>
            WHERE box_code = <cfqueryparam cfsqltype="cf_sql_integer" value="#box_code#">
        </cfquery> 
        
		<cfoutput>~~#updateWeight.weight#~~</cfoutput>
    <!--------------------------------arina change end----------------------------------------->
                
                
  	<cfelseif action_flag EQ "update" >
        
		<cfset trx_status = "failed" >
		<cfset errorMsg = "" >
		
		<cftransaction action="begin">
			<cftry> 
            
            	<!---------------- MAIN INFO -------------------------------------------------------------------------------->	
                
                 
                <cfquery name="updatePartListHeader" datasource="#dswms#">
					UPDATE gen_part_list_headers
					SET 
                        <cfif back_no NEQ curr_back_no >
                        	back_number = <cfqueryparam cfsqltype="cf_sql_varchar" value="#back_no#">,
                        </cfif>
						<cfif inactive_date NEQ "">
							inactive_date = to_date(<cfqueryparam cfsqltype="cf_sql_varchar" value="#inactive_date#">,'dd/mm/yyyy'),
						<cfelse>
							inactive_date = NULL,
						</cfif>
                      	remark_id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#remark_id#">,
                        last_updated_date = sysdate,
					    last_updated_by = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.user_code#"> 
					WHERE part_list_header_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#part_list_header_id#">
				</cfquery>
                
				<cfif back_no NEQ curr_back_no >
                         
                    <cfquery name="updateBackNo" datasource="#dswms#" >
                    	UPDATE gen_part_list_back_number
                        SET status = 'N',
                        last_updated_date = sysdate,
					    last_updated_by = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.user_code#"> 
                        WHERE back_number = <cfqueryparam cfsqltype="cf_sql_varchar" value="#curr_back_no#">
                        AND part_list_header_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#part_list_header_id#">
                    </cfquery>
                    
                    <cfquery name="logBackNo" datasource="#dswms#" >
                    	INSERT INTO gen_part_list_back_number
                        (org_id, part_list_header_id, part_number, back_number, creation_by)
                        VALUES
                        (
                        	<cfqueryparam cfsqltype="cf_sql_integer" value="#org_id#">,
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#part_list_header_id#">,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#part_number#">,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#back_no#">,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.user_code#">
                        )
                    </cfquery>
                    
                         
                </cfif>
				
                
                
                
                <cfif inactive_date NEQ "" >
                
                    <cfquery name="updateMain1" datasource="#dswms#" >   
                        UPDATE gen_part_list_headers
                        	 SET inactive_date = to_date(<cfqueryparam cfsqltype="cf_sql_varchar" value="#inactive_date#">,'dd/mm/yyyy'), 
                             last_updated_date = sysdate,
                             last_updated_by = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.user_code#"> 
                        WHERE part_list_header_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#part_list_header_id#" >
                    </cfquery>
    
                    <cfquery name="updateMain2" datasource="#dswms#" >   
                        UPDATE gen_part_list_psi  
                        	 SET inactive_date = to_date(<cfqueryparam cfsqltype="cf_sql_varchar" value="#inactive_date#">,'dd/mm/yyyy'),
                             last_updated_date = sysdate,
                             last_updated_by = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.user_code#"> 
                        WHERE part_list_header_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#part_list_header_id#" >
                        AND NVL(inactive_date,to_date(<cfqueryparam cfsqltype="cf_sql_varchar" value="#inactive_date#">,'dd/mm/yyyy') + 1) >= to_date(<cfqueryparam cfsqltype="cf_sql_varchar" value="#inactive_date#">,'dd/mm/yyyy')
                    </cfquery>
    
                    <cfquery name="updateMain3" datasource="#dswms#" >   
                        UPDATE gen_part_list_delivery_info 
                        	 SET inactive_date = to_date(<cfqueryparam cfsqltype="cf_sql_varchar" value="#inactive_date#">,'dd/mm/yyyy'),
                             last_updated_date = sysdate,
                             last_updated_by = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.user_code#"> 
                        WHERE part_list_header_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#part_list_header_id#" >
                        AND NVL(inactive_date,to_date(<cfqueryparam cfsqltype="cf_sql_varchar" value="#inactive_date#">,'dd/mm/yyyy') + 1) >= to_date(<cfqueryparam cfsqltype="cf_sql_varchar" value="#inactive_date#">,'dd/mm/yyyy')
                    </cfquery>
                    
                    
    
                    <cfquery name="updateMain4" datasource="#dswms#" >   
                        UPDATE gen_part_list_tpl 
                        	 SET inactive_date = to_date(<cfqueryparam cfsqltype="cf_sql_varchar" value="#inactive_date#">,'dd/mm/yyyy'),
                             last_updated_date = sysdate,
                             last_updated_by = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.user_code#"> 
                        WHERE part_list_header_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#part_list_header_id#" >
                        AND NVL(inactive_date,to_date(<cfqueryparam cfsqltype="cf_sql_varchar" value="#inactive_date#">,'dd/mm/yyyy') + 1) >= to_date(<cfqueryparam cfsqltype="cf_sql_varchar" value="#inactive_date#">,'dd/mm/yyyy')
                    </cfquery>
                    
                    
                   <!--- <cfquery name="updateMain4" datasource="#dswms#" >   
                       update gen_part_list_tpl a
                         set inactive_date = (select inactive_date from gen_part_list_delivery_info b
                         where a.part_list_header_id = b.part_list_header_id
                         and b.part_list_header_id=<cfqueryparam cfsqltype="cf_sql_integer" value="#part_list_header_id#" >),
                         last_updated_date = sysdate,
                         last_updated_by = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.user_code#"> 
                        where a.part_list_header_id= <cfqueryparam cfsqltype="cf_sql_integer" value="#part_list_header_id#" >
                      <!---  AND NVL(inactive_date,to_date(<cfqueryparam cfsqltype="cf_sql_varchar" value="#inactive_date#">,'dd/mm/yyyy') + 1) >= to_date(<cfqueryparam cfsqltype="cf_sql_varchar" value="#inactive_date#">,'dd/mm/yyyy')--->
                    </cfquery>--->
                    
                    <cfquery name="updateMain5" datasource="#dswms#" >   
                        UPDATE gen_part_list_tpl_tier 
                        	 SET inactive_date = to_date(<cfqueryparam cfsqltype="cf_sql_varchar" value="#inactive_date#">,'dd/mm/yyyy'),
                             last_updated_date = sysdate,
                             last_updated_by = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.user_code#"> 
                        WHERE part_list_header_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#part_list_header_id#" >
                        AND NVL(inactive_date,to_date(<cfqueryparam cfsqltype="cf_sql_varchar" value="#inactive_date#">,'dd/mm/yyyy') + 1) >= to_date(<cfqueryparam cfsqltype="cf_sql_varchar" value="#inactive_date#">,'dd/mm/yyyy')
                    </cfquery>

		 	  	 </cfif>
				
                <!---------------- PSI -------------------------------------------------------------------------------->
                
                <cfif isDefined("current_part_list_psi_id") AND current_part_list_psi_id NEQ "" >
                
                	<cfquery name="updatePSI" datasource="#dswms#" >
                        UPDATE gen_part_list_psi
                        SET <cfif curr_psi_inactive_date NEQ ""> 
                        		inactive_date = to_date(<cfqueryparam cfsqltype="cf_sql_varchar" value="#curr_psi_inactive_date#">,'dd/mm/yyyy'), 
                             <cfelse>
                             	inactive_date = null,
                             </cfif> 
                             last_updated_date = sysdate,
                             last_updated_by = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.user_code#">
                        WHERE part_list_psi_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#current_part_list_psi_id#">
                    </cfquery>

                    <!---arina change start
                    <cfquery name="updatePSI" datasource="#dswms#" >
                        UPDATE gen_box
                        SET <cfif updated_weight NEQ ""> 
                        		weight = <cfqueryparam cfsqltype="cf_sql_numeric" value="#updated_weight#">,
                             </cfif>
                        WHERE box_code = <cfqueryparam cfsqltype="cf_sql_integer" value="#box_code#"> 
                    </cfquery>
                    arina change end--->	
                
                </cfif>
                
                <cfif isDefined("new_box_id") AND new_box_id NEQ "" >
                
                	<cfquery name="savePSI" datasource="#dswms#" >
                        INSERT INTO gen_part_list_psi
                        (
                        part_list_header_id, part_number, box_id, qty_per_box,
                        active_date, <cfif new_psi_inactive_date NEQ ""> inactive_date, </cfif>
                        creation_by
                        )
                        VALUES
                        ( 
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#part_list_header_id#">,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#part_number#">, 
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#new_box_id#">,  
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#new_qty_per_box#">,   
                            to_date(<cfqueryparam cfsqltype="cf_sql_varchar" value="#new_psi_active_date#">,'dd/mm/yyyy'),
                            <cfif new_psi_inactive_date NEQ "">
                                to_date(<cfqueryparam cfsqltype="cf_sql_varchar" value="#new_psi_inactive_date#">,'dd/mm/yyyy'),
                            </cfif> 
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.user_code#">
                        ) 
                    </cfquery>
                    
                </cfif>
                
                <cfif isDefined("new_part_list_psi_id") AND new_part_list_psi_id NEQ "" >
                
                	<cfquery name="updatePSI" datasource="#dswms#" >
                        UPDATE gen_part_list_psi
                        SET <cfif new_psi_inactive_date NEQ ""> 
                        		inactive_date = to_date(<cfqueryparam cfsqltype="cf_sql_varchar" value="#new_psi_inactive_date#">,'dd/mm/yyyy'), 
                             <cfelse>
                             	inactive_date = null,
                             </cfif> 
                             last_updated_date = sysdate,
                             last_updated_by = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.user_code#">
                        WHERE part_list_psi_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#new_part_list_psi_id#">
                    </cfquery>	
                
                </cfif>


			 
             
             
             
             	<!--------------------------------------------- DELIVERY INFO ----------------------------------------------------->
                
                <cfloop from="1" to="#dlvInfoId#" index="r" >	
                
                	<cfset part_list_delivery_info_id = evaluate("part_list_delivery_info_id_#r#") >
                    <cfset curr_dlv_inactive_date = evaluate("curr_dlv_inactive_date_#r#") >
                
                	<cfquery name="updateDlvInfo" datasource="#dswms#" >
                        UPDATE gen_part_list_delivery_info
                        SET  <cfif curr_dlv_inactive_date NEQ ""> 
                        		inactive_date = to_date(<cfqueryparam cfsqltype="cf_sql_varchar" value="#curr_dlv_inactive_date#">,'dd/mm/yyyy'), 
                             <cfelse>
                             	inactive_date = null,
                             </cfif> 
                             last_updated_date = sysdate,
                             last_updated_by = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.user_code#">
                        WHERE part_list_delivery_info_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#part_list_delivery_info_id#">
                    </cfquery>	

                    
                	<cfquery name="updateDlvInfo" datasource="#dswms#" >
                        UPDATE gen_part_list_tpl
                        SET  <cfif curr_dlv_inactive_date NEQ ""> 
                        		inactive_date = to_date(<cfqueryparam cfsqltype="cf_sql_varchar" value="#curr_dlv_inactive_date#">,'dd/mm/yyyy'), 
                             <cfelse>
                             	inactive_date = null,
                             </cfif> 
                             last_updated_date = sysdate,
                             last_updated_by = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.user_code#">
                        WHERE part_list_delivery_info_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#part_list_delivery_info_id#">
                    </cfquery>	
                    
                    
<!------------------------------ DISABLED : ------ LSP INVENTORY PROJECT ---------------------------- 
                    <cfset totalTier1 = evaluate("totalTier1_#r#") >
                    <cfset totalTier2 = evaluate("totalTier2_#r#") >
                    
                    <cfloop from="1" to="#totalTier1#" index="t1" >
                    
                    	<cfset part_list_tpl_id = evaluate("part_list_tpl_id_#r#_#t1#") >
                    	<cfset tpl1_inactive_date = evaluate("tpl1_inactive_date_#r#_#t1#") >
                        
                        <cfquery name="updateTPL1Info" datasource="#dswms#" >
                        UPDATE gen_part_list_tpl 
                        	 SET <cfif tpl1_inactive_date NEQ ""> 
                        		inactive_date = to_date(<cfqueryparam cfsqltype="cf_sql_varchar" value="#tpl1_inactive_date#">,'dd/mm/yyyy'), 
                             <cfelse>
                             	inactive_date = null,
                             </cfif> 
                             last_updated_date = sysdate,
                             last_updated_by = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.user_code#">
                        WHERE part_list_tpl_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#part_list_tpl_id#" > 
                    	</cfquery>
                        
                    </cfloop>
                    
                    
                    <cfloop from="1" to="#totalTier2#" index="t2" >
                    
                    	<cfset part_list_tpl_tier_id = evaluate("part_list_tpl_tier_id_#r#_#t2#") >
                    	<cfset tpl2_inactive_date = evaluate("tpl2_inactive_date_#r#_#t2#") >
                        
                        <cfquery name="updateTPL2Info" datasource="#dswms#" >
                         UPDATE gen_part_list_tpl_tier  
                        	 SET <cfif tpl2_inactive_date NEQ ""> 
                        		inactive_date = to_date(<cfqueryparam cfsqltype="cf_sql_varchar" value="#tpl2_inactive_date#">,'dd/mm/yyyy'), 
                             <cfelse>
                             	inactive_date = null,
                             </cfif> 
                             last_updated_date = sysdate,
                             last_updated_by = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.user_code#">
                        WHERE part_list_tpl_tier_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#part_list_tpl_tier_id#" > 
                    	</cfquery>
                        
                    </cfloop>
                
     -- END : ----------------------------- DISABLED : ------ LSP INVENTORY PROJECT ------------------------------>



                </cfloop>
                
                
                
   
                
            <cfloop list="#deliveryInfoRowID#" delimiters="," index="r" >
                
                <cfset order_type_id = evaluate("order_type_id_#r#") >
                <cfset vendor_category_id = evaluate("vendor_category_id_#r#") >
                <cfset dock_id = evaluate("dock_id_#r#") >
                <cfset delivery_category = evaluate("delivery_category_#r#") >
                <cfset dlv_active_date = evaluate("dlv_active_date_#r#") >
                <cfset dlv_inactive_date = evaluate("dlv_inactive_date_#r#") > 
                
                <cfset vendor_setting_detail_id = evaluate("vendor_setting_detail_id_#r#") > <!---- LSP INVENTORY IMPROVEMENT ---->
                
                <cfquery name="dlvInfo" datasource="#dswms#">
					SELECT gen_part_list_dlv_info_id_seq.nextval newid FROM dual
				</cfquery> 
				<cfset part_list_delivery_info_id = dlvInfo.newid >
                
                <cfquery name="addPartListDlvInfo" datasource="#dswms#">
					INSERT INTO gen_part_list_delivery_info
					(
					part_list_delivery_info_id, part_list_header_id, part_number, order_type_id, vendor_category_id, dock_id, delivery_category,
                    vendor_setting_detail_id, <!---- LSP INVENTORY IMPROVEMENT ---->
					active_date, <cfif dlv_inactive_date NEQ ""> inactive_date, </cfif>
					creation_date, creation_by
					)
					VALUES
					(
						<cfqueryparam cfsqltype="cf_sql_integer" value="#dlvInfo.newid#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#part_list_header_id#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#part_number#">, 
                        
						<cfqueryparam cfsqltype="cf_sql_integer" value="#order_type_id#">, 
						<cfqueryparam cfsqltype="cf_sql_integer" value="#vendor_category_id#">,  
						<cfqueryparam cfsqltype="cf_sql_integer" value="#dock_id#">,    
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#delivery_category#">,   
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#vendor_setting_detail_id#">, <!---- LSP INVENTORY IMPROVEMENT ---->   
						to_date(<cfqueryparam cfsqltype="cf_sql_varchar" value="#dlv_active_date#">,'dd/mm/yyyy'),
						<cfif dlv_inactive_date NEQ "">
							to_date(<cfqueryparam cfsqltype="cf_sql_varchar" value="#dlv_inactive_date#">,'dd/mm/yyyy'),
						</cfif>
						sysdate,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.user_code#">
					) 
				</cfquery>   



<!--------------------------------------------------------------- LSP INVENTORY IMPROVEMENT ------------------------------------------------------------>  
                <cfset warehouse_id = evaluate("warehouse_id_#r#") > 
			    <cfset tier_delivery_category = evaluate("tier_delivery_category_#r#") > 

                <cfif warehouse_id NEQ "" AND tier_delivery_category NEQ "" >

                
                        <cfquery name="tplInfo" datasource="#dswms#">
                            SELECT gen_part_list_tpl_id_seq.nextval newid FROM dual
                        </cfquery>
                        
                        <cfquery name="addPartListTpl" datasource="#dswms#">
                            INSERT INTO gen_part_list_tpl
                            (
                            part_list_delivery_info_id, vendor_setting_detail_id, part_list_tpl_id, part_list_header_id, part_number,  
                            tpl_id, delivery_category,
                            active_date, <cfif dlv_inactive_date NEQ ""> inactive_date, </cfif> 
                            creation_date, creation_by
                            )
                            VALUES
                            (
                                <cfqueryparam cfsqltype="cf_sql_integer" value="#part_list_delivery_info_id#">,
                                <cfqueryparam cfsqltype="cf_sql_numeric" value="#vendor_setting_detail_id#">,
                                <cfqueryparam cfsqltype="cf_sql_integer" value="#tplInfo.newid#">,
                                <cfqueryparam cfsqltype="cf_sql_integer" value="#part_list_header_id#">,
                                <cfqueryparam cfsqltype="cf_sql_varchar" value="#part_number#">, 
                                <cfqueryparam cfsqltype="cf_sql_integer" value="#warehouse_id#">,   
                                <cfqueryparam cfsqltype="cf_sql_varchar" value="#tier_delivery_category#">,   
                                to_date(<cfqueryparam cfsqltype="cf_sql_varchar" value="#dlv_active_date#">,'dd/mm/yyyy'),
                                <cfif dlv_inactive_date NEQ "">
                                    to_date(<cfqueryparam cfsqltype="cf_sql_varchar" value="#dlv_inactive_date#">,'dd/mm/yyyy'),
                                </cfif> 
                                sysdate,
                                <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.user_code#">
                            ) 
                        </cfquery>


                </cfif>
  
  <!--------------------------------------------------------------- LSP INVENTORY IMPROVEMENT ------------------------------------------------------------> 
  
  


  <!--- --------------------------------------------------------- DISABLED ---- LSP Inventory Project ------------------------------------------------------- 

                <cfif isDefined("tpl1_delivery_category_#r#") AND evaluate("tpl1_delivery_category_#r#") NEQ "">
                	
					 	<cfset tpl1_id = evaluate("tpl1_id_#r#") >
					 	<cfset tpl1_delivery_category = evaluate("tpl1_delivery_category_#r#") >
					 	<cfset tpl1_active_date = evaluate("tpl1_active_date_#r#") >
					 	<cfset tpl1_inactive_date = evaluate("tpl1_inactive_date_#r#") >
                        <cfset tpl1_inactive_dateView = evaluate("tpl1_inactive_dateView_#r#")> <!---add tpl1_inactive_dateView by syafiqah on 06/05/2019 for incident 1903/5663 --->
                     
                        <cfquery name="tplInfo" datasource="#dswms#">
                            SELECT gen_part_list_tpl_id_seq.nextval newid FROM dual
                        </cfquery>
                        
                        <cfquery name="addPartListTpl" datasource="#dswms#">
                            INSERT INTO gen_part_list_tpl
                            (
                            part_list_delivery_info_id, part_list_tpl_id, part_list_header_id, part_number, tpl_id, delivery_category,
                            active_date, <cfif tpl1_inactive_date NEQ ""> inactive_date, </cfif><cfif tpl1_inactive_dateView NEQ ""> inactive_date, </cfif>
                            creation_date, creation_by
                            )
                            VALUES
                            (
                                <cfqueryparam cfsqltype="cf_sql_integer" value="#part_list_delivery_info_id#">,
                                <cfqueryparam cfsqltype="cf_sql_integer" value="#tplInfo.newid#">,
                                <cfqueryparam cfsqltype="cf_sql_integer" value="#part_list_header_id#">,
                                <cfqueryparam cfsqltype="cf_sql_varchar" value="#part_number#">, 
                                <cfqueryparam cfsqltype="cf_sql_integer" value="#tpl1_id#">,  
                                <cfqueryparam cfsqltype="cf_sql_varchar" value="#tpl1_delivery_category#">,   
                                to_date(<cfqueryparam cfsqltype="cf_sql_varchar" value="#tpl1_active_date#">,'dd/mm/yyyy'),
                                <cfif tpl1_inactive_date NEQ "">
                                    to_date(<cfqueryparam cfsqltype="cf_sql_varchar" value="#tpl1_inactive_date#">,'dd/mm/yyyy'),
                                </cfif>
                                 <cfif tpl1_inactive_dateView NEQ ""> <!---add tpl1_inactive_dateView by syafiqah on 06/05/2019 for incident 1903/5663 --->
                                    to_date(<cfqueryparam cfsqltype="cf_sql_varchar" value="#tpl1_inactive_dateView#">,'dd/mm/yyyy'),
                                </cfif>
                                sysdate,
                                <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.user_code#">
                            ) 
                        </cfquery>
                     
                     
                     
                </cfif>
                 
                <cfif isDefined("tpl2_delivery_category_#r#") AND evaluate("tpl2_delivery_category_#r#") NEQ "">
                	
					 <cfset tpl2_id = evaluate("tpl2_id_#r#") >
					 <cfset tpl2_delivery_category = evaluate("tpl2_delivery_category_#r#") > 
					 <cfset tpl2_active_date = evaluate("tpl2_active_date_#r#") >
					 <cfset tpl2_inactive_date = evaluate("tpl2_inactive_date_#r#") > 
       
					<cfquery name="addPartListTpl2" datasource="#dswms#">
						INSERT INTO gen_part_list_tpl_tier
						(
						 part_list_header_id, part_list_delivery_info_id, part_number, tpl_id, delivery_category,  
						active_date, <cfif tpl2_inactive_date NEQ ""> inactive_date, </cfif>
						creation_date, creation_by
						)
						VALUES
						(  
							<cfqueryparam cfsqltype="cf_sql_integer" value="#part_list_header_id#">,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#part_list_delivery_info_id#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#part_number#">, 
							<cfqueryparam cfsqltype="cf_sql_integer" value="#tpl2_id#">,  
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#tpl2_delivery_category#">,   
							to_date(<cfqueryparam cfsqltype="cf_sql_varchar" value="#tpl2_active_date#">,'dd/mm/yyyy'),
							<cfif tpl2_inactive_date NEQ "">
								to_date(<cfqueryparam cfsqltype="cf_sql_varchar" value="#tpl2_inactive_date#">,'dd/mm/yyyy'),
							</cfif>
							sysdate,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.user_code#">
						) 
					</cfquery>
               
             	</cfif>

                ----- END : -------------------------------------------------------- DISABLED ---- LSP Inventory Project -------------------------------------------------------> 



                  
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
        
        
    <cfelseif action_flag EQ "getTPLSettings" > 
    
    	<cfset tpl1_id = "" >
        <cfset tpl1_name = "" >
        <cfset tpl1_total_dc = 0 >
        <cfset TPL1_optionList = "<option value=''>--</option>" > 
        
    	<cfquery name="getTPL1" datasource="#dswms#" >
        	 SELECT a.tpl_id, b.vendor_name tpl_name
             FROM gen_vendor_setting_details a, frm_vendors b
             WHERE a.tpl_id = b.vendor_id
             AND a.vendor_setting_detail_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#vendor_setting_detail_id#" > <!--- 1 --->
        </cfquery>
        <cfset tpl1_id = getTPL1.tpl_id >
        <cfset tpl1_name = getTPL1.tpl_name >
        
        <cfif getTPL1.recordCount NEQ 0 >
            <cfquery name="getTPL1_info" datasource="#dswms#" >
                SELECT a.delivery_category
                FROM gen_vendor_setting_headers a, gen_vendor_setting_details b
                WHERE a.vendor_setting_header_id = b.vendor_setting_header_id
                AND a.active_date <= sysdate AND NVL(a.inactive_date, sysdate+1) > sysdate
                AND b.active_date <= sysdate AND NVL(b.inactive_date, sysdate+1) > sysdate
                AND a.vendor_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#getTPL1.tpl_id#" >
                AND a.org_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#org_id#" >
                ORDER BY a.delivery_category
            </cfquery>
             
        	<cfset tpl1_total_dc = getTPL1_info.recordCount >
            <cfloop query="getTPL1_info">
                <cfset TPL1_optionList = TPL1_optionList & "<option value='" & getTPL1_info.delivery_category & "'>" & getTPL1_info.delivery_category & "</option>" >
            </cfloop>
        </cfif>
        
        <!-------------------->
        
        <cfset tpl2_id = "" >
        <cfset tpl2_name = "" >
        <cfset tpl2_total_dc = 0 >
        <cfset TPL2_optionList = "<option value=''>--</option>" > 
        
        <cfquery name="getTPL2" datasource="#dswms#" >
        	 SELECT a.tpl_id, b.vendor_name tpl_name 
             FROM gen_vendor_setting_t_details a, frm_vendors b
             WHERE a.tpl_id = b.vendor_id
             AND a.active_date <= sysdate AND NVL(a.inactive_date, sysdate+1) > sysdate
             AND a.vendor_setting_detail_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#vendor_setting_detail_id#" > <!--- 1 --->
        </cfquery> 
        <cfset tpl2_id = getTPL2.tpl_id >
        <cfset tpl2_name = getTPL2.tpl_name >
        
        <cfif getTPL2.recordCount NEQ 0 >
            <cfquery name="getTPL2_info" datasource="#dswms#" >
                SELECT a.delivery_category
                FROM gen_vendor_setting_t_headers a, gen_vendor_setting_t_details b
                WHERE a.vendor_setting_t_header_id = b.vendor_setting_t_header_id
                AND a.active_date <= sysdate AND NVL(a.inactive_date, sysdate+1) > sysdate
                AND b.active_date <= sysdate AND NVL(b.inactive_date, sysdate+1) > sysdate
                AND a.vendor_setting_detail_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#vendor_setting_detail_id#" > <!--- 1 --->
                <!---AND a.vendor_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#getTPL2.tpl_id#" >
                AND a.org_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#org_id#" >--->
                ORDER BY a.delivery_category
            </cfquery> 
            <cfset tpl2_total_dc = getTPL2_info.recordCount >
            <cfloop query="getTPL2_info">
                <cfset TPL2_optionList = TPL2_optionList & "<option value='" & getTPL2_info.delivery_category & "'>" & getTPL2_info.delivery_category & "</option>" >
            </cfloop> 
        </cfif>
        
        
   
   		<cfoutput>~~#tpl1_id#~~#tpl1_name#~~#tpl1_total_dc#~~#TPL1_optionList#~~#tpl2_id#~~#tpl2_name#~~#tpl2_total_dc#~~#TPL2_optionList#~~</cfoutput>
        
   <cfelseif action_flag EQ "getChildDescr" >
   		<cfif tier EQ 1>
        	   
             <cfquery name="getTPL" datasource="#dswms#" >
                 SELECT a.tpl_id, b.vendor_name tpl_name
                 FROM gen_vendor_setting_details a, frm_vendors b
                 WHERE a.tpl_id = b.vendor_id
                 AND a.vendor_setting_detail_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#vendor_setting_detail_id#" > <!--- 1 --->
        	  </cfquery>
            
              <cfquery name="getDESCR" datasource="#dswms#" >
                    SELECT a.delivery_category_desc
                    FROM gen_vendor_setting_headers a, gen_vendor_setting_details b
                    WHERE a.vendor_setting_header_id = b.vendor_setting_header_id
                    AND a.active_date <= sysdate AND NVL(a.inactive_date, sysdate+1) > sysdate
                    AND b.active_date <= sysdate AND NVL(b.inactive_date, sysdate+1) > sysdate
                    AND a.vendor_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#getTPL.tpl_id#" >
                    AND a.org_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#org_id#" >
                    AND a.delivery_category = <cfqueryparam cfsqltype="cf_sql_varchar" value="#delivery_category#" >
                    ORDER BY a.delivery_category
              </cfquery>
        <cfelseif tier EQ 2>

            <cfquery name="getDESCR" datasource="#dswms#" >
              SELECT a.delivery_category_desc
                FROM gen_vendor_setting_t_headers a, gen_vendor_setting_t_details b
                WHERE a.vendor_setting_t_header_id = b.vendor_setting_t_header_id
                AND a.active_date <= sysdate AND NVL(a.inactive_date, sysdate+1) > sysdate
                AND b.active_date <= sysdate AND NVL(b.inactive_date, sysdate+1) > sysdate
                AND a.delivery_category = <cfqueryparam cfsqltype="cf_sql_varchar" value="#delivery_category#" >
                AND a.vendor_setting_detail_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#vendor_setting_detail_id#" > <!--- 1 --->
                ORDER BY a.delivery_category
           	</cfquery>
        	  
        </cfif>
        
        <cfoutput>~~#getDESCR.delivery_category_desc#~~</cfoutput>
   
   
   
   
   
    <cfelseif action_flag EQ "getDeliveryCategoryDescription" >
    
    	<cfif tier EQ 1 >
        	
            <cfquery name="getDesc" datasource="#dswms#" >
        	     SELECT delivery_category_desc
                 FROM gen_vendor_setting_headers
                 WHERE org_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#org_id#" >
                 AND vendor_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#vendor_id#" >
                 AND delivery_category = <cfqueryparam cfsqltype="cf_sql_varchar" value="#delivery_category#" >
            </cfquery> 
        
        <cfelse>
        
        	<cfquery name="getDesc" datasource="#dswms#" >
        	     SELECT delivery_category_desc
                 FROM gen_vendor_setting_t_headers
                 WHERE org_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#org_id#" >
                 AND vendor_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#vendor_id#" >
                 AND delivery_category = <cfqueryparam cfsqltype="cf_sql_varchar" value="#delivery_category#" >
            </cfquery>
        
        </cfif>
    
    	<cfoutput>~~#getDesc.delivery_category_desc#~~</cfoutput>
    
    
     <cfelseif action_flag EQ "validatePartNo" >
        	<cfset status = ''>
            
                <cfquery name="validatePartNo" datasource="#dswms#">
                  SELECT part_number 
                  FROM gen_part_list_headers
                  WHERE org_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#org_id#"> 
                  AND part_number = <cfqueryparam cfsqltype="cf_sql_varchar" value="#part_number#" >
                  AND active_date <= sysdate AND NVL(inactive_date,sysdate+1) > sysdate
                </cfquery>
                
            <cfif #validatePartNo.recordcount# neq 0>
            	<cfset status = 'duplicate'>
            <cfelse>
            	<cfquery name="checkForVendor" datasource="#dswms#">
                	SELECT count(1) as count
                    FROM psms_item_master a, lsp_sourcing_info_v b, frm_vendors c, frm_organizations d
                    WHERE a.item_no = b.item_no
                    AND b.vendor_id = c.vendor_id
                    AND a.company = b.org_id 
                    AND a.company = d.ebiz_org_code
                    AND d.org_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#org_id#"> 
                    AND a.item_no = <cfqueryparam cfsqltype="cf_sql_varchar" value="#part_number#" >
                </cfquery>
                
                <cfif #checkForVendor.count# neq 0>
                    <cfset status = 'success'>
                <cfelse>
                    <cfset status = 'fail'>
                </cfif>
                
            </cfif>
			
        	<cfoutput>~~#status#~~</cfoutput> 
            
    
    <cfelseif action_flag EQ "validateBackNo" >
    
    
    		<cfquery name="validateBackNumber" datasource="#dswms#">
              SELECT back_number 
              FROM gen_part_list_headers
              WHERE org_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#org_id#"> 
              AND back_number = TRIM(REPLACE(<cfqueryparam cfsqltype="cf_sql_varchar" value="#back_no#">,' ','')) 
              AND active_date <= sysdate AND NVL(inactive_date,sysdate+1) > sysdate
			</cfquery>
            
            
        
        	<cfoutput>~~#validateBackNumber.recordCount#~~</cfoutput> 
   
   
   
    <cfelseif action_flag EQ "add" >
    
    
    <cfset trx_status = "failed" >
		<cfset errorMsg = "" >
		
		<cftransaction action="begin">
			<cftry> 
		 	  	 
	 	 
			  	<cfquery name="headerInfo" datasource="#dswms#">
					SELECT gen_part_list_header_id_seq.nextval newid FROM dual
				</cfquery>
				<cfset part_list_header_id = headerInfo.newid>
				<cfquery name="addPartListHeader" datasource="#dswms#">
					INSERT INTO gen_part_list_headers
					(
					part_list_header_id, org_id, part_number, part_name, back_number, vendor_id, color, 
                    ownership_id,  
					active_date, <cfif inactive_date NEQ ""> inactive_date, </cfif>
					creation_date, creation_by
					)
					VALUES
					(
						<cfqueryparam cfsqltype="cf_sql_integer" value="#headerInfo.newid#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#org_id#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#part_number#">, 
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#part_name#">, 
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#back_no#">,  
						<cfqueryparam cfsqltype="cf_sql_integer" value="#vendor_id#">,  
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#color_code#">, 
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#ownership_id#">,
						to_date(<cfqueryparam cfsqltype="cf_sql_varchar" value="#active_date#">,'dd/mm/yyyy'),
						<cfif inactive_date NEQ "">
							to_date(<cfqueryparam cfsqltype="cf_sql_varchar" value="#inactive_date#">,'dd/mm/yyyy'),
						</cfif>
						sysdate,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.user_code#">
					) 
				</cfquery>
				
				
				<cfquery name="psiInfo" datasource="#dswms#">
					SELECT gen_part_list_psi_id_seq.nextval newid FROM dual
				</cfquery>
				
				<cfquery name="addPartListPSI" datasource="#dswms#">
					INSERT INTO gen_part_list_psi
					(
					part_list_psi_id, part_list_header_id, part_number, box_id, qty_per_box,
					active_date, <cfif psi_inactive_date NEQ ""> inactive_date, </cfif>
					creation_date, creation_by
					)
					VALUES
					(
						<cfqueryparam cfsqltype="cf_sql_integer" value="#psiInfo.newid#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#headerInfo.newid#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#part_number#">, 
						<cfqueryparam cfsqltype="cf_sql_integer" value="#box_id#">,  
						<cfqueryparam cfsqltype="cf_sql_integer" value="#qty_per_box#">,   
						to_date(<cfqueryparam cfsqltype="cf_sql_varchar" value="#psi_active_date#">,'dd/mm/yyyy'),
						<cfif psi_inactive_date NEQ "">
							to_date(<cfqueryparam cfsqltype="cf_sql_varchar" value="#psi_inactive_date#">,'dd/mm/yyyy'),
						</cfif>
						sysdate,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.user_code#">
					) 
				</cfquery>
				
                
               	<cfquery name="dlvInfo" datasource="#dswms#">
					SELECT gen_part_list_dlv_info_id_seq.nextval newid FROM dual
				</cfquery> 
				<cfset part_list_delivery_info_id = dlvInfo.newid >
                
                <cfquery name="addPartListDlvInfo" datasource="#dswms#">
					INSERT INTO gen_part_list_delivery_info
					(
					part_list_delivery_info_id, part_list_header_id, part_number, order_type_id, vendor_category_id, dock_id, delivery_category,
					active_date, <cfif dlv_inactive_date NEQ ""> inactive_date, </cfif>
					creation_date, creation_by
					)
					VALUES
					(
						<cfqueryparam cfsqltype="cf_sql_integer" value="#dlvInfo.newid#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#headerInfo.newid#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#part_number#">, 
						<cfqueryparam cfsqltype="cf_sql_integer" value="#order_type_id#">, 
						<cfqueryparam cfsqltype="cf_sql_integer" value="#vendor_category_id#">,  
						<cfqueryparam cfsqltype="cf_sql_integer" value="#dock_id#">,    
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#delivery_category#">,   
						to_date(<cfqueryparam cfsqltype="cf_sql_varchar" value="#dlv_active_date#">,'dd/mm/yyyy'),
						<cfif dlv_inactive_date NEQ "">
							to_date(<cfqueryparam cfsqltype="cf_sql_varchar" value="#dlv_inactive_date#">,'dd/mm/yyyy'),
						</cfif>
						sysdate,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.user_code#">
					) 
				</cfquery>
                

                
<!--------------------------------------------------------------- LSP INVENTORY IMPROVEMENT ------------------------------------------------------------>  
                <cfset warehouse_id = evaluate("warehouse_id") > 
                <cfset tier_delivery_category = evaluate("tier_delivery_category") > 

                <cfif warehouse_id NEQ "" AND tier_delivery_category NEQ "" >


                        <cfquery name="tplInfo" datasource="#dswms#">
                            SELECT gen_part_list_tpl_id_seq.nextval newid FROM dual
                        </cfquery>
                        
                        <cfquery name="addPartListTpl" datasource="#dswms#">
                            INSERT INTO gen_part_list_tpl
                            (
                            part_list_delivery_info_id, vendor_setting_detail_id, part_list_tpl_id, part_list_header_id, part_number,  
                            tpl_id, delivery_category,
                            active_date, <cfif dlv_inactive_date NEQ ""> inactive_date, </cfif> 
                            creation_date, creation_by
                            )
                            VALUES
                            (
                                <cfqueryparam cfsqltype="cf_sql_integer" value="#part_list_delivery_info_id#">,
                                <cfqueryparam cfsqltype="cf_sql_numeric" value="#vendor_setting_detail_id#">,
                                <cfqueryparam cfsqltype="cf_sql_integer" value="#tplInfo.newid#">,
                                <cfqueryparam cfsqltype="cf_sql_integer" value="#part_list_header_id#">,
                                <cfqueryparam cfsqltype="cf_sql_varchar" value="#part_number#">, 
                                <cfqueryparam cfsqltype="cf_sql_integer" value="#warehouse_id#">,   
                                <cfqueryparam cfsqltype="cf_sql_varchar" value="#tier_delivery_category#">,   
                                to_date(<cfqueryparam cfsqltype="cf_sql_varchar" value="#dlv_active_date#">,'dd/mm/yyyy'),
                                <cfif dlv_inactive_date NEQ "">
                                    to_date(<cfqueryparam cfsqltype="cf_sql_varchar" value="#dlv_inactive_date#">,'dd/mm/yyyy'),
                                </cfif> 
                                sysdate,
                                <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.user_code#">
                            ) 
                        </cfquery>


                </cfif>

<!--------------------------------------------------------------- LSP INVENTORY IMPROVEMENT ------------------------------------------------------------> 




<!--- --------------------------------------------------------- DISABLED ---- LSP Inventory Project ------------------------------------------------------- 



                <cfif tpl1_delivery_category NEQ "" >
				 
                	<cfquery name="tplInfo" datasource="#dswms#">
						SELECT gen_part_list_tpl_id_seq.nextval newid FROM dual
					</cfquery>
					
					<cfquery name="addPartListTpl" datasource="#dswms#">
						INSERT INTO gen_part_list_tpl
						(
						part_list_delivery_info_id, part_list_tpl_id, part_list_header_id, part_number, tpl_id, delivery_category,
						active_date, <cfif tpl1_inactive_date NEQ ""> inactive_date, </cfif>
						creation_date, creation_by
						)
						VALUES
						(
							<cfqueryparam cfsqltype="cf_sql_integer" value="#part_list_delivery_info_id#">,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#tplInfo.newid#">,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#part_list_header_id#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#part_number#">, 
							<cfqueryparam cfsqltype="cf_sql_integer" value="#tpl1_id#">,  
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#tpl1_delivery_category#">,   
							to_date(<cfqueryparam cfsqltype="cf_sql_varchar" value="#tpl1_active_date#">,'dd/mm/yyyy'),
							<cfif tpl1_inactive_date NEQ "">
								to_date(<cfqueryparam cfsqltype="cf_sql_varchar" value="#tpl1_inactive_date#">,'dd/mm/yyyy'),
							</cfif>
							sysdate,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.user_code#">
						) 
					</cfquery>
                 
                 </cfif>
                 
                <cfif tpl2_delivery_category NEQ "" >     
       
					<cfquery name="addPartListTpl2" datasource="#dswms#">
						INSERT INTO gen_part_list_tpl_tier
						(
						 part_list_header_id, part_list_delivery_info_id, part_number, tpl_id, delivery_category,  
						active_date, <cfif tpl2_inactive_date NEQ ""> inactive_date, </cfif>
						creation_date, creation_by
						)
						VALUES
						(  
							<cfqueryparam cfsqltype="cf_sql_integer" value="#part_list_header_id#">,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#part_list_delivery_info_id#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#part_number#">, 
							<cfqueryparam cfsqltype="cf_sql_integer" value="#tpl2_id#">,  
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#tpl2_delivery_category#">,   
							to_date(<cfqueryparam cfsqltype="cf_sql_varchar" value="#tpl2_active_date#">,'dd/mm/yyyy'),
							<cfif tpl2_inactive_date NEQ "">
								to_date(<cfqueryparam cfsqltype="cf_sql_varchar" value="#tpl2_inactive_date#">,'dd/mm/yyyy'),
							</cfif>
							sysdate,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.user_code#">
						) 
					</cfquery>
               
             	</cfif>

-----------------END : ---------------------------------------- DISABLED ---- LSP Inventory Project ------------------------------------------------------->                


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

    <cfelseif action_flag EQ "loadDeliveryCategory" >

        <cfquery name="getDeliveryCategory" datasource="#dswms#"> 
            SELECT a.vendor_setting_header_id, b.vendor_setting_detail_id, a.delivery_category, a.delivery_category_desc
            FROM gen_vendor_setting_headers a, gen_vendor_setting_details b
            WHERE a.vendor_setting_header_id = b.vendor_setting_header_id
            AND b.attr1 IS NULL
            AND a.org_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#org_id#">
            AND a.vendor_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#vendor_id#">
            AND a.active_date <= to_date(<cfqueryparam cfsqltype="cf_sql_varchar" value="#active_date#">, 'dd/mm/yyyy') 
            AND NVL(a.inactive_date,to_date(<cfqueryparam cfsqltype="cf_sql_varchar" value="#active_date#">, 'dd/mm/yyyy')+1) > to_date(<cfqueryparam cfsqltype="cf_sql_varchar" value="#active_date#">, 'dd/mm/yyyy')
            AND b.active_date <= to_date(<cfqueryparam cfsqltype="cf_sql_varchar" value="#active_date#">, 'dd/mm/yyyy')
            AND NVL(b.inactive_date,to_date(<cfqueryparam cfsqltype="cf_sql_varchar" value="#active_date#">, 'dd/mm/yyyy')+1) > to_date(<cfqueryparam cfsqltype="cf_sql_varchar" value="#active_date#">, 'dd/mm/yyyy')
            ORDER BY a.delivery_category
        </cfquery>

        <cfoutput>~~#getDeliveryCategory.recordCount#~~
            
        <cfset field_vendor_setting = "vendor_setting_detail_id_" & rowID >
        <cfif rowID EQ 0 >
            <cfset field_vendor_setting = "vendor_setting_detail_id" > 
        </cfif>

        <select name="#field_vendor_setting#" id="#field_vendor_setting#"  class="formStyle tips">
            <cfif getDeliveryCategory.recordCount EQ 0 > 
                <option value="">-- No record found --</option>
            <cfelse> 
                <option value="" vendor_setting_header_id="" delivery_category="" route="" >-- Please Select --</option>
             </cfif>  

             <cfloop query="getDeliveryCategory">
                <option value='#getDeliveryCategory.vendor_setting_detail_id#' vendor_setting_header_id='#getDeliveryCategory.vendor_setting_header_id#' delivery_category='#getDeliveryCategory.delivery_category#' route ='#getDeliveryCategory.delivery_category_desc#'> #getDeliveryCategory.delivery_category#</option> 
            </cfloop> 
        </select>

        ~~</cfoutput> 

 

    <cfelseif action_flag EQ "loadVendorSetting" >
        
        <cfquery name="getDeliveryCategory" datasource="#dswms#">  
            SELECT ( SELECT vendor_name FROM frm_vendors WHERE vendor_id = a.vendor_id ) vendor_name,
                a.delivery_category, 
                b.delivery_type_id, ( SELECT delivery_type FROM lsp_delivery_type WHERE delivery_type_id = b.delivery_type_id ) delivery_type,
                delivery_point, 
                b.buy_off_point_id, ( SELECT buy_off_point_code FROM gen_buy_off_point WHERE buy_off_point_id = b.buy_off_point_id ) buy_off_point_code, 
                b.tier1_tpl_id transporter_id, ( SELECT vendor_name FROM frm_vendors WHERE vendor_id = b.tier1_tpl_id ) transporter_name, 
                DECODE(b.tier1_tpl_id,NULL,'N','Y') tpl1_flag,
                c.route, 
                d.warehouse_id,
                ( SELECT vendor_name FROM frm_vendors WHERE vendor_id = d.warehouse_id ) warehouse_name, 
                tier_delivery_category, tier_delivery_type_id, tier_delivery_type, tier_delivery_point, tier_buy_off_point_id, tier_buy_off_point_code, 
                tier_transporter_id, tier_transporter_name, tier_route, DECODE(tier_transporter_id,NULL,'N','Y') tpl2_flag
            FROM gen_vendor_setting_headers a, gen_vendor_setting_details b, gen_vendor_setting_routing c, 
                gen_vendor_setting_warehouse d, 
                (
                    SELECT a.vendor_setting_detail_id, a.delivery_category tier_delivery_category, 
                        b.delivery_type_id tier_delivery_type_id, ( SELECT delivery_type FROM lsp_delivery_type WHERE delivery_type_id = b.delivery_type_id ) tier_delivery_type,
                        'PERODUA' tier_delivery_point, 
                        b.buy_off_point_id tier_buy_off_point_id, ( SELECT buy_off_point_code FROM gen_buy_off_point WHERE buy_off_point_id = b.buy_off_point_id ) tier_buy_off_point_code, 
                        b.tpl_id tier_transporter_id, ( SELECT vendor_name FROM frm_vendors WHERE vendor_id = b.tpl_id ) tier_transporter_name, 
                        c.route tier_route
                    FROM gen_vendor_setting_t_headers a, gen_vendor_setting_t_details b, gen_vendor_setting_t_routing c
                    WHERE a.vendor_setting_t_header_id = b.vendor_setting_t_header_id
                    AND a.vendor_setting_detail_id = b.vendor_setting_detail_id (+)
                    AND a.vendor_setting_detail_id = c.vendor_setting_detail_id (+)
                    AND a.vendor_setting_detail_id = b.vendor_setting_detail_id
                ) e
            WHERE a.vendor_setting_header_id = b.vendor_setting_header_id
            AND b.vendor_setting_detail_id = c.vendor_setting_detail_id (+)
            AND b.vendor_setting_detail_id = d.vendor_setting_detail_id (+) 
            AND b.vendor_setting_detail_id = e.vendor_setting_detail_id (+) 
            AND b.active_date <= sysdate AND NVL(b.inactive_date,sysdate+1) > sysdate
            AND a.vendor_setting_header_id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vendor_setting_header_id#"> 
        </cfquery>
 
 

        <cfoutput>~~#getDeliveryCategory.recordCount#~~ 
                    <table>
                        <tr>
                            <td style="border:none;min-width:460px" align="center" width="470px">
                                <table class="tablestyle" width="100%">
                                    <tr>
                                        <cfif getDeliveryCategory.warehouse_id EQ "" OR ( getDeliveryCategory.warehouse_id NEQ "" AND getDeliveryCategory.tier_delivery_category EQ "" )  > 
                                            <td colspan="2" align="center" class="vendor_header" height="16">
                                                <i class="fa-solid fa-industry"></i>  1st Tier Vendor
                                            </td>    
                                        <cfelse>
                                            <td colspan="2" align="center" class="vendor_header" height="16">
                                                <i class="fa-solid fa-industry"></i>  2nd Tier Vendor
                                            </td>
                                        </cfif> 
                                    </tr>
                                    <tr>
                                        <td colspan="2" height="30px" align="center" class="vendor_name_bg">#getDeliveryCategory.vendor_name#</td>
                                    </tr>
                                    <tr>
                                        <td width="58%" class="setting_blue_bg"><i class="fa-solid fa-sliders"></i> #getDeliveryCategory.delivery_category#</td>
                                        <td width="42%" class="setting_blue_bg"><i class="fa-solid fa-arrows-turn-to-dots"></i> #getDeliveryCategory.delivery_type#</td>
                                    </tr>
                                    <tr>
                                        <td class="setting_blue_bg"><i class="fa-solid fa-location-crosshairs"></i> #getDeliveryCategory.delivery_point#</td>
                                        <td class="setting_blue_bg"><i class="fa-solid fa-hand-holding-dollar"></i> #getDeliveryCategory.buy_off_point_code#</td>
                                    </tr>
                                    <cfif getDeliveryCategory.transporter_id NEQ "" > 
                                        <tr>
                                            <td class="setting_blue_bg"><i class="fa-solid fa-truck"></i> #getDeliveryCategory.transporter_name#</td>
                                            <td class="setting_blue_bg"><i class="fa-solid fa-route"></i> #getDeliveryCategory.route#</td>
                                        </tr> 
                                    </cfif> 
                                    <tr><td colspan="2" class="bottom_panel"></td></tr>
                                </table> 
                            </td>   

                            <cfif getDeliveryCategory.warehouse_id NEQ "" AND getDeliveryCategory.tier_delivery_category EQ "" > 

                                <td style="border:none" align="center" width="50"><i class="fa-solid fa-angles-right blink" style="font-size:20px; color:green"></i></td>

                                <td style="border:none" align="center" width="250px">
                                    <table cellpadding="0" cellspacing="0" style="border:none" width="100%">
                                        <tr>
                                            <td colspan="2" align="center" class="warehouse_header" height="16">
                                            <i class="fa-solid fa-warehouse"></i>  Warehouse
                                            </td>
                                        </tr>
                                        <tr>
                                            <td colspan="2" height="30px" align="center" class="warehouse_content">#getDeliveryCategory.warehouse_name#</td>
                                        </tr> 
                                        <tr><td colspan="2" class="bottom_panel"></td></tr>
                                    </table> 
                                </td>

                            <cfelseif getDeliveryCategory.warehouse_id NEQ "" AND getDeliveryCategory.tier_delivery_category NEQ "" > 

                                <td style="border:none" align="center" width="50"><i class="fa-solid fa-angles-right blink" style="font-size:20px; color:green"></i></td>

                                <td style="border:none;min-width:470px" align="center" width="460px">
                                    <table class="tablestyle" width="100%">
                                        <tr>
                                            <td colspan="2" align="center" class="tier1_header" height="16">
                                            <i class="fa-solid fa-industry"></i>  1st Tier Vendor</td>
                                        </tr>
                                        <tr>
                                            <td colspan="2" height="30px" align="center" class="vendor_name_bg">#getDeliveryCategory.warehouse_name#</td>
                                        </tr>
                                        <tr>
                                            <td width="58%" class="setting_orange_bg"><i class="fa-solid fa-sliders"></i> #getDeliveryCategory.tier_delivery_category#</td>
                                            <td width="42%" class="setting_orange_bg"><i class="fa-solid fa-arrows-turn-to-dots"></i> #getDeliveryCategory.tier_delivery_type#</td>
                                        </tr>
                                        <tr>
                                            <td class="setting_orange_bg"><i class="fa-solid fa-location-crosshairs"></i> #getDeliveryCategory.tier_delivery_point#</td>
                                            <td class="setting_orange_bg"><i class="fa-solid fa-hand-holding-dollar"></i> #getDeliveryCategory.tier_buy_off_point_code#</td>
                                        </tr>
                                        <tr>
                                            <td class="setting_orange_bg"><i class="fa-solid fa-truck"></i> #getDeliveryCategory.tier_transporter_name#</td>
                                            <td class="setting_orange_bg"><i class="fa-solid fa-route"></i> #getDeliveryCategory.tier_route#</td>
                                        </tr>  
                                        <tr><td colspan="2" class="bottom_panel"></td></tr>
                                    </table> 
                                </td>

                            </cfif>

                            <cfif getDeliveryCategory.warehouse_id NEQ "" AND getDeliveryCategory.tier_delivery_category EQ "" >
                            <cfelse>
                            <td style="border:none" align="center" width="50"><i class="fa-solid fa-angles-right blink" style="font-size:20px; color:green"></i></td> 
                            <td style="border:none" align="center" width="1"><img src="../../../includes/images/P2newsmall2.jpg" height="50px"> </td>
                            </cfif>

 
                             




                            <cfset field_transporter = "transporter_id_" & rowID >
                            <cfset field_warehouse = "warehouse_id_" & rowID >
                            <cfset field_tier_dlv_category = "tier_delivery_category_" & rowID >
                            <cfif rowID EQ 0 >
                                <cfset field_transporter = "transporter_id" >
                                <cfset field_warehouse = "warehouse_id" >
                                <cfset field_tier_dlv_category = "tier_delivery_category" >
                            </cfif>


                            <input type="hidden" id="#field_transporter#" name="#field_transporter#" value="#getDeliveryCategory.transporter_id#" >
                            <input type="hidden" id="#field_warehouse#" name="#field_warehouse#" value="#getDeliveryCategory.warehouse_id#" >
                            <input type="hidden" id="#field_tier_dlv_category#" name="#field_tier_dlv_category#" value="#getDeliveryCategory.tier_delivery_category#" >


                        </tr>
                    </table>  
           
        ~~#getDeliveryCategory.tpl1_flag#~~#getDeliveryCategory.tpl2_flag#~~</cfoutput> 


        
        
    <cfelseif action_flag EQ "generate_vendor_setting">
    
		
          <cfquery name="getVSetting" datasource="#dswms#"> 
            SELECT a.vendor_setting_header_id, b.vendor_setting_detail_id, a.delivery_category
            FROM gen_vendor_setting_headers a,  gen_vendor_setting_details b
            WHERE a.org_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#org_id#">
            AND a.vendor_setting_header_id = b.vendor_setting_header_id
            AND a.vendor_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#vendor_id#">
             AND a.active_date <= to_date(<cfqueryparam cfsqltype="cf_sql_varchar" value="#active_date#">, 'dd/mm/rrrr')
            AND (a.inactive_date is null OR a.inactive_date > to_date(<cfqueryparam cfsqltype="cf_sql_varchar" value="#active_date#">, 'dd/mm/rrrr'))
            AND b.active_date <= to_date(<cfqueryparam cfsqltype="cf_sql_varchar" value="#active_date#">, 'dd/mm/rrrr')
            AND (b.inactive_date is null OR b.inactive_date > to_date(<cfqueryparam cfsqltype="cf_sql_varchar" value="#active_date#">, 'dd/mm/rrrr'))
            AND b.attr1 IS NULL
            ORDER BY a.delivery_category                 
    	</cfquery>
		
      
    
    	<cfoutput>
        ~~
			<cfif #getVSetting.recordcount# neq 0>
            		<cfif rowID neq ''>
                      <select name="vendor_setting_detail_id_#rowID#" 
                      id="vendor_setting_detail_id_#rowID#" class="formStyle tips" 
                      onChange="getTPLSettings(#rowID#);getDeliveryCategory(this.id,#rowID#);" style="width:98%">
                    <cfelse>
                      <select name="vendor_setting_detail_id" 
                      id="vendor_setting_detail_id" class="formStyle tips" 
                      onChange="getTPLSettings();getDeliveryCategory(this.value);" style="width:98%">
                   	</cfif>   
                          <option value="">-- Please Select --</option> 
                          <cfloop query="getVSetting">
                         	 <option value="#vendor_setting_detail_id#">#delivery_category#</option>
                          </cfloop>
                      </select>
               <cfelse>
               		<cfif rowID neq ''>
                      <select disabled name="vendor_setting_detail_id_#rowID#" id="vendor_setting_detail_id_#rowID#" 
                      class="formStyle tips">
                    <cfelse>
                       <select disabled name="vendor_setting_detail_id" id="vendor_setting_detail_id" 
                      class="formStyle tips">
                   	</cfif>
                     
                          <option value="">-- No Data Available --</option>
                      </select>
            </cfif>
        ~~    
		</cfoutput>
        
    
    <cfelseif action_flag EQ "add_remark" >    
        
    	<cfquery name="getOrg" datasource="#dswms#">   
        	SELECT org_description
            FROM frm_organizations 
            WHERE org_id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#org_id#" >            
        </cfquery> 
        
        <cfset currRowStyle = "lookupRow1" >
        <cfset currBgColor = "F4F4F4" > 
        <cfset rowno = 0 >
           
		<cfoutput>
                ~~
				<table  width="98%" height="100%" class="formStyle" cellpadding="5" cellspacing="0" style="font-size:12px;"> 
					
				<table width="85%" cellpadding="4" align="center">
                	<tr><td height="10px" colspan="2"></td></tr>
                     <tr>
                        <td width="25" align="right" colspan="1">Remark : </td>
                        <td width="70"align="left">
                        <input class="formStyle tips" type="text" id="remarks" name="remarks" > 
                        </td>                    
                     </tr>
                     
                     <tr>
                        <td align="right" nowrap="nowrap" colspan="1">Remark Description : </td>
                        <td align="left">
                        	<input type="text" id="remark_descr" name="remark_descr" size="60"> 
                        </td>
                     </tr> 
                      
                     <tr>
                     	<td colspan="4" align="right" nowrap="nowrap"> 
                        	<input id="saveBtnAdd" name="saveBtnAdd" type="button" class="button white" onclick="saveAdd();" value="Save" /> 
                            <input id="closeBtnAdd" name="closeBtnAdd" type="button" class="button white" value="Close" />
                        </td>
                     </tr> 
				</table>  
        	
            ~~#rowno#~~
	  </cfoutput>
        
    <cfelseif action_flag EQ "addRemark" >
    
    
    <cfset trx_status = "failed" >
		<cfset errorMsg = "" >
		
		<cftransaction action="begin">
			<cftry> 		 	  	 
	 	 
			  	<cfquery name="remarkID" datasource="#dswms#">
					SELECT LSP_REMARK_SEQ.nextval newid FROM dual
				</cfquery>                
				
				<cfquery name="addRemark" datasource="#dswms#">
					INSERT INTO lsp_remark
					(
						remark_id, 
                        org_id, 
                        remark_code, 
                        remark_description, 
                        creation_date, 
                        creation_by,
                        status
					)
					VALUES
					(
						<cfqueryparam cfsqltype="cf_sql_integer" value="#remarkID.newid#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#org_id#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#remark#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#remark_descr#">,
						sysdate,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.user_code#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="ACTIVE">
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

		<cfoutput>~~#trx_status#~~#errorMsg#~~#remarkID.newid#~~</cfoutput>
    
    
        
        <cfelseif action_flag EQ "fillRemark" >
            
            <cfquery name="getRemark" datasource="#dswms#" >
                SELECT remark_id, remark_code, remark_description
                FROM lsp_remark a
                WHERE a.org_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#org_id#">	
                <!---START--added by Luqman 28082022--->
                AND a.status = <cfqueryparam cfsqltype="cf_sql_varchar" value="ACTIVE">
                <!---END--added by Luqman 28082022--->
                ORDER BY remark_id
            </cfquery>
            
            <cfquery name="getCurrRemark" datasource="#dswms#" >
                SELECT a.org_id, a.part_number, a.remark_id, d.remark_code, d.remark_description, part_list_header_id
                FROM gen_part_list_headers a,  lsp_remark d 
                WHERE a.remark_id = d.remark_id
                <cfif part_list_header_id NEQ "">
					AND a.part_list_header_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#part_list_header_id#">
                </cfif>               
            </cfquery>
            
            <cfset returnVal = ''>

					<cfif #getRemark.recordcount# neq 0>
                       <cfset returnVal = '<option value="">-- Please Select --</option>'>;
                       <cfloop query="#getRemark#">
							<cfif #getCurrRemark.recordcount# neq 0 AND #getCurrRemark.remark_id# eq #remark_id#>
                            	<cfset returnVal = returnVal & '<option selected value="#remark_id#" descr="#remark_description#">#remark_code#</option>'>;
                            <cfelse>
                            	<cfset returnVal = returnVal & '<option value="#remark_id#" descr="#remark_description#">#remark_code#</option>'>;
                            </cfif>                        
                       </cfloop>
                    <cfelse>
                        <cfset returnVal = '<option value="">-- No Remarks --</option>'>
                    </cfif>

        <cfoutput>~~#returnVal#~~#getRemark.recordcount#~~</cfoutput> 
	
    <!---START--added by Luqman 28082022--->
    <cfelseif action_flag EQ "edit_remark" >    
        
    	<cfquery name="getOrg" datasource="#dswms#">   
        	SELECT org_description
            FROM frm_organizations 
            WHERE org_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#org_id#" >            
        </cfquery> 
        
        <cfquery name="getRemark" datasource="#dswms#">   
        	SELECT remark_code, remark_description
			FROM lsp_remark
			WHERE org_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#org_id#">	
			AND remark_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#remark_id#">           
        </cfquery> 
        
        <cfset currRowStyle = "lookupRow1" >
        <cfset currBgColor = "F4F4F4" > 
        <cfset rowno = 0 >
           
		<cfoutput>
                ~~
				<table  width="98%" height="100%" class="formStyle" cellpadding="5" cellspacing="0" style="font-size:12px;"> 
					
				<table width="85%" cellpadding="4" align="center">
                	<tr><td height="10px" colspan="2"></td></tr>
                     <tr>
                        <td width="25" align="right" colspan="1">Remark : </td>
                        <td width="70"align="left">
                        <input class="formStyle tips" type="text" id="remarks_edit" name="remarks_edit" value="#getRemark.remark_code#"> 
                        </td>                    
                     </tr>
                     
                     <tr>
                        <td align="right" nowrap="nowrap" colspan="1">Remark Description : </td>
                        <td align="left">
                        	<input type="text" id="remark_descr_edit" name="remark_descr_edit" size="60" value="#getRemark.remark_description#"> 
                        </td>
                     </tr> 
                      
                     <tr>
                     	<td colspan="4" align="right" nowrap="nowrap"> 
                        	<input id="saveBtnEdit" name="saveBtnAdd" type="button" class="button white" onclick="saveEdit();" value="Save" /> 
                            <input id="closeBtnEdit" name="closeBtnAdd" type="button" class="button white" value="Close" />
                            <input type="button" id="deleteBtnEdit" style="margin-right:7px;" class="button red" value="Delete" onclick="deleteRemark();">
                        </td>
                     </tr> 
				</table>  
        	
            ~~#rowno#~~
	  </cfoutput>
      
  	<cfelseif action_flag EQ "editRemark" >
    
    
    <cfset trx_status = "failed" >
		<cfset errorMsg = "" >
		
		<cftransaction action="begin">
			<cftry> 		 	  	 
	 	             
				
				<cfquery name="editRemark" datasource="#dswms#">
                	UPDATE LSP_REMARK
                    SET remark_code = <cfqueryparam cfsqltype="cf_sql_varchar" value="#remark#">,
                    	remark_description = <cfqueryparam cfsqltype="cf_sql_varchar" value="#remark_descr#">,
                        last_updated_date = sysdate,
                        last_updated_by = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.user_code#">
                   	WHERE org_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#org_id#">	
					AND remark_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#remark_id#"> 
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

		<cfoutput>~~#trx_status#~~#errorMsg#~~#remark_id#~~</cfoutput>
    
    <cfelseif action_flag EQ "removeRemark" >
    
    
    <cfset trx_status = "failed" >
		<cfset errorMsg = "" >
		
		<cftransaction action="begin">
			<cftry> 		 	  	 
	 	             
				
				<cfquery name="removeRemark" datasource="#dswms#">
                	UPDATE LSP_REMARK
                    SET status = <cfqueryparam cfsqltype="cf_sql_varchar" value="INACTIVE">,
                        last_updated_date = sysdate,
                        last_updated_by = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.user_code#">
                   	WHERE org_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#org_id#">	
					AND remark_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#remark_id#"> 
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
    <!---END--added by Luqman 28082022--->
         
	</cfif>
	
</cfif>
<cfif !parameterExists(target)>ENDOFREQUEST</cfif>

 
 
 
  

 


 
 
  
