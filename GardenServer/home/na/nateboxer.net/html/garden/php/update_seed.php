<?php

echo "<?xml version=\"1.0\" encoding=\"utf-8\"?>\n";
echo "<seed>";

$path = '/home/na/nateboxer.net/php/';
if( $_SERVER['SERVER_NAME'] == "localhost" ) {
	$path = '../../../php/';
}
require_once $path . 'Evolver.php';
$evolver = new Evolver();

$id = $_POST['id'];
$name = $_POST['name'];

echo $evolver->updateSeed( $id, $name );

echo "</seed>\n";

?>