<?php
echo "<?xml version=\"1.0\" encoding=\"utf-8\"?>\n";

$path = '/home/na/nateboxer.net/php/';
if( $_SERVER['SERVER_NAME'] == "localhost" ) {
	$path = '../../../php/';
}
require_once $path . 'Evolver.php';
$evolver = new Evolver();

$seed = $evolver->getRandomSeed();
echo $seed->toXML();

?>