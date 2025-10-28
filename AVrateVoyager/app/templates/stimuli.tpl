
<!-- add needed libs for video vr player -->
<script src="/static/ext/three.min.js"> </script>
<script src="/static/ext/video.min.js"> </script>
<script src="/static/ext/videojs-vr.min.js"> </script>

<!-- css imports for video vr player -->
<link href="/static/ext/video-js.min.css" rel="stylesheet">
<link href="/static/ext/videojs-vr.css" rel="stylesheet">

<style type="text/css">

.vjs-big-vr-play-button {
    display:none !important;
}
</style>

<div class="col-12">
    % is_audio = stimuli_file.split(".")[-1].lower() in ["wav", "flac", "ogg", "aac", "mp3", "opus"]
    % is_image = stimuli_file.split(".")[-1].lower() in ["jpg", "jpeg", "png", "gif", "tiff"]
    % is_video = not is_audio and not is_image
    % task_msg = "listen" if is_audio else "watch"

    <div class="row">
        <div class="col-12 align-top">

            % if is_audio:
            <audio id="stimuli" nocontrols onended="display_rating();hide_media_element();" preload="auto" oncanplaythrough="display_button()" style="display:none" oncontextmenu="return false;">
                <source src="{{stimuli_file.replace("./", "/")}}" type="audio/flac">
                Your browser does not support the audio element.
            </audio>
            % end
            % if is_video:
            <video id="stimuli" style="display:none" class="vstimuli col-12 align-top video-js vjs-default-skin" controls playsinline onended="display_rating();hide_media_element();video_ended();enable_submit_button();disable_play_button()" preload="auto" oncanplaythrough="display_button()" oncontextmenu="return false;" onstalled="collect_stalling('stop')" onsuspend="collect_stalling('stop')" onplaying="collect_stalling('play')">
                <source src="{{stimuli_file.replace("./", "/")}}" type="video/mp4">
                Your browser does not support the video tag.
            </video>
            % end
            % if is_image:
            <img id="stimuli" class="col-12 align-top" onload="image_loaded()" src="{{stimuli_file.replace("./", "/")}}" alt="{{stimuli_file.replace("./", "/")}}" >
            % end
        </div>
    </div>

<!-- extension to play the videos as vr video -->
  <script>
    var video_started = false;

    (function(window, videojs) {
      var player = window.player = videojs('stimuli');
      player.mediainfo = player.mediainfo || {};
      player.mediainfo.projection = '360';

      // AUTO is the default and looks at mediainfo
      var vr = window.vr = player.vr({projection: 'AUTO', debug: true, forceCardboard: false});
      // Set to Fullscreen
      setInterval( function() {
        if (player.paused() == false) {
          player.requestFullscreen()
          player.controls(false)
        }
        if (player.remainingTime() == 0) {
          player.exitFullscreen();
        }
      }, 10);

      data = { 'filename': '{{stimuli_file.replace("./", "/")}}', 'pitch_yaw_roll_data_hmd': [] }

      setInterval( function() {
        if (video_started) {
            spherical = new THREE.Spherical().setFromVector3(vr.cameraVector);
            yaw = (spherical["theta"]*180/Math.PI - 180) * -1;
            if (yaw > 180) {
              yaw = yaw - 360;
            }
            if (yaw < 180) {
              yaw = yaw * -1
            }
            pitch = (spherical["phi"]*180/Math.PI - 90) * -1;
            // console.log("pitch ", pitch, "yaw ", yaw)
            data["pitch_yaw_roll_data_hmd"].push(
                {
                    'pitch': pitch,
                    'yaw': yaw,
                    'sec': player.currentTime(),
                    "sample_timestamp": new Date().getTime(),
                }
            );
            // write the data to the textarea
            document.getElementById("tracking_data").value = JSON.stringify(data)
        }


      }, 100);
      //
      // var camera_position = vr.cameraVector;
      // console.log(camera_position["x"]);
    }(window, window.videojs));
  </script>

    <div class="row">
        <div class="col-12">

            <div id="info" style="display:none;cursor:default" class="btn alert-success" disabled>
              Please {{task_msg}}
            </div>
            <div id="loader" class="spinner-border" role="status">
              <span class="visually-hidden">Loading...</span>
            </div>

            <button style="display:none" class="btn btn-secondary" id="playbutton" onclick="play()">
            play
            </button>
        </div>
    </div>

</div>

<script>

var stalling = []

function collect_stalling(what) {
    var video = document.getElementById("stimuli");
    stall_event = {
        "media_time": video.currentTime,
        "start_timestamp": Date.now(),
        "what": what,
    };
    stalling.push(stall_event);
}

function enable_submit_button() {
  if(document.getElementById("submitButtonTrain")) {
    document.getElementById("submitButtonTrain").style.display = "inline"
  } else {
    document.getElementById("submitButton").style.display = "inline"
  }
}

function disable_play_button() {
  console.log("hide button");
  document.getElementById("playbutton").style.display = "none";
}

function video_ended() {
    var video = document.getElementById("stimuli");
    video_started = false;
    // var qmeta = video.getVideoPlaybackQuality();
    //
    // qmeta_json = {
    //     "droppedVideoFrames": qmeta.droppedVideoFrames,
    //     "totalVideoFrames": qmeta.totalVideoFrames,
    //     "stalling_events": stalling
    // }
    // document.getElementById("quality_meta").value = JSON.stringify(qmeta_json);
    //console.log(qmeta_json);
}

function store_window_size() {
    var h = window.innerHeight;
    var w = window.innerWidth;
    document.getElementById("ww").value = w;
    document.getElementById("wh").value = h;

    // store zoom factor (see https://stackoverflow.com/a/45191169)
    document.getElementById("wz").value =  window.devicePixelRatio;

}

function image_loaded() {
    console.log("image here");
    store_window_size();

    document.getElementById("pi").value ++;
    document.getElementById("info").style.display = "none";
    document.getElementById("playbutton").style.display = "none";
    document.getElementById("loader").style.display = "none";
    stimuli_loaded = true;
}

function play() {

    var stimuli = document.getElementById("stimuli");
    stimuli.style.display = "inline";
    /* no full screen
    if (stimuli.tagName != "AUDIO") {
        stimuli.requestFullscreen();
    }
    // hiding of the video/audio element
    document.getElementById("stimuli").style.display = "inline";
    */
    if (stimuli.hasOwnProperty("play")) {
        stimuli.play();
    } else {
        //may be a video-js-VR player
        if (stimuli.hasOwnProperty("player")) {
            stimuli.player.play();
        }

    }
    video_started = true;
    store_window_size();

    console.log("hide button");
    document.getElementById("playbutton").style.display = "none";
    document.getElementById("info").style.display = "inline";
    document.getElementById("pi").value ++;
}

var stimuli_loaded = false;

function display_button() {
    console.log("here we go");
    if (!stimuli_loaded) { // while pressing the button several times this event was fired again thus this will prevent this behaviour
        document.getElementById("loader").style.display = "none";
        //document.getElementById("stimuli").style.display = "inline";
        document.getElementById("playbutton").style.display = "inline";
    }
    stimuli_loaded = true;

}

function hide_media_element() {

    document.getElementById("playbutton").style.display = "inline";
    document.getElementById("info").style.display = "none";
    return; // we dont hide it.. only required for fullscreen
    var stimuli = document.getElementById("stimuli");
    if (stimuli.tagName != "AUDIO") {
        document.exitFullscreen();
    }
    stimuli.style.display = "none";
    document.getElementById("info").style.display = "none";
}
</script>
