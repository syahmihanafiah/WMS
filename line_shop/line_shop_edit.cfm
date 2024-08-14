<!---
  Suite         : DSI - Demand Supply Information
  Purpose       : New D55L - DPI3 Implementation
  
  Version    Developer    		Date            Remarks
  2.0.00     Harris        		20/4/2020     	Add DPI Source Data
  2.0.01     Nawawi        		03/02/2021     	Add Model Adjust Flag
  3.0.00     Syahmi        		13/08/2024     	Add Ownership for Gear Up
--->

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>
<head>

<cfinclude template="../../../includes/file_access_validation.cfm" > 
<cfinclude template="../../../includes/basic_includes.cfm" >
<script language="javascript" src="line_shop_edit.js"></script>
<link rel="stylesheet" href="../../../includes/css/menu_ext.css" type="text/css" >  <!--- Include CSS style for JQX Menu (Row Painter Menu) ---> 

 
<style>
.addBtn:hover {
 background-color: #f5f5f5;
 }
.active_row_style {
	background-color:#CAFFE4;
} 
.inactive_row_style {
	background-color:#FFD9D9;
} 
.lock_row_style {
	background-color:#FFD9D9;
}  
.future_row_style {
	background-color:#A8D3FF;
} 
</style>

</head> 
  
<cfquery name="getLineShop" datasource="#dswms#"> 
	 SELECT a.line_shop, b.shop_name, a.org_id, a.jit_flag, a.ratio_flag,      
            (SELECT DISTINCT org_nick_name FROM
            frm_organizations WHERE
            org_id = a.volume_source_org_id) AS volume_source,                                
	 		to_char(a.active_date,'dd/mm/yyyy') active_date, to_char(a.inactive_date,'dd/mm/yyyy') inactive_date, c.org_description ownership_name
	 FROM gen_line_shop a, gen_shop b , frm_ownership c
	 WHERE a.shop_id = b.shop_id 
     AND a.ownership_id = c.ownership_id
	 AND a.line_shop_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#line_shop_id#"> 
</cfquery>

<cfquery name="getSourceList" datasource="#dswms#">
  SELECT config_value
    FROM gen_dpi_config
    WHERE config_type = <cfqueryparam  cfsqltype="cf_sql_varchar" value="DPI_SOURCE" >
        AND active_date <= sysdate
        AND NVL(inactive_date,sysdate+1) > sysdate

</cfquery>

<cfset DPISourceList = ValueList(getSourceList.config_value) >

<cfquery name="getDPISource" datasource="#dswms#">
	SELECT 
        dpi_source_id, dpi_source, 
        to_char(start_do_date,'dd/mm/yyyy') start_do_date, 
        to_char(end_do_date,'dd/mm/yyyy') end_do_date,
        to_char(start_do_date,'mm/dd/yyyy') jqx_start_do_date, 
        to_char(end_do_date,'mm/dd/yyyy') jqx_end_do_date,
        CASE
            WHEN start_do_date <= sysdate and NVL(end_do_date,sysdate+1) > sysdate THEN 'ACTIVE'
            WHEN start_do_date > sysdate and NVL(end_do_date,sysdate+1) <> start_do_date THEN 'FUTURE'
            ELSE 'INACTIVE'
       END status  
    FROM GEN_DPI_SOURCE
    WHERE LINE_SHOP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#line_shop_id#"> 
</cfquery>

<cfquery name="getInactiveDPI" dbtype="query">
	SELECT * FROM getDPISource WHERE status = 'INACTIVE'
</cfquery>

<cfquery name="getActiveDPI" dbtype="query">
	SELECT * FROM getDPISource WHERE status = 'ACTIVE'
</cfquery>

<cfquery name="getFutureDPI" dbtype="query">
	SELECT * FROM getDPISource WHERE status = 'FUTURE'
</cfquery>

<cfinvoke component="#component_path#.organization_decoder" method="decodeOrganizationsID" dsn="#dswms#" returnvariable="OrgArr" ></cfinvoke>
 
