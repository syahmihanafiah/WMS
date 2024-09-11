<cfsetting showdebugoutput="yes" > 

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>
<head>
<cfinclude template="../../../includes/file_access_validation.cfm" > 
<cfinclude template="../../../includes/basic_includes.cfm" > 
<cfinclude template="../../../includes/parameter_option_control.cfm" >
<link rel="stylesheet" href="../../../includes/css/menu_ext.css" type="text/css" >
   
<script language="javascript" src="tpl_concept_add.js"></script> 

<!---ADDED BY SYAHMI (START)--->
<cfinvoke component="#component_path#.organization_decoder" method="decodeOrganizationsID" dsn="#dswms#" returnvariable="OrgArr"></cfinvoke>
<!---ADDED BY SYAHMI (END)--->
<style type="text/css">
.active_row_style {
	background-color:#CAFFE4;
} 
.inactive_row_style {
	background-color:#FFD9D9;
} 
.lock_row_style {
	background-color:#FFD9D9;
}  
</style>

<cfquery name="getOrgDesc" datasource="#dswms#">
	SELECT org_description FROM frm_organizations
    WHERE org_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#org_id#">
</cfquery>

<cfif #tpl_id# neq "">

	<cfquery name="getTier" datasource="#dswms#">
        SELECT tier                            
        FROM gen_tpl_concept_headers
       		WHERE tpl_concept_header_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#tpl_id#">
        
	</cfquery>
    
	<cfset getTier = #getTier.tier#>

<cfelse>
	<cfset getTier = #tier#>
</cfif>    

	
 
