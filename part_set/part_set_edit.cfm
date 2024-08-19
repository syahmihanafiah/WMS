<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>
<head>

<cfinclude template="../../../includes/file_access_validation.cfm" > 
<cfinclude template="../../../includes/basic_includes.cfm" >
 
<cfinvoke component="#component_path#.organization_decoder" method="decodeOrganizationsID" dsn="#dswms#" returnvariable="OrgArr" ></cfinvoke>   
<!---v1.1(START)--->
<cfinvoke component="#component_path#.ownership" method="retrieveOwnership" dsn="#dsscmfw#" returnvariable="getOwnerships" ></cfinvoke> 
<!---v1.1(END)--->
  
<script type="text/javascript" src="part_set_edit.js"></script> 
  
<cfquery name="getMotherPartDetails" datasource="#dswms#">
	SELECT DISTINCT b.part_list_header_id, a.mother_part_number part_number,  b.part_name, b.back_number, b.color, c.vendor_name, a.ownership_id
	FROM gen_part_set a, gen_part_list_headers b, frm_vendors c
	WHERE a.mother_part_number = b.part_number 
	AND b.vendor_id = c.vendor_id
	AND a.org_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#org_id#" >
	AND mother_part_number = <cfqueryparam cfsqltype="cf_sql_varchar" value="#mother_part_number#" >
</cfquery>	
 
<cfquery name="getChildPartDetails" datasource="#dswms#">
	SELECT ROWNUM rn, a.* FROM (
	SELECT DISTINCT b.part_list_header_id, a.part_set_id, a.part_number,  b.part_name, b.back_number, b.color, c.vendor_name, 
	to_char(a.active_date,'dd/mm/yyyy') active_date, to_char(a.inactive_date,'dd/mm/yyyy') inactive_date, 
    a.inactive_date x, a.active_date y, a.last_updated_date z, 
	CASE WHEN a.active_date <= sysdate AND NVL(a.inactive_date,sysdate+1) > sysdate THEN 'ACTIVE'
    ELSE 'INACTIVE' END status   
	FROM gen_part_set a, gen_part_list_headers b, frm_vendors c
	WHERE a.part_number = b.part_number 
	AND b.vendor_id = c.vendor_id
	AND a.org_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#org_id#" >
	AND a.mother_part_number = <cfqueryparam cfsqltype="cf_sql_varchar" value="#mother_part_number#" >
    AND b.active_date <= sysdate AND NVL(b.inactive_date,sysdate+1) > sysdate
	ORDER BY  a.inactive_date, a.active_date, a.last_updated_date asc 
	) a
</cfquery>

<cfquery name="getACTIVEChildPartDetails" dbtype="query">
	SELECT part_set_id, part_list_header_id, part_number, part_name, back_number, color, vendor_name, active_date, inactive_date, status
	FROM getChildPartDetails
	WHERE status = <cfqueryparam cfsqltype="cf_sql_varchar" value="ACTIVE">
	ORDER BY rn ASC
</cfquery>

<cfquery name="getINACTIVEChildPartDetails" dbtype="query">
	SELECT part_set_id, part_list_header_id, part_number, part_name, back_number, color, vendor_name, active_date, inactive_date, status
	FROM getChildPartDetails
	WHERE status = <cfqueryparam cfsqltype="cf_sql_varchar" value="INACTIVE">
	ORDER BY rn ASC
</cfquery>

<script language="javascript">
	var rowID = '<cfoutput>#getACTIVEChildPartDetails.recordCount#</cfoutput>';
	var totalRow = rowID;
	var totalCreatedRow = rowID;
</script>

<link rel="stylesheet" href="menu_ext.css" type="text/css" > 

</head>
 
