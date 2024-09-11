<!---
  Suite         : EMCT
  Purpose       : Initial Creation

  Version    Developer    		Date            Remarks
  1.0.00     Yusrah         	03/12/2020     	Initial
  1.1.00     Harris         	15/03/20210     Fix SIT Bugs
  												Added EMCT Flag Checkbox
  1.2.00     Syahmi             11/09/2024      Add ownership for NAC                                
--->

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>
<head> 
<cfinclude template="../../../includes/file_access_validation.cfm" > <!--- to prevent direct access to this file by url --->
<cfinclude template="../../../includes/basic_includes.cfm" ><!---contains all the plugins/reference required for basic development ---> 
<cfinclude template="../../../includes/parameter_option_control.cfm" >  <!--- ** Optional** contain generated drop-down list such ---> 

<script language="javascript" src="trans_route_add.js"></script> <!--- Javascript file are saparated from main file ---> 
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
 <!---v1.1(START)--->
 <cfinvoke component="#component_path#.ownership" method="retrieveOwnership" dsn="#dsscmfw#" ownership_id="#ownership_id#" returnvariable="getOwnerships" ></cfinvoke> 
 <!---v1.1(END)--->

<cfquery name="getOrgInfo" datasource="#dswms#">
     SELECT org_id, org_description
     FROM frm_organizations 
     WHERE org_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#org_id#"> 
</cfquery>

<cfquery name="getVendorInfo" datasource="#dswms#">
     SELECT vendor_id, vendor_name
     FROM frm_vendors
     WHERE vendor_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#tpl_id#"> 
</cfquery>

<cfquery name="getTransRoute" datasource="#dswms#">
     SELECT
          a.route_group_header_id, a.tpl_id, a.route_group, a.org_id, DECODE(a.tier,1,'1st Tier','2nd Tier') trans_type, a.tier,
         CASE WHEN a.status = 'Y' THEN 'ACTIVE' ELSE 'INACTIVE' END header_status, b.route_group_detail_id, b.sub_route_group, 
         CASE WHEN b.status = 'Y' THEN 'ACTIVE' ELSE 'INACTIVE' END detail_status, b.status,
         c.vendor_id, c.vendor_name, d.org_description,
         CASE WHEN b.status = 'Y' THEN 1 ELSE 2 END status_flag
    FROM GEN_ROUTE_GROUP_HEADER a, GEN_ROUTE_GROUP_DETAIL b, FRM_VENDORS c, FRM_ORGANIZATIONS d
    WHERE a.route_group_header_id = b.route_group_header_id
    AND a.tpl_id = c.vendor_id
    AND a.org_id = d.org_id
    AND a.status = 'Y'
    <cfif route_group NEQ "" >
   	 	AND a.route_group = <cfqueryparam cfsqltype="cf_sql_varchar" value="#route_group#">
    </cfif>
    <cfif org_id NEQ "" >
        AND a.org_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#org_id#">
    </cfif>
    <cfif tpl_id NEQ "" >
        AND a.tpl_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#tpl_id#">
    </cfif>
    <cfif tier NEQ "" >
        AND a.tier = <cfqueryparam cfsqltype="cf_sql_integer" value="#tier#">
    </cfif>
</cfquery>

<cfquery name="getActive" dbtype="query">
    SELECT route_group_header_id, route_group_detail_id, org_id, org_description, vendor_name, route_group, trans_type,
            header_status, detail_status, route_group, sub_route_group
    FROM getTransRoute
    WHERE detail_status = 'ACTIVE' 	
</cfquery>

<cfquery name="getInactive" dbtype="query">
    SELECT route_group_header_id, route_group_detail_id, org_id, org_description, vendor_name, route_group, trans_type,
            header_status, detail_status, route_group, sub_route_group
    FROM getTransRoute
    WHERE detail_status = 'INACTIVE' 	
</cfquery>

<cfquery name="loadEdit" datasource="#dswms#">
        SELECT DISTINCT route_group_header_id, tier, route_group, emct_flag
    	FROM GEN_ROUTE_GROUP_HEADER
    	WHERE route_group = <cfqueryparam cfsqltype="cf_sql_varchar" value="#route_group#">
		<cfif org_id NEQ "" >
            AND org_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#org_id#">
        </cfif>
        <cfif tpl_id NEQ "" >
            AND tpl_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#tpl_id#">
        </cfif>
        <cfif tier NEQ "" >
            AND tier = <cfqueryparam cfsqltype="cf_sql_integer" value="#tier#">
        </cfif>
</cfquery>

<cfset header_id = "">
<cfif #getTransRoute.recordCount# NEQ 0>
    <cfset type = 'edit'>
    <cfset header_id = getTransRoute.route_group_header_id>
</cfif>

<cfif #type# EQ 'edit'>
	<cfset getRG = loadEdit.route_group>
    <cfset getTier = loadEdit.tier>
    <cfset getEMCTFlag = loadEdit.emct_flag>
    <cfset header_id = loadEdit.route_group_header_id>
<cfelse>
	<cfset getRG = "">
    <cfset getTier = "">
    <cfset getEMCTFlag = "">
</cfif>


</head>

