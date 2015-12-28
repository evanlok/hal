var ScenesController = Paloma.controller('Admin/Scenes');

ScenesController.prototype.edit = function(){
  var vglContentEditor = ace.edit($('#vgl_content .editor')[0]);
  vglContentEditor.getSession().setMode('ace/mode/ruby');
  vglContentEditor.setTheme("ace/theme/twilight");

  $('form').on('submit', function () {
    $(this).find('#vgl_content input').val(vglContentEditor.getValue());
  });
};
