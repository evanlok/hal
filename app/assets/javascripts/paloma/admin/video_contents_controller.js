var VideoContentsController = Paloma.controller('Admin/VideoContents');

VideoContentsController.prototype.edit = function(){
  var dataInput = $('#video_content_data');

  if (dataInput.val()) {
    dataInput.val(JSON.stringify(JSON.parse(dataInput.val()), null, 2));
  }
};
