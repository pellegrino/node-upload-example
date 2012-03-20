$(document).ready(function () {
  $('input[type=file]').change(function() {
    var filename = $(this).val();

    $(document).trigger('uploadStarted', 'fooo');
    $(this).parents('form').submit(); 
  });

  // handles progress 
  $(document).bind('uploadStarted', function(e, filename){
    alert(filename);
  });

  // handles upload completion 
  $(document).bind('uploadFinished', function(e, response){
    // stop polling
    alert(response);
  });

});
