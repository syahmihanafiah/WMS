<!---
  Suite         : SETUP
  Purpose       : NEW ACCESSORY CENTRE

  Version    Developer    		Date            Remarks
  v1.1.00     Syahmi         	13/08/2024   	1. Add Ownership for Gear Up

--->
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>
<head>

<cfinclude template="../../../includes/file_access_validation.cfm" > 
<cfinclude template="../../../includes/basic_includes.cfm" >
 
<cfinvoke component="#component_path#.organization_decoder" method="decodeOrganizationsID" dsn="#dswms#" returnvariable="OrgArr" ></cfinvoke>   
  
<script type="text/javascript" src="part_set_add2.js"></script> 
  
<cfquery name="getMotherPartDetails" datasource="#dswms#">
	SELECT part_list_header_id, part_number, part_name,  back_number, color, vendor_name
	FROM gen_part_list_headers a, frm_vendors b
	WHERE a.vendor_id = b.vendor_id
	AND part_number = <cfqueryparam cfsqltype="cf_sql_varchar" value="#mother_part_number#" >
</cfquery>	
 
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
				<form name="addForm" id="addForm" action="bgprocess.cfm" method="post">  
					<input type="hidden" name="action_flag" value="add" >  
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
										<!------>
										<td align="right" width="100">Ownership : </td>
										<td align="left">
											<input type="hidden" name="ownership_id" id="ownership_id" value="#ownership_id#">
											<input type="text" class="formStyleReadOnly" readonly size="40" value="#decodeOrgID(OrgArr,ownership_id)#">
										</td>	
										<!------>									
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
										<td align="center">Vendor Name</td> 
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
								
								<table class="tablestyle" id="childPartTable" width="1191">
									<tr class="boldstyle bgstyle1" id="childPartBar">
										<td align="left" colspan="9" style="font-style:italic;">
											<div style="float:left">Child Part Details</div>
											<div id='childPartMenu' style="visibility: hidden; float:right">
													<ul> 
														<li><img id="childPartMenuIcon" src="../../../includes/images/gear.png">
															<ul> 
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
										<td align="center">Part Number</td>
										<td align="center">Part Name</td>
										<td align="center">Back Number</td>
										<td align="center">Color</td>
										<td align="center">Vendor Name</td> 
										<td align="center" width="110">Active Date</td>
										<td align="center" width="110">Inactive Date</td>
									</tr> 
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
						    <input id="saveBtn" name="submit" type="submit" class="button white" value="Save" />
							<input id="backBtn" type="button" class="button white" value="Back" onClick="window.location.href='part_set_add1.cfm';"/>
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








