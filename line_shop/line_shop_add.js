	var currRow = 0;
	var totalCreatedRow = 0;

  	$(document).ready(function () {  
    	$("#jqxExpander").jqxExpander({ width: '100%', toggleMode: "none", showArrow: false });
		
		$("#active_date_picker").jqxDateTimeInput({width: '185px', height: '25px'}); 
		setMinDate('','active_date_picker'); 
		 
		$('#active_date_picker').on('valuechanged', function (event) {   
			$('#active_date').val( $('#active_date_picker').val());
			clear_tooltips();
		}); 
		$('#active_date_picker').jqxDateTimeInput('setDate', Date.now());
	 
		$("#inactive_date_picker").jqxDateTimeInput({width: '185px', height: '25px'}); 
		setMinDate('','inactive_date_picker'); 
		
		setTimeout(function(){$('#inactive_date_picker').val(null);
		$('#inactive_date').val(null)},1);
		
		$('#inactive_date_picker').on('valuechanged', function (event) {   
			$('#inactive_date').val( $('#inactive_date_picker').val()); 
		}); 
		
		$("#ratio_flag").prop('unchecked',true);
		
	
		/*------------------------------- JQX MENU (START)------------------------------------*/
		$("#jqx_menu").jqxMenu({ width: '20px', height: '20px', rtl: true}); //--> JQX MENU INITILIZATION
		$("#jqx_menu").css('visibility', 'visible'); //--> JQX MENU INITILIZATION

		//--> check box to select all created rows
		$("#checkAll").change(function (e) {  
			$(this).closest("table").find('.rowCheckBox').attr("checked", this.checked).change(); //--> Find all created rows chechbox and check/uncheck them all.
			toogleRemoveBtn('rowCheckBox','removeBtn'); //--> toggle remove button to show/hide. Parameters: (checkbox class, remover button id)
			
		});
		
		$("#closeBtn").click(function(e) {
			window.parent.closeTab($("#tabid").val()); 
		});
		
		//--> Add new row button in the configuration (gear)
		$(".addBtn").click(function(e) {
			$(".noRow").hide();
			addNewRow(); //-->Initialize new row
		}); 
		
		$("#addBtn").click(function(e) {
			$(".noRow").hide();
			addNewRow(); //-->Initialize new row
		}); 
		//--> History button in the configuration (gear) icon (To show history if available)
		$("#showhistoryBtn").click(function(e) {
			$(".inactive_row").show();
			$("#showhistoryBtn").hide();
			$("#hidehistoryBtn").show(); 
		});
		
		//--> History button in the configuration (gear) icon (To hide history if available)	
		$("#hidehistoryBtn").click(function(e) {
			$(".inactive_row").hide();
			$("#showhistoryBtn").show();
			$("#hidehistoryBtn").hide(); 
		});
		
		//--> Remove all checked rows
		$("#removeBtn").click(function(e) {
			//--> Loop through each checkboxs to find checked and remove 
			$(".rowCheckBox").each(function(index, element) {
				if(this.checked == true){
					var getID = this.id.split("_");
					removeRow(getID[1]);
				}
			});
		}); 
		
		
		 
		var add_options = {   
			beforeSubmit:  validateInput,
			success: showChangeResponse   
		}; 
		$('#addForm').ajaxForm(add_options); 
		 
  	}); 
	
	$jqtips(document).ready(function() { 
		$jqtips('#org_id').poshytip({ className: 'tip-red', content: 'none', showOn: 'none', alignTo: 'target', alignX: 'right', alignY: 'center', offsetX: 6, offsetY: 5 });   
		$jqtips('#displayShop').poshytip({ className: 'tip-red', content: 'none', showOn: 'none', alignTo: 'target', alignX: 'right', alignY: 'center', offsetX: 6, offsetY: 5 });    
		$jqtips('#line_shop').poshytip({ className: 'tip-red', content: 'none', showOn: 'none', alignTo: 'target', alignX: 'right', alignY: 'center', offsetX: 6, offsetY: 5 }); 
		$jqtips('#volume_source').poshytip({ className: 'tip-red', content: 'none', showOn: 'none', alignTo: 'target', alignX: 'right', alignY: 'center', offsetX: 6, offsetY: 5 }); 
		$jqtips('#active_date_picker').poshytip({ className: 'tip-red', content: 'none', showOn: 'none', alignTo: 'target', alignX: 'right', alignY: 'center', offsetX: 6, offsetY: 5 });  
		$jqtips('#inactive_date_picker').poshytip({ className: 'tip-red', content: 'none', showOn: 'none', alignTo: 'target', alignX: 'right', alignY: 'center', offsetX: 6, offsetY: 5 });  
		$jqtips('#ownership_id').poshytip({ className: 'tip-red', content: 'none', showOn: 'none', alignTo: 'target', alignX: 'right', alignY: 'center', offsetX: 6, offsetY: 5 });  
	});
	  
	function clear_tooltips(){
		$jqtips('#org_id').poshytip('hide');
		$jqtips('#displayShop').poshytip('hide'); 
		$jqtips('#line_shop').poshytip('hide'); 
		$jqtips('#volume_source').poshytip('hide'); 
		$jqtips('#active_date_picker').poshytip('hide'); 
		$jqtips('#inactive_date_picker').poshytip('hide');
		$jqtips('#ownership_id').poshytip('hide');
	}
	
	function inprogress(status){
		if(status=="start"){
			$("#progressbar").show(); 
			document.getElementById("saveBtn").disabled = true; 
			document.getElementById("resetBtn").disabled = true; 
			document.getElementById("closeBtn").disabled = true; 
		}
		else {
			$("#progressbar").hide();
			document.getElementById("saveBtn").disabled = false; 
			document.getElementById("resetBtn").disabled = false; 
			document.getElementById("closeBtn").disabled = false; 
		}
	}
 
	function validateInput(formData, jqForm, options) {
		
		clear_tooltips();
		
		var f = document.addForm; 
	
		if(trim(f.org_id.value) == ""){
				$jqtips(document).ready(function() {   
					$jqtips('#org_id').poshytip('update', 'Please select organization');
					$jqtips('#org_id').poshytip('show'); 
				});
				f.org_id.focus();
				return false;
		}
		else if(trim(f.shop_id.value) == ""){
				$jqtips(document).ready(function() {   
					$jqtips('#displayShop').poshytip('update', 'Please select shop');
					$jqtips('#displayShop').poshytip('show'); 
				});
				f.shop_id.focus();
				return false;
		}
		else if(trim(f.line_shop.value) == ""){
				$jqtips(document).ready(function() {   
					$jqtips('#line_shop').poshytip('update', 'Please insert line shop');
					$jqtips('#line_shop').poshytip('show'); 
				});
				f.line_shop.focus();
				return false;
		} 
		
		else if(trim(f.volume_source.value) == ""){
				$jqtips(document).ready(function() {   
					$jqtips('#volume_source').poshytip('update', 'Please select volume source');
					$jqtips('#volume_source').poshytip('show'); 
				});
				f.volume_source.focus();
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
		/*Gear Up Project*/
		else if(trim(f.ownership_id.value) == ""){
				$jqtips(document).ready(function() {   
					$jqtips('#ownership_id').poshytip('update', 'Please insert ownership');
					$jqtips('#ownership_id').poshytip('show'); 
				});
				$('#ownership_id').focus();
				return false;
		}
		/*Gear Up Project*/
		else if(!checkDPISource()){
			return false;
		} 
		
		else { 
			//inprogress("start");
			loadingoverlay('show');
			return true;
		}
	}
	
	function checkDPISource(){
		var invalidCounter = true;
			if($("#newRowList").val() != ""){		
				var validateList = $("#newRowList").val().split(',');
				
				for(x=0; x < validateList.length; x++){
					if($('#dpi_source_'+validateList[x]).val() == ''){
						showTips('dpi_source_'+validateList[x],'Please select DPI source!', 3000);
						invalidCounter = false;
						return false;
					}
					else if($('#do_start_date_'+validateList[x]).val() == ''){
						showTips('do_start_date_'+validateList[x],'Please insert DO start date!', 3000);
						invalidCounter = false;
						return false;
					}
					else if($('#do_start_date_'+validateList[x]).val() == $('#do_end_date_'+validateList[x]).val()){
						showTips('do_end_date_'+validateList[x],'End date must be more than Start Date!', 3000);
						setTimeout(function(){ $('#do_end_date_'+validateList[x]).jqxDateTimeInput('setDate',null); },100);
						invalidCounter = false;
						return false;
					}
				}
			} 
		return invalidCounter;	
	}
	
	function showChangeResponse(responseText, statusText, xhr, $form)  { 
		//inprogress("end"); 
		loadingoverlay('hide');
		var responseArr = responseText.split("~~");
 
		if(trim(responseArr[1]) == "success"){	
				window.parent.notify("success","Add Line Shop","Line Shop "+$("#line_shop").val()+" is successfully add!","5000");  
				//window.location.href='line_shop.cfm';
				window.location.href='line_shop_edit.cfm?line_shop_id=' + responseArr[4];   
				
		} else if(trim(responseArr[1]) == "failed"){
				window.parent.notify("error","Add Line Shop",trim(responseArr[2]),"5000");
		}		
	}
	
		function save_jit_flag() 
	{
		if (document.getElementById('jit_flag').checked) {
		  	document.getElementById("jit_flag_val").value = "Y"  
		  }
		else {
		  	document.getElementById("jit_flag_val").value = "N"  
		  } 
	}
	
	function fillShop(org_id){
		$(document).ready(function(){ 
			clear_tooltips();
			document.getElementById("displayShop").innerHTML = '<select class="formStyle" disabled="disabled"><option value="">-- Please Select --</option></select>';   
			if(org_id!= "") {
				var param="org_id="+org_id; 
				var url="bgprocess.cfm?action_flag=fillShop";
				var request=null; 
				if(window.XMLHttpRequest){ request=new XMLHttpRequest(); }
				else if(window.ActiveXObject){ request = new ActiveXObject("Microsoft.XMLHTTP"); } 
				if(request){  
					request.open("POST",url);
					request.setRequestHeader("Content-Type","application/x-www-form-urlencoded; charset=UTF-8"); 
					request.onreadystatechange = function() {
						 if(request.readyState==4){  
							var responseArr = request.responseText.split("~~");  
							document.getElementById("displayShop").innerHTML = responseArr[1]; 
						} 
					}
					request.send(param); 
				} 
			}
		});
	}
	
		/* PLANE PMSB PROJECT */
	function fillJITFlag(org_id){
		$(document).ready(function(){ 
			if($('#org_id').val() != '') {
			$.ajax({
						type: 'POST',
						url: 'bgprocess.cfm',
						data: {
						target:'grid',
						action_flag:'fillJITFlag',
						org_id:$('#org_id').val()
	
					}, 
					
					success:function(data){ 
						var resultArr = data.split("~~"); 
						if (trim(resultArr[1]) == 'N') {  
							$("#displayJITFlag").html('<input type="checkbox" name="jit_flag" id="jit_flag" onchange="save_jit_flag();">');
						}
						else{
							$("#displayJITFlag").html('<input type="checkbox" name="jit_flag" id="jit_flag" disabled>');
					  	}
					  },
						error:function(){ 
							window.parent.notify("error","Line Shop",'Error while processing your request',"3000");
						}
					});
		}
		else { 
				$("#displayJITFlag").html('<input type="checkbox" name="jit_flag" id="jit_flag" disabled>');
			}

	  });
	}
	

	//-->Create new rows
	function addNewRow(){ 
		$(document).ready(function(e) { 
		
			var setActiveDate = '';
			var proceed = 'Y';
			var lastInactivePicker = '';
			
			if($("#newRowList").val() != ''){
				var getLastID = $("#newRowList").val().split(',');
				
				if(getLastID.length >= 2){
					window.parent.notify("warning","Add Line Shop","Only 2 DPI source can be added at a time!","5000");
					proceed = 'N';
				}
				else if($("#do_end_date_"+getLastID[getLastID.length-1]).val() == ''){
					showTips('do_end_date_'+getLastID[getLastID.length-1],'Please select end date first!', 3000);
					proceed = 'N';
				}
				else{
					setActiveDate = $("#do_end_date_"+getLastID[getLastID.length-1]).val();
					lastInactivePicker = 'do_end_date_'+getLastID[getLastID.length-1];
				}
			}
			
			
			if(proceed == 'Y'){
				
				currRow++;  //--> set new row
				totalCreatedRow++;  //--> update created rows
				
				var DPISourceList = $("#DPISourceList").val();
				var DPISourceArr = DPISourceList.split(',');
				
				//--> Create row painter based on total column defined 
				var rowpainter = '';
					rowpainter = '<tr id="newRow_'+currRow+'" class="newRow" >';
					rowpainter = rowpainter + '<td align="center"><input type="checkbox"  value="'+currRow+'" class="rowCheckBox" id="rowCheckBox_'+currRow+'"></td>'; 
					rowpainter = rowpainter + '<td align="center" ><img src="../../../includes/images/new.png"></td>';
					
					rowpainter = rowpainter  + '<td align="center">';
					rowpainter = rowpainter  + '<select  name="dpi_source_'+currRow+'" id="dpi_source_'+currRow+'"  class="formStyle tips" >';
					rowpainter = rowpainter + '<option value=""> -- Please Select --</option> ';
						for ( var t = 0 ; t < DPISourceArr.length ; t++ ){
							rowpainter = rowpainter + '<option value="' + DPISourceArr[t] + '">' + DPISourceArr[t] + '</option> ';
						}
					rowpainter = rowpainter  + '</select>'; 
					rowpainter = rowpainter  + '</td>'; 
									
					rowpainter = rowpainter + '<td align="center">';
					rowpainter = rowpainter + '<div id="do_start_date_'+currRow+'" name="do_start_date_'+currRow+'"  class="do_start_date" currID="'+currRow+'"></div>'; 
					rowpainter = rowpainter + '</td>'; 
					
					rowpainter = rowpainter + '<td align="center">';
					rowpainter = rowpainter + '<div id="do_end_date_'+currRow+'" name="do_end_date_'+currRow+'"  class="do_end_date"  currID="'+currRow+'"></div>'; 
					rowpainter = rowpainter + '</td>'; 
					
					rowpainter = rowpainter + '</tr>';
				
				//--> Append row painter to table after the last row	
				$('#rowPainter > tbody:last').append(rowpainter);  
				
				$('#do_start_date_'+currRow).jqxDateTimeInput({width: '120px', height: '25px'});  
				$('#do_end_date_'+currRow).jqxDateTimeInput({width: '120px', height: '25px'}); 
				
				setMinDate(setActiveDate,'do_start_date_'+currRow);  
				setMinDateNextDay(setActiveDate,'do_end_date_'+currRow);
				
				setTimeout(function(){ 
					//$('#do_start_date_'+currRow).jqxDateTimeInput('setDate',null);
					$('#do_end_date_'+currRow).jqxDateTimeInput('setDate',null);
				},100);
				
				regTips('dpi_source_'+currRow); 
				regTips('do_start_date_'+currRow); 
				regTips('do_end_date_'+currRow); 
				
				$('#do_start_date_'+currRow).change(function(e){
					var currID = $(this).attr('currID');
					setMinDateNextDay(this.value,'do_end_date_'+currID);
					setTimeout(function(){ $('#do_end_date_'+currID).jqxDateTimeInput('setDate',null); },100);
					resetNextRow(currID,'start');
				});
				
				$('#do_end_date_'+currRow).change(function(e){
					var currID = $(this).attr('currID');
					if($('#do_start_date_'+currID).val() == ''){
						showTips('do_start_date_'+currID,'Please select DO start date first!', 3000);
						setTimeout(function(){ $('#do_end_date_'+currID).jqxDateTimeInput('setDate',null); },100);
					}
					resetNextRow($(this).attr('currID'),'end');
				});
				
				$('#'+lastInactivePicker).change(function(e){
					setMinDate(this.value,'do_start_date_'+currRow);
				});
				
				//--> Toggle remove button on change
				$("#rowCheckBox_"+currRow).change(function(e) { 
					toogleRemoveBtn('rowCheckBox','removeBtn'); //--> toggle remove button to show/hide. Parameters: (checkbox class, remover button id)
				});
				
				updateRowList(); //--> Update Row List for submition
			}
		});
	}
	
	function resetNextRow(currID,type){
		$(document).ready(function(e) {
			
			if($("#newRowList").val() != ''){
				var findNextRow = $("#newRowList").val().split(',');
				var currIndex = findNextRow.indexOf(currID);
				
				if(currIndex >= 0 && currIndex < findNextRow.length - 1){
				   var nextRow = findNextRow[currIndex + 1];
				   if(type == 'start'){
					   setTimeout(function(){ 
						$('#do_start_date_'+nextRow).jqxDateTimeInput('setDate',null); 
						$('#do_end_date_'+nextRow).jqxDateTimeInput('setDate',null); 
					   },100);
				   }
				   else{
					  setTimeout(function(){ 
						$('#do_start_date_'+nextRow).jqxDateTimeInput('setDate',null); 
						$('#do_end_date_'+nextRow).jqxDateTimeInput('setDate',null); 
					   },100);  
					  setMinDate($('#do_end_date_'+currID).val(),'do_start_date_'+nextRow);
				   }
				}
			}
        });	
	}
	
	//--> Toggle remove button to show/hide base on check box selected is checked or not
	function toogleRemoveBtn(checkBoxClass,removeBtnID){
		$(document).ready(function(e) {
			var counter = 0;
			$("."+checkBoxClass).each(function(index, element) {
				  if($(this).prop('checked') == true){
					counter++;
					return false;
				  }
			});
			if(counter > 0) { $("#"+removeBtnID).show(); } else { $("#"+removeBtnID).hide(); }
        });	
	}
	
	
	
	function removeRow(getID){
		$(document).ready(function(e) { 
			$("#newRow_"+getID).remove();
			
			totalCreatedRow--;   //--> Update total created rows value
			if(totalCreatedRow<=0 && $(".active_row").length == 0){ $(".noRow").show(); } //--> If no active rows are available, default add 1 new row
			$("#checkAll").attr("checked", false); // --> Unchecked the Select all checkbox
			toogleRemoveBtn('rowCheckBox','removeBtn'); //--> toggle remove button to show/hide. Parameters: (checkbox class, remover button id)
			updateRowList(); //--> Update Row List for submition
        });
	}
	
	function updateRowList(){
		$(document).ready(function(e) {
            var newRowList = '';
			
			 //-->Loop through each new rows
			$(".newRow").each(function(index, element) {
				var getID = this.id.split("_");
                if(newRowList ==''){
					newRowList = getID[1];	
				}
				else{
					newRowList = newRowList + ',' + getID[1];	
				}
            });
			 //--> Store all new rows ID into a list of value
			$("#newRowList").val(newRowList);
        });	
	}
	
	
