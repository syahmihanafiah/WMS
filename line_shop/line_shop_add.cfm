<!---
  Suite         : DSI - Demand Supply Information
  Purpose       : New D55L - DPI3 Implementation
  
  Version    Developer    		Date            Remarks
  2.0.00     Harris        		20/4/2020     	Add DPI Source Data
  2.0.01     Nawawi        		03/02/2021     	Add Model Adjust Flag
  2.0.02     Syahmi             13/08/2024      Add Ownership for Gear Up
--->


<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>
<head>

<cfinclude template="../../../includes/file_access_validation.cfm" > 
<cfinclude template="../../../includes/basic_includes.cfm" >
<script language="javascript" src="line_shop_add.js"></script>
<link rel="stylesheet" href="../../../includes/css/menu_ext.css" type="text/css" >  <!--- Include CSS style for JQX Menu (Row Painter Menu) ---> 
 

<style>
.addBtn:hover {
 background-color: #f5f5f5;
 }

</style>
  
 
</head>
 
<cfinvoke component="#component_path#.organization" method="retrieveOrganizations" dsn="#dsscmfw#" returnvariable="registeredOrg" ></cfinvoke>  
<!---v1.1(START)--->
<cfinvoke component="#component_path#.ownership" method="retrieveOwnership" dsn="#dsscmfw#" returnvariable="getOwnerships" ></cfinvoke> 
<!---v1.1(END)---> 
<cfif registeredOrg.recordCount LT 2 >
	<script type="text/javascript">
		var orgid = '<cfoutput>#registeredOrg.org_id#</cfoutput>';
		fillShop(orgid);
		fillJITFlag(orgid)
	</script>
</cfif> 

<cfquery name="getSourceList" datasource="#dswms#">
  SELECT config_value
    FROM gen_dpi_config
    WHERE config_type = <cfqueryparam  cfsqltype="cf_sql_varchar" value="DPI_SOURCE" >
        AND active_date <= sysdate
        AND NVL(inactive_date,sysdate+1) > sysdate
</cfquery>

<cfset DPISourceList = ValueList(getSourceList.config_value) >