<body background="../../../includes/images/bground1.png">  
	
	<div id="content">
		<div class="screen_header">General Master > Master Data > Transportation Route</div>  
	</div>   
	
	<br><br><br>   
	
	<div style="width:99%; margin:auto">  
    	<div id='UIPanel' > 
        	<div>
				<div style="float:left">Transportation Route</div> 
                	<div id="progressbar" class="ajaxProgressBar" style="float:right; display:none; margin-left:10px; margin-top:3px">
                	<img src="../../../includes/images/progress_green_small.gif" >
                </div>
       		</div> 
            <div>    
				<cfoutput>
                  <form id="addForm" name="addForm" method="post" action="bgprocess.cfm" > 
                        <input type="hidden" id="newRowList" name="newRowList" value=""> 
                        <input type="hidden" id="tabid" value="#tabid#" >
                        <input type="hidden" id="action_flag" name="action_flag" value="#type#" >
                        <input type="hidden" name="org_id" id="org_id" value="#getOrgInfo.org_id#" >
                        <input type="hidden" name="route_group_header_id" id="route_group_header_id" value="#header_id#" >
                        
                        
                 
                 	<table width="100%" cellpadding="4" class="formStyle" cellspacing="0" >
                         <tr><td height="5"></td></tr>
                             <tr>
                                <td align="right" width="20%">Organization : </td>
                                <td align="left" width="25%">
                                <input type="text" name="org_description" id="org_description" class="formStyleReadOnly" 
                                  value="#getOrgInfo.org_description#" size="40" readonly>
                                </td>
                                
                                <td align="right" width="20%"> Ownership :</td>
                                <td align="left" width="25%">
                                    <cfoutput>
                                        <select name="ownership_id" id="ownership_id" class="formStyle" readonly style="color: ##333; background-color: ##f5f5f5; opacity: 0.8;">                                        
                                            <cfloop query="getOwnerships">
                                                <option value="#org_id#" selected>#org_description#</option>
                                            </cfloop>
                                        </select>                           
                                    </cfoutput>
                                </td> 	                                

                            </tr>
                             <tr>

                                <td align="right" width="25%">Transporter : </td>
                                <td width="30%" align="left">
                                    <div style="float:left; width:66%; margin-top:3px;">
                                        <input type="hidden" id="tpl_id" name="tpl_id" class="formStyleReadOnly" value="#getVendorInfo.vendor_id#">
                                        <input type="text" id="tpl_name" name="tpl_name" class="formStyleReadOnly" style="width:94%"
                                        value="#getVendorInfo.vendor_name#">
                                    </div>
                                 </td>                                
                                <td align="right" width="20%">Route Group : </td>
                                <td width="25%" align="left">
                                    <input type="text" name="route_group" id="route_group" class="formStyle edit tips"
                                    edit_value="#getRG#" value="#route_group#" size="40">
                                    <input type="hidden" name="getRG" value="#getRG#">
                                </td>
                                

                             </tr>
                             <tr>
                                <td align="right" width="25%">Transporter Tier : </td>
                                <td width="30%" align="left" >
                                    <input type="text" name="tier" id="tier" class="formStyleReadOnly tips" readonly value="#tier#" size="20">
       								<input type="hidden" name="getTier" value="#getTier#">
                                </td>                                
                                <td width="20%" align="right">EMCT Flag:</td>
                                <td width="25%" align="left">
                                	<cfif getEMCTFlag EQ "N" >
                                		<input type="checkbox" id="emct_flag" name="emct_flag" class="formStyle">
                                    <cfelse>
                                		<input type="checkbox" id="emct_flag" name="emct_flag" class="formStyle" checked>
                                    </cfif>    
                                </td>
                                
                             </tr>
                             <tr>
                                <td align="right" width="25%">Status:</td>
                                <td width="30%" align="left" >
                                    <select name="group_status" id="group_status" class="formStyle tips">
                                          <option selected value="Y">ACTIVE</option>
                                          <option value="N">INACTIVE</option>
                                    </select>
                                </td>
                             </tr>
                    </table>
                        <br>
                          
                    <table class="tablestyle" id="rowPainter" align="center" width="60%" >
                        <thead>
                            <tr class="boldstyle bgstyle1">
                                <td align="left" colspan="4" height="22" style="font-style:italic;" valign="middle">
                                    <div style="float:left; font-size:11px; margin-top:3px;">Sub Group</div>  
                                    <div id='TransRouteMenu' style="visibility: show; float:right">
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
                        </thead> 
                        
                      <cfloop query="getInactive">
                            <tr class="inactive_row_style inactive_row" style="display:none;">   
                                <td align="center"><img src="../../../includes/images/inactive.png"></td> 
                                <td align="center">#sub_route_group#</td>
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
                                <input type="hidden" id="route_group_detail_id_#getRowID#" name="route_group_detail_id_#getRowID#"
                                value="#route_group_detail_id#"></td>
                                <td align="center" style="width:40%">#sub_route_group#</td>
                                <td align="center" style="width:20%">
                                   <img src="../../../includes/images/switch_on.png" id="switchBtn_#getRowID#" width="45" height="18" 
                                    class="switchBtn" style="margin-top:3px;cursor:pointer">
                                  <input type="hidden" id="status_#getRowID#" name="status_#getRowID#" value="#detail_status#">
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
    
	<div id="lookupTPLWindow" style="display:none">
         <div class="lookupHeader" style="background-image:url(../../../includes/images/lookupheader.png); ">
			 <div style="float:left">Transporter List</div>
			 <div id="lookupTPLProgress" style="float:left; margin:2px 0px 0px 5px">
             <img src="../../../includes/images/progress_green_small.gif" /></div>
		 </div>
         <div style="padding:0px;"> 
		 <iframe class="lookupFrame" id="lookupTPLContent" frameborder="0" scrolling="auto" ></iframe>
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









 
