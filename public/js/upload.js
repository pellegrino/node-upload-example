$(document).ready(function () {
  $('input[type=file]').change(function() {
    // Creating the uploadId to identify this single upload throughout the application 
    uploadId = generateUploadId(); 

    // Adds uploadId to the queryString so it can be used as an identifier 
    $(this).parents('form').attr("action", "/uploads?uploadId=" + uploadId).submit(); 

    $(document).trigger('uploadStarted', uploadId);
  });

  // handles progress 
  $(document).bind('uploadStarted', function(e, uploadId){
    // Sets the description form the correct uploadId 
    $('#uploadId').val(uploadId);
    // cleans last upload state
    $('#uploadDescriptionSubmit').removeAttr('disabled');
    $('#uploadProgres').html('');
    $('#uploadStatus').html('');
    $('#uploadDescription').html('').removeClass('present');

    fetchProgress(uploadId);
  });

  // handles upload completion 
  $(document).bind('uploadFinished', function(e, response){
    $('#uploadStatus').html('File was stored in ' + response['path']);
  });


  // handle description form
  $('#description-form').find('form').bind('submit', function(e) {
    // prevents the form to being submitted 
    e.preventDefault();
    $.post("/uploads/description", { 
      "uploadId": $('#uploadId').val(),  
      "description": $('#uploadDescriptionField').val()
    }, 
    function (data) {
      $('#uploadDescription').html(data['description']);
      $('#uploadDescription').addClass('present');
    });

  });

});

// generate a random UUIDish to represent this uploaded file
function generateUploadId() {
  return (S4()+S4()+"-"+S4()+"-"+S4()+"-"+S4()+"-"+S4()+S4()+S4());
}

// Random value
var S4 = function() {
  return (((1+Math.random())*0x10000)|0).toString(16).substring(1);
};

// Fetches the server for progress and calls itself recursively 
// if upload is still running
function fetchProgress(uploadId){
  // Adding random number to avoid being wrongly cached.
  $.getJSON("/progress?uploadId=" + uploadId + "&r=" + S4()+S4()+S4(), function (response){
    $('#uploadProgress').progressbar({
      value: response['progress']
    }); 

    if(! response['completed']){
      setTimeout(fetchProgress(uploadId), 1000);
    }
  });
}
