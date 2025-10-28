<link rel="stylesheet" href="/static/bootstrap.min.css">

<link rel="stylesheet" href="/static/avrate.css">



<script>
function check_screensize(event) {
  var w = window.innerWidth;
  var h = window.innerHeight;
  if (w < 1700 || h < 800) {

      var e = document.getElementById("screensize_error");
      e.style.display="block";
      event.preventDefault();
  }
}
</script>
