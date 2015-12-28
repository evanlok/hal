var SceneContentsController = Paloma.controller('Admin/SceneContents');

SceneContentsController.prototype.edit = function(){
  var dataInput = $('#scene_content_data');

  if (dataInput.val()) {
    dataInput.val(JSON.stringify(JSON.parse(dataInput.val()), null, 2));
  }
};
