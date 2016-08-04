var SceneCollectionsController = Paloma.controller('Admin/SceneCollections');

SceneCollectionsController.prototype.edit = function () {
  $('.form-actions .preview').on('ajax:success', function (e, data) {
    openPreviewTab(data.id);
  }).on('ajax:error', function (e, xhr) {
    new PNotify({
      title: 'Preview Error',
      text: '<ul class="list-unstyled">' + _.reduce(xhr.responseJSON.errors, function (html, error) {
        return html + '<li>' + error + '</li>';
      }, '') + '</ul>',
      type: 'error',
      width: '500px'
    });
  });

  function openPreviewTab(videoPreviewId) {
    window.open('/video_previews/' + videoPreviewId);
  }
};