<body background="../../../includes/images/bground1.png"> 
	<div id="content">
		<div class="screen_header">General Master > Master Data > Line Shop Master > Edit</div>  
	</div>  
	<br><br><br>  
	<div id='jqxWidget' style="width:99%; margin:auto"> 
		<div id='jqxExpander'>
            <div>
				<div style="float:left">Edit line shop</div> 
				<div id="progressbar" style="float:right; display:none; margin-left:10px; margin-top:3px"><img src="../../../includes/images/progress_green_small.gif" ></div>
			</div>  
		 
            <div> 
				<cfoutput> 
				<form name="editForm" id="editForm" action="bgprocess.cfm" method="post">  
					<input type="hidden" name="action_flag" value="edit" >  
					<input type="hidden" name="line_shop_id" value="#line_shop_id#" >
                    <!---<input type="hidden" id="tabid" value="#tabid#" >--->
					<table width="100%" cellpadding="4" class="formStyle" cellspacing="0">
					  <tr>
						<td height="5"></td>
					  </tr>
					  <tr>
						<td align="right" width="20%">Organization : </td>
						<td align="left" width="25%">
                        <input type="text" class="formStyleReadOnly" readonly size="40" value="#decodeOrgID(OrgArr,getLineShop.org_id)#">
                        </td>
                        <!---ADDED BY SYAHMI(START)--->
                        <td align="right">Ownership:</td>
                        <td align="left">
                            <input type="text" class="formStyleReadOnly" readonly size="40" value="#getLineShop.ownership_name#" disable>                                
                        </td>
                        <!---ADDED BY SYAHMI(END)--->                        

					  </tr> 
					  <tr>
						<td align="right" width="20%">Line Shop : </td>
						<td align="left" width="25%">
                         <input type="text" name="line_shop" class="formStyleReadOnly" readonly size="20" value="#getLineShop.line_shop#">
                        </td> 
						<td align="right" width="25%">Volume Source : </td>
                        
						<td align="left" width="30%" >
                        <input type="text" name="volume_source" class="formStyleReadOnly" readonly size="20" value="#getLineShop.volume_source#">
                        </td>
					  </tr>
					  <tr>
						<td align="right">Active Date : </td>
						<td align="right">
							<div align="left">
						<!---		<div id='active_date_picker'></div>--->
								<input type="text" name="active_date" id="active_date" class="formStyleReadOnly" readonly size="20" value="#getLineShop.active_date#">
							</div>
						</td>
						<td align="right">Inactive Date : </td>
						<td align="right">
							<div align="left">
								<div id='inactive_date_picker'></div>
								<input type="hidden" name="inactive_date" id="inactive_date" class="formStyle" size="20" value="#getLineShop.inactive_date#">
                                <input type="hidden" id="get_ID"  value="#getLineShop.inactive_date#">
							</div>
						</td>
                        <tr>
                      	    <!---PLANE PMSB PROJECT--->
                      	    <td align="right">JIT Flag: </td>
                      	    <td align="left">
                                <input type="text" class="formStyleReadOnly" readonly size="10" value="#getLineShop.jit_flag#" disable>
                            </td>
                            <td align="right" width="25%"> Shop : </td>
                            <td align="left" width="30%" >
                            <input type="text" name="shop_name" class="formStyleReadOnly" readonly size="20" value="#getLineShop.shop_name#">
                            </td>                            

                      	</tr> 
                        <tr>
                      	<!---EMCT Ratio--->
                      	<td align="right">Ratio Flag: </td>
                      	<td align="left">
                        <cfif getLineShop.ratio_flag EQ "Y">
                            <input type="checkbox" name="ratio_flag" id="ratio_flag" value="Y" checked> 
                        <cfelse>
                            <input type="checkbox" name="ratio_flag" id="ratio_flag" value="Y"> 
                        </cfif> 
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
                                                                	<cfif getInactiveDPI.recordCount NEQ 0 >
                                                                        <li id="showhistoryBtn">View History </li>  
                                                                        <li id="hidehistoryBtn" style="display:none">Hide History </li> 
                                                                    </cfif>  
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
                                        	<!--- INACTIVE ROWS --->
                                            <cfloop query="getInactiveDPI" > 
                                                <tr class="inactive_row_style inactive_row" style="display:none">  
                                                    <td width="5%" align="center"><input type="checkbox" class="formStyle" disabled></td>
                                                    <td width="5%" align="center"><img src="../../../includes/images/inactive.png"></td>
                                                    <td width="30%" align="center" >#dpi_source#</td>  
                                                    <td width="30%" align="center" >#start_do_date#</td> 
                                                    <td width="30%" align="center" >#end_do_date#</td> 
                                                </tr>  
                                            </cfloop>    
                                            
                                            <!--- ACTIVE ROWS --->
                                             <cfset actRowID = 0 >
                                            <cfloop query="getActiveDPI" > 
                                            	<cfset actRowID = actRowID + 1 >
                                                <tr class="active_row_style active_row">  
                                                	<input type="hidden" name="dpi_source_id_#actRowID#" id="dpi_source_id_#actRowID#"  value="#dpi_source_id#">
                                                    <td width="5%" align="center"><input type="checkbox" class="formStyle" disabled></td>
                                                    <td width="5%" align="center"><img src="../../../includes/images/active.png"></td>
                                                    <td width="30%" align="center" >
                                                    	<input type="hidden" name="act_dpi_source_#actRowID#" id="act_dpi_source_#actRowID#"  value="#dpi_source#">
                                                    	#dpi_source#
                                                    </td>  
                                                    <td width="30%" align="center" >
                                                    	<input type="hidden" name="act_do_start_date_#actRowID#" id="act_do_start_date_#actRowID#" currID="#actRowID#" currDate="#jqx_start_do_date#" value="#start_do_date#">
                                                    	#start_do_date#
                                                    </td> 
                                                    <td width="30%" align="center" >
                                                    	<div id="act_do_end_date_#actRowID#" name="act_do_end_date_#actRowID#" currDate="#jqx_end_do_date#" currID="#actRowID#" class="act_date_picker tips end_date"></div>
                                                    </td>
                                                </tr>  
                                            </cfloop> 
                                            
                                            <!--- FUTURE ROWS --->
                                            <cfloop query="getFutureDPI" > 
                                            	<cfset actRowID = actRowID + 1 >
                                                <tr class="future_row_style active_row">  
                                               		<input type="hidden" name="dpi_source_id_#actRowID#" id="dpi_source_id_#actRowID#"  value="#dpi_source_id#">
                                                    <td width="5%" align="center"><input type="checkbox" class="formStyle" disabled></td>
                                                    <td width="5%" align="center"><img src="../../../includes/images/blue_status.png"></td>
                                                    <td width="30%" align="center" >
                                                    	<select  name="act_dpi_source_#actRowID#" id="act_dpi_source_#actRowID#"  class="formStyle tips" >
                                                        	<option value=""> -- Please Select --</option>
                                                            <cfloop query="getSourceList">
                                                            	<cfif #getFutureDPI.dpi_source# EQ #getSourceList.config_value#>
                                                            		<option value="#getSourceList.config_value#" selected>#getSourceList.config_value#</option> 
                                                                <cfelse>
                                                                	<option value="#getSourceList.config_value#">#getSourceList.config_value#</option>     
                                                                </cfif>
                                                            </cfloop>
                                                        </select>
                                                    </td>  
                                                    <td width="30%" align="center" >
                                                    	<div id="act_do_start_date_#actRowID#" name="act_do_start_date_#actRowID#" currDate="#jqx_start_do_date#" currID="#actRowID#" class="act_date_picker future_date tips"></div>
                                                    </td> 
                                                    <td width="30%" align="center" >
                                                    	<div id="act_do_end_date_#actRowID#" name="act_do_end_date_#actRowID#" currDate="#jqx_end_do_date#" currID="#actRowID#" class="act_date_picker future_date tips"></div>
                                                    </td>
                                                </tr>  
                                            </cfloop> 
                                        	<tr class="smallfont boldstyle noRow addBtn" style="cursor:pointer;" >  
                                                <td colspan="5" align="center"> -- Assign DPI Source <img src="../../../includes/images/add.png" style="cursor:pointer; vertical-align:middle;"> --</td>
                                            </tr>
                                        </tbody>
                                        <tfoot><tr class="boldstyle bgstyle1 borderRow"><td align="right" colspan="5" style="height:2px;padding:0px;"></td></tr></tfoot>
                                   	</table> 
                                    <input type="hidden" id="actRowID" name="actRowID" value="#actRowID#">    
                                    <input type="hidden" id="DPISourceList" value="#DPISourceList#">                       
                            </td>
                        </tr>
                        
                        
					  <tr>
						<td height="10"></td>
					  </tr>
					  <tr>
						<td colspan="4" align="right" bgcolor="F5F5F5" style="padding:8px">
							<input id="updateBtn" name="submit" type="submit" class="button white" value="Update" />
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








