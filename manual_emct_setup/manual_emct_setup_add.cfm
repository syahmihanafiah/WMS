<!---
  Suite         : EMCT
  Purpose       : Manual EMCT Setup

  Version    Developer    		Date            Remarks
  1.0.00     Yusrah         	     			Initial Creation
  1.1.00	 Harris				15/03/2021		Fix SIT BUGS   
  1.2.00     Syahmi             19/08/2024      Gear Up Project
--->

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>
<head> 
<cfinclude template="../../../includes/file_access_validation.cfm" > <!--- to prevent direct access to this file by url --->
<cfinclude template="../../../includes/basic_includes.cfm" ><!---contains all the plugins/reference required for basic development ---> 
<cfinclude template="../../../includes/parameter_option_control.cfm" >  <!--- ** Optional** contain generated drop-down list such ---> 

<script language="javascript" src="../manual_emct_setup/manual_emct_setup_add.js"></script> <!--- Javascript file are saparated from main file ---> 
<link rel="stylesheet" href="../../../includes/css/menu_ext.css" type="text/css" >  <!--- Include CSS style for JQX Menu (Row Painter Menu) ---> 

<style type="text/css">

	/*Define row color in row painter*/
	.active_row_style {
		background-color:#CAFFE4;
	} 
	.inactive_row_style {
		background-color:#FFD9D9;
	} 
	
	/*Style For Floating Buttons*/
	#menuContainer {
	  position: fixed;
	  right: 0;
	  bottom:11px;
	} 
</style>

<cfquery name="getOrgInfo" datasource="#dsprc#">
     SELECT org_id, org_description
     FROM frm_organizations 
     WHERE org_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#org_id#"> 
</cfquery>

<!---v(1.2-START)--->
<cfquery name="getOwnershipInfo" datasource="#dsprc#">
    SELECT org_id ownership_id, org_description ownership_name
    FROM frm_organizations
    WHERE ownership_flag = 'Y'
    AND org_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#ownership_id#">
</cfquery>
<!---v(1.2-END)--->

<cfquery name="getCategory" datasource="#dsprc#">
     SELECT DISTINCT category
     FROM EMCT_MANUAL_SETUP
     WHERE org_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#org_id#">
     <cfif category NEQ "" >
        AND category = <cfqueryparam cfsqltype="cf_sql_varchar" value="#category#">
    </cfif> 
</cfquery>

<cfquery name="getPurpose" datasource="#dsprc#">
     SELECT DISTINCT purpose
     FROM EMCT_MANUAL_SETUP
     WHERE org_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#org_id#">
     AND category = <cfqueryparam cfsqltype="cf_sql_varchar" value="#category#">
</cfquery>

<cfquery name="getEMCTSetup" datasource="#dswms#">
    SELECT
    	setup_id, org_id, category, purpose, do_number_flag, trip_flag, m3_flag, status
    FROM EMCT_MANUAL_SETUP
    WHERE org_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#org_id#">
	AND category = <cfqueryparam cfsqltype="cf_sql_varchar" value="#category#">
</cfquery>

<cfquery name="getActive" dbtype="query">
    SELECT setup_id, org_id, category, purpose, do_number_flag, trip_flag, m3_flag, status
    FROM getEMCTSetup
    WHERE status = 'Y' 	
</cfquery>

<cfquery name="getInactive" dbtype="query">
    SELECT setup_id, org_id, category, purpose, do_number_flag, trip_flag, m3_flag, status
    FROM getEMCTSetup
    WHERE status = 'N' 		
</cfquery>

<!---<cfquery name="loadEdit" dbtype="query">
        SELECT DISTINCT tier, route_group
        FROM getTransRoute
</cfquery>--->

<cfif #getEMCTSetup.recordCount# NEQ 0>
    <cfset type = 'Edit'>
<cfelse>
	<cfset type = 'Add'>
</cfif>

<!---<cfif #type# EQ 'edit'>
	<cfset getRG = loadEdit.route_group>
    <cfset getTier = loadEdit.tier>
<cfelse>
	<cfset getRG = "">
    <cfset getTier = "">
</cfif>--->


</head>

