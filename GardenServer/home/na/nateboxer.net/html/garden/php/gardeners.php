<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>G A R D E N E R S</title>
<link rel="shortcut icon" href="favicon.ico" type="image/x-icon"/>
<style media="screen" type="text/css">
* {
	margin: 0;
	padding: 0;
}
td {
	color: #202020; 
	font-family: 'Courier New', Courier, monospace; 
	font-size: 13px;
	padding: 10px;
}
th {
	color: #202020; 
	font-family: 'Courier New', Courier, monospace; 
	font-size: 13px;
	font-weight: bold;
	padding: 10px;
}
</style>
</head>
<body bgcolor="#EDE5DE">
<div align="center">
<?php

$path = '/home/na/nateboxer.net/php/';
if( $_SERVER['SERVER_NAME'] == "localhost" ) {
	$path = '../../../php/';
}
require_once $path . 'Garden.php';

$garden = Garden::instance();
$garden->init();

if( isset( $_REQUEST['password'] ) ) {
	$garden->listGardeners( $_REQUEST['password'] );
}

?>
</div>
</body>
</html>
