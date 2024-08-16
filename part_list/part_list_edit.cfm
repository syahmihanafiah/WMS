<!---
  Version    Developer    		Date            Remarks
  -------	 ---------------	----------		----------------------------------
  1.0.0.1    Nawawi Nasrudin 	18/08/2013      Add remark maintenance for Change Order 2022/17184
--->
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html><head> 
<cfinclude template="../../../includes/file_access_validation.cfm" > 
<cfinclude template="../../../includes/basic_includes.cfm" >
<script type="text/javascript" src="part_list_edit.js"></script> 
<link rel="stylesheet" href="../../../includes/css/menu_ext.css" type="text/css" >  
<style type="text/css">
.active_row_style {
	background-color:#CAFFE4;
} 
.inactive_row_style {
	background-color:#FFD9D9;
} 
.new_row_style {
	background-color:#FFFFFB;
} 


/*-------------------------------------- LSP Inventory Project  --------------------------------- */ 

    .blink {
        animation: blinker 0.2s step-start infinite;
    }

    @keyframes blinker {
        50% {
            opacity: 0.5; 
        }
    }
 
 
    .vendor_header {
        padding-top:5px !important;
        border-top:none;
        border-right:none; 
        border-left:none; 
        border-radius: 10px 10px 0px 0px; 
        border-bottom:none !important;
        color:#FFF; 
        font-weight:bold;
        font-size:11px;
        background-image:url('../../../includes/images/blue_stripes.png');
    }

    .tier1_header {
        padding-top:5px !important;
        border-top:none;
        border-right:none; 
        border-left:none;
        border-radius: 10px 10px 0px 0px; 
        border-bottom:none !important;
        color:#FFF; 
        font-weight:bold;
        font-size:11px;
        background-image:url('../../../includes/images/orange_stripes.png');
    }
 
    .warehouse_header {
        padding-top:5px !important;
        border-top:none;
        border-right:none; 
        border-left:none;
        border-radius: 10px 10px 0px 0px; 
        border-bottom:none !important;
        color:#FFF; 
        font-weight:bold;
        font-size:11px;
        background-image:url('../../../includes/images/green_stripe.png');
    }

    .warehouse_content { 
        border-radius:  0px 0px 10px 10px;  
        color:#000; 
        font-weight:bold;
        background-image: linear-gradient(to top, #Ccf8e2,white);
    }
    
    .bottom_panel {  
        padding:0px !important;
        height:2px;
        background-image:url('../../../includes/images/dark_stripe.png');
    }
 
    .vendor_name_bg {
        background-color:#000; 
        border-top:none !important; 
        color:#FFF; 
        font-weight:bold; 
        font-size:11px; 
        background-image:url('../../../includes/images/dark_stripe.png');
    }

    .setting_blue_bg { 
        height:17px;
        font-size:11px;
        background-image: linear-gradient(to top, #e6f2ff,white);
    }

    .setting_orange_bg { 
        height:17px;
        font-size:11px;
        background-image: linear-gradient(to top, #fffae6,white);
    }
</style> 


<link rel="stylesheet" type="text/css" href="../../../includes/plugins_3.0/fontawesome_6.2.0/css/all.min.css"/>
 
<cfquery name="getPartListHeaders" datasource="#dswms#" >
	SELECT a.org_id, c.org_description, a.part_number, a.part_number, a.part_name, a.back_number, a.vendor_id , a.color color_code, b.vendor_name,
    to_char(a.active_date,'dd/mm/yyyy') active_date, to_char(a.inactive_date,'dd/mm/yyyy') inactive_date,
    GEN_GET_PART_MODEL(4,a.org_id,a.part_number,sysdate, sysdate) model_info, d.remark_code, d.remark_description ,
    <!---ADDED BY SYAHMI HANAFIAH (START)--->
     e.org_description ownership_name
    <!---ADDED BY SYAHMI HANAFIAH (END)--->
    FROM gen_part_list_headers a, frm_vendors b, frm_organizations c, lsp_remark d, frm_organizations e
    WHERE a.vendor_id = b.vendor_id 
    AND a.org_id = c.org_id
    AND a.remark_id = d.remark_id (+)
    <!---ADDED BY SYAHMI HANAFIAH (START)--->
    AND a.ownership_id = e.org_id
    AND c.ownership_flag = 'Y'
    <!---ADDED BY SYAHMI HANAFIAH (ENDED)--->
	AND a.part_list_header_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#part_list_header_id#">
</cfquery>

<cfquery name="getBackNoHistory" datasource="#dswms#" >
	SELECT back_number, CASE WHEN status = 'Y' THEN 'ACTIVE' ELSE 'INACTIVE' END status, 
           to_char(creation_date,'dd/mm/yyyy hh24:mi:ss') creation_date, creation_by,
           to_char(last_updated_date,'dd/mm/yyyy hh24:mi:ss') last_updated_date, last_updated_by
    FROM gen_part_list_back_number
    WHERE part_list_header_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#part_list_header_id#">
    ORDER BY creation_date DESC
</cfquery>

<!--- build selection list ----------------------------------------------------------------------------------------------------------------------------------->

<!---<cfquery name="getBox" datasource="#dswms#" >
	SELECT box_id, box_code
    FROM gen_box 
	WHERE org_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#getPartListHeaders.org_id#">
	AND active_date != NVL(inactive_date, active_date+1) AND active_date <= sysdate AND NVL(inactive_date, sysdate+1) > sysdate 
	ORDER BY box_code  
</cfquery>

<cfquery name="getOrderType" datasource="#dswms#" >
	SELECT order_type_id, order_type
    FROM lsp_order_type a
	WHERE org_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#getPartListHeaders.org_id#">
	AND active_date != NVL(inactive_date, active_date+1) AND active_date <= sysdate AND NVL(inactive_date, sysdate+1) > sysdate 
	ORDER BY order_type
</cfquery>
<cfset order_type_id_list = valueList(getOrderType.order_type_id) >
<cfset order_type_list = valueList(getOrderType.order_type) >

<cfquery name="getVendorCategory" datasource="#dswms#" >
	SELECT vendor_category_id, vendor_category
    FROM gen_vendor_category a
	WHERE org_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#getPartListHeaders.org_id#"> 
	AND active_date != NVL(inactive_date, active_date+1) AND active_date <= sysdate AND NVL(inactive_date, sysdate+1) > sysdate  
	ORDER BY vendor_category 
</cfquery>
<cfset vendor_category_id_list = valueList(getVendorCategory.vendor_category_id) >
<cfset vendor_category_list = valueList(getVendorCategory.vendor_category) >

 
<cfquery name="getDock" datasource="#dswms#" > 
    SELECT  a.dock_id, a.dock_code
    FROM lsp_dock a, gen_line_shop b
    WHERE a.line_shop_id = b.line_shop_id
    AND a.org_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#getPartListHeaders.org_id#">
    AND a.active_date != NVL(a.inactive_date, a.active_date+1) AND a.active_date <= sysdate AND NVL(a.inactive_date, sysdate+1) > sysdate 
    AND b.active_date != NVL(b.inactive_date, b.active_date+1) AND b.active_date <= sysdate AND NVL(b.inactive_date, sysdate+1) > sysdate 
    ORDER BY a.dock_code 
</cfquery> 
<cfset dock_id_list = valueList(getDock.dock_id) >
<cfset dock_list = valueList(getDock.dock_code) >
 
<cfquery name="getDeliveryCategory" datasource="#dswms#" >
	SELECT a.vendor_setting_header_id, b.vendor_setting_detail_id, a.delivery_category 
	FROM gen_vendor_setting_headers a,  gen_vendor_setting_details b
	WHERE a.org_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#getPartListHeaders.org_id#">
	AND a.vendor_setting_header_id = b.vendor_setting_header_id
	AND a.active_date != NVL(a.inactive_date, a.active_date+1) AND a.active_date <= sysdate AND NVL(a.inactive_date, sysdate+1) > sysdate 
	AND b.active_date != NVL(b.inactive_date, b.active_date+1) AND b.active_date <= sysdate AND NVL(b.inactive_date, sysdate+1) > sysdate 
	AND a.vendor_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#getPartListHeaders.vendor_id#">
	AND b.attr1 IS NULL
	ORDER BY a.delivery_category
</cfquery>
<cfset delivery_category_list = valueList(getDeliveryCategory.delivery_category) > 
<cfset vendor_setting_detail_id_list = valueList(getDeliveryCategory.vendor_setting_detail_id) > --->
 
<!----- get Delivery Info data ------------------------------------------------------------------------------------------------------------------------------->
<!---
<cfquery name="getTPL1" datasource="#dswms#" >
    SELECT a.part_list_tpl_id, b.vendor_name tpl_name, a.delivery_category, c.delivery_category_desc,
            to_char(a.active_date,'dd/mm/yyyy') active_date, to_char(a.inactive_date,'dd/mm/yyyy') inactive_date,
            CASE WHEN a.active_date = a.inactive_date THEN 'INACTIVE'
                 WHEN a.active_date <= sysdate AND NVL(a.inactive_date,sysdate+1) > sysdate THEN 'ACTIVE' 
                 WHEN a.active_date > sysdate AND NVL(a.inactive_date,sysdate+1) > sysdate THEN 'FUTURE' 
            ELSE 'INACTIVE' END status, 
            CASE WHEN a.active_date = a.inactive_date THEN 0
                 WHEN a.active_date <= sysdate AND NVL(a.inactive_date,sysdate+1) > sysdate THEN 1 
                 WHEN a.active_date > sysdate AND NVL(a.inactive_date,sysdate+1) > sysdate THEN 2
            ELSE 0 END status_flag 
    FROM gen_part_list_tpl a, frm_vendors b, gen_vendor_setting_headers c
    WHERE a.tpl_id = b.vendor_id
    AND part_list_header_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#part_list_header_id#">
    AND a.tpl_id = c.vendor_id (+)
    AND a.delivery_category = c.delivery_category (+)
    AND c.org_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#getPartListHeaders.org_id#">
    ORDER BY status_flag, part_list_tpl_id ASC
</cfquery>


 <cfquery name="getTPL2" datasource="#dswms#" >
    SELECT a.part_list_tpl_tier_id, b.vendor_name tpl_name, a.delivery_category, c.delivery_category_desc,
            to_char(a.active_date,'dd/mm/yyyy') active_date, to_char(a.inactive_date,'dd/mm/yyyy') inactive_date,
            CASE WHEN a.active_date = a.inactive_date THEN 'INACTIVE'
                 WHEN a.active_date <= sysdate AND NVL(a.inactive_date,sysdate+1) > sysdate THEN 'ACTIVE' 
                 WHEN a.active_date > sysdate AND NVL(a.inactive_date,sysdate+1) > sysdate THEN 'FUTURE' 
            ELSE 'INACTIVE' END status, 
            CASE WHEN a.active_date = a.inactive_date THEN 0
                 WHEN a.active_date <= sysdate AND NVL(a.inactive_date,sysdate+1) > sysdate THEN 1 
                 WHEN a.active_date > sysdate AND NVL(a.inactive_date,sysdate+1) > sysdate THEN 2
            ELSE 0 END status_flag 
    FROM gen_part_list_tpl_tier a, frm_vendors b, gen_vendor_setting_headers c
    WHERE a.tpl_id = b.vendor_id
    AND part_list_header_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#part_list_header_id#">
    AND a.tpl_id = c.vendor_id (+)
    AND a.delivery_category = c.delivery_category (+)
    AND c.org_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#getPartListHeaders.org_id#">
    ORDER BY status_flag, part_list_tpl_tier_id ASC
</cfquery>
--->
<!--- build selection list ----------------------------------------------------------------------------------------------------------------------------------->

<cfquery name="getBox" datasource="#dswms#" >
	SELECT box_id, box_code
    FROM gen_box a
	WHERE org_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#getPartListHeaders.org_id#">
	AND a.active_date != NVL(a.inactive_date, a.active_date+1) AND a.active_date <= sysdate AND NVL(a.inactive_date, sysdate+1) > sysdate 
	ORDER BY box_code  
</cfquery>

<cfquery name="getOrderType" datasource="#dswms#" >
	SELECT order_type_id, order_type
    FROM lsp_order_type a
	WHERE org_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#getPartListHeaders.org_id#">
	AND a.active_date != NVL(a.inactive_date, a.active_date+1) AND a.active_date <= sysdate AND NVL(a.inactive_date, sysdate+1) > sysdate 
	ORDER BY order_type
</cfquery>
<cfset order_type_id_list = valueList(getOrderType.order_type_id) >
<cfset order_type_list = valueList(getOrderType.order_type) >

<cfquery name="getVendorCategory" datasource="#dswms#" >
	SELECT vendor_category_id, vendor_category
    FROM gen_vendor_category a
	WHERE org_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#getPartListHeaders.org_id#"> 
	AND a.active_date != NVL(a.inactive_date, a.active_date+1) AND a.active_date <= sysdate AND NVL(a.inactive_date, sysdate+1) > sysdate 
	ORDER BY vendor_category 
</cfquery>
<cfset vendor_category_id_list = valueList(getVendorCategory.vendor_category_id) >
<cfset vendor_category_list = valueList(getVendorCategory.vendor_category) >

<cfquery name="getDock" datasource="#dswms#" > 
    SELECT  a.dock_id, a.dock_code || '(' || b.line_shop || ')' dock_code
    FROM lsp_dock a, gen_line_shop b
    WHERE a.line_shop_id = b.line_shop_id
    AND a.org_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#getPartListHeaders.org_id#">
    AND a.active_date != NVL(a.inactive_date, a.active_date+1) AND a.active_date <= sysdate AND NVL(a.inactive_date, sysdate+1) > sysdate 
    AND b.active_date != NVL(b.inactive_date, b.active_date+1) AND b.active_date <= sysdate AND NVL(b.inactive_date, sysdate+1) > sysdate 
    ORDER BY a.dock_code 
</cfquery> 
<cfset dock_id_list = valueList(getDock.dock_id) >
<cfset dock_list = valueList(getDock.dock_code) >
 
<cfquery name="getDeliveryCategory" datasource="#dswms#" >
	SELECT a.vendor_setting_header_id, b.vendor_setting_detail_id, a.delivery_category 
	FROM gen_vendor_setting_headers a,  gen_vendor_setting_details b
	WHERE a.org_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#getPartListHeaders.org_id#">
	AND a.vendor_setting_header_id = b.vendor_setting_header_id
	AND a.active_date != NVL(a.inactive_date, a.active_date+1) AND a.active_date <= sysdate AND NVL(a.inactive_date, sysdate+1) > sysdate 
	AND b.active_date != NVL(b.inactive_date, b.active_date+1) AND b.active_date <= sysdate AND NVL(b.inactive_date, sysdate+1) > sysdate 
	AND a.vendor_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#getPartListHeaders.vendor_id#">
	AND b.attr1 IS NULL
	ORDER BY a.delivery_category
</cfquery>

<cfquery name="getRemark" datasource="#dswms#" >
	SELECT remark_id, remark_code, remark_description
	FROM lsp_remark a
	WHERE a.org_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#getPartListHeaders.org_id#">	
	ORDER BY remark_id
</cfquery>

<cfset delivery_category_list = valueList(getDeliveryCategory.delivery_category) > 
<cfset vendor_setting_detail_id_list = valueList(getDeliveryCategory.vendor_setting_detail_id) >  
 
<script type="text/javascript"> 
	var order_type_id_list = '<cfoutput>#order_type_id_list#</cfoutput>';
	var order_type_list = '<cfoutput>#order_type_list#</cfoutput>';  
	
	var vendor_category_id_list = '<cfoutput>#vendor_category_id_list#</cfoutput>';
	var vendor_category_list = '<cfoutput>#vendor_category_list#</cfoutput>';  
	
	var dock_id_list = '<cfoutput>#dock_id_list#</cfoutput>';
	var dock_list = '<cfoutput>#dock_list#</cfoutput>'; 
	
</script>

</head>
 
<body background="../../../includes/images/bground1.png">
	<div id="content">
		<div class="screen_header">General Master > Master Data > Part List > Add</div>  
	</div> 
    <br><br><br>
    
		<cfoutput>   
        <div style="width:99%; margin:auto">
            <div id='UIPanel'>
            <div>
                <div style="float:left">Edit Part</div> 
                <div id="progressbar" class="ajaxProgressBar" style="float:right; display:none; margin-left:10px; margin-top:3px">
                    <img src="../../../includes/images/progress_green_small.gif" ></div>
                </div>
                <div>  
              
              
              	<form name="editForm" id="editForm" action="bgprocess.cfm" method="post"> 
					<input type="hidden" id="part_list_header_id" name="part_list_header_id" value="#part_list_header_id#" >
					<input type="hidden" name="action_flag" value="update" >  
                    <input type="hidden" name="deliveryInfoRowID" id="deliveryInfoRowID" >
                    <input type="hidden" id="tabid" value="#tabid#" >
                    <input type="hidden" name="org_id" value="#getPartListHeaders.org_id#" >
				    <table width="100%" cellpadding="4" class="formStyle" cellspacing="0">
                    	<tr>
                        	<td height="5"></td>
                      	</tr>
                      	<tr>
                       	 	<td align="right" width="20%">Organization : </td>
                        	<td align="left" width="25%">
								<input type="hidden" name="	" id="org_id" value="#getPartListHeaders.org_id#">
                            	<input type="text" class="formStyleReadOnly" readonly size="40" value="#getPartListHeaders.org_description#">
                        	</td>                                      
                            <td align="right" width="20%">Ownership :</td>
                            <td align="left" width="25%"><input type="text" class="formStyleReadOnly" readonly size="40" value="#getPartListHeaders.ownership_name#"</td>
						</tr> 
						<tr>
                        	<td align="right" width="20%">Part Number : </td>
                        	<td align="left" width="25%"> 
                            		<input type="text" id="part_number" name="part_number" class="formStyleReadOnly" readonly size="20" 
                                    value="#getPartListHeaders.part_number#" >
							</td>
							<td align="right" width="25%">Part Name : </td>
                        	<td align="left" width="30%"> 
                            		<input type="text" id="part_name" name="part_name" class="formStyleReadOnly" readonly size="50" 
                                    value="#getPartListHeaders.part_name#" >
							</td>
                      	</tr>
						<tr>
                        	<td align="right">Vendor : </td>
                        	<td align="left"> 
									<input type="hidden" id="vendor_id" name="vendor_id" class="formStyleReadOnly" readonly size="50" 
                                    value="#getPartListHeaders.vendor_id#" >
                            		<input type="text" id="vendor_name" name="vendor_name" class="formStyleReadOnly" readonly size="50" 
                                    value="#getPartListHeaders.vendor_name#" >
							</td>
							<td align="right">Color : </td>
                        	<td align="left"> 
                            		<input type="text" id="color_code" name="color_code" class="formStyleReadOnly" readonly size="20" 
                                    value="#getPartListHeaders.color_code#" >
							</td>
                      	</tr>
						
						<tr>
                        	<td align="right">Back No : </td>
                        	<td align="left"> 
                            	<div style="float:left">
                                	<input type="text" id="back_no" name="back_no" class="formStyleReadOnly" style="height:18px" readonly size="14" 
                                    value="#getPartListHeaders.back_number#" onKeyUp="uppercaseInput(this.id);" curr_back_no="#getPartListHeaders.back_number#">
                                    <input type="hidden" id="curr_back_no" name="curr_back_no" value="#getPartListHeaders.back_number#">
                                </div>
                                    
                                <div id='backNumberMenu' style="visibility: hidden; float:left; margin-left:-24px; margin-top:1px;">
									<ul> 
                                    	<li><img id="backNumberMenuIcon" src="../../../includes/images/gear.png">
                                            <ul>
                                                <li id="editBackNumberBtn">Edit</li> 
                                                <li id="cancelBackNumberBtn" style="display:none">Cancel</li> 
                                                <li id="historyShowBackNumberBtn">Display History</li>  
                                                <li id="historyHideBackNumberBtn" style="display:none">Hide History</li> 
                                            </ul>
										</li>
									</ul>
								</div>
                                     
 
							</td> 
                            
							<td align="right">Model Info : </td>
                        	<td align="left"> 
                            	<input type="text" id="model_info" name="model_info" class="formStyleReadOnly" readonly size="20" value="#getPartListHeaders.model_info#" >
							</td> 
                      	</tr>
                        <tr>
                            <td align="right">Active Date : </td>
                            <td align="left"><input type="text" class="formStyleReadOnly" readonly size="10" id="active_date" value="#getPartListHeaders.active_date#" > 
                            </td>
                            <td align="right">Inactive Date : </td>
                            <td align="left"><div id="inactive_date" name="inactive_date" val="#getPartListHeaders.inactive_date#"></div></td>
						</tr>

                        <tr>
                        	<td align="right">Remark : </td>
                        	<td align="left"> 
								<div style="float:left;margin-right:3px">                             	
                                    <select id="remark" name="remark" class="formStyle" value="#getPartListHeaders.remark_description#" style="height:24px" disabled> 
                                    </select>                                         
                                </div> 
                                    
                            	<div id='getRemark' style="float:left">
                                	<input type="text" id="remark_desc" name="remark_desc" class="formStyleReadOnly" value="#getPartListHeaders.remark_description#" style="height:18px" readonly size="31" >
                                    <input type="hidden" id="remark_id" name="remark_id" class="formStyleReadOnly" style="height:18px" readonly size="31" >
                                </div>
                                    
                                <div id='remarkMenu' style="visibility: hidden; float:left; margin-left:-24px; margin-top:1px;">
									<ul> 
                                    	<li><img id="remarkMenuIcon" src="../../../includes/images/gear.png">
                                            <ul>
                                            	<li id="addRemarkBtn">Add</li>
                                                <li id="editRemarkBtn">Edit</li>
                                            </ul>
										</li>
									</ul>
								</div>
                                     
 
							</td> 
                      	</tr>
                     </table>
                     
                     
                     <table width="100%" cellpadding="4" class="formStyle" cellspacing="0" >
                    	<tr><td></td></tr>
						<tr>
							<td align="center" >   
                            
                            	<!---- back number panel ---->
                            	<div id="backNumberPanel" style="display:none;">
									<table class="tablestyle" width="80%">
										  <tr class="boldstyle bgstyle1"><td align="left" colspan="7" style="font-style:italic;">
										  <div style="float:left">Back Number History</div>  
                                           <div id="closeBackNoHistory" style="float:right; margin-right:0px; cursor:pointer; ">
                                          	<img src="../../../includes/images/close_small.png" >
                                          </div> 
										  </td></tr>
										  <tr class="bgstyle2 smallfont boldstyle"> 
										  		<td></td>
												<td align="center">Back Number</td>
												<td align="center" width="100">Status</td> 
												<td align="center" width="150">Creation Date</td>
												<td align="center" width="110">Creation By</td>
												<td align="center" width="150">Inactive Date</td>
												<td align="center" width="110">Inactive By</td>
										  </tr> 
										  
										  <cfloop query="getBackNoHistory" >
										  	<tr style="<cfif status EQ 'ACTIVE' >background-color:##CAFFE4<cfelse>background-color:##FFD9D9</cfif>" > 
												<td align="center" width="24">
													<cfif status EQ 'ACTIVE' >
                                                        <img src="../../../includes/images/active.png">
                                                    <cfelse>
                                                        <img src="../../../includes/images/inactive.png">
                                                    </cfif>
                                                </td> 
												<td align="center">#back_number#</td>
												<td align="center">#status#</td>
												<td align="center">#creation_date#</td>
												<td align="center">#creation_by#</td>
												<td align="center">#last_updated_date#</td>
												<td align="center">#last_updated_by#</td>
										  	</tr> 
										  </cfloop>
									  
										  <tr class="boldstyle bgstyle1" id="backNumberFooter">
											<td align="right" colspan="7"></td>
										  </tr> 
									</table> 
                                    <div style="height:10px;"></div>
								</div> 
                                
                                <!------------------------------------------- psi panel ----------------------------------------------------->

                                
                                <cfquery name="getPartListPSI" datasource="#dswms#" >   
                                        SELECT a.part_list_psi_id, b.box_id, b.box_code, a.qty_per_box,
                                        b.length || ' x ' || b.width || ' x ' || b.height measurement, b.weight, 
                                        to_char(a.active_date,'dd/mm/yyyy') active_date, to_char(a.inactive_date,'dd/mm/yyyy') inactive_date,
                                          
                                        CASE WHEN a.active_date = a.inactive_date THEN 'INACTIVE'
                                             WHEN a.active_date <= sysdate AND NVL(a.inactive_date,sysdate+1) > sysdate THEN 'ACTIVE' 
                                             WHEN a.active_date > sysdate AND NVL(a.inactive_date,sysdate+1) > sysdate THEN 'FUTURE' 
                                        ELSE 'INACTIVE' END status,
                                        
                                        CASE WHEN a.active_date = a.inactive_date THEN 0
                                             WHEN a.active_date <= sysdate AND NVL(a.inactive_date,sysdate+1) > sysdate THEN 1 
                                             WHEN a.active_date > sysdate AND NVL(a.inactive_date,sysdate+1) > sysdate THEN 2
                                        ELSE 0 END status_flag
                                         
                                        FROM gen_part_list_psi a, gen_box b
                                        WHERE a.box_id = b.box_id 
                                        AND attr1 IS NULL
                                        AND a.part_list_header_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#part_list_header_id#">
                                        ORDER BY status_flag, a.inactive_date, a.active_date, a.last_updated_date ASC  
                                </cfquery>
                                
                                <cfquery name="checkPartListInactive" dbtype="query" >
                                	SELECT status_flag FROM getPartListPSI WHERE status_flag = 0
                                </cfquery>


                                <div id="PSIPanel">
									<table class="tablestyle" width="80%">
										  <tr class="boldstyle bgstyle1" id="psiBar"><td align="left" colspan="7" style="font-style:italic;">
										  <div style="float:left; margin-top:4px;">Packing Style Information</div>
										  <div id="progressbarPSI" style="display:none; float:left; margin-left:5px; ">
                                          	<img src="../../../includes/images/progress_green_small.gif" >
                                          </div> 
										  <div id='psiMenu' style="visibility: hidden; float:right">
													<ul> 
														<li><img id="psiMenuIcon" src="../../../includes/images/gear.png">
															<ul>  
                                                            <cfif checkPartListInactive.recordcount GT 0>
                                                            	<li id="historyPSIBtn">Display History</li>
                                                            </cfif>     
																<li id="newPSIBtn">Add New Setting</li>   
															</ul>
														</li>
													</ul>
											</div>
										  </td></tr>
										  <tr class="bgstyle2 smallfont boldstyle" id="psiHeader"> 
										  		<td></td>
												<td align="center" >Box Code</td>
												<td align="center" width="143">Measurement(mm)</td>
												<td align="center" width="143">Weight(g)</td>
												<td align="center" width="143">Quantity Per Box</td>
												<td align="center" width="110">Active Date</td>
												<td align="center" width="110">Inactive Date</td>
										  </tr> 
                                          
                                          <cfset future_psi_counter = 0 >
                                          
                                          <cfquery name="checkActive" dbtype="query">
                                          	SELECT * FROM getPartListPSI 
                                            WHERE status_flag = 1
                                          </cfquery>
                                          
                                          <cfquery name="getCurInactiveDate" datasource="#dswms#" >
                                            select to_char(sysdate,'dd/mm/yyyy') curInactiveDate from dual
                                          </cfquery>
                                  
                                          
                                          <cfloop query="getPartListPSI" >
                                          
										  		<cfif status_flag EQ 0 >
                                                    <tr class="inactive_row_style INACTIVE_psiRows" style="display:none" > 
                                                        <td align="center" width="24"><img src="../../../includes/images/inactive.png" alt="Old Setting"></td> 
                                                        <td align="center">#box_code#</td>
                                                        <td align="center">#measurement#</td>
                                                        <td align="center">#weight#</td> 
                                                        <td align="center">#qty_per_box#</td>
                                                        <td align="center">#active_date#</td>
                                                        <td align="center">#inactive_date#</td>
                                                    </tr> 
                                                </cfif>
                                                
                                                <cfif status_flag EQ 1>
                                                  
                                                    <input type="hidden" name="current_part_list_psi_id" value="#part_list_psi_id#" >
                                                    <tr class="active_row_style ACTIVE_psiRows"> 
                                                        <td align="center" width="24"><img src="../../../includes/images/active.png" alt="Current Setting"></td> 
                                                        <td align="center">#box_code#</td>
                                                        <td align="center">#measurement#</td>
                                                        <!---arina change start--->
                                                        <td align="center">
                                                           <input type="text" name="updated_weight" id="updated_weight" value="#weight#" class="formStyle" style="text-align:center" size="10" >
                                                        </td>
                                                        <!---arina change end--->
                                                        <td align="center">#qty_per_box#</td> 
                                                        <td align="center">#active_date#</td>
                                                        <td align="center">
                                                            <div align="left">
                                                                <div class="curr_psi_inactive_date tips_left date_ctrl" dsb="N" id="curr_psi_inactive_date" val="#inactive_date#"></div>
                                                                <input type="hidden" name="curr_psi_active_date" id="curr_psi_active_date" value="#active_date#"> 
                                                            </div> 
                                                        </td>
                                                    </tr> 
                                                </cfif>
                                                
                                                <cfif status_flag EQ 2 >
                                                	<cfset future_psi_counter = future_psi_counter + 1 > 
                         				  			<input type="hidden" name="new_part_list_psi_id" value="#part_list_psi_id#" >
										  			<tr class="new_row_style FUTURE_psiRows" active_date="#active_date#" inactive_date="#inactive_date#">   
                                                        <td align="center" width="24"><img src="../../../includes/images/new.png"></td>
                                                        <td align="center">#box_code#</td>
                                                        <td align="center">#measurement#</td>
                                                        <td align="center">#weight#</td>
                                                        <td align="center">#qty_per_box#</td>
                                                        <td align="center">#active_date#</td>
                                                        <td align="center">
                                                            <div class="new_psi_inactive_date" id="new_psi_inactive_date" ></div> 
                                                        </td>
                                                    </tr>
                                                </cfif>
                                                
										  </cfloop>
                                          
                                          
                                          <cfif future_psi_counter EQ 0 > 
                                              <tr class="new_row_style NEW_psiRows" style="display:none;" >  
                                                    <td align="center" width="24"><img src="../../../includes/images/new.png"></td>
                                                    <td align="center">
                                                        <select name="new_box_id" id="new_box_id" class="formStyle tips" onChange="getBoxSettings(this.value)" 
                                                        style="width:100%; text-align-last:center" >
                                                            <option value="">-- Please Select --</option>
                                                            <cfloop query="getBox">  
                                                                <option value="#box_id#">#box_code#</option>
                                                            </cfloop>	
                                                        </select> 
                                                    </td>
                                                    <td align="center">
                                                        <input type="text" size="17" id="new_measurement" readonly class="formStyleReadOnly" 
                                                        style="text-align:center" >
                                                    </td>
                                                    <td align="center">
                                                        <input type="text" size="17" id="new_weight" readonly class="formStyleReadOnly" 
                                                        style="text-align:center" >
                                                    </td>
                                                    <td align="center">
                                                        <input type="text" size="17" name="new_qty_per_box" id="new_qty_per_box" style="text-align:center" 
                                                        class="formStyle tips" onKeyUp="validateInputNumber(this.id,this.value)" >
                                                    </td>
                                                    <td align="center"><div id="new_psi_active_date" class="tips" ></div></td>
                                                    <td align="center"><div id="new_psi_inactive_date"></div></td>
                                              </tr>  
                                          </cfif>
                                           
										  <tr class="boldstyle bgstyle1" id="psiFooter">
											<td align="right" colspan="7">
                                            </td>
										  </tr> 
									</table> 
								</div>
                                <!------------------------------------------- END psi panel ----------------------------------------------------->
                                
                                <br>
                                
                                 <!------------------------------------------ delivery info panel ------------------------------------------------->
                                 
                                <cfquery name="getDeliveryInfo" datasource="#dswms#" >    
                                     SELECT part_list_delivery_info_id, dock_code  || '(' || f.line_shop || ')' dock_code, b.order_type, c.vendor_category, a.delivery_category, e.delivery_category_desc, 
                                            e.vendor_setting_header_id, 
                                            to_char(a.active_date,'dd/mm/yyyy') active_date, to_char(a.inactive_date,'dd/mm/yyyy') inactive_date,
                                            CASE WHEN a.active_date = a.inactive_date THEN 'INACTIVE'
                                                 WHEN a.active_date <= sysdate AND NVL(a.inactive_date,sysdate+1) > sysdate THEN 'ACTIVE' 
                                                 WHEN a.active_date > sysdate AND NVL(a.inactive_date,sysdate+1) > sysdate THEN 'FUTURE' 
                                            ELSE 'INACTIVE' END status, 
                                            CASE WHEN a.active_date = a.inactive_date THEN 0
                                                 WHEN a.active_date <= sysdate AND NVL(a.inactive_date,sysdate+1) > sysdate THEN 1 
                                                 WHEN a.active_date > sysdate AND NVL(a.inactive_date,sysdate+1) > sysdate THEN 2
                                            ELSE 0 END status_flag 
                                    FROM gen_part_list_delivery_info a, lsp_order_type b, gen_vendor_category c, lsp_dock d, gen_line_shop f, 
                                            (
                                                SELECT vendor_setting_header_id, delivery_category, delivery_category_desc
                                                FROM gen_vendor_setting_headers 
                                                WHERE org_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#getPartListHeaders.org_id#">
                                                AND vendor_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#getPartListHeaders.vendor_id#">
                                                AND active_date != NVL(inactive_date,active_date+1)
                                            ) e
                                    WHERE a.order_type_id = b.order_type_id
                                    AND a.vendor_category_id = c.vendor_category_id
                                    AND a.dock_id = d.dock_id
                                    AND a.delivery_category = e.delivery_category (+)
                                    AND a.part_list_header_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#part_list_header_id#">
                                    AND d.line_shop_id = f.line_shop_id
                                    ORDER BY status_flag, part_list_delivery_info_id ASC 
                                    
                                </cfquery>
                                
                                <cfquery name="checkinactive" dbtype="query">
                                	SELECT status_flag FROM
                                    getDeliveryInfo
                                    WHERE status_flag = 0
                                </cfquery>
                               
                                 
                                <div id="deliveryInfoPanel">
									<table class="tablestyle" width="80%" id="delivery_info_table">
										  <tr class="boldstyle bgstyle1"><td align="left" colspan="10" style="font-style:italic;">
										  <div style="float:left; margin-top:4px;">Delivery Information</div>
										  <div id="progressbarDeliveryInfo" style="display:none; float:left; margin-left:5px; ">
                                          	<img src="../../../includes/images/progress_green_small.gif" >
                                          </div> 
										  <div id='deliveryInfoMenu' style="visibility:hidden; float:right">
													<ul> 
														<li><img src="../../../includes/images/gear.png">
															<ul>
                                                            	<cfif checkinactive.recordcount GT 0 >
                                                            		<li id="historyDeliveryInfoBtn">Display History</li> 
                                                                </cfif>
																<li id="newDeliveryInfoBtn">Add New Setting</li>   
																<li id="removeDeliveryInfoBtn" style="display:none">Remove Selected</li>   
															</ul>
														</li>
													</ul>
											</div>
										  </td></tr>
										  <tr class="bgstyle2 smallfont boldstyle"> 
										  		<td rowspan="2"></td>
												<td align="center" rowspan="2">Dock Code ( Line Shop )</td> 
												<td align="center" rowspan="2">Order Type</td> 
												<td align="center" rowspan="2">Vendor Category</td> 
												<td align="center" colspan="4">Delivery Category</td> 
												<td align="center" rowspan="2" width="110">Active Date</td>
												<td align="center" rowspan="2" width="110">Inactive Date</td>
										  </tr> 
                                           <tr class="bgstyle2 smallfont boldstyle">  
												<td align="center">Code</td>  
												<td align="center">Description</td>  
												<td align="center" width="80">1st Tier TPL</td> 
												<td align="center" width="80">2nd Tier TPL</td> 
										  </tr>   
                                          
                                          <cfset dlvInfoId = 0 >
                                          <cfloop query="getDeliveryInfo" >
                                          
										  		<cfif status_flag EQ 0 >
                                                    <tr class="INACTIVE_dlvRows inactive_row_style" style="display:none" > 
                                                        <td align="center" width="24"><img src="../../../includes/images/inactive.png" alt="Old Setting"></td> 
                                                        <td align="center">#dock_code#</td>
                                                        <td align="center">#order_type#</td>
                                                        <td align="center">#vendor_category#</td>
                                                        <td align="center">#delivery_category#</td>
                                                        <td align="center">#delivery_category_desc#</td>
                                                        <td align="center"><img src="../../../includes/images/tick_med_off.png" ></td>
                                                        <td align="center"><img src="../../../includes/images/tick_med_off.png" ></td>
                                                        <td align="center">#active_date#</td>
                                                        <td align="center">#inactive_date#</td>
                                                    </tr> 
                                                </cfif>
                                                
                                                <cfif status_flag EQ 1 OR status_flag EQ 2> 
                                                	<cfset dlvInfoId = dlvInfoId + 1 >
                                                    
<!-----------------------------------------------------  DISABLED ------------- LSP INVENTORY PROJECT --------------------------------------- 
                                                    <cfset checkTPL1_icon = 'tick_med_off.png' >
                                                    <cfset checkTPL2_icon = 'tick_med_off.png' >
                                                    
                                                    <cfquery name="checkTPL1" datasource="#dswms#" > 
                                                        SELECT MAX(vendor_setting_detail_id) vendor_setting_detail_id, 
                                                        DECODE(COUNT(tpl_id),0,'tick_med_off.png','tick_med.png') icon, b.vendor_name tpl1_name
                                                        FROM gen_vendor_setting_details a, frm_vendors b
                                                        WHERE a.tpl_id = b.vendor_id
                                                        <cfif status_flag EQ 1>
                                                        AND a.active_date <= sysdate AND NVL(a.inactive_date, sysdate+1) > sysdate
                                                        <cfelseif status_flag EQ 2>
                                                         AND a.active_date > sysdate
                                                        </cfif>
                                                        AND a.tpl_id IS NOT NULL 
                                                        AND a.vendor_setting_header_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#getDeliveryInfo.vendor_setting_header_id#" >
                                                        GROUP BY  b.vendor_name
													</cfquery>
                                                    
                                                    <cfif checkTPL1.recordCount NEQ 0 AND checkTPL1.vendor_setting_detail_id NEQ "" >
														<cfset checkTPL1_icon = checkTPL1.icon>
                                                        
                                                        <cfquery name="checkTPL2" datasource="#dswms#" >
                                                            SELECT DECODE(COUNT(tpl_id),0,'tick_med_off.png','tick_med.png') icon
                                                            FROM gen_vendor_setting_t_details
                                                            WHERE active_date <= sysdate AND NVL(inactive_date, sysdate+1) > sysdate
                                                            AND tpl_id IS NOT NULL
                                                            AND vendor_setting_detail_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#checkTPL1.vendor_setting_detail_id#" >
                                                        </cfquery>
														<cfset checkTPL2_icon = checkTPL2.icon>
                                                    
                                                    </cfif>
-- END : ---------------------------------------------------  DISABLED ------------- LSP INVENTORY PROJECT ----------------------------------------->


                                                    
                                                    <tr class="ACTIVE_dlvRows active_row_style" rID="#dlvInfoID#" dock_code="#dock_code#" vendor_setting_header_id="#vendor_setting_header_id#" > 
                                                        <td align="center" width="24"><img src="../../../includes/images/active.png" alt="Current Setting"></td> 
                                                        <td align="center">
                                                        #dock_code# 
                                                        <input type="hidden" id="curr_dock_code_#dlvInfoID#" value="#dock_code#" > 
                                                        <input type="hidden" name="part_list_delivery_info_id_#dlvInfoID#" value="#part_list_delivery_info_id#" >
                                                        </td>
                                                        <td align="center">#order_type#</td>
                                                        <td align="center">#vendor_category#</td>
                                                        <td align="center">#delivery_category#</td>
                                                        <td align="center">#delivery_category_desc#</td> 
                                                        <td align="center"><img id="checkTPL1_icon_#dlvInfoID#" src="../../../includes/images/tick_med_off.png" ></td>
                                                        <td align="center"><img id="checkTPL2_icon_#dlvInfoID#" src="../../../includes/images/tick_med_off.png" ></td>
                                                        <td align="center">#active_date#</td>
                                                        <td align="center"> 
                                                        <div class="curr_dlv_inactive_date tips_left" id="curr_dlv_inactive_date_#dlvInfoID#"
                                                        val="#inactive_date#" active_date="#active_date#"></div>  
                                                       
                                                        </td>
                                                    </tr>

                                                    <!-------------------------- - LSP INVENTORY PROJECT ----------------------------------------->
                                                    <tr id="vendor_setting_panel_#dlvInfoID#"><td colspan="10" align="center" valign="middle"></td></tr>



    <!-----------------------------------------------------  DISABLED ------------- LSP INVENTORY PROJECT --------------------------------------- 
                                                    <cfquery name="getTPL1" datasource="#dswms#" > 
                                                        SELECT a.part_list_tpl_id, a.tpl_id, b.vendor_name tpl_name, a.delivery_category, 
                                                               to_char(a.active_date, 'dd/mm/yyyy') active_date, to_char(a.inactive_date, 'dd/mm/yyyy') inactive_date, c.delivery_category_desc
                                                        FROM gen_part_list_tpl a, frm_vendors b, gen_vendor_setting_headers c
                                                        WHERE a.tpl_id = b.vendor_id
                                                        AND a.active_date != NVL(a.inactive_date, a.active_date+1) AND a.active_date <= sysdate AND NVL(a.inactive_date, sysdate+1) > sysdate
                                                        AND c.active_date != NVL(c.inactive_date,c.active_date+1) AND c.active_date <= sysdate AND NVL(c.inactive_date, sysdate+1) > sysdate
                                                        AND a.tpl_id = c.vendor_id
                                                        AND a.delivery_category = c.delivery_category
                                                        AND a.part_list_delivery_info_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#getDeliveryInfo.part_list_delivery_info_id#" >
                                                        AND c.org_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#getPartListHeaders.org_id#">
                                                    </cfquery> 
                                                    
                                                    <!---<cfquery name="getTPL2" datasource="#dswms#" >  
                                                        SELECT e.part_list_tpl_tier_id, e.tpl_id, f.vendor_name tpl_name, e.delivery_category, c.delivery_category_desc,
                                                               to_char(e.active_date, 'dd/mm/yyyy') active_date, to_char(e.inactive_date, 'dd/mm/yyyy') inactive_date
                                                        FROM gen_part_list_delivery_info a, gen_part_list_headers b, gen_vendor_setting_t_headers c, gen_vendor_setting_t_details d, gen_part_list_tpl_tier e, frm_vendors f
                                                        WHERE a.part_list_header_id = b.part_list_header_id
                                                        AND c.vendor_setting_t_header_id = d.vendor_setting_t_header_id 
                                                        AND b.vendor_id = c.vendor_id
                                                        AND b.org_id = c.org_id
                                                        AND a.part_list_delivery_info_id = e.part_list_delivery_info_id
                                                        AND e.active_date != NVL(e.inactive_date, e.active_date+1) AND e.active_date <= sysdate AND NVL(e.inactive_date, sysdate+1) > sysdate
                                                        AND c.active_date != NVL(c.inactive_date, c.active_date+1) AND c.active_date <= sysdate AND NVL(c.inactive_date, sysdate+1) > sysdate
                                                        AND d.active_date != NVL(d.inactive_date, d.active_date+1) AND d.active_date <= sysdate AND NVL(d.inactive_date, sysdate+1) > sysdate
                                                        AND e.tpl_id = f.vendor_id
                                                        AND a.part_list_delivery_info_id=<cfqueryparam cfsqltype="cf_sql_integer" value="#getDeliveryInfo.part_list_delivery_info_id#" >
                                                    </cfquery> ---> 
                                                    
                                                    <cfquery name="getTPL2" datasource="#dswms#" >  
                                                        SELECT e.part_list_tpl_tier_id, e.tpl_id, f.vendor_name tpl_name, e.delivery_category, g.delivery_category_desc,
                                                                   to_char(e.active_date, 'dd/mm/yyyy') active_date, to_char(e.inactive_date, 'dd/mm/yyyy') inactive_date  
                                                        FROM gen_part_list_delivery_info a, gen_part_list_headers b, gen_vendor_setting_headers c, gen_vendor_setting_details d, gen_part_list_tpl_tier e, frm_vendors f,
                                                                 gen_vendor_setting_t_headers g, gen_vendor_setting_t_details h
                                                        WHERE a.part_list_header_id = b.part_list_header_id
                                                        AND b.vendor_id = c.vendor_id 
                                                        AND a.delivery_category = c.delivery_category
                                                        AND c.vendor_setting_header_id = d.vendor_setting_header_id
                                                        AND a.part_list_delivery_info_id = e.part_list_delivery_info_id
                                                        AND e.tpl_id = f.vendor_id
                                                        AND d.vendor_setting_detail_id = g.vendor_setting_detail_id
                                                        AND g.vendor_setting_t_header_id = h.vendor_setting_t_header_id
                                                        AND c.active_date != NVL(c.inactive_date, c.active_date+1) AND c.active_date <= sysdate AND NVL(c.inactive_date, sysdate+1) > sysdate
                                                        AND d.active_date != NVL(d.inactive_date, c.active_date+1) AND d.active_date <= sysdate AND NVL(d.inactive_date, sysdate+1) > sysdate
                                                        AND e.active_date != NVL(e.inactive_date, e.active_date+1) AND e.active_date <= sysdate AND NVL(e.inactive_date, sysdate+1) > sysdate
                                                        AND g.active_date != NVL(g.inactive_date, g.active_date+1) AND g.active_date <= sysdate AND NVL(g.inactive_date, sysdate+1) > sysdate
                                                        AND h.active_date != NVL(h.inactive_date, h.active_date+1) AND h.active_date <= sysdate AND NVL(h.inactive_date, sysdate+1) > sysdate
                                                        AND c.org_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#getPartListHeaders.org_id#">
                                                        AND a.part_list_delivery_info_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#getDeliveryInfo.part_list_delivery_info_id#" >
                                                   </cfquery>      
                                                    
                                                    
                                                    
                                                    <cfif getTPL1.recordCount EQ 0 >
                                                    
                                                    
                                                    <tr class="delivery_info_tier">
                                                    	<td colspan="10" align="center">
                                                        	
                                                            <br>  
                                                            <table class="tablestyle" width="80%" id="tier1_#dlvInfoID#">
                                                              <tr class="boldstyle bgstyle1"><td align="left" colspan="10" style="font-style:italic;">
                                                              		<div style="float:left; margin-top:4px;">1st Tier TPL Information </div> 
                                                              </td></tr>
                                                              <tr class="bgstyle2 smallfont boldstyle"> 
                                                                    <td width="20"></td>
                                                                    <td align="left">TPL Name</td> 
                                                              </tr> 
                                                              <tr class="active_row_style" >
                                                              		<td align="center" height="28"><img src="../../../includes/images/active.png"></td>
                                                              		<td align="left">#checkTPL1.tpl1_name#</td>
                                                              </tr> 
                                                        	</table> 
                                                            <br>
                                                             
                                                             
                                                        </td>
                                                    </tr>
                                                    
                                                    	
                                                    
                                                    </cfif>
                                                    
                                                    
                                                    
                                                    <cfset t1_counter = 0 > 
                                                    <cfset t2_counter = 0 > 
                                                    <cfif getTPL1.recordCount NEQ 0 OR getTPL2.recordCount NEQ 0 > 
                                                   
                                                    <tr class="delivery_info_tier">
                                                    	<td colspan="10" align="center">
                                                        	
                                                            <cfif getTPL1.recordCount NEQ 0 >
                                                            <br>  
                                                            <table class="tablestyle" width="80%" id="tier1_#dlvInfoID#">
                                                              <tr class="boldstyle bgstyle1"><td align="left" colspan="10" style="font-style:italic;">
                                                              <div style="float:left; margin-top:4px;">1st Tier TPL Information </div> 
                                                              </td></tr>
                                                              <tr class="bgstyle2 smallfont boldstyle"> 
                                                                    <td rowspan="2" width="20"></td>
                                                                    <td align="left" rowspan="2">TPL Name</td>  
                                                                    <td align="center" colspan="2">Delivery Category</td>  
                                                                    <td align="center" width="110" rowspan="2">Active Date</td>
                                                                    <td align="center" width="110" rowspan="2">Inactive Date</td>
                                                              </tr> 
                                                              <tr class="bgstyle2 smallfont boldstyle">  
                                                                    <td align="center" width="80">Code</td>  
                                                                    <td align="center" width="140">Description</td>  
                                                              </tr>  
                                                              <cfloop query="getTPL1" >
                                                              	<cfset t1_counter = t1_counter + 1 > 
                                                              	<tr class="active_row_style"> 
                                                        			<td align="center" width="24"><img src="../../../includes/images/active.png" alt="Current Setting"></td> 
                                                                	<td align="left">#tpl_name#</td>
                                                                    <td align="center">#delivery_category#</td>
                                                                    <td align="center">#delivery_category_desc#</td>
                                                                    <td align="center">#active_date#</td>
                                                                    <td align="center"> 
                                                                    <input type="hidden" name="part_list_tpl_id_#dlvInfoID#_#t1_counter#" value="#part_list_tpl_id#" >
                                                                 <!---<div class="tpl1_inactive_date childDate_#dlvInfoID#" id="tpl1_inactive_date_#dlvInfoID#_#t1_counter#" val="#inactive_date#" active_date="#active_date#" ></div>--->
                                                                 	<input type="text" id="tpl1_inactive_date_#dlvInfoID#_#t1_counter#" name="tpl1_inactive_date_#dlvInfoID#_#t1_counter#" size="14" value="#inactive_date#" readonly class="childDate_#dlvInfoID# formStyleReadOnly">
                                                                    
                                                                 	</td>
                                                                </tr>                                                                  
                                                              </cfloop>
                                                        	</table>
                                                            </cfif>
                                                            
                                                            <cfif getTPL2.recordCount NEQ 0 >
                                                            <br> 
                                                            <table class="tablestyle" width="80%" id="tier2_#dlvInfoID#">
                                                              <tr class="boldstyle bgstyle1"><td align="left" colspan="10" style="font-style:italic;">
                                                              <div style="float:left; margin-top:4px;">2nd Tier TPL Information </div> 
                                                              </td></tr>
                                                              <tr class="bgstyle2 smallfont boldstyle"> 
                                                                    <td rowspan="2" width="20"></td>
                                                                    <td align="left" rowspan="2">TPL Name</td>  
                                                                    <td align="center" colspan="2">Delivery Category</td>  
                                                                    <td align="center" width="110" rowspan="2">Active Date</td>
                                                                    <td align="center" width="110" rowspan="2">Inactive Date</td>
                                                              </tr> 
                                                              <tr class="bgstyle2 smallfont boldstyle">  
                                                                    <td align="center" width="80">Code</td>  
                                                                    <td align="center" width="140">Description</td>  
                                                              </tr>   
                                                               
                                                              <cfloop query="getTPL2" >
                                                              	<cfset t2_counter = t2_counter + 1 > 
                                                              	<tr class="active_row_style">
                                                        			<td align="center" width="24"><img src="../../../includes/images/active.png" alt="Current Setting"></td> 
                                                                	<td align="left">#tpl_name#</td>
                                                                    <td align="center">#delivery_category#</td>
                                                                    <td align="center">#delivery_category_desc#</td>
                                                                    <td align="center">#active_date#</td>
                                                                    <td align="center">
                                                                    <input type="hidden" name="part_list_tpl_tier_id_#dlvInfoID#_#t2_counter#" value="#part_list_tpl_tier_id#" >
                                                                <!--- <div class="tpl2_inactive_date" id="tpl2_inactive_date_#dlvInfoID#_#t2_counter#" val="#inactive_date#" active_date="#active_date#" ></div>--->
                                                                 <input type="text" id="tpl2_inactive_date_#dlvInfoID#_#t2_counter#" name="tpl2_inactive_date_#dlvInfoID#_#t2_counter#" size="14" readonly class="childDate_#dlvInfoID# formStyleReadOnly">
                                                                 	</td>
                                                              	</tr>                                                                    
                                                              </cfloop>
                                                        	</table>
                                                            </cfif>
                                                            
                                                            <br> 
                                                             
                                                        </td>
                                                    </tr>
                                                    
                                                    </cfif>
                                                    
                                                    <input type="hidden" name="totalTier1_#dlvInfoId#" id="totalTier1_#dlvInfoId#" value="#t1_counter#" >
                                                    <input type="hidden" name="totalTier2_#dlvInfoId#" id="totalTier2_#dlvInfoId#" value="#t2_counter#" >
                                    
 -- END : ---------------------------------------------------  DISABLED ------------- LSP INVENTORY PROJECT ----------------------------------------->



                                               </cfif>
                                        </cfloop>  
                                        <input type="hidden" name="dlvInfoId" id="dlvInfoId" value="#dlvInfoId#" >
                                        <tbody></tbody>
                               			<tr class="boldstyle bgstyle1 rowborder"><td align="right" colspan="10"></td></tr> 
                     </table> 
               
                     <table width="100%">
                        <tr><td height="5"></td></tr>
                        <tr>
                            <td align="right" bgcolor="F5F5F5" style="padding:8px">  
                                <input class="button white ctrlObj" type="submit" value="Save" id="saveBtn" />   
                                <input class="button white ctrlObj" type="button" value="Close" id="closeBtn">
                            </td>
                        </tr>
                     </table>  
                     
                 </form>
             </div>
        </div>                
             
    	<div id="lookupEditWindow" style="display:none;"  >
        	<div class="lookupHeader" style="background-image:url(../../../includes/images/lookupheader.png); ">
				<div style="float:left">Edit Remark</div> 
		 	</div>
         	<div style="padding:0px;"> 
				<cfoutput> 
                    <div id="edit_remark_panel"></div>	
                </cfoutput>
        	</div>
    	</div>
        
        <div id="lookupAddWindow" style="display:none;"  >
        	<div class="lookupHeader" style="background-image:url(../../../includes/images/lookupheader.png); ">
				<div style="float:left">Add New Remark</div> 
		 	</div>
         	<div style="padding:0px;"> 
				<cfoutput> 
                    <div id="add_remark_panel"></div>	
                </cfoutput>
        	</div>
    	</div>    
    </cfoutput> 
    
</body>
</html>