</head>	 
<body background="../../../includes/images/bground1.png">  
               
	<div id="content">
		<div class="screen_header">General Master > Master Data > Transportation Cost > TPL Cost Elements </div>  
	</div>  
	
	<br><br><br>   
	
            <div style="width:99%; margin:auto">  
                    <div id='UIPanel' > 
                <div>
				<div style="float:left">TPl Cost Elements <cfif #type# eq 'add'>(Add)<cfelseif #type# eq 'edit'>(Edit)</cfif></div>
                <div id="progressbar" class="ajaxProgressBar" style="float:right; display:none; margin-left:10px; margin-top:3px">
                <img src="../../../includes/images/progress_green_small.gif" >
                </div>
                </div> 
                        <div>    
					<cfoutput>  
					
                   <form name="addForm" id="addForm" action="bgprocess.cfm" method="post"> 
                   <input type="hidden" id="tabid" value="#tabid#" >
                   <input type="hidden" name="org_id" id="org_id" value="#org_id#">
                   <input type="hidden" name="action_flag" id="action_flag" value="add" > 
                   <input type="hidden" name="new_row_id" id="new_row_id" >
                   <input type="hidden" name="new_child_row" id="new_child_row" >
                   <input type="hidden"  id="lookupID" >
                   
							<table width="100%" cellpadding="4" class="formStyle" cellspacing="0" >
                            	 <tr><td height="5"></td></tr>
                                     <tr>
                                          <td align="right" width="20%">Organization : </td>
                                          <td align="left" width="25%">
                                          <input type="text" name="org_description" id="org_description" class="formStyleReadOnly" 
                                    		value="#getOrgDesc.org_description#" size="33" readonly>
                                          </td> 
                                          <!---ADDED BY SYAHMI(START)--->
                                          <td align="right" width="25%">Ownership : </td>
                                          <td width="30%" align="left">
                                            <input type="hidden" name="ownership_id" id="ownership_id" value="#ownership_id#">
                                            <input type="text" class="formStyleReadOnly" readonly size="40" value="#decodeOrgID(OrgArr,ownership_id)#">
                                          </td>
                                          <!---ADDED BY SYAHMI(END)--->
                                    </tr>
                                    
                                     <tr>
                                          <td align="right" width="20%">Transporter Type : </td>
                                          <td width="25%" align="left" >           
                                           	<input type="text" name="tier" id="tier" class="formStyleReadOnly" 
                                    		value="#getTier#" size="15" readonly>
                                          </td>
                                          
                                          
                                          <td align="right" width="25%"></td>
                                          <td width="30%" align="left" ></td>
                                     </tr>
							</table>
                        <br> 
                        
                        
                        
                         <cfquery name="activeRows" datasource="#dswms#">
                                    SELECT tpl_concept_header_id AS tpl_id,
                                    	   group_code,
                                           group_desc,
                                           collection,
                                           handling,
                                           delivery,
                                           tier,
                                           to_char(active_date,'dd/mm/yyyy') as active_date,
                                           to_char(inactive_date,'dd/mm/yyyy') as inactive_date,
                                           (SELECT to_char(sysdate,'dd/mm/yyyy') FROM dual) currDate                                   
                                      FROM gen_tpl_concept_headers
                                     WHERE org_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#org_id#">
                                     AND tier = <cfqueryparam cfsqltype="cf_sql_integer" value="#getTier#">
                                     AND ((inactive_date is null) OR (inactive_date > ( select trunc(sysdate) from dual)))
                                     	<cfif #tpl_id# neq ''>
                                        	AND tpl_concept_header_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#tpl_id#">
                                        </cfif>
                                     ORDER BY inactive_date ASC, active_date DESC   
						
                         </cfquery>
                         
                         
                   	     
               	     <cfquery name="inactiveRows" datasource="#dswms#" >
                        			SELECT tpl_concept_header_id AS tpl_id,
                                    	   group_code,
                                           group_desc,
                                           collection,
                                           handling,
                                           delivery,
                                           to_char(active_date,'dd/mm/yyyy') as active_date,
                                           to_char(inactive_date,'dd/mm/yyyy') as inactive_date  
                                      FROM gen_tpl_concept_headers
                                     WHERE org_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#org_id#">
                                     AND tier = <cfqueryparam cfsqltype="cf_sql_integer" value="#getTier#">
                                     AND ((inactive_date is not null) OR (inactive_date <= ( select trunc(sysdate) from dual)))
                                     	<cfif #tpl_id# neq ''>
                                        AND tpl_concept_header_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#tpl_id#">
                                        </cfif>
                        			

                        </cfquery>
                     
                        <table class="tablestyle" id="TPLTable" align="center" width="90%" > 
                        	<tr class="boldstyle bgstyle1" id="TPLBar">
                            	<td align="left" colspan="15" height="22" style="font-style:italic;" valign="middle">
                                	<div style="float:left; font-size:11px; margin-top:3px;">Add TPL Concept</div>  
                                	<div id='TPL_menu' style="visibility: hidden; float:right">
                                   <cfif #type# eq 'edit' AND inactiveRows.recordCount neq 0>
										<ul> 
											<li><img src="../../../includes/images/gear.png">
												<ul> 
                                                	<li id="showhistoryBtn">View History </li>  
													<li id="hidehistoryBtn" style="display:none">Hide History </li> 
												</ul>
											</li>
										</ul>
                                        
                                   	<cfelseif #type# eq 'add'>
                                    	<ul> 
											<li><img src="../../../includes/images/gear.png">
												<ul> 
                                                	<cfif inactiveRows.recordCount NEQ 0 >
                                                	<li id="showhistoryBtn">View History </li>  
													<li id="hidehistoryBtn" style="display:none">Hide History </li> 
                                                    </cfif> 
                                                    <li id="addBtn">Add New</li>
													<li id="removeBtn" style="display:none">Remove Selected</li>
												</ul>
											</li>
										</ul>     
                                    </cfif>    
									</div> 
                               	</td>
                          	</tr>
                            <tr class="bgstyle2 smallfont boldstyle">  
                                <cfif #type# eq 'add'><td width="40" align="center"><input type="checkbox" class="formStyle" id="checkAll"></td></cfif>
                                <td width="40" align="center"></td>
                                <td width="120" align="center">Group Code</td>  
                                <td width="120" align="center">Description</td>
                                <td width="140" align="center">Collection</td> 
                                <td width="140" align="center">Handling</td> 
                                <td width="140" align="center">Delivery</td> 
                                <td width="120" align="center">Active Date</td> 
                                <td width="120" align="center">Inactive Date</td>
                                <td width="30" align="center"></td>
                                
                            </tr> 
                            
                            <cfloop query="inactiveRows" > 
                            <tr class="inactive_row_style inactive_row" style="display:none">  
                               <cfif #type# eq 'add'> <td width="58" align="center"><input type="checkbox" disabled></td></cfif>
                                <td width="50" align="center"><img src="../../../includes/images/inactive.png"></td> 
                                
                                <td align="center">#group_code#</td>  
                                <td align="center">#group_desc#</td>
                                <td align="center">#collection#</td> 
                                <td align="center">#handling#</td> 
                                <td align="center">#delivery#</td> 
                                <td align="center">#active_date#</td> 
                                <td align="center">#inactive_date#</td>
                                <td width="30" align="center"><img src="../../../includes/images/grey_status.png"></td>

                            </tr>  
                            </cfloop>
              
                            <cfset actRowID = 0 >
                           <input type="hidden" name="getCurrDate" id="getCurrDate" value="#activeRows.currDate#">
                            <cfloop query="activeRows" >
                            <cfset actRowID = actRowID + 1 >
                            <tr class="active_row_style" id="actRow_#actRowID#" height="30">  
                            	<cfif #type# eq 'add'>
                                    <td width="58" align="center">
                                    <input type="checkbox" disabled>
                                    </td>
                                </cfif>
                                <td width="50" align="center">
                                <img src="../../../includes/images/active.png" id="flag_#actRowID#" >
                                
                                <input type="hidden" name="tpl_id_#actRowID#" id="tpl_id_#actRowID#" value="#tpl_id#" >
                                <input type="hidden" class="groupcodes" id="group_code_#actRowID#" value="#group_code#" >
                                </td>
                                
								<td align="center">#group_code#</td>  
                                <td align="center">#group_desc#</td>
                                <td align="center">#collection#</td> 
                                <td align="center">#handling#</td> 
                                <td align="center">#delivery#</td> 
                                <td align="center">
                                #active_date#
                   				<input type="hidden" name="active_date_#actRowID#" id="active_date_#actRowID#" value="#active_date#">
                                </td> 
                                <cfif #inactive_date# eq ''>
                                    <td align="center">
                                    	<div class="inactive_date_picker" id="inactive_date_picker_#actRowID#" val=""></div> 
                                    </td>
                                <cfelse>
                                	<td align="center">
                                    	<input type="hidden" name="inactive_date_picker_#actRowID#" 
                                        id="inactive_date_picker_#actRowID#" value="">
                                    	#inactive_date#
                                    </td>   
                                </cfif>
                                
                                <td width="30" align="center">
                                <img src="../../../includes/images/arrow_down.png" id="down#actRowID#" 
                                style="cursor:pointer;" onClick="toggleDisplay(#actRowID#);" >
                                <img src="../../../includes/images/arrow_up.png" id="up#actRowID#" 
                                style="cursor:pointer; display:none;" onClick="toggleDisplay(#actRowID#);"  >
                                </td>  
                                
                            </tr> 
                                 <tbody class="resultDetail#actRowID#" style="display:none" >
                                    <tr height="80">
                                        <td colspan="10" >
                                        
                                        <cfquery name="getChildInactive" datasource="#dswms#">
                                        		
                                                        	SELECT detail_id,
                                                                   vendor_name,
                                                                   delivery_category,
                                                                   route,
                                                                   route_id,
                                                                   delivery_type,
                                                                   tpl_name,
                                                                   status
                                                              FROM (  SELECT a.tpl_concept_detail_id AS detail_id,
                                                                             (SELECT DISTINCT vendor_name
                                                                                FROM frm_vendors
                                                                               WHERE vendor_id = a.vendor_id)
                                                                                AS vendor_name,
                                                                             a.delivery_category,
                                                                             a.delivery_category_desc AS route,
                                                                             a.vendor_setting_header_id AS route_id,
                                                                             (SELECT DISTINCT delivery_type
                                                                                FROM lsp_delivery_type
                                                                               WHERE delivery_type_id = a.delivery_type_id)
                                                                                AS delivery_type,
                                                                             CASE
                                                                                WHEN a.inactive_date IS NULL THEN 'ACTIVE'
                                                                                WHEN a.inactive_date > SYSDATE THEN 'ACTIVE'
                                                                                ELSE 'INACTIVE'
                                                                             END
                                                                                AS status,
                                                                             e.vendor_name tpl_name
                                                                        FROM gen_tpl_concept_details a,
                                                                             gen_tpl_concept_headers b,
                                                                             frm_vendors e,
                                                                             <cfif #tier# eq 1>
                                                                               gen_vendor_setting_details c,
                                                                               gen_vendor_setting_headers d
                                                                             <cfelseif #tier# eq 2>
                                                                               gen_vendor_setting_t_details c,
                                                                               gen_vendor_setting_t_headers d
                                                                             </cfif>
                                                                       WHERE     a.tpl_concept_header_id = b.tpl_concept_header_id
                                                                               AND a.vendor_setting_header_id = <cfif #tier# eq 1>c.vendor_setting_header_id<cfelseif #tier# eq 2>c.vendor_setting_t_header_id</cfif>
                                                                             <cfif #tier# eq 1>
                                                                               AND c.vendor_setting_header_id = d.vendor_setting_header_id
                                                                             <cfelseif #tier# eq 2>
                                                                               AND c.vendor_setting_t_header_id = d.vendor_setting_t_header_id
                                                                             </cfif>
                                                                             AND b.org_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#org_id#">
                                                                             AND b.tier = <cfqueryparam cfsqltype="cf_sql_varchar" value="#tier#">
                                                                             <cfif #tpl_id# neq "">
                                                                             	AND b.tpl_concept_header_id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#tpl_id#">
                                                                             </cfif>
                                                                             AND (a.inactive_date is not null AND a.inactive_date <= sysdate)
                                                                             AND a.tpl_id = e.vendor_id
                                                                             )
                                                                    GROUP BY detail_id,
                                                                             vendor_name,
                                                                             delivery_category,
                                                                             delivery_type,
                                                                             route,
                                                                             tpl_name,
                                                                             status,
                                                                             route_id
                                                                    ORDER BY LPAD(UPPER(route),20), vendor_name                                       </cfquery>			
                                    
                                                <table align="center" class="tablestyle" id="childtable_#actRowID#" width="98%">  
                                               	<tr class="boldstyle bgstyle1" id="childBar_#actRowID#">
                                                        <td align="left" colspan="15" height="22" style="font-style:italic;" valign="middle">
                                                            <div style="float:left; font-size:11px; margin-top:3px;">Add TPL Concept</div>  
                                                            <div id='childBar_menu_#actRowID#' style="visibility: hidden; float:right">
                                                                <ul> 
                                                                    <li><img src="../../../includes/images/gear.png">
                                                                        <ul> 
                                                                            <cfif getChildInactive.recordCount NEQ 0 >
                                                                            <li
                                                                             id="showchildhistoryBtn_#actRowID#"
                                                                             onClick="toggleHistoryBtn(this.id)">
                                                                            View History 
                                                                            </li>  
                                                                            
                                                                            <li id="hidechildhistoryBtn_#actRowID#"
                                                                            onClick="toggleHistoryBtn(this.id)"
                                                                             style="display:none">
                                                                            Hide History 
                                                                            </li> 
                                                                            </cfif>  
                                                                            <li id="addBtn_#actRowID#" 
                                                                             onClick="openLookupVendor(this.id)">
                                                                            Add New
                                                                            </li>  
                                                                            <li id="removeBtn_#actRowID#" style="display:none">Remove Selected</li>
                                                                        </ul>
                                                                    </li>
                                                                </ul>
                                                            </div> 
                                                        </td>
                          							</tr>

                                                    <tr class="bgstyle2 smallfont boldstyle" height="30">
                                						<td width="25" align="center"></td>
                                                    	
                                                        <td width="410" align="left">Vendor Name</td>  
                                                        <td width="110" align="center">Delivery Category</td>
                                                        <td width="110" align="center">Route</td> 
                                                        <td width="110" align="center">Delivery Type</td>
                                                        <td width="250" align="center">Transporter</td>
                                                        <td width="110" align="center">Status</td>
                                                    </tr>
                                                    
                                                    
                                                    <cfloop query="getChildInactive" > 
                                                        <tr class="inactive_row_style childinactive_row_#actRowID#" style="display:none">  
                                                           <td width="25" align="center">
                                                                <img src="../../../includes/images/inactive.png" >
                                                           </td>
                                                           
                                                            <td align="left">#vendor_name#</td>  
                                                            <td align="center">#delivery_category#</td>
                                                            <td align="center">#route#</td> 
                                                            <td align="center">#delivery_type#</td>
                                                            <td align="left">#tpl_name#</td>  
                                                            <td align="center">
                                                                <img src="../../../includes/images/switch_red.png" 
                                                                width="45" height="18" style="margin-top:3px;">
                                                            </td>
                                                        </tr>  
                                                    </cfloop>
                                                                           
                                                    
                                                    	<cfquery name="getChildActive" datasource="#dswms#">
                                                        
                                                        	SELECT detail_id,
                                                                   vendor_name,
                                                                   delivery_category,
                                                                   route,
                                                                   route_id,
                                                                   delivery_type,
                                                                   tpl_name,
                                                                   status
                                                              FROM (  SELECT a.tpl_concept_detail_id AS detail_id,
                                                                             (SELECT DISTINCT vendor_name
                                                                                FROM frm_vendors
                                                                               WHERE vendor_id = a.vendor_id)
                                                                                AS vendor_name,
                                                                             a.delivery_category,
                                                                             a.delivery_category_desc AS route,
                                                                             a.vendor_setting_header_id AS route_id,
                                                                             (SELECT DISTINCT delivery_type
                                                                                FROM lsp_delivery_type
                                                                               WHERE delivery_type_id = a.delivery_type_id)
                                                                                AS delivery_type,
                                                                             CASE
                                                                                WHEN a.inactive_date IS NULL THEN 'ACTIVE'
                                                                                WHEN a.inactive_date > SYSDATE THEN 'ACTIVE'
                                                                                ELSE 'INACTIVE'
                                                                             END
                                                                                AS status,
                                                                             e.vendor_name tpl_name
                                                                        FROM gen_tpl_concept_details a,
                                                                             gen_tpl_concept_headers b,
                                                                             frm_vendors e,
                                                                             <cfif #tier# eq 1>
                                                                               gen_vendor_setting_details c,
                                                                               gen_vendor_setting_headers d
                                                                             <cfelseif #tier# eq 2>
                                                                               gen_vendor_setting_t_details c,
                                                                               gen_vendor_setting_t_headers d
                                                                             </cfif>
                                                                       WHERE     a.tpl_concept_header_id = b.tpl_concept_header_id
                                                                             AND a.vendor_setting_header_id = <cfif #tier# eq 1>c.vendor_setting_header_id<cfelseif #tier# eq 2>c.vendor_setting_t_header_id</cfif>
                                                                             <cfif #tier# eq 1>
                                                                               AND c.vendor_setting_header_id = d.vendor_setting_header_id
                                                                             <cfelseif #tier# eq 2>
                                                                               AND c.vendor_setting_t_header_id = d.vendor_setting_t_header_id
                                                                             </cfif>
                                                                             AND b.org_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#org_id#">
                                                                             AND b.tier = <cfqueryparam cfsqltype="cf_sql_varchar" value="#tier#">
                                                                             <cfif #tpl_id# neq "">
                                                                             	AND b.tpl_concept_header_id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#tpl_id#">
                                                                             </cfif>
                                                                             AND (a.inactive_date is null OR a.inactive_date > sysdate)
                                                                             AND a.tpl_id = e.vendor_id
                                                                             )
                                                                    GROUP BY detail_id,
                                                                             vendor_name,
                                                                             delivery_category,
                                                                             delivery_type,
                                                                             route,
                                                                             status,
                                                                             route_id,
                                                                             tpl_name
                                                                   	ORDER BY LPAD(UPPER(route),20), vendor_name
                                                                    		                       
                                        
                                                        </cfquery>
                                                        
                                                        <cfset childRowId = 0>
                                                        <cfif getChildActive.recordcount gt 0>
                                                        
                                                                <cfloop query="getChildActive">
                                                                	<cfset childRowId = childRowId + 1 >
                                                                    	
                                                                    	<tr class="active_row_style" 
                                                                        id="childRow_#actRowID#_#childRowId#" 
                                                                        height="30" >
                                                       
                                                                        
                                										<td width="25" align="center">
                                                                        	<input type="hidden" 
                                                                            name="detail_id_#actRowID#_#childRowId#" 
                                                                            value="#detail_id#" >
                                											<img src="../../../includes/images/active.png" 
                                                                            id="flag_#actRowID#_#childRowId#" >
                               											</td>
                                                                        <td align="left">#vendor_name#</td>
                                                                        <td align="center">#delivery_category#</td>
                                                                        <td align="center">#route#</td> 
                                                                        <td align="center">#delivery_type#</td>
                                                                        <td align="left">#tpl_name#</td>
                                                                        <td align="center">
                                                                        
                                                                        <img src="../../../includes/images/switch_on.png" 
                                                                        id="act_switchBtn_#actRowID#_#childRowId#" width="45" height="18" 
                                										class="act_switchBtn" style="margin-top:3px;cursor:pointer"
                                                                        onClick="changeStatus(this.id)">
                                                                        
                                										<input type="hidden" id="status_#actRowID#_#childRowId#" 
                                                                        name="status_#actRowID#_#childRowId#" value="Y" >
                                                                        </td>
                                                                        
                                                                        <input type="hidden" 
                                                                         name="route_id_#actRowID#_#childRowId#" 
                                                                         value="#route_id#" class="routes_id">

                                                                        </tr>
                                                                </cfloop>
                                                        </cfif>
                                                    	<input type="hidden" name="totalRow_#actRowID#" id="totalRow_#actRowID#" value="#childRowId#" >
                                                 <tbody></tbody>    
                                                </table>
                                                <input type="hidden" id="childRowId_#actRowID#" name="childRowId_#actRowID#" value="#childRowId#" >
                                        </td>
                                    </tr>
                                    </tbody>
                            </cfloop>   
                            
                            <tr class="boldstyle bgstyle1 borderRow"><td align="right" colspan="15" style="height:2px;padding:0px;"></td></tr>
                            <tbody></tbody>   
                        </table>  
                        <input type="hidden" id="actRowID" name="actRowID" value="#actRowID#" >  
            
                        
                 </td>
                 </tr>
                 </table>
                 
                		 <table width="100%">
                           <tr><td height="10"></td></tr>
                           <tr>
                                <td align="right" bgcolor="F5F5F5" style="padding:8px">  
                                     <input class="button white ctrlObj" type="submit" value="Save" id="saveBtn" /> 
                                     <input class="button white ctrlObj" type="button" value="Reset" id="resetBtn" /> 
                                     <input class="button white ctrlObj" type="button" value="Close" id="closeBtn" /> 
                               </td>
                           </tr>
                        </table> 
                  </form>
                    </cfoutput> 
                        

  
   
				</div> 
			</div>  
	                   
	</div>
    
    
    
    <div id="lookupWindow" style="display:none">
        <div class="lookupHeader" style="background-image:url(../../../includes/images/lookupheader.png); ">
			<div style="float:left">Vendor List</div>
			<div id="lookupProgress" style="float:left; margin:2px 0px 0px 5px"><img src="../../../includes/images/progress_green_small.gif" /></div>
		</div>
        <div style="padding:0px;"> 
		<iframe class="lookupFrame" id="lookupContent" frameborder="0" scrolling="auto" ></iframe>
		</div>   
	</div>  
	  
</body> 
</html>


 