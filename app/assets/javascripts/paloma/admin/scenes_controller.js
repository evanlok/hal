var ScenesController = Paloma.controller('Admin/Scenes');

ScenesController.prototype.edit = function () {
  var vglContentEditor = ace.edit($('#vgl_content .editor')[0]);
  vglContentEditor.getSession().setMode('ace/mode/ruby');
  vglContentEditor.setTheme("ace/theme/twilight");

  $('form').on('submit', function () {
    $(this).find('#vgl_content input').val(vglContentEditor.getValue());
  });

  $('.modal .preview').on('click', function (e) {
    e.preventDefault();
    submitPreview();
  });

  function submitPreview() {
    var sceneId = $('#scene_id').val();
    var sceneVGL = vglContentEditor.getValue();
    var sceneData = $('#scene_data').val();

    $.ajax({
      url: '/admin/scenes/preview',
      data: {
        scene_id: sceneId,
        scene_vgl: sceneVGL,
        scene_data: sceneData
      },
      method: 'POST'
    }).done(function onSuccess(data) {
      openPreviewTab(data.id);
    }).fail(function onFail(xhr) {
      new PNotify({
        title: 'Preview Error',
        text: '<ul>' + _.reduce(xhr.responseJSON.errors, function (html, error) {
          return html + '<li>' + error + '</li>';
        }, '') + '</ul>',
        type: 'error'
      });
    });

    $('#preview-modal').modal('hide');
  }

  function openPreviewTab(videoPreviewId) {
    window.open('/video_previews/' + videoPreviewId);
  }
};