<input type="hidden" name="appr_list" id="appr_list" >
<body background="../../../includes/images/bground1.png"> 
	<div id="content">
		<div class="screen_header">General Master > Master Data > Line Shop Master > Add</div>  
	</div>  
	<br><br><br>  
	<div id='jqxWidget' style="width:99%; margin:auto"> 
		<div id='jqxExpander'>
            <div>
				<div style="float:left">Add new line shop</div> 
				<div id="progressbar" style="float:right; display:none; margin-left:10px; margin-top:3px"><img src="../../../includes/images/progress_green_small.gif" ></div>
			</div>  
			
            <div> 
				<cfoutput> 
				<form name="addForm" id="addForm" action="bgprocess.cfm" method="post">  
					<input type="hidden" name="action_flag" value="add" >  
                    <input type="hidden" id="tabid" value="#tabid#" >
					<table width="100%" cellpadding="4" class="formStyle" cellspacing="0">
					  <tr>
						<td height="5"></td>
					  </tr>
					  <tr>
						<td align="right" width="20%">Organization : </td>
						<td align="left" width="25%">
							
							<cfif registeredOrg.recordCount LT 2 > 
								<input type="hidden" name="org_id" id="org_id" class="formStyle" value="#registeredOrg.org_id#">
								<input type="text" name="org_description" id="org_description" class="formStyleReadOnly" value="#registeredOrg.org_description#" 
								size="50" readonly> 
							<cfelse>
								<select name="org_id" id="org_id" class="formStyle" onChange="fillShop(this.value);fillJITFlag(this.value)">
								<option value="">-- Please Select --</option>
									<cfloop query="registeredOrg">
										<option value="#org_id#">#org_description#</option>
									</cfloop>
								</select> 
							</cfif>
						</td>
						<!---ADDED BY SYAHMI(START)--->														
						<td align="right" width="20%"> Ownership :</td>
						<td align="left" width="25%">
							<cfoutput>
								<cfif getOwnerships.recordCount LT 2 > 
									 <input type="hidden" name="ownership_id" id="ownership_id" class="formStyle" value="#getOwnerships.org_id#">
									 <input type="text" name="org_description" id="org_description" class="formStyleReadOnly" value="#getOwnerships.org_description#" 
									 size="40" readonly> 
								<cfelse>
									<select name="ownership_id" id="ownership_id" class="formStyle">
									<option value="">-- All --</option> 
										<cfloop query="getOwnerships">
											<option value="#org_id#">#org_description#</option>
										</cfloop>
									</select> 
								</cfif> 
							</cfoutput>
						</td> 																							
				<!---ADDED BY SYAHMI(END)--->	                                                
					  </tr> 
                      
					  <tr>
                      
						<td align="right" width="20%">Line Shop : </td>
						<td align="left" width="25%">
						<input type="text" name="line_shop" id="line_shop" class="formStyle" size="20" onKeyDown="clear_tooltips();">
						</td> 
                        
						<td align="right" width="25%">Volume Source : </td>
						<td align="left" width="30%" >
                        <!--- PLANE PMSB PROJECT --->
                        
                        <cfquery name="getVsource" datasource="#dswms#">
                              SELECT DISTINCT a.parent_org_id, b.org_nick_name
                              FROM frm_parent_organizations a, frm_organizations b, frm_st_applications c
                              WHERE a.parent_org_id = b.org_id
                              AND a.apps_id = c.apps_id
                              AND b.status = 'ACTIVE'
                              AND c.active_date <= sysdate AND NVL(c.inactive_date,sysdate+1) > sysdate
                              AND org_nick_name IS NOT NULL
                              ORDER BY  b.org_nick_name 
                        </cfquery> 

                       	<select id="volume_source" name="volume_source" class="formStyle" >
								<option value="">-- Please Select --</option> 
                                	<cfloop query="getVsource">
										<option value="#getVsource.parent_org_id#">#getVsource.org_nick_name#</option>
									</cfloop>
							</select> 
                        </td>
                        
					  </tr>  
                      
					  <tr>
						<td align="right">Active Date : </td>
						<td align="right">
							<div align="left">
								<div id='active_date_picker'></div>
								<input type="hidden" name="active_date" id="active_date" class="formStyle" size="30">
							</div>
						</td>
						<td align="right">Inactive Date : </td>
						<td align="right">
							<div align="left">
								<div id='inactive_date_picker'></div>
								<input type="hidden" name="inactive_date" id="inactive_date" class="formStyle" size="30">
							</div>
						</td>
					  </tr>
                      <tr>
                      	<!---PLANE PMSB PROJECT--->
                      	<td align="right">JIT Flag: </td>
                      	<td align="left">
                        	<div id="displayJITFlag" style="display: inline-block;">
                        		<input type="checkbox" name="jit_flag" id="jit_flag" disabled>
							</div>
                        	<input type="hidden" name="jit_flag_val" id="jit_flag_val"> </td>
							<td align="right" width="25%">Shop : </td>
							<td align="left" width="30%" >
							<div id="displayShop" style="display: inline-block;">
								<select id="shop_id" name="shop_id" class="formStyle" disabled="disabled">
									<option value="">-- Please Select --</option> 
								</select> 
							</div>
							</td>						
                      </tr>
                      
                      <tr>
                      	<!---EMCT Ratio--->
                      	<td align="right">Model Ratio Flag: </td>
                      	<td align="left"> 
                        	<input type="checkbox" name="ratio_flag" id="ratio_flag" value="Y"> 
                      </tr>
                      
                      	<tr style="padding-top:10px;">
                            <td colspan="4" align="center">
								     <table class="tablestyle" id="rowPainter" align="center" width="40%" >
                       					<input type="hidden" id="newRowList" name="newRowList" value="">
                                        <thead>
                                            <tr class="boldstyle bgstyle1">
                                                <td align="left" colspan="5" height="22" style="font-style:italic;" valign="middle">
                                                    <div style="float:left; font-size:11px; margin-top:3px;">DPI Source Data Information</div>  
                                                    <div id='jqx_menu' style="visibility: hidden; float:right">
                                                        <ul> 
                                                            <li><img src="../../../includes/images/gear.png" >
                                                                <ul> 
                                                                    <li id="addBtn" class="addBtn">Add New</li>  
                                                                    <li id="removeBtn" class="removeBtn" style="display:none">Remove Selected</li>
                                                                </ul>
                                                            </li>
                                                        </ul>
                                                    </div> 
                                                </td>
                                            </tr>
                                            
                                            <tr class="bgstyle2 smallfont boldstyle">  
                                                <td width="5%" align="center"><input type="checkbox" class="formStyle" id="checkAll"></td>
                                                <td width="5%" align="center"></td>
                                                <td width="30%" align="center" >DPI Source</td>  
                                                <td width="30%" align="center" >Start DO Date</td> 
                                                <td width="30%" align="center" >End DO Date</td> 
                                            </tr>
                                        </thead>
                                        
                                        <tbody>
                                        	<tr class="smallfont boldstyle noRow addBtn" style="cursor:pointer;">  
                                                <td colspan="5" align="center"> -- Assign DPI Source <img src="../../../includes/images/add.png" style="cursor:pointer; vertical-align:middle;"> --</td>
                                            </tr>
                                        </tbody>
                                         <tfoot><tr class="boldstyle bgstyle1 borderRow"><td align="right" colspan="5" style="height:2px;padding:0px;"></td></tr></tfoot>
                                   	</table>   
                                    <input type="hidden" id="DPISourceList" value="#DPISourceList#">                       
                            </td>
                        </tr>
                        
                              
					  <tr>
						<td height="10"></td>
					  </tr>
					  <tr>
						<td colspan="4" align="right" bgcolor="F5F5F5" style="padding:8px">
							<input id="saveBtn" name="submit" type="submit" class="button white" value="Save" />
							<input id="resetBtn" name="button" type="button" class="button white" onClick="window.location.href=self.location" value="Reset"/>
							<input id="closeBtn" name="button" type="button" class="button white"  value="Close" />
						</td>
					  </tr>
					</table>
				</form>
				</cfoutput>
 
			</div>
		</div> 
	<br> 
	</div>  
</body>
</html>








