<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta name="description" content="plant evolution art project"/>
<title>G A R D E N</title>
<link rel="shortcut icon" href="favicon.ico" type="image/x-icon"/>
<script type="text/javascript" src="swfobject.js"></script>
<script type="text/javascript">
swfobject.registerObject("theGarden", "10.0.0", "expressInstall.swf");
</script>
<style media="screen" type="text/css">
* {
	margin: 0;
	padding: 0;
	border: 0;
}
a {
	color: #F09090;
	text-decoration: none;
}
a:hover {
	color: #F0C0C0;
	text-decoration: underline;
}
p {
	color: #202020; 
	font-family: 'Courier New', Courier, monospace; 
	font-size: 13px;
	margin: 20px 30px 30px 20px;
}
.title {
	color: #F5F5F5; 
	font-size: 15px;
	font-weight: bold;
	margin: 0;
	padding: 10px;
}
#gardenDiv {
	height: 600px;
}
#titleDiv {
	background-color: #807070;
	width: 900px;
}
#bottomDiv {
	clear: both;
}
</style>
</head>
<body bgcolor="#EDE5DE">

<div align="center">

<div id="gardenDiv">
<object id="theGarden" classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" width="900" height="600" name="garden" align="center" bgcolor="#000000">
<param name="movie" value="GardenClient.swf" />
<param name="quality" value="high" />
<param name="bgcolor" value="#000000" />
<!--[if !IE]>-->
<object type="application/x-shockwave-flash" data="GardenClient.swf" width="900" height="600" name="garden" align="center" bgcolor="#000000">
<!--<![endif]-->
<div>
<p>To view the Garden, please obtain the latest version of Flash:</p>
<p><a href="http://www.adobe.com/go/getflashplayer"><img src="http://www.adobe.com/images/shared/download_buttons/get_flash_player.gif" alt="Get Adobe Flash player" /></a></p>
</div>
<!--[if !IE]>-->
</object>
<!--<![endif]-->
</object>
</div>

<?php
$path = '/home/na/nateboxer.net/php/';
if( $_SERVER['SERVER_NAME'] == "localhost" ) {
	$path = '../../php/';
}
require_once $path . 'Garden.php';
require_once $path . 'Gardener.php';

$garden = Garden::instance();
$back = '';
if( Gardener::isFirstTime( $_SERVER['REMOTE_ADDR'] ) ) {
	$back = ' back';
}	
?>

<div id="titleDiv" align="center">
	<p class="title"> Welcome To The Garden - <a href="">gardening</a> | <a href="">artist statement</a> | <a href="">project notes</a> </p>
</div>

<div id="bottomDiv"></div>

</div>

</body>
</html>
