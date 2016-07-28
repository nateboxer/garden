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
#infoDiv {
	text-align: left;
	width: 600px;
	padding-top: 20px;
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
	<p class="title"> Welcome To The Garden - <a href="http://nateboxer.net/notes/alife/" target="_blank">project notes</a> </p>
</div>

<div id="infoDiv">
   
	<p class="subtitle"><b>What is the Garden?</b></p>
	
	<p>The Garden is a persistent, evolving, interactive art project 
	that you influence by voting for the plants you like the most. 
	The fittest plants, those that get the most votes, 
	will reproduce and recombine more often than those less fit.</p>
			
	<p class="subtitle"><b>How to vote</b></p>
	
	<p>Vote for a plant by clicking on it and then clicking the Vote button. 
	You can optionally give that plant a name to track its descendants.
	Someday, you may return to the Garden to discover a plant you chose
	is now a very popular and common species.</p>
	
	<p class="subtitle"><b>Take a walk</b></p>
	
	<p>Some species of plants only grow in certain parts. 
	So, if you want to see new plant forms, you need to do a little exploring.
	(To explore the Garden, click and drag your mouse left and right.)</p>

	<p class="subtitle"><b>What does voting do?</b></p>
	
	<p>When you vote for a plant, its DNA is added to the Garden's seed bank.
	From then on, there is a chance that the DNA will be used 
	when more seeds are planted.</p>
		
	<p class="subtitle"><b>How big is the Garden and what is Kpx?</b></p>
	
	<p>The Garden is very large, 100,000 pixels wide. The distance markers
	you occasionally see tell you where you are in thousands (K) of pixels (px).
	For example, 65 Kpx means you are near the 65,000th pixel mark.</p>

	<p class="subtitle"><b>Controls:</b></p>
	
	<p>* Click on plants to vote for them.<br/><br/>
	* Click the Vote button to vote (or hit the Enter key.)<br/><br/>
	* Hit the escape key or click Cancel to hide the vote panel.<br/><br/>
	* Click and drag, left and right, to explore the Garden.<br/><br/>
	* Browse plants with the left and right arrow keys.</p>
	
	<p class="subtitle"><b>Questions, comments, suggestions?</b></p>

	<p>Please email me:<br/><br/>
	&nbsp;&nbsp;&nbsp;<img src="i/contact.gif"/></p>
	
</div>

<div id="bottomDiv"></div>

</div>

</body>
</html>
