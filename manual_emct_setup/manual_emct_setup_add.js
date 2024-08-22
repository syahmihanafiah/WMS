/*
  Suite         : EMCT
  Purpose       : Initial Creation 

  Version    Developer    		Date            Remarks
  2.0.00     Yusrah         	
*/

var currRow = 0;
var totalCreatedRow = 0;

$(document).ready(function(e) {
	 //--> this features allow panel to collapse or expand to get more space 
	$("#UIPanel").jqxExpander({ width: '100%', toggleMode: "none", showArrow: false  }) 
	
	//--> START (FLOATING BUTTONS) ANIMATIONS
		$jqeff("#addFloatBtn").mouseenter(function() { 
		  $jqeff( this ).animate({ marginBottom:'8px' }, 100 ); 
		  $(this).attr("src",'../../../includes/images/add_round_green.png');
		}); 
		$jqeff("#addFloatBtn").mouseout(function() { 
		  $jqeff( this ).animate({ marginBottom:'0px' }, 100 ); 
		  $(this).attr("src",'../../../includes/images/add_round_dimmed.png');
		});
		
		$jqeff("#removeFloatBtn").mouseenter(function() { 
		  $jqeff( this ).animate({ marginBottom:'8px' }, 100 ); 
		  $(this).attr("src",'../../../includes/images/dustbin_orange.png');
		}); 
		$jqeff("#removeFloatBtn").mouseout(function() { 
		  $jqeff( this ).animate({ marginBottom:'0px' }, 100 ); 
		  $(this).attr("src",'../../../includes/images/dustbin_dimmed.png');
		});
		
		$jqeff("#saveBtn").mouseenter(function() { 
		  $jqeff( this ).animate({ marginBottom:'8px' }, 100 ); 
		  $(this).attr("src",'../../../includes/images/save.png');
		}); 
		$jqeff("#saveBtn").mouseout(function() { 
		  $jqeff( this ).animate({ marginBottom:'0px' }, 100 ); 
		  $(this).attr("src",'../../../includes/images/save_dimmed.png');
		});
		
		$jqeff("#resetBtn").mouseenter(function() { 
		  $jqeff( this ).animate({ marginBottom:'8px' }, 100 ); 
		  $(this).attr("src",'../../../includes/images/reset_blue.png');
		}); 
		$jqeff("#resetBtn").mouseout(function() { 
		  $jqeff( this ).animate({ marginBottom:'0px' }, 100 ); 
		  $(this).attr("src",'../../../includes/images/reset_dimmed.png');
		});
		
		$jqeff("#closeBtn").mouseenter(function() { 
		 	 $jqeff( this ).animate({ marginBottom:'8px' }, 100 ); 
		 	 $(this).attr("src",'../../../includes/images/close_round_red.png');
		}); 
		
		$jqeff("#closeBtn").mouseout(function() { 
		 	 $jqeff( this ).animate({ marginBottom:'0px' }, 100 ); 
		 	 $(this).attr("src",'../../../includes/images/close_round_dimmed.png');
		});
	//--> END (FLOATING BUTTONS) ANIMATIONS
	
	
	// ---> load edit
	if($("#action_flag").val() == 'Add'){
		addNewRow();
		$("#category").removeClass('formStyleReadOnly');
		$("#category").addClass('formStyle');
	}
	
	//--> Submit Form on save button
	$("#saveBtn").click(function(e) {
		confirmBox( function(){$("#addForm").submit();}); //--> Submit Form
	});
	
	$("#category").blur(function(){
    	$("#category").val(trim(this.value.toUpperCase()))
    });
	
	$(".sub_group").blur(function(){
    	$(".sub_group").val(trim(this.value.toUpperCase()))
    });
	
	
	/* Validation and Response on form submit (START)*/
	var add_options = {   
	beforeSubmit: validateInput,
	success: showChangeResponse   
	}; 
	$('#addForm').ajaxForm(add_options);
	/* Validation and Response on form submit (END)*/
	
	
	$("#resetBtn").click(function(e) {
		window.location.href=self.location; //--> Reload current screen
	});
	
	$("#closeBtn").click(function(e) {
		window.parent.closeTab($("#tabid").val()); //--> Close current tab (Must define TAB ID)
	});
	
	/*------------------------------- JQX MENU (START)------------------------------------*/
	$("#EMCTSetupMenu").jqxMenu({ width: '20px', height: '20px', rtl: true}); //--> JQX MENU INITILIZATION
	$("#EMCTSetupMenu").css('visibility', 'visible'); //--> JQX MENU INITILIZATION

	currRow = $('#totalRows').val(); //--> get latest row to assign as ID on new rows
	
	
	//--> Add new row button in the configuration (gear)
	$("#addBtn").click(function(e) {
		addNewRow(); //-->Initialize new row
		//$("html, body").animate({ scrollTop: $(document).height() }, 1000); //-->Scroll the the page to bottom if scroll bar are available
	}); 
	
	//--> Add new row button in the configuration (gear) (FLOAT BUTTON)
	$("#addFloatBtn").click(function(e) {
		addNewRow(); //-->Initialize new row
		$("html, body").animate({ scrollTop: $(document).height() }, 1000); //-->Scroll the the page to bottom if scroll bar are available
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
	
	$(".switchBtn").click(function(e) {  
		var getID = this.id.split("_");
		switchControl(getID[1]);
	});
	/*------------------------------- JQX MENU (END)------------------------------------*/
	
});

	//-->Create new rows
	function addNewRow(){ 
		$(document).ready(function(e) { 
		
			currRow++;  //--> set new row
			totalCreatedRow++;  //--> update created rows
			
			//--> Create row painter based on total column defined 
			var rowpainter = '';
				
				rowpainter = '<tr id="RowID_'+currRow+'" class="newRow" >'; 
				rowpainter = rowpainter + '<td align="center" ><img src="../../../includes/images/new.png"></td>';
				
				rowpainter = rowpainter + '<td align="center" ><input type="text" name="purpose_'+currRow+'" id="purpose_'+currRow+'"';
				rowpainter = rowpainter + 'class="formStyle" size="20" value=""></td>';
				
				rowpainter = rowpainter + '<td align="center"><select id="do_number_flag_'+currRow+'" name="do_number_flag_'+currRow+'"';
				rowpainter = rowpainter + 'class="formStyle tips"><option value="">- Y/N -</option>';
				rowpainter = rowpainter + '<option value="Y">Y</option><option value="N">N</option></select></td>';
				
				rowpainter = rowpainter + '<td align="center" ><input type="text" name="trip_flag_'+currRow+'" id="trip_flag_'+currRow+'"';
				rowpainter = rowpainter + 'class="formStyleReadOnly" size="5" value=""></td>';
				
				rowpainter = rowpainter + '<td align="center" ><input type="text" name="m3_flag_'+currRow+'" id="m3_flag_'+currRow+'"';
				rowpainter = rowpainter + 'class="formStyleReadOnly" size="5" value=""></td>';
				
				rowpainter = rowpainter + '<td align="center">';
				rowpainter = rowpainter + '<img src="../../../includes/images/switch_on.png" id="switchBtn_'+currRow+'" width="45" ';
				rowpainter = rowpainter + 'height="18" style="margin-top:3px;cursor:pointer" class="switchBtn">';
				rowpainter = rowpainter + '<input type="hidden" name="status_'+currRow+'" id="status_'+currRow+'"';
				rowpainter = rowpainter + 'value="Y">';
				
				rowpainter = rowpainter + '</td>'; 
				
				rowpainter = rowpainter + '</tr>';
			
			//--> Append row painter to table after the last row	
			$('#rowPainter > tbody:last').append(rowpainter);  
			
			$("#do_number_flag_"+currRow).change(function(e) {
				if($("#do_number_flag_"+currRow).val() == 'Y'){
					$("#trip_flag_"+currRow).val('Y');
					$("#m3_flag_"+currRow).val('N');
				}
				else if($("#do_number_flag_"+currRow).val() == 'N'){
					$("#trip_flag_"+currRow).val('N');
					$("#m3_flag_"+currRow).val('Y');
				}
				else {
					$("#trip_flag_"+currRow).val('');
					$("#m3_flag_"+currRow).val('');
				}

			});
			
			/*Each appended rows using rowpainter will need to initialize they functinality */
			//-->  Set switch button functionality
			$("#switchBtn_"+currRow).click(function(e) { 
				var getID =  this.id.split("_");
				removeRow(getID[1]);
            });
	
			regTips('purpose_'+currRow); //--> Register Show Tips *Optional - Only use if you need a validation*
			regTips('do_number_flag_'+currRow);
			//--> Toggle remove button on change
			$("#purpose_"+currRow).keyup(function(e) { 
				if(trim(this.value) == ''){
					showTips(this.id,'Please insert a purpose!', 3000);//--> Call showTips for validation (Please refer to Framework Tools)	
				}
            });
			$("#do_number_flag_"+currRow).keyup(function(e) { 
				if(trim(this.value) == ''){
					showTips(this.id,'Please select a DO number flag!', 3000);	
				}
            });
			
			
			
			updateRowList(); //--> Update Row List for submition
			
		});
	}
	
	function switchControl(getID){
		$(document).ready(function(e) {
			
            if($('#status_'+getID).val() == 'Y'){
				$("#RowID_"+getID).removeClass('active_row_style');
				$("#RowID_"+getID).addClass('inactive_row_style');
				$("#flag_"+getID).attr('src','../../../includes/images/inactive.png');
				$("#switchBtn_"+getID).attr('src','../../../includes/images/switch_red.png');	
				$('#status_'+getID).val('N');
			}
			else{
				$("#RowID_"+getID).removeClass('inactive_row_style').addClass('active_row_style');
				$("#flag_"+getID).attr('src','../../../includes/images/active.png');
				$("#switchBtn_"+getID).attr('src','../../../includes/images/switch_on.png');	
				$('#status_'+getID).val('Y');
				
				
			}
        });	
	}
	
	function removeRow(getID){
		$(document).ready(function(e) { 
			$("#RowID_"+getID).remove();
			
			totalCreatedRow--;   //--> Update total created rows value
			if(totalCreatedRow<=0 && $(".active_row").length == 0){ addNewRow(); } 
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
	
	//--> Validation on form submit
	function validateInput(formData, jqForm, options) { 
		var invalidDataCounter = 0; 
		  
		//--> Loop through each new created rows  
		$(".newRow").each(function(index, element) { 
        	var idArr = this.id.split("_");
			var r = idArr[1];
			if( ($("#purpose_"+r).val()).trim() == '' ){  
				showTips('purpose_'+r, 'Please select a purpose!', 3000);
				invalidDataCounter++; 
				return false;
			}
			else if($("#do_number_flag_"+r).val()==''){  
				showTips('do_number_flag_'+r, 'Please select a DO number flag!', 3000);
				invalidDataCounter++;
				return false;
			}
        });
		 
		//--> Return false or proceed to submit based on validation results
		if(invalidDataCounter > 0 ){
			confirmBox_close(); //--> Close confirmbox
			return false;
		}
		else { 
			return true; 
		}
		
	}
	
	//--> Submitted forms results
	function showChangeResponse(responseText, statusText, xhr, $form)  {  
		var responseArr = responseText.split("~~");   
 
		if(responseArr[1]== "success"){	
			window.parent.notify("success","Manual EMCT Setup","Manual EMCT Setup are successfully updated","3000");
			window.location.href=self.location
			
			/*if (("#action_flag").val() == 'Add'){
			var filePath = '../systems/general_master/master_data/manual_emct_setup/';
						  
			var fullPath = filePath + 'manual_emct_setup_add.cfm?org_id='+$("#org_id").val()+'&category='+$("#category").val()+'&type=edit';
						  
			window.parent.openNewTab('Manual EMCT Setup',fullPath,$("#fID").val());
			}*/
		}  
		else { 
			window.parent.notify("error","Manual EMCT Setup",responseArr[2],"3000");
			confirmBox_close(); //--> Close confirmbox
			return false;
		}
	}