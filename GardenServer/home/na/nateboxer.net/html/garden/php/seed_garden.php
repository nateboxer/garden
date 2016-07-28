<?php
echo "<?xml version=\"1.0\" encoding=\"utf-8\"?>\n";
echo "<garden>\n";

$path = '/home/na/nateboxer.net/php/';
if( $_SERVER['SERVER_NAME'] == "localhost" ) {
	$path = '../../../php/';
}
require_once $path . 'Garden.php';

$garden = Garden::instance();
$garden->init();

if( isset( $_REQUEST['password'] ) && isset( $_REQUEST['pop'] ) ) {
	$garden->seedGarden( $_REQUEST['password'], $_REQUEST['pop'] );
	echo '</garden>';
} else {
	echo '<error/>';
	echo '</garden>';
	exit( 0 );
}


?>
