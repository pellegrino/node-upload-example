$(document).ready(function () {
  $('input[type=file]').change(function() {
    uploadId = generateUploadId(); 

    // Adds uploadId to the queryString so it can be used as an identifier 
    $(this).parents('form').attr("action", "/uploads?uploadId=" + uploadId).submit(); 

    $(document).trigger('uploadStarted', uploadId);
    $(this).parents('form').submit(); 
  });

  // handles progress 
  $(document).bind('uploadStarted', function(e, uploadId){
    fetchProgress(uploadId);
  });

  // handles upload completion 
  $(document).bind('uploadFinished', function(e, response){
    $('#uploadStatus').html('File was stored in ' + response['path'] + response['name']);
  });

});

// generate a random UUIDish to represent this uploaded file
function generateUploadId() {
  var S4 = function() {
    return (((1+Math.random())*0x10000)|0).toString(16).substring(1);
  };
  return (S4()+S4()+"-"+S4()+"-"+S4()+"-"+S4()+"-"+S4()+S4()+S4());
}

function fetchProgress(uploadId){
  $.getJSON("/progress?uploadId=" + uploadId, function (response){
    $('#uploadProgress').html("File is " + response['progress'] + " percent completed"); 
    if(response['progress'] != 100){
      setTimeout(fetchProgress(uploadId), 1000);
    }
  });
}