<body background="../../../includes/images/bground1.png">  
	
	<div id="content">
		<div class="screen_header">General Master > Master Data > Manual EMCT Setup</div>  
	</div>   
	
	<br><br><br>   
	<cfoutput>
	<div style="width:99%; margin:auto">  
    	<div id='UIPanel' > 
        	<div>
				<div style="float:left">Manual EMCT Setup (#type#)</div> 
                	<div id="progressbar" class="ajaxProgressBar" style="float:right; display:none; margin-left:10px; margin-top:3px">
                	<img src="../../../includes/images/progress_green_small.gif" >
                </div>
       		</div> 
            <div>    
				
                  <form id="addForm" name="addForm" method="post" action="../manual_emct_setup/bgprocess.cfm" > 
                        <input type="hidden" id="newRowList" name="newRowList" value=""> 
                        <input type="hidden" id="tabid" value="#tabid#" >
                        <input type="hidden" id="action_flag" name="action_flag" value="#type#" >
                        <input type="hidden" name="org_id" id="org_id" value="#getOrgInfo.org_id#" >
                 
                 	<table width="100%" cellpadding="4" class="formStyle" cellspacing="0" >
                         <tr><td height="5"></td></tr>
                             <tr>
                                <td align="right" width="20%">Organization : </td>
                                <td align="left" width="35%">
                                <input type="text" name="org_description" id="org_description" class="formStyleReadOnly" 
                                  value="#getOrgInfo.org_description#" size="40" readonly>
                                </td> 

                                <td align="right" width="5%" >Ownership : </td>
                                <td align="left" width="25%">
                                    <input type="hidden" id="ownership_id" name="ownership_id" value="#ownership_id#">
                                <input type="text" name="ownership" id="ownership" class="formStyleReadOnly" 
                                  value="#getOwnershipInfo.ownership_name#" size="40" readonly>
                                </td> 
                            </tr>
                             <tr>
                                <td align="right" width="20%">Category : </td>
                                <td width="35%" align="left">
                                    <div style="float:left; width:66%; margin-top:3px;">
                                        <input type="text" id="category" name="category" class="formStyleReadOnly edit" size="40"
                                        value="#category#">
                                    </div>
                                </td>
                                

                             </tr>
                    </table>
                        <br>
                          
                    <table class="tablestyle" id="rowPainter" align="center" width="60%" >
                        <thead>
                            <tr class="boldstyle bgstyle1">
                                <td align="left" colspan="6" height="22" style="font-style:italic;" valign="middle">
                                    <div style="float:left; font-size:11px; margin-top:3px;">Purpose Setup</div>  
                                    <div id='EMCTSetupMenu' style="visibility: show; float:right">
                                        <ul> 
                                            <li><img src="../../../includes/images/gear.png" >
                                                <ul> 
                                                    <cfif #getInactive.recordCount# NEQ 0>
                                                        <li id="showhistoryBtn">View History</li>  
                                                        <li id="hidehistoryBtn" style="display:none">Hide History</li>
                                                    </cfif>
                                                    <li id="addBtn" class="addBtn">Add New</li>  
                                                    <li id="removeBtn" class="removeBtn" style="display:none">Remove Selected</li>
                                                </ul>
                                            </li>
                                        </ul>
                                    </div> 
                                </td>
                            </tr>
                            <tr class="boldstyle bgstyle1">
                            	<td align="center"></td> 
                                <td align="center" height="22" style="font-style:normal;">
                                	<div style="font-size:11px; margin-top:3px;">Purpose</div>
                                </td>
                                <td align="center" height="22" style="font-style:normal;">
                                	<div style="font-size:11px; margin-top:3px;">DO Number</div>
                                </td>
                                <td align="center" height="22" style="font-style:normal;">
                                	<div style="font-size:11px; margin-top:3px;">Trip</div>
                                </td>
                                <td align="center" height="22" style="font-style:normal;">
                                	<div style="font-size:11px; margin-top:3px;">M3</div>
                                </td>
                                <td align="center" height="22" style="font-style:normal;">
                                	<div style="font-size:11px; margin-top:3px;">Status</div>
                                </td>
                            </tr>
                        </thead> 
                        
                      <cfloop query="getInactive">
                            <tr class="inactive_row_style inactive_row" style="display:none;">   
                                <td align="center"><img src="../../../includes/images/inactive.png"></td> 
                                <td align="center">#purpose#</td>
                                <td align="center">#do_number_flag#</td>
                                <td align="center">#trip_flag#</td>
                                <td align="center">#m3_flag#</td>
                                <td align="center">
                                    <img src="../../../includes/images/switch_red.png" width="45" height="18" 
                                     style="margin-top:3px;cursor:pointer">
                                </td>
                             </tr>  
                        </cfloop>
                        
                   <cfset getRowID = 0>
                   <cfloop query="getActive">
                            <cfset getRowID = getRowID + 1>
                            <tr class="active_row_style active_row" id="RowID_#getRowID#"> 
                                <td align="center" style="width:10%"><img src="../../../includes/images/active.png" id="flag_#getRowID#">
                                <input type="hidden" id="setup_id_#getRowID#" name="setup_id_#getRowID#" value="#setup_id#">
                                <input type="hidden" id="purpose_#getRowID#" name="purpose_#getRowID#" value="#purpose#">
                                </td>
                                <td align="center" style="width:30%">
                                	#purpose#
                                </td>
                               <!-- <td align="center" style="width:15%">
                                	<select name="do_number_flag_#getRowID#" id="do_number_flag_#getRowID#" class="formStyle tips">
                                       <option value="#do_number_flag#">#do_number_flag#</option>
                                       <option value="Y">Y</option>
                                       <option value="N">N</option>
                                    </select>
                                </td>-->
                                 <td align="center" style="width:15%">
                                	<input type="text" id="do_number_flag_#getRowID#" name="do_number_flag_#getRowID#" value="#do_number_flag#" size="5"
                                    class="formStyleReadOnly" style="text-align:center;">
                                </td>
                                <td align="center" style="width:15%">
                                	<input type="text" id="trip_flag_#getRowID#" name="trip_flag_#getRowID#" value="#trip_flag#" size="5"
                                    class="formStyleReadOnly" style="text-align:center;">
                                </td>
                                <td align="center" style="width:15%">
                                    <input type="text" id="m3_flag_#getRowID#" name="m3_flag_#getRowID#" value="#m3_flag#" size="5"
                                    class="formStyleReadOnly" style="text-align:center;">
                                </td>
                                <td align="center" style="width:20%">
                                   <img src="../../../includes/images/switch_on.png" id="switchBtn_#getRowID#" width="45" height="18" 
                                    class="switchBtn" style="margin-top:3px;cursor:pointer">
                                  <input type="hidden" id="status_#getRowID#" name="status_#getRowID#" value="#status#">
                                </td>
                            </tr>  
                        </cfloop>
                        <tbody></tbody>  
                        <input type="hidden" id="totalRows" name="totalRows" value="#getRowID#">
                    </table>
                    <br>
                    <table width="100%"><tr style="padding-top:10px"><td align="right" bgcolor="F5F5F5" style="padding:8px"></td></tr></table> 
                      </form>
                  </cfoutput>    
              </div> 
          </div>              
	</div>    
    
     <br><br><br>
    <!---Floating Buttons Containers *Must Include style as shown above*--->
    <div id="menuContainer" style="width:100%;text-align:center" >
    	<div style="display: inline-block;"> 
        	 <!---Add and Delete floating button are optional, only use when there are more rows to fit the screen--->
            <img src="../../../includes/images/add_round_dimmed.png" class="addBtn" id="addFloatBtn" style="cursor:pointer;" title="Add" >  
            <img src="../../../includes/images/dustbin_dimmed.png" class="removeBtn" id="removeFloatBtn" style="cursor:pointer;display:none;" title="Remove" > 
            
            <img src="../../../includes/images/save_dimmed.png" id="saveBtn" style="cursor:pointer;margin-left:-2px" title="Save" >   
            <img src="../../../includes/images/reset_dimmed.png" id="resetBtn" style="cursor:pointer;margin-left:-2px" title="Reset" >
            <img src="../../../includes/images/close_round_dimmed.png" id="closeBtn" style="cursor:pointer;margin-left:-2px" title="Close" >
        </div>
    </div> 
	  
</body> 
</html>









 
