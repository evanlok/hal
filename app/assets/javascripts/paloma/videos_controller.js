var VideosController = Paloma.controller('Videos');

VideosController.prototype.show = function () {
  var params = this.params;
  var player = videojs('video', {}, setupMixpanel);

  window.onload = resizeVideoJS;
  window.onresize = resizeVideoJS;

  if (!player.src()) {
    initializeStreamPolling(this.params.video_id);
  }

  function initializeStreamPolling(videoId) {
    pollStreamUrl();

    function pollStreamUrl() {
      $.ajax({
        url: "/videos/" + videoId + "/stream.json",
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

  function setupMixpanel() {
    if (typeof mixpanel != 'undefined') {
      mixpanel.register({
        "Video Type": params.video_type,
        "Definition": params.definition,
        "video_id": params.video_id,
        "video_uid": params.video_uid
      });

      this.on('play', function () {
        mixpanel.track('Played video');
      });
      this.on('pause', function () {
        mixpanel.track('Paused video', {"progress": parseInt((this.currentTime() / this.duration()) * 100) });
      });
      this.on('ended', function () {
        mixpanel.track('Ended video');
      });
      this.on('seeked', function (e) {
        mixpanel.track('Seeked video', {"seek_to_second": parseInt(this.currentTime())});
      });
    }
  }

  function resizeVideoJS() {
    var width = $('.video-wrapper').width();

    if (width == 0) {
      width = window.innerWidth
    }
    var calculatedHeight = width * 9 / 16;

    if (!calculatedHeight == 0) {
      player.width(width).height(calculatedHeight);
    }
  }
};
