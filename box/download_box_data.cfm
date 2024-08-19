<cfsetting enablecfoutputonly="Yes"> 
<cfcontent type="application/msexcel"> 
<cfheader name="Content-Disposition" value="filename=#filename# #dateformat(now(),'dd/mm/yyyy')#.xls"> 

	<cfquery name="getData" datasource="#dswms#" >  
        SELECT * FROM 
        (SELECT a.box_id, a.box_code, a.box_name, 
               a.length || ' x ' || a.width || ' x ' || a.height measurement, a.weight,
               b.org_description, c.org_description ownership_name,
               to_char(a.creation_date,'dd/mm/yy hh:mi:ss AM') creation_date, a.creation_by, 
               to_char(a.last_updated_date,'dd/mm/yy hh:mi:ss AM') last_updated_date, a.last_updated_by,
                    CASE WHEN a.inactive_date IS NULL THEN
                             CASE WHEN a.active_date <= to_date(sysdate,'dd/mm/yy') 
                             THEN 'ACTIVE' ELSE 'INACTIVE' END
                    ELSE  
                            CASE WHEN a.active_date <= to_date(sysdate,'dd/mm/yy') AND a.inactive_date > to_date(sysdate,'dd/mm/yy')
                            THEN 'ACTIVE' ELSE 'INACTIVE' END 
                    END status,
                    CASE WHEN a.inactive_date IS NULL THEN
                             CASE WHEN a.active_date <= to_date(sysdate,'dd/mm/yy') 
                             THEN 'ACTIVE' ELSE 'INACTIVE' END
                    ELSE  
                            CASE WHEN a.active_date <= to_date(sysdate,'dd/mm/yy') AND a.inactive_date > to_date(sysdate,'dd/mm/yy')
                            THEN 'ACTIVE' ELSE 'INACTIVE' END 
                    END edit
        FROM gen_box a, frm_organizations b, frm_organizations c
        WHERE a.org_id = b.org_id
        AND c.ownership_flag = 'Y'
        AND a.ownership_id = c.org_id
        <cfif org_id NEQ "" >
            AND a.org_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#org_id#">
        </cfif>  )
        <cfif status NEQ "" >
            where status = <cfqueryparam cfsqltype="cf_sql_varchar" value="#status#">
        </cfif> 
    </cfquery> 
       
<cfoutput>           
<html>
<head>
<body>


<table cellpadding="20">
    <tr><td colspan="12" align="center" style="font-size:24px; font-weight:bold; font-style:italic;">
    BOX MASTER REPORT
    </td></tr>
</table>


<br>
<table border="1" style="border:thin">
	<tr style="font-weight:bold">
    	<td align="center" width="1">No</td>
        <td align="center">Box Code</td> 
		<td align="center">Box Name</td>
        <td align="center">Measurement(mm)</td> 
        <td align="center">Weight(g)</td>
        <td align="center">Organization</td>
        <td align="center">Ownership</td>
        <td align="center">Status</td> 
        <td align="center">Created Date</td>    
        <td align="center">Created By</td> 
        <td align="center">Last Update Date</td> 
        <td align="center">Last Update By</td> 
	</tr>
    
    	<cfset i = 0>
    	<cfloop query="getData" >
            <cfset i = #i#+1>
            <cfset bgclr = "" >
            <tr bgcolor="#bgclr#">
                <td align="center">#i#</td>
                <td align="center">#box_code#</td>
                <td align="center">#box_name#</td>
                <td align="center">#measurement#</td>
                <td align="center">#weight#</td>
                <td align="center">#org_description#</td>
                <td align="center">#ownership_name#</td>
                <td align="center">#status#</td>
                <td align="center">#creation_date#</td>
                <td align="center">#creation_by#</td>
                <td align="center">#last_updated_date#</td>
                <td align="center">#last_updated_by#</td>
            </tr>
        </cfloop> 
  
    
</table> 
	 

</body>
</html>

  </cfoutput>






