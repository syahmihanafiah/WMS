$(document).ready(function () {  
    	$("#jqxExpander").jqxExpander({ width: '100%', toggleMode: "none", showArrow: false });
 
		$("#lookupMotherPartNumberBtn").click( function(){ 
			if($("#org_id").val() == ""){
				$jqtips(document).ready(function() {   
					$jqtips('#org_id').poshytip('update', 'Please select organization');
					$jqtips('#org_id').poshytip('show'); 
				});
				f.org_id.focus();
				return false;
			}
			else {  
				openLookupMotherPartNumber(); clear_tooltips(); 
			}
		} ); 
		
		$('#lookupMotherPartNumberWindow').on('close', function (event) { 
			document.getElementById('lookupMotherPartNumberContent').src="about:blank";
			$('#lookupMotherPartNumberProgress').show();    
		}); 
        function openLookupMotherPartNumber() {
		  
			var lookupStr = trim($("#mother_part_number").val());
			lookupStr = lookupStr.replace('&','chr38');
			var lookupFile = '../../../includes/lookup/part_number.cfm?prefix=MotherPartNumber&parentForm=addForm&field2=mother_part_number&org_id='+$("#org_id").val()+'&lookupStr='+lookupStr;
			
			document.getElementById('lookupMotherPartNumberContent').src=lookupFile; 
            $('#lookupMotherPartNumberWindow').jqxWindow({ 
				maxHeight: 600, maxWidth: 600, 
				minHeight: 400, minWidth: 400, 
				height: 500, width: 500, 
				resizable: true,
				isModal: true,
				modalOpacity:0.1,
				showAnimationDuration: 0,
				closeAnimationDuration: 0
            });  
			$('#lookupMotherPartNumberWindow').jqxWindow('open');  
        }
		
		 
		var add_options = {   
			beforeSubmit:  validateInput,
			success: showChangeResponse   
		}; 
		$('#addForm').ajaxForm(add_options); 
 
	});
	
	$jqtips(document).ready(function() { 
		$jqtips('#org_id').poshytip({ className: 'tip-red', content: 'none', showOn: 'none', alignTo: 'target', alignX: 'right', alignY: 'center', offsetX: 6, offsetY: 5 }); 
		$jqtips('#lookupMotherPartNumberBtn').poshytip({ className: 'tip-red', content: 'none', showOn: 'none', alignTo: 'target', alignX: 'right', alignY: 'center', offsetX: 6, offsetY:5}); 		   
		$jqtips('#ownership_id').poshytip({ className: 'tip-red', content: 'none', showOn: 'none', alignTo: 'target', alignX: 'right', alignY: 'center', offsetX: 6, offsetY:5}); 		   
	});
	  
	function clear_tooltips(){
		$jqtips('#org_id').poshytip('hide');  
		$jqtips('#lookupMotherPartNumberBtn').poshytip('hide');   
		$jqtips('#ownership_id').poshytip('hide');   
	} 
	
	function inprogress(status){
		if(status=="start"){
			$("#progressbar").show(); 
			document.getElementById("nextBtn").disabled = true; 
			document.getElementById("resetBtn").disabled = true; 
			document.getElementById("closeBtn").disabled = true; 
		}
		else {
			$("#progressbar").hide();
			document.getElementById("nextBtn").disabled = false; 
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
		else if(trim(f.mother_part_number.value) == ""){
				$jqtips(document).ready(function() {   
					$jqtips('#lookupMotherPartNumberBtn').poshytip('update', 'Please select a part number');
					$jqtips('#lookupMotherPartNumberBtn').poshytip('show'); 
				});
				f.mother_part_number.focus();
				return false;
		} 
		else if (trim(f.ownership_id.value) == ""){
			$jqtips(document).ready(function() {   
				$jqtips('#ownership_id').poshytip('update', 'Please select an ownership');
				$jqtips('#ownership_id').poshytip('show'); 
			});
			f.ownership_id.focus();
			return false;
		}
		 
		else {  
			inprogress("start");
			return true;
		}
	}
	
	function showChangeResponse(responseText, statusText, xhr, $form)  { 
 		 
		inprogress("end"); 
	
		validateAJAXResponse(responseText); 
		
		var responseArr = responseText.split("~~");
 
 		var pn = trim($("#mother_part_number").val());
		var oi = trim($("#org_id").val()); 
		var os = trim($("#ownership_id").val());
		if(trim(responseArr[1]) != '0'){ 
				 window.parent.notify("error","Add New Part Set",'Part <b>'+pn+'</b> is already registered as a mother part',"5000"); 
		}
		else { 
			  var param = 'org_id='+oi+'&mother_part_number='+pn+'&ownership_id='+ os;
			  window.location.href='part_set_add2.cfm?'+param; 
	    }
		 
	}
