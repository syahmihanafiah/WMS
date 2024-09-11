<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<cfsetting showdebugoutput="yes">
<html>
<head>
 
<cfinclude template="../../../includes/basic_includes.cfm" > 




<script type="text/javascript"> 
	
function rowSelected(vn,vid,dc,route,dt,tid,dtid,lookupID,parentID,tpl_name){
	
		
				var parentIDArr = parentID;
				var getParentID = parentIDArr.split("_"); 
				
				
				if (typeof parent.window.addChildRow == 'function') {
						parent.window.addChildRow(vn,vid,dc,route,dt,tid,dtid,lookupID,getParentID[1],tpl_name);
				}
				parent.window.$('#lookupWindow').jqxWindow('close');	
		}
		
</script>
  
</head>	 
                        
<body marginheight="0" marginwidth="0" topmargin="0" leftmargin="0" rightmargin="0" bottommargin="0">
<cfoutput>
<cfset currRowStyle = "lookupRow1" >
<cfset currBgColor = "F4F4F4" > 
<cfset rowno = 0 >
				
                	<cfif #url.tier# EQ 1>
                    	<cfquery name="lookupVendorList" datasource="#dswms#">    
                            SELECT a.vendor_setting_header_id as lookupID,
                            	   a.delivery_category,
                                   a.delivery_category_desc AS route,
                                   b.vendor_name,
                                   b.vendor_id,
                                   d.delivery_type,
                                   c.tpl_id,
                                   (SELECT vendor_name from frm_vendors where vendor_id = c.tpl_id) tpl_name,
       							   c.delivery_type_id
                              FROM gen_vendor_setting_headers a,
                                   frm_vendors b,
                                   gen_vendor_setting_details c,
                                   lsp_delivery_type d
                             WHERE     a.vendor_id = b.vendor_id
                                   AND a.vendor_setting_header_id = c.vendor_setting_header_id
                                   AND c.delivery_type_id = d.delivery_type_id
                                   AND d.org_id = a.org_id
                                   AND a.org_id = <cfqueryparam cfsqltype="cf_sql_integer"  value="#org_id#">
                                   AND c.tpl_id IS NOT NULL
                                   AND ( (c.inactive_date IS NULL)
                                        OR (c.inactive_date > (SELECT TRUNC (SYSDATE) FROM DUAL)))
                                   AND a.delivery_category_desc is not null   
                                   <cfif #url.lookupID# neq ''>
                                   		      AND a.vendor_setting_header_id  NOT IN (<cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#lookupID#">)
                                   </cfif>
                                        
                             ORDER BY  b.vendor_name            
                           
                        </cfquery>
                    
                    
                    
                    <cfelseif #url.tier# EQ 2>
                    
                    	<cfquery name="lookupVendorList" datasource="#dswms#">     
                            SELECT a.vendor_setting_t_header_id as lookupID,
                            	     --a.delivery_category,
                                   --a.delivery_category_desc AS route,
                                   (
                                       SELECT delivery_category 
                                       FROM gen_vendor_setting_details x, gen_vendor_setting_headers y
                                       WHERE x.vendor_setting_header_id = y.vendor_setting_header_id
                                       AND x.vendor_setting_detail_id = c.vendor_setting_detail_id
                                       AND x.active_date <= sysdate AND NVL(x.inactive_date,sysdate+1)>sysdate
                                       AND y.active_date <= sysdate AND NVL(y.inactive_date,sysdate+1)>sysdate
                                   ) delivery_category,
                                   (
                                       SELECT delivery_category_desc
                                       FROM gen_vendor_setting_details x, gen_vendor_setting_headers y
                                       WHERE x.vendor_setting_header_id = y.vendor_setting_header_id
                                       AND x.vendor_setting_detail_id = c.vendor_setting_detail_id
                                       AND x.active_date <= sysdate AND NVL(x.inactive_date,sysdate+1)>sysdate
                                       AND y.active_date <= sysdate AND NVL(y.inactive_date,sysdate+1)>sysdate
                                   ) route, 
                                   b.vendor_name,
                                   b.vendor_id,
                                   d.delivery_type,
                                   c.tpl_id,
                                   (SELECT vendor_name from frm_vendors where vendor_id = c.tpl_id) tpl_name,
       							   c.delivery_type_id 
                              FROM gen_vendor_setting_t_headers a,
                                   frm_vendors b,
                                   gen_vendor_setting_t_details c,
                                   lsp_delivery_type d
                             WHERE     a.vendor_id = b.vendor_id
                                   AND a.vendor_setting_t_header_id = c.vendor_setting_t_header_id
                                   AND c.delivery_type_id = d.delivery_type_id
                                   AND d.org_id = a.org_id
                                   AND a.org_id = <cfqueryparam cfsqltype="cf_sql_integer"  value="#org_id#">
                                   AND c.tpl_id IS NOT NULL
                                   AND ( (c.inactive_date IS NULL)
                                        OR (c.inactive_date > (SELECT TRUNC (SYSDATE) FROM DUAL)))
                                   --AND a.delivery_category_desc is not null 
                                   AND (
                                       SELECT MAX(delivery_category_desc)
                                       FROM gen_vendor_setting_details x, gen_vendor_setting_headers y
                                       WHERE x.vendor_setting_header_id = y.vendor_setting_header_id
                                       AND x.vendor_setting_detail_id = c.vendor_setting_detail_id
                                       AND x.active_date <= sysdate AND NVL(x.inactive_date,sysdate+1)>sysdate
                                       AND y.active_date <= sysdate AND NVL(y.inactive_date,sysdate+1)>sysdate
                                   ) IS NOT NULL
                                   <cfif #url.lookupID# neq ''>
                                      AND a.vendor_setting_t_header_id  NOT IN (<cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#lookupID#">)
                                   </cfif>
                            ORDER BY  b.vendor_name 

                        </cfquery>
                    
                    
                    
                    </cfif>
                    
                       
                                            
	<table width="100%" cellpadding="4">
		<tr class="lookupHeaderText">
			<td>No</td>
			<td>Vendor Name</td>
			<td>Delivery Category</td>
            <td>Route</td>
            <td>Delivery Type</td>
            <td>Transporter</td>
            <td style="display:none">lookupID</td>
		</tr>
        
       <cfif lookupVendorList.recordcount neq 0>	
		<cfloop query="lookupVendorList" >	
		
			<cfif currRowStyle EQ "lookupRow1" >
				<cfset currRowStyle = "lookupRow2" >
				<cfset currBgColor = "EBEBEB" >
			<cfelse>
				<cfset currRowStyle = "lookupRow1" >
				<cfset currBgColor = "F4F4F4" >
			</cfif> 
			
			<cfflush>
			
			<cfset rowno = rowno + 1 > 
			<!---<cfset description2 = Replace(col2, "'", "\'", "ALL")>
			<cfset description2 = Replace(description2, """", "\'\'", "ALL")> To catter special character.Remark on 20/08/2014--->
			<tr class="#currRowStyle#" onClick="rowSelected('#vendor_name#','#vendor_id#','#delivery_category#','#route#','#delivery_type#','#tpl_id#','#delivery_type_id#','#lookupID#','#url.rowId#','#tpl_name#');" 
			onMouseOver="this.style.backgroundColor='F0FFF4'" onMouseOut="this.style.backgroundColor='#currBgColor#'" >
			
                    <td nowrap="nowrap">#rowno#</td>
                    <td nowrap="nowrap">#vendor_name#</td>
                    <td nowrap="nowrap">#delivery_category#</td>
                    <td nowrap="nowrap">#route#</td>
                    <td nowrap="nowrap">#delivery_type# </td>
                    <td nowrap="nowrap">#tpl_name# </td>
                    <td nowrap="nowrap" style="display:none">#lookupID#</td>
			</tr> 
		</cfloop>
            <cfelse>
                    <tr  class=" formStyle"><td nowrap="nowrap" align="center" colspan="5">No Routes Available</td></tr>
            </cfif>
				
	</table>
	
</cfoutput>
     
</body> 
</html>


 