$(document).ready(function () {
  $('input[type=file]').change(function() {
    uploadId = generateUploadId(); 

    // Adds uploadId to the queryString so it can be used as an identifier 
    $(this).parents('form').attr("action", "/uploads?uploadId=" + uploadId).submit(); 

    $(document).trigger('uploadStarted', uploadId);
  });

  // handles progress 
  $(document).bind('uploadStarted', function(e, uploadId){
    // Sets the description form the correct uploadId 
    $('#uploadId').val(uploadId);
    fetchProgress(uploadId);
  });

  // handles upload completion 
  $(document).bind('uploadFinished', function(e, response){
    $('#uploadStatus').html('File was stored in ' + response['path'] + response['name']);
  });


  // handle description form
  $('#description-form').find('form').bind('submit', function(e) {
    // prevents the form to being submitted 
    e.preventDefault();
$.post("/uploads/description", 
      { 
        "uploadId": $('#uploadId').val(),  
        "description": $('#uploadDescriptionField').val()
      }, 
      function (data) {
        $('#uploadDescription').html(data['description']);
      }
    );

  });
  
});

// generate a random UUIDish to represent this uploaded file
function generateUploadId() {
  var S4 = function() {
    return (((1+Math.random())*0x10000)|0).toString(16).substring(1);
  };
  return (S4()+S4()+"-"+S4()+"-"+S4()+"-"+S4()+"-"+S4()+S4()+S4());
}

// Fetches the server for progress and calls itself recursively 
// if upload is still running
function fetchProgress(uploadId){
  $.getJSON("/progress?uploadId=" + uploadId, function (response){
    $('#uploadProgress').html("File is " + response['progress'] + " percent completed"); 
    if(response['progress'] != 100){
      setTimeout(fetchProgress(uploadId), 1000);
    }
  });
}
