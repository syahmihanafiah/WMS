<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>
<head>

<cfinclude template="../../../includes/file_access_validation.cfm" > 
<cfinclude template="../../../includes/basic_includes.cfm" >
 
<script type="text/javascript"> 
  
  	$(document).ready(function () {  
    	$("#jqxExpander").jqxExpander({ width: '100%', toggleMode: "none", showArrow: false });
		
		$("#active_date_picker").jqxDateTimeInput({width: '230px', height: '25px', disabled: 'true'}); 
		$('#active_date_picker').val(convertDateFormat($('#active_date').val()));
		$('#active_date_picker').on('valuechanged', function (event) {   
			$('#active_date').val( $('#active_date_picker').val());
			clear_tooltips();
		}); 
	  
		$("#inactive_date_picker").jqxDateTimeInput({width: '230px', height: '25px'}); 
		setMinDate('','inactive_date_picker');
		
		if($('#inactive_date').val() == ''){
			setTimeout(function(){
				$('#inactive_date_picker').val(null);
			},1);
		}
		else {
			setTimeout(function(){
				$('#inactive_date_picker').val(convertDateFormat($('#inactive_date').val()));
			},1);
		}
		
		$('#inactive_date_picker').on('valuechanged', function (event) {   
			$('#inactive_date').val( $('#inactive_date_picker').val());
		});
		 
		var edit_options = {   
			beforeSubmit:  validateInput,
			success: showChangeResponse   
		}; 
		$('#editForm').ajaxForm(edit_options); 
		 
  	}); 
	
	$jqtips(document).ready(function() {    
		$jqtips('#box_name').poshytip({ className: 'tip-red', content: 'none', showOn: 'none', alignTo: 'target', alignX: 'right', alignY: 'center', offsetX: 6, offsetY: 5 });  
		$jqtips('#length').poshytip({ className: 'tip-red', content: 'none', showOn: 'none', alignTo: 'target', alignX: 'right', alignY: 'center', offsetX: 6, offsetY: 5 });  
		$jqtips('#width').poshytip({ className: 'tip-red', content: 'none', showOn: 'none', alignTo: 'target', alignX: 'right', alignY: 'center', offsetX: 6, offsetY: 5 });  
		$jqtips('#height').poshytip({ className: 'tip-red', content: 'none', showOn: 'none', alignTo: 'target', alignX: 'right', alignY: 'center', offsetX: 6, offsetY: 5 });  
		$jqtips('#weight').poshytip({ className: 'tip-red', content: 'none', showOn: 'none', alignTo: 'target', alignX: 'right', alignY: 'center', offsetX: 6, offsetY: 5 }); 
		$jqtips('#active_date_picker').poshytip({ className: 'tip-red', content: 'none', showOn: 'none', alignTo: 'target', alignX: 'right', alignY: 'center', offsetX: 6, offsetY: 5 });  
	});
	  
	function clear_tooltips(){ 
		$jqtips('#box_name').poshytip('hide');   
		$jqtips('#length').poshytip('hide');   
		$jqtips('#width').poshytip('hide');   
		$jqtips('#height').poshytip('hide');   
		$jqtips('#weight').poshytip('hide'); 
		$jqtips('#active_date_picker').poshytip('hide'); 
	}
	
	function inprogress(status){
		if(status=="start"){
			$("#progressbar").show(); 
			document.getElementById("updateBtn").disabled = true; 
			document.getElementById("resetBtn").disabled = true; 
			document.getElementById("closeBtn").disabled = true; 
		}
		else {
			$("#progressbar").hide();
			document.getElementById("updateBtn").disabled = false; 
			document.getElementById("resetBtn").disabled = false; 
			document.getElementById("closeBtn").disabled = false; 
		}
	}
 
	function validateInput(formData, jqForm, options) {
		
		clear_tooltips();
		
		var f = document.editForm; 
	
		if(trim(f.box_name.value) == ""){
				$jqtips(document).ready(function() {   
					$jqtips('#box_name').poshytip('update', 'Please insert box name');
					$jqtips('#box_name').poshytip('show'); 
				});
				f.box_name.focus();
				return false;
		} 
		else if(trim(f.length.value) == ""){
				$jqtips(document).ready(function() {   
					$jqtips('#length').poshytip('update', 'Please insert box length');
					$jqtips('#length').poshytip('show'); 
				});
				f.length.focus();
				return false;
		} 
		else if(trim(f.width.value) == ""){
				$jqtips(document).ready(function() {   
					$jqtips('#width').poshytip('update', 'Please insert box width');
					$jqtips('#width').poshytip('show'); 
				});
				f.width.focus();
				return false;
		} 
		else if(trim(f.height.value) == ""){
				$jqtips(document).ready(function() {   
					$jqtips('#height').poshytip('update', 'Please insert box height');
					$jqtips('#height').poshytip('show'); 
				});
				f.height.focus();
				return false;
		} 
		else if(trim(f.weight.value) == ""){
				$jqtips(document).ready(function() {   
					$jqtips('#weight').poshytip('update', 'Please insert box weight');
					$jqtips('#weight').poshytip('show'); 
				});
				f.weight.focus();
				return false;
		} 
		else if(trim(f.active_date.value) == ""){
				$jqtips(document).ready(function() {   
					$jqtips('#active_date_picker').poshytip('update', 'Please insert active date');
					$jqtips('#active_date_picker').poshytip('show'); 
				});
				$('#active_date_picker').focus();
				return false;
		} 
		else { 
		 
			inprogress("start");
			return true;
		}
	}
	
	function showChangeResponse(responseText, statusText, xhr, $form)  { 
		inprogress("end"); 
 
		var responseArr = responseText.split("~~");
 
		if(trim(responseArr[1]) == "success"){	
				window.parent.notify("success","Edit Box","Box "+$("#box_code").val()+" is successfully update!","5000");  
				window.location.href='box.cfm';
				
		} else if(trim(responseArr[1]) == "failed"){
				window.parent.notify("error","Edit Box",trim(responseArr[2]),"5000");
		}
	}
 
 	function validateInputNumber(fieldID,data) {
 
		clear_tooltips();
	 	if(isNaN(data)) {
				$jqtips(document).ready(function() {  
					$jqtips('#'+fieldID).val('');  
					$jqtips('#'+fieldID).poshytip('update', 'Please insert a valid number');
					$jqtips('#'+fieldID).poshytip('show'); 
					$jqtips('#'+fieldID).focus();
				});
		}  
				 
	}
	
