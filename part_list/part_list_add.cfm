<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html><head> 
<cfinclude template="../../../includes/file_access_validation.cfm" > 
<cfinclude template="../../../includes/basic_includes.cfm" >
<script type="text/javascript" src="part_list_add.js"></script> 
<link rel="stylesheet" href="../../../includes/css/menu_ext.css" type="text/css" >  

 <!---v1.1(START)--->
 <cfinvoke component="#component_path#.ownership" method="retrieveOwnership" dsn="#dsscmfw#" returnvariable="getOwnerships" ></cfinvoke> 
 <!---v1.1(END)--->
<style type="text/css">
 
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
            border-top:none;
            border-right:none; 
            border-left:none; 
            border-radius: 10px 10px 0px 0px; 
            border-bottom:none !important;
            color:#FFF; 
            font-weight:bold;
            background-image:url('../../../includes/images/blue_stripes.png');
        }
    
        .tier1_header {
            border-top:none;
            border-right:none; 
            border-left:none;
            border-radius: 10px 10px 0px 0px; 
            border-bottom:none !important;
            color:#FFF; 
            font-weight:bold;background-image:url('../../../includes/images/orange_stripes.png');
        }
     
        .warehouse_header {
            border-top:none;
            border-right:none; 
            border-left:none;
            border-radius: 10px 10px 0px 0px; 
            border-bottom:none !important;
            color:##FFF; 
            font-weight:bold;background-image:url('../../../includes/images/orange_stripes.png');
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
            font-size:11px;
            background-image: linear-gradient(to top, #e6f2ff,white);
        }
    
        .setting_orange_bg { 
            font-size:11px;
            background-image: linear-gradient(to top, #fffae6,white);
        }
    </style> 
    
    
    <link rel="stylesheet" type="text/css" href="../../../includes/plugins_3.0/fontawesome_6.2.0/css/all.min.css"/>

<cfquery name="getHeaders" datasource="#dswms#" >
	SELECT a.item_no part_number, a.item_description part_name, a.color_code, c.vendor_id, c.vendor_name, d.org_description, 
    	   GEN_GET_PART_MODEL(4,d.org_id,a.item_no,sysdate, sysdate) model_info
    FROM psms_item_master a, lsp_sourcing_info_v b, frm_vendors c, frm_organizations d
    WHERE a.item_no = b.item_no
    AND b.vendor_id = c.vendor_id
    AND a.company = b.org_id 
    AND a.company = d.ebiz_org_code
    AND d.org_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#org_id#" >
	AND a.item_no = <cfqueryparam cfsqltype="cf_sql_varchar" value="#part_number#" > 
</cfquery> 

<cfquery name="getBox" datasource="#dswms#" >
	SELECT box_id, box_code
    FROM gen_box 
	WHERE org_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#org_id#">
	AND active_date != NVL(inactive_date, active_date+1) AND active_date <= sysdate AND NVL(inactive_date, sysdate+1) > sysdate 
	ORDER BY box_code  
</cfquery>

<cfquery name="getOrderType" datasource="#dswms#" >
	SELECT order_type_id, order_type
    FROM lsp_order_type a
	WHERE org_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#org_id#">
	AND active_date != NVL(inactive_date, active_date+1) AND active_date <= sysdate AND NVL(inactive_date, sysdate+1) > sysdate 
	ORDER BY order_type
</cfquery> 

<cfquery name="getVendorCategory" datasource="#dswms#" >
	SELECT vendor_category_id, vendor_category
    FROM gen_vendor_category a
	WHERE org_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#org_id#"> 
	AND active_date != NVL(inactive_date, active_date+1) AND active_date <= sysdate AND NVL(inactive_date, sysdate+1) > sysdate  
	ORDER BY vendor_category 
</cfquery> 

<cfquery name="getDock" datasource="#dswms#" > 
    SELECT  a.dock_id, a.dock_code || '(' || b.line_shop || ')' dock_code
    FROM lsp_dock a, gen_line_shop b
    WHERE a.line_shop_id = b.line_shop_id
    AND a.org_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#org_id#">
    AND a.active_date != NVL(a.inactive_date, a.active_date+1) AND a.active_date <= sysdate AND NVL(a.inactive_date, sysdate+1) > sysdate 
    AND b.active_date != NVL(b.inactive_date, b.active_date+1) AND b.active_date <= sysdate AND NVL(b.inactive_date, sysdate+1) > sysdate 
    ORDER BY a.dock_code 
</cfquery> 
 
<cfquery name="getDeliveryCategory" datasource="#dswms#" >
	SELECT a.vendor_setting_header_id, b.vendor_setting_detail_id, a.delivery_category 
	FROM gen_vendor_setting_headers a,  gen_vendor_setting_details b
	WHERE a.org_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#org_id#">
	AND a.vendor_setting_header_id = b.vendor_setting_header_id
	AND a.active_date != NVL(a.inactive_date, a.active_date+1) AND a.active_date <= sysdate AND NVL(a.inactive_date, sysdate+1) > sysdate 
	AND b.active_date != NVL(b.inactive_date, b.active_date+1) AND b.active_date <= sysdate AND NVL(b.inactive_date, sysdate+1) > sysdate 
	AND a.vendor_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#getHeaders.vendor_id#">
	AND b.attr1 IS NULL
	ORDER BY a.delivery_category
</cfquery> 

<!---<cfquery name="getRemark" datasource="#dswms#" >
	SELECT remark_id, remark_code, remark_description
    FROM lsp_remark a
    WHERE a.org_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#org_id#">
    AND a.status = <cfqueryparam cfsqltype="cf_sql_varchar" value="ACTIVE">
    ORDER BY remark_id
</cfquery>---> 
 
  
</head>
 
<body background="../../../includes/images/bground1.png">
	<div id="content">
		<div class="screen_header"><cfoutput>#session.apps_name#</cfoutput> > General Master > Master Data > Part List > Add </div>  
	</div> 
    <br><br><br>
    
		<cfoutput>   
        <div style="width:99%; margin:auto">
            <div id='UIPanel'>
            <div>
                <div style="float:left">Add Part</div> 
                <div id="progressbar" class="ajaxProgressBar" style="float:right; display:none; margin-left:10px; margin-top:3px">
                    <img src="../../../includes/images/progress_green_small.gif" ></div>
                </div>
                <div>  
              
              
              	<form name="addForm" id="addForm" action="bgprocess.cfm" method="post">   
                	<input type="hidden" name="tabid" id="tabid" value="#tabid#">
					<input type="hidden" name="action_flag" value="add" >  
				    <table width="100%" cellpadding="4" class="formStyle" cellspacing="0">
                    	<tr>
                        	<td height="5"></td>
                      	</tr>
                      	<tr>
                       	 	<td align="right" width="20%">Organization : </td>
                        	<td align="left" width="25%">
								<input type="hidden" name="org_id" id="org_id" value="#org_id#">
                            	<input type="text" class="formStyleReadOnly" readonly size="40" value="#getHeaders.org_description#">
                        	</td>
                            <!---ADDED BY SYAHMI HANAFIAH (START)--->
								<!---v1.1(START)--->
                                <td align="right" width="20%">Ownership : </td> 
                                <td align="left" width="25%">								
                                    <cfif getOwnerships.recordCount LT 2 > 
                                         <input type="hidden" name="ownership_id" id="ownership_id" class="formStyle" value="#getOwnerships.ownership_id#">
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
                            </td> 															
                        <!---V1.1(END)--->
                            
                             <!------>
						</tr> 
						<tr>
                        	<td align="right" width="20%">Part Number : </td>
                        	<td align="left" width="25%"> 
                            		<input type="text" id="part_number" name="part_number" class="formStyleReadOnly" readonly size="20" 
                                    value="#getHeaders.part_number#" >
							</td>
							<td align="right" width="25%">Part Name : </td>
                        	<td align="left" width="30%"> 
                            		<input type="text" id="part_name" name="part_name" class="formStyleReadOnly" readonly size="50" 
                                    value="#getHeaders.part_name#" >
							</td>
                      	</tr>
						<tr>
                        	<td align="right">Vendor : </td>
                        	<td align="left"> 
									<input type="hidden" id="vendor_id" name="vendor_id" class="formStyleReadOnly" readonly size="50" 
                                    value="#getHeaders.vendor_id#" >
                            		<input type="text" id="vendor_name" name="vendor_name" class="formStyleReadOnly" readonly size="50" 
                                    value="#getHeaders.vendor_name#" >
							</td>
							<td align="right">Color : </td>
                        	<td align="left"> 
                            		<input type="text" id="color_code" name="color_code" class="formStyleReadOnly" readonly size="20" 
                                    value="#getHeaders.color_code#" >
							</td>
                      	</tr>
						
						<tr>
                        	<td align="right">Back No : </td>
                        	<td align="left">
                            	<input type="text" id="back_no" name="back_no" class="formStyle tips" size="14" onKeyUp="uppercaseInput(this.id);">  
							</td> 
                            
							<td align="right">Model Info : </td>
                        	<td align="left"> 
                            	<input type="text" id="model_info" name="model_info" class="formStyleReadOnly" readonly size="20" value="#getHeaders.model_info#" >
							</td> 
                      	</tr>
                        <tr>
                            <td align="right">Active Date : </td>
                            <td align="left"><div id="active_date" name="active_date" class="tips"></div></td>
                            <td align="right">Inactive Date : </td>
                            <td align="left"><div id="inactive_date" name="inactive_date"></div></td>
						</tr>
                        <tr>
                        	<td align="right">Remark : </td>
                        	<td align="left"> 
								<div style="float:left;margin-right:3px">                             	
                                    <select id="remark" name="remark" class="formStyle" style="height:24px" disabled> 
                                    </select>                                         
                                </div> 
                                    
                            	<div id='getRemark' style="float:left">
                                	<input type="text" id="remark_desc" name="remark_desc" class="formStyleReadOnly" style="height:18px" readonly size="31" >
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
                     
                     
                     
                     <table width="100%" cellpadding="4" class="formStyle" cellspacing="0"  >  
                    	<tr><td></td></tr>
						<tr>
							<td align="center" >   
                              
									<table class="tablestyle" width="80%">
										  <tr class="boldstyle bgstyle1" ><td align="left" colspan="7" style="font-style:italic;">
										  <div style="float:left; margin-top:4px;">Packing Style Information</div>
										  <div id="progressbarPSI" style="display:none; float:left; margin-left:5px; ">
                                          	<img src="../../../includes/images/progress_green_small.gif" >
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
                                           
                                              <tr>  
                                                    <td align="center" width="24"><img src="../../../includes/images/new.png"></td>
                                                    <td align="center">
                                                        <select name="box_id" id="box_id" class="formStyle tips" onChange="getBoxSettings(this.value)" 
                                                        style="width:100%; text-align-last:center" >
                                                            <option value="">-- Please Select --</option>
                                                            <cfloop query="getBox">  
                                                                <option value="#box_id#">#box_code#</option>
                                                            </cfloop>	
                                                        </select> 
                                                    </td>
                                                    <td align="center">
                                                        <input type="text" size="17" id="measurement" readonly class="formStyleReadOnly" 
                                                        style="text-align:center" >
                                                    </td>
                                                    <td align="center">
                                                        <input type="text" size="17" id="weight" readonly class="formStyleReadOnly" 
                                                        style="text-align:center" >
                                                    </td>
                                                    <td align="center">
                                                        <input type="text" size="17" name="qty_per_box" id="qty_per_box" style="text-align:center" 
                                                        class="formStyle tips" onKeyUp="validateInputNumber(this.id)" >
                                                    </td>
                                                    <td align="center"><div id="psi_active_date" class="tips" ></div></td>
                                                    <td align="center"><div id="psi_inactive_date"></div></td>
                                              </tr>  
                                           
                                           
										  <tr class="boldstyle bgstyle1" id="psiFooter">
											<td align="right" colspan="7"></td>
										  </tr> 
									</table> 
							 
                             
                             		<br>
                            
                            
                            		<table class="tablestyle" width="80%" >
										  <tr class="boldstyle bgstyle1"><td align="left" colspan="10" style="font-style:italic;">
										  <div style="float:left; margin-top:4px;">Delivery Information</div>
										  <div id="progressbarDeliveryInfo" style="display:none; float:left; margin-left:5px; ">
                                          	<img src="../../../includes/images/progress_green_small.gif" >
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
                                          
                                           
                                          
                                          <tr>
				
											<td align="center" width="24"><img src="../../../includes/images/new.png"></td> 
											<td align="center">
                                                <select name="dock_id" id="dock_id" class="formStyle tips" style="width:98%"> 
                                                	<option value="">-- Please Select --</option>  
                                                    <cfloop query="getDock" >
                                                    	<option value="#dock_id#">#dock_code#</option>
                                                    </cfloop>
                                                </select> 
											</td>  
											<td align="center"> 
												<select name="order_type_id" id="order_type_id" class="formStyle tips" style="width:98%"> 
													<option value="">-- Please Select --</option>  
                                                    <cfloop query="getOrderType" >
                                                    	<option value="#order_type_id#">#order_type#</option>
                                                    </cfloop>  
												</select>  
											</td>  
											<td align="center"> 
												<select name="vendor_category_id" id="vendor_category_id" class="formStyle tips" style="width:98%"> 
													<option value="">-- Please Select --</option>    
                                                    <cfloop query="getVendorCategory" >
                                                    	<option value="#vendor_category_id#">#vendor_category#</option>
                                                    </cfloop>   
												</select> 
											</td> 
											<td align="center"> 
                                            <div id="div_vendor_setting_detail_id">
												<select name="vendor_setting_detail_id" id="vendor_setting_detail_id" class="formStyle tips" 
                                                onChange="loadDetailID();" style="width:98%" DISABLED> 
													<option value="">-- Please Select --</option>      
												</select>
                                            </div>
                                                <input type="hidden" id="delivery_category" name="delivery_category" >
                                            
                                            </td>
											<td><input type="text" class="formStyleReadOnly" readOnly style="width:98%" id="delivery_category_desc"></td>  
											<td align="center"><img id="checkTPL1_icon" src="../../../includes/images/tick_med_off.png" id="tpl1_flag" ></td> 
											<td align="center"><img id="checkTPL2_icon" src="../../../includes/images/tick_med_off.png" id="tpl2_flag" ></td>  
                                            <td align="center"><div id="dlv_active_date" class="tips"></div>
                                            </td>
                                            <td align="center">
                                                <div id="dlv_inactive_date"></div>
                                            </td>
				
										</tr>

                                        <!----------------- LSP Inventory Project ----------------------->
				                        <tr id="vendor_setting_panel"><td colspan="10" align="center" valign="middle"></td></tr>';

	
			<!----- DISABLED ------ LSP INVENTORY PROJECT ----------------------------------------------------------- 
										<tr class="tpl_panel" style="display:none">
                						<td colspan="10" align="center">
			
 
				 
                                            <table class="tablestyle" width="80%" style="margin-top:13px; margin-bottom:16px; display:none" id="tier1_panel">
                                            
                                                <tr class="boldstyle bgstyle1">
                                                    <td align="left" colspan="10" style="font-style:italic;">
                                                        <div style="float:left; margin-top:4px;">1st Tier TPL Information</div> 
                                                    </td>
                                                </tr>
                                                
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
                                                
												<tr>  
                                                    <td>
                                                        <img src="../../../includes/images/new.png" alt="New Setting"> 
                                                        <input type="hidden" name="tpl1_id" id="tpl1_id" > 
                                                    </td>  
													<td align="left" id="tpl1_name"></td>  
													<td> 
                                                        <select class="formStyle" name="tpl1_vendor_setting_detail_id" id="tpl1_vendor_setting_detail_id" 
                                                        style="text-align-last:center;width:98%" > 
                                                        <option value="">---</option> 
                                                        </select> 
                                                        <input type="hidden" id="tpl1_delivery_category" name="tpl1_delivery_category" >
                                                    </td>  
                                                    <td ><input type="text" class="formStyleReadOnly" readOnly style="width:98%" id="tier1_delivery_category_desc"></td> 
                                                    <td><div id="tpl1_active_date" class="tips"></div></td> 
                                                    <td><div id="tpl1_inactive_date"></div></td>   
                                                </tr> 
                                                     
										 </table>
			
			
			 
                                          <table class="tablestyle" width="80%" style="margin-top:13px; margin-bottom:16px; display:none" id="tier2_panel">
                                            
                                                <tr class="boldstyle bgstyle1">
                                                    <td align="left" colspan="10" style="font-style:italic;">
                                                        <div style="float:left; margin-top:4px;">2nd Tier TPL Information</div> 
                                                    </td>
                                                </tr>
                                                
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
                                                
												<tr>  
                                                    <td>
                                                        <img src="../../../includes/images/new.png" alt="New Setting"> 
                                                        <input type="hidden" name="tpl2_id" id="tpl2_id" > 
                                                    </td>  
													<td align="left" id="tpl2_name"></td>  
													<td> 
                                                        <select class="formStyle" name="tpl2_vendor_setting_detail_id" 
                                                        id="tpl2_vendor_setting_detail_id" onChange="getTier2DeliveryDescr(this.value)"
                                                        style="text-align-last:center;width:98%" > 
                                                        <option value="">---</option> 
                                                        </select> 
                                                        <input type="hidden" id="tpl2_delivery_category" 
                                                        name="tpl2_delivery_category" >
                                                    </td>  
                                                    <td ><input type="text" class="formStyleReadOnly" readOnly style="width:98%" id="tier2_delivery_category_desc"></td> 
                                                    <td><div id="tpl2_active_date" class="tips"></div></td> 
                                                    <td><div id="tpl2_inactive_date"></div></td>   
                                                </tr> 
                                                     
										 </table> 
                                    </td>
                               </tr>      
                                           
                               
                               
    ---- END : DISABLED ------ LSP INVENTORY PROJECT ----------------------------------------------------------->



                               <tr class="boldstyle bgstyle1 rowborder"><td align="right" colspan="10"></td></tr> 
                                        
                     	</table> 
				 
       
                     <table width="100%">
                        <tr><td height="5"></td></tr>
                        <tr>
                            <td align="right" bgcolor="F5F5F5" style="padding:8px">  
                                <input class="button white ctrlObj" type="button" value="Save" id="saveBtn" />   
                                <input class="button white ctrlObj" type="button" value="Cancel" id="cancelBtn" >
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

