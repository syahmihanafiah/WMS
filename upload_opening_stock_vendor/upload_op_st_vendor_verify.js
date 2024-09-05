/*---
  Suite         : LOCAL PART IMPROVEMENT
  Purpose       : 

  Version    Developer    		Date            Remarks
  1.0.00     Syahmi         	2/1/2024     	 
*/
$(document).ready(function () {

    setTimeout(() => {
        $(".uiBreadcrumb").text(
          "Warehouse Management System > LSP > Inventory > Opening Stock Upload (Vendor)"
        );
      }, 500);
      //re-upload function
  $("#reuploadBtn").click(function (e) {

      $("#action_flag").val('reupload');
      var prev_file = $("#reupload_label").val(); 
      $("#prev_file").val(prev_file);    
    $("#reuploadFile").trigger("click");    
    $("#reuploadFile").change((e) => {    
      var file = e.target.files[0];
      var filename = file.name;
      var org_id = $("#organization").val();
      var vendor_name = $("#upload_vendor").val();
      var filenameArr = filename.split(".");
      if (filenameArr.length > 1) {
        var ext = filenameArr[filenameArr.length - 1].trim();
        if (
          ext.toUpperCase() == "TXT" ||
          ext.toUpperCase() == "XLS" ||
          ext.toUpperCase() == "XLSX"
        ) {
          $("#reupload_label").val(file.name);
          //$("#prev_file").val(file.name);
            var file_name = $("#reupload_label").val();
          $("#reuploadForm").attr(
            "action",
            "upload_op_st_vendor_verify.cfm?org_id=" +
              encodeURIComponent(org_id) +
              "&vendor_name=" +
              encodeURIComponent(vendor_name) +
              "&file_name=" + encodeURIComponent(file_name) + 
              "&prev_file=" + encodeURIComponent(prev_file)
          );
          $("#reuploadBtn").attr("disabled", false);
          $("#reuploadForm").submit();
        } else {
          showTips("chooseBtn", "Only an excel file is allowed", 3000);
        }
      }
    });
  });
  $("#approveBtn").click(function (e) {
    if ($("#reupload_label").val() !== '') {
      if ($('td:contains("INVALID")').length > 0 && $('td:contains("Duplicate found:")').length > 0) {
        parent.fw_notify("error", "Part number cannot be duplicate!", 2000);
      }
      else if ($('td:contains("Part Number does not Exist!")').length > 0) {
        parent.fw_notify("error", "Part Number does not exist!", 2000);
      }
      else {
        approveDoc('approve');
      }
    }
    else {
      window.parent.fw_notify("error", "Upload an Excel File First!", 2000);
    }
  }); 
  $("#cancelBtn").click(function (e) { 
    $("#action_flag").val('delete_file');
    // Change the form's action attribute
    $('#reuploadForm').attr('action', 'bgprocess.cfm');
    var upload_options = {
        beforeSubmit: validateInput,
        success: cancelShowResponse,
      };
      
    $("#reuploadForm").ajaxForm(upload_options);
    $('#reuploadForm').submit();    
  
  });
});

function approveDoc(action_flag){

    $("#action_flag").val('approve');
    // Change the form's action attribute
    $('#reuploadForm').attr('action', 'bgprocess.cfm');
    var upload_options = {
        beforeSubmit: validateInput,
        success: showChangeResponse,
      };
      
    $("#reuploadForm").ajaxForm(upload_options);
    $('#reuploadForm').submit();
}
function validateInput(formData, jqForm, options) {
  return true;
}
function cancelShowResponse(responseText, statusText, xhr, $form) {
  var responseArr = responseText.split("~~");
  console.log(responseArr);
  if(responseArr[1] == 'success'){
      $("#reupload_label").val('');
      window.parent.fw_notify("success", responseArr[3], "3000");
      setTimeout(() => {
        window.parent.closeTab(getTabID());
      }, 1000);      
  }
  else{
      window.parent.fw_notify("error", "Failed","3000");
  }
}

function showChangeResponse(responseText, statusText, xhr, $form) {
    var responseArr = responseText.split("~~");

    if(responseArr[1] == 'success'){
        $("#reupload_label").val('');
        window.parent.fw_notify("success", "Success", responseArr[1], "3000");
        setTimeout(() => {
            window.parent.closeTab(getTabID());
          }, 1500);
    }
    else{
        window.parent.fw_notify("error", "Failed", responseArr[2], "3000");
    }
}