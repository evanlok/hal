var SceneAttributesController = Paloma.controller('Admin/SceneAttributes');

SceneAttributesController.prototype.edit = function(){
  showDisplayConfig();

  function showDisplayConfig() {
    $('.attribute-config').addClass('hidden');
    var elementId = $('#scene_attribute_scene_attribute_type_id').find('option:selected').text() + '-attributes';
    $('#' + elementId).removeClass('hidden');
  }

  $('#scene_attribute_scene_attribute_type_id').on('change', function (e) {
    showDisplayConfig();
  });
};
