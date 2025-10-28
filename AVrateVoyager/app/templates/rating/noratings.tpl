
<div class="col-12" id="ratingform" >

% is_audio = stimuli_file.split(".")[-1].lower() in ["wav", "flac", "ogg", "aac", "mp3", "opus"]
% is_image = stimuli_file.split(".")[-1].lower() in ["jpg", "jpeg", "png", "gif", "tiff"]
% is_video = not is_audio and not is_image


% if train:
  <h5>Please patiently wait until the loading indicator above disappears. Then click the "play" button, watch the video and explore it by pressing and holding your left mouse key. Please count the number of screens shown in the video.</h5>
  <p></p>
  <h5>After you have watched and explored the video, enter the correct number of screens in the input field below and click the "next video" button.</h5>
% else:
  <h5>Please patiently wait until the loading indicator above disappears. Then click the "play" button, watch the video and explore it by pressing and holding your left mouse key.</h5>
  <p></p>
  <h5>After you have watched and explored the video, click the "next video" button.</h5>
% end

% if train:
  <p></p>
  <input name="screen_count_input" id="screen_count_input_id" type="number" class="form-control" required ></input>
  <p></p>
% end

  % route = f"save_rating?stimuli_idx={stimuli_idx}" if not train else "training/" + str(stimuli_idx + 1)
  <form id="form1" action="/{{route}}" method="post">


    <textarea id="tracking_data" style="display:none" name="tracking_data"></textarea>

    % include('templates/rating/common.tpl', stimuli_file=stimuli_file)

    % if train:
      <button type="submit" id="submitButtonTrain" style="display:none" class="btn btn-success btn-block" onclick="check_form_train(event)">next video</button>
    % else:
      <button type="submit" id="submitButton" style="display:none" class="btn btn-success btn-block" onclick="check_form(event)">next video</button>
    % end

    % if dev:
      <button type="submit" class="btn btn-success" formnovalidate>skip (for dev)</button>
    % end

    <div id="training_not_correct" class="btn alert-danger" style="display:none;cursor:default; margin-top: 0.5em; margin-bottom: 0.5em" disabled>This number is wrong. Please watch the video again, explore it and enter the correct number of screens shown there (as a number).</div>
    <div id="playonce" class="btn alert-danger" style="display:none;cursor:default; margin-top: 0.5em; margin-bottom: 0.5em" disabled>Please play and explore the video at least once.</div>
    <div id="ratingselect" class="btn alert-danger" style="display:none;cursor:default; margin-top: 0.5em; margin-bottom: 0.5em" disabled>Please select a rating.</div>
  </form>
</div>



<script>


    function check_form_train(event) {
      if (document.getElementById("screen_count_input_id").value != 7) {
          document.getElementById("training_not_correct").style.display="block";
          event.preventDefault();
          return
      }
    }
    function display_rating() {
      document.getElementById("ratingform").style.display="block";
    }
    function check_form(event) {
      console.log(document.getElementById("pi").value);
      document.getElementById("playonce").style.display = "none";
      document.getElementById("ratingselect").style.display = "none";

      if (document.getElementById("pi").value == 0) {
          document.getElementById("playonce").style.display="block";
          event.preventDefault();
          return
      }
    }
</script>