<body background="../../../includes/images/bground1.png"> 
	<div id="content">
		<div class="screen_header">General Master > Master Data > Part Set Master > Add </div>  
	</div>  
	<br><br><br>  
	<div id='jqxWidget' style="width:99%; margin:auto"> 
		<div id='jqxExpander'>
            <div>
				<div style="float:left">Add new part set</div> 
				<div id="progressbar" style="float:right; display:none; margin-left:10px; margin-top:3px"><img src="../../../includes/images/progress_green_small.gif" ></div>
			</div>  
			
            <div> 
				<cfoutput> 
				<form name="editForm" id="editForm" action="bgprocess.cfm" method="post">  
					<input type="hidden" name="action_flag" value="edit" >  
				    <input type="hidden" id="mother_part_list_header_id" name="mother_part_list_header_id" value="#getMotherPartDetails.part_list_header_id#" >
				    <input type="hidden" id="mother_part_number" name="mother_part_number" value="#mother_part_number#" >
					<input type="hidden" id="new_row_id" name="new_row_id" >
					 <table width="100%" cellpadding="4" class="formStyle" cellspacing="0">
					 	<tr>
							<td align="center">
								<table width="1191"> 
									<tr><td height="10"></td></tr>
									<tr>
										<td align="right" width="100">Organization : </td>
										<td align="left">
											<input type="hidden" name="org_id" id="org_id" value="#org_id#">
											<input type="text" class="formStyleReadOnly" readonly size="40" value="#decodeOrgID(OrgArr,org_id)#">
										</td>	
										<td align="right" width="100">Ownership : </td>
										<td align="left">
											<cfset ownership_id = #getMotherPartDetails.ownership_id#>
											<input type="hidden" name="ownership_id" id="ownership_id" value="#getMotherPartDetails.ownership_id#">
											<input type="text" class="formStyleReadOnly" readonly size="40" value="#decodeOrgID(OrgArr,ownership_id)#">
										</td>											
									</tr> 
									<tr><td height="10"></td></tr>
								</table>
								<table class="tablestyle" width="1191">
									<tr class="boldstyle bgstyle1" id="motherPartBar">
										<td align="left" colspan="5" style="font-style:italic;">
											<div style="float:left">Mother Part Details</div> 
										</td>
									</tr>
									<tr class="bgstyle2 smallfont boldstyle" id="motherPartHeader"> 
										<td align="center" width="195">Part Number</td>
										<td align="center" width="320">Part Name</td>
										<td align="center" width="80">Back Number</td>
										<td align="center" width="80">Color</td>
										<td align="center" width="320">Vendor Name</td> 
									</tr>  
									<tr>
										<td align="center">#getMotherPartDetails.part_number#</td>
										<td align="center">#getMotherPartDetails.part_name#</td>
										<td align="center">#getMotherPartDetails.back_number#</td>
										<td align="center">#getMotherPartDetails.color#</td>
										<td align="center">#getMotherPartDetails.vendor_name#</td> 
									</tr>
									<tr class="boldstyle bgstyle1" id="motherPartFooter">
										<td align="right" colspan="5"></td>
									</tr> 
								</table>
								
								<table><tr><td height="10"></td></tr></table>
								
								<table class="tablestyle" id="childPartTable" width="1191" >
									<tr class="boldstyle bgstyle1" id="childPartBar">
										<td align="left" colspan="9" style="font-style:italic;">
											<div style="float:left">Child Part Details</div>
											<div id='childPartMenu' style="visibility: hidden; float:right">
													<ul> 
														<li><img id="childPartMenuIcon" src="../../../includes/images/gear.png">
															<ul>
                                                            <cfif getINACTIVEChildPartDetails.recordcount neq 0>
																<li id="historyChildPartBtn">Display History</li>  
                                                            </cfif>    
																<li id="addChildPartBtn">Add New </li>  
																<li id="removeChildPartBtn">Remove Selection</li>  
															</ul>
														</li>
													</ul>
											</div> 
										</td>
									</tr>
									<tr class="bgstyle2 smallfont boldstyle" id="motherPartHeader"> 
										<td align="center"><input type="checkbox" name="checkAll" id="checkAll" class="formStyle"></td>
										<td>&nbsp;</td>
										<td align="center" width="165">Part Number</td>
										<td align="center" width="260">Part Name</td>
										<td align="center" width="80">Back Number</td>
										<td align="center" width="80">Color</td>
										<td align="center" width="260">Vendor Name</td> 
										<td align="center" width="110">Active Date</td>
										<td align="center" width="110">Inactive Date</td>
									</tr> 
									
									<cfloop query="getINACTIVEChildPartDetails">
									<tr class="INACTIVE_rows" style="display:none;background-color:##FFD9D9" >  
										<td align="center"><input type="checkbox" disabled="disabled"></td>
										<td align="center" width="24"><img src="../../../includes/images/inactive.png" alt="Old Setting"></td>
										<td align="center">#part_number#</td> 
										<td align="center">#part_name#</td>
										<td align="center">#back_number#</td>
										<td align="center">#color#</td>
										<td align="center">#vendor_name#</td> 
										<td align="center">#active_date#</td>
										<td align="center">#inactive_date#</td> 
									</tr>
									</cfloop>
									
						
									<cfset rowID = 0 >
									<cfset old_row_id = "" >
									<cfloop query="getACTIVEChildPartDetails">
									<cfset rowID = rowID + 1 >
									<cfif old_row_id EQ "" >
										<cfset old_row_id = rowID >
									<cfelse>
										<cfset old_row_id = old_row_id & "," & rowID >
									</cfif>
									<input type="hidden" id="part_set_id_#rowID#" name="part_set_id_#rowID#" value="#part_set_id#" >
									<input type="hidden" id="part_list_header_id_#rowID#" name="part_list_header_id_#rowID#" value="#part_list_header_id#" > 
									<tr id="row_#rowID#" class="ACTIVE_rows"style="background-color:##CAFFE4">  
										<td align="center"><input type="checkbox" name="chkoldrowid" value="#rowID#" disabled="disabled"></td>
										<td align="center" width="24"><img src="../../../includes/images/active.png" alt="Current Setting"></td>
										<td align="center">#part_number#</td> 
										<td align="center">#part_name#</td>
										<td align="center">#back_number#</td>
										<td align="center">#color#</td>
										<td align="center">#vendor_name#</td> 
										<td align="center">#active_date#</td> 
										<td align="center">
											<div align="left">
												<div class="old_inactive_date_picker" id="old_inactive_date_picker_#rowID#"></div>
												<input type="hidden" name="old_active_date_#rowID#" id="old_active_date_#rowID#" value="#active_date#">
												<input type="hidden" name="old_inactive_date_#rowID#" id="old_inactive_date_#rowID#" value="#inactive_date#">
											</div>  
										</td> 
									</tr>
									</cfloop> 
									<input type="hidden" id="old_row_id" name="old_row_id" value="#old_row_id#" >
					 
									<tbody></tbody>
								</table> 
								<table class="tablestyle" width="1191" style="margin-top:-1px;" >
									<tr class="boldstyle bgstyle1" id="motherPartFooter">
										<td align="right" colspan="8"></td>
									</tr> 
								</table>
								
							</td>
						</tr>
					</table>
  					<table><tr><td height="10"></td></tr></table>
						 
					<table width="100%" cellpadding="4" class="formStyle" cellspacing="0"> 
                      <tr>
                        <td colspan="4" align="right" bgcolor="F5F5F5" style="padding:8px">
						    <input id="updateBtn" name="submit" type="submit" class="button white" value="Update" /> 
                            <input id="resetBtn" type="button" class="button white" onClick="window.location.href=self.location" value="Reset"/>
                            <input id="closeBtn" type="button" class="button white" onClick="window.location.href='part_set.cfm'" value="Close" />
                        </td>
                     </tr>
                   </table>
				</form>
				</cfoutput>
 
			</div>
		</div> 
	<br> 
	</div>  
	
	
	<div id="lookupTPLWindow" style="display:none">
         <div class="lookupHeader" style="background-image:url(../../../includes/images/lookupheader.png); ">
			 <div style="float:left">Third Party Logistic List</div>
			 <div id="lookupTPLProgress" style="float:left; margin:2px 0px 0px 5px"><img src="../../../includes/images/progress_green_small.gif" /></div>
		 </div>
         <div style="padding:0px;"> 
		 <iframe class="lookupFrame" id="lookupTPLContent" frameborder="0" scrolling="auto" ></iframe>
		 </div>
    </div>
	
	<div id="lookupPartNumberWindow" style="display:none">
         <div class="lookupHeader" style="background-image:url(../../../includes/images/lookupheader.png); ">
			 <div style="float:left">Part Number List</div>
			 <div id="lookupPartNumberProgress" style="float:left; margin:2px 0px 0px 5px"><img src="../../../includes/images/progress_green_small.gif" /></div>
		 </div>
         <div style="padding:0px;"> 
		 <iframe class="lookupFrame" id="lookupPartNumberContent" frameborder="0" scrolling="auto" ></iframe>
		 </div>
    </div>
	
	
</body>
</html>








