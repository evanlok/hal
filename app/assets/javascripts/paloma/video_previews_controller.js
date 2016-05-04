var VideoPreviewsController = Paloma.controller('VideoPreviews');

VideoPreviewsController.prototype.show = function () {
  var params = this.params;
  var player = videojs('video');

  window.onload = resizeVideoJS;
  window.onresize = resizeVideoJS;

  if (!player.src()) {
    initializeStreamPolling(this.params.id);
  }

  function initializeStreamPolling(videoId) {
    pollStreamUrl();

    function pollStreamUrl() {
      $.ajax({
        url: "/video_previews/" + videoId + ".json",
        success: streamUrlSuccessCallback
      });
    }

    function streamUrlSuccessCallback(data) {
      if (data.stream_url) {
        pollPlaylist(data.stream_url);
      } else {
        setTimeout(pollStreamUrl, 2000);
      }
    }

    function pollPlaylist(playlistUrl) {
      $.ajax({
        url: playlistUrl,
        success: function () {
          streamReady(playlistUrl);
        },
        error: function () {
          setTimeout(function () {
            pollPlaylist(playlistUrl);
          }, 1500);
        }
      });
    }

    function streamReady(url) {
      player.src({src: url, type: 'application/x-mpegURL'});
      player.currentTime(0);
      player.play();
    }
  }

  function resizeVideoJS() {
    var height = $(window).height();
    player.height(height);
  }
};
