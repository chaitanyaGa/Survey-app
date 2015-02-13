$(function()
{
    /*
  Webcam.attach('#my_camera');
  function take_snapshot() {
    Webcam.snap( function(data_uri) {
      document.getElementById('my_result').innerHTML = '<img src="'+data_uri+'"/>';
    } );

  }*/

  Webcam.attach( '#my_camera' );

});

function take_snapshot()  {
  var access;
  Webcam.snap( function(data_uri) {
    document.getElementById('my_result').innerHTML = '<img id=\'captured\', src="'+data_uri+'"/>';
    access = data_uri;
  } );
    //document.write(auth_token);

  var url = '/sessions/upload'
  Webcam.upload( access, url , function(code, text) {
    // Upload complete!
    //     'code' will be the HTTP response code from the server, e.g. 200
    //     'text' will be the raw response content
    //       document.write(code);
    //         document.write("URI" + access);
  } );
}
