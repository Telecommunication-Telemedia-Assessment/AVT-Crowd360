% rebase('templates/skeleton.tpl', title=title)

<h1 class="mt-5">Instructions</h1>

<div id="screensize_error" class="alert alert-danger" style="display:none">
    Your browser window is not large enough, please maximize your window. Also remember that you need a screen with a resolution of 1920x1080 to do this test.
</div>

<p>
You will see different 360 videos.
Your task is to watch these videos by clicking the play button and explore them by pressing your left mouse key and moving the mouse.
The videos have a duration of 30 seconds and don't contain audio.
While you watch the videos, your mouse movements are captured.
After you have watched and explored the video, click the "next video" button.
</p>
<p>
The training phase is to understand how to use the 360 degree video player.
</p>


<div class="alert alert-primary" role="alert">
Please wait until the loading indicator disappears. Then you are able to play the video.
</div>
<div class="alert alert-danger" role="alert">
Please close running applications and browser tabs now to smoothly playout the videos. If the videos are not smoothly playing out, it could be a performance issue with your device.
</div>
<div class="alert alert-warning " role="alert">
Please maximize your browser window (F11 mostly works).
</div>

<p>
<a class="btn btn-large btn-success" href="{{next}}" onclick="check_screensize(event)"  id="next">next</a>
</p>



% include("templates/precache.tpl", stimuli=stimuli)
