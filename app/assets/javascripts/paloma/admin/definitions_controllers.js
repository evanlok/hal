var DefinitionsController = Paloma.controller('Admin/Definitions');

DefinitionsController.prototype.edit = function(){
  var vglHeaderEditor = ace.edit($('#vgl_header .editor')[0]);
  vglHeaderEditor.getSession().setMode('ace/mode/ruby');
  vglHeaderEditor.setTheme("ace/theme/twilight");

  var vglContentEditor = ace.edit($('#vgl_content .editor')[0]);
  vglContentEditor.getSession().setMode('ace/mode/ruby');
  vglContentEditor.setTheme("ace/theme/twilight");

  var vglMethodsEditor = ace.edit($('#vgl_methods .editor')[0]);
  vglMethodsEditor.getSession().setMode('ace/mode/ruby');
  vglMethodsEditor.setTheme("ace/theme/twilight");

  $('form').on('submit', function () {
    $(this).find('#vgl_header input').val(vglHeaderEditor.getValue());
    $(this).find('#vgl_content input').val(vglContentEditor.getValue());
    $(this).find('#vgl_methods input').val(vglMethodsEditor.getValue());
  });
};