</script>
 
</head> 
  
<cfquery name="getBox" datasource="#dswms#"> 
	 SELECT a.box_id, a.box_code, a.box_name, b.org_description ownership_name,
	 		a.length , a.width, a.height, a.weight, a.org_id,
	 		to_char(a.active_date,'dd/mm/yyyy') active_date, to_char(a.inactive_date,'dd/mm/yyyy') inactive_date
     FROM gen_box a, frm_ownership b
     WHERE a.box_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#box_id#"> 
	 AND a.ownership_id = b.ownership_id
</cfquery>

<cfinvoke component="#component_path#.organization_decoder" method="decodeOrganizationsID" dsn="#dswms#" returnvariable="OrgArr" ></cfinvoke>
 
<body background="../../../includes/images/bground1.png"> 
	<div id="content">
		<div class="screen_header">General Master > Master Data > Box > Edit</div>  
	</div>  
	<br><br><br>  
	<div id='jqxWidget' style="width:99%; margin:auto"> 
		<div id='jqxExpander'>
            <div>
				<div style="float:left">Edit box</div> 
				<div id="progressbar" style="float:right; display:none; margin-left:10px; margin-top:3px"><img src="../../../includes/images/progress_green_small.gif" ></div>
			</div>  
		 
            <div> 
				<cfoutput> 
				<form name="editForm" id="editForm" action="bgprocess.cfm" method="post">  
					<input type="hidden" name="action_flag" value="edit" >  
					<input type="hidden" name="box_id" value="#box_id#" >
					<table width="100%" cellpadding="4" class="formStyle" cellspacing="0">
					  <tr>
						<td height="5"></td>
					  </tr>
					  <tr>
						<td align="right" width="20%">Organization : </td>
						<td align="left" width="25%"><input type="text" class="formStyleReadOnly" readonly size="40" value="#decodeOrgID(OrgArr,getBox.org_id)#"></td>
						<td align="right" width="20%"> Ownership :</td>
						<td align="left" width="25%">
							<input type="text" class="formStyleReadOnly" readonly size="40" value="#getBox.ownership_name#"></td>
						</td> 	
					  </tr>  
					  <tr>
						<td align="right" width="20%">Box Code : </td>
						<td align="left" width="25%"><input type="text" name="box_code" id="box_code" value="#getBox.box_code#" class="formStyleReadOnly" readonly size="20"></td> 
						<td align="right" width="25%">Box Name : </td>
						<td align="left" width="30%" ><input type="text" name="box_name" id="box_name" value="#getBox.box_name#" class="formStyle" size="40" onKeyDown="clear_tooltips();"></td>
					  </tr>
					   <tr>
						<td align="right" width="20%" >Measurement(mm) : </td>
						<td align="left" width="25%">
							<table cellpadding="0" cellspacing="0">
								<tr> 
									<td>
										<input type="text" name="length" id="length" value="#getBox.length#" class="formStyle" style="text-align:center" size="10" 
										 onKeyUp="validateInputNumber(this.id,this.value);" onBlur="clear_tooltips();">
									</td>
									<td> x </td>
									<td>
										<input type="text" name="width" id="width" value="#getBox.width#" class="formStyle" style="text-align:center" size="10" 
										 onKeyUp="validateInputNumber(this.id,this.value);" onBlur="clear_tooltips();">
									</td>
									<td> x </td>
									<td>
										<input type="text" name="height" id="height" value="#getBox.height#" class="formStyle" style="text-align:center" size="10" 
										 onKeyUp="validateInputNumber(this.id,this.value);" onBlur="clear_tooltips();">
									</td>
								</tr>
								<tr> 
									<td align="center" style="font-style:italic; font-size:smaller">(length)</td>
									<td></td>
									<td align="center" style="font-style:italic; font-size:smaller">(width)</td>
									<td></td>
									<td align="center" style="font-style:italic; font-size:smaller">(height)</td>
								</tr>
							</table> 
						</td> 
						<td align="right" width="25%">Weight(g) : </td>
						<td align="left" width="30%" >
							<input type="text" name="weight" id="weight" value="#getBox.weight#" class="formStyle" style="text-align:center" size="10" 
							 onKeyUp="validateInputNumber(this.id,this.value);" onBlur="clear_tooltips();">
						</td>
					  </tr>   
					  <tr>
						<td align="right">Active Date : </td>
						<td align="right">
							<div align="left">
								<div id='active_date_picker'></div>
								<input type="hidden" name="active_date" id="active_date" class="formStyle" size="30" value="#getBox.active_date#">
							</div>
						</td>
						<td align="right">Inactive Date : </td>
						<td align="right">
							<div align="left">
								<div id='inactive_date_picker'></div>
								<input type="hidden" name="inactive_date" id="inactive_date" class="formStyle" size="30" value="#getBox.inactive_date#">
							</div>
						</td>
					  </tr>
					  <tr>
						<td height="10"></td>
					  </tr>
					  <tr>
						<td colspan="4" align="right" bgcolor="F5F5F5" style="padding:8px">
							<input id="updateBtn" name="submit" type="submit" class="button white" value="Update" />
							<input id="resetBtn" name="button" type="button" class="button white" onClick="window.location.href=self.location" value="Reset"/>
							<input id="closeBtn" name="button" type="button" class="button white" onClick="window.location.href='box.cfm'" value="Close" />
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








