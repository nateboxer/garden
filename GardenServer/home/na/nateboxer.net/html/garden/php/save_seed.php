<?php

echo "<?xml version=\"1.0\" encoding=\"utf-8\"?>\n";
echo "<seed>";

$path = '/home/na/nateboxer.net/php/';
if( $_SERVER['SERVER_NAME'] == "localhost" ) {
	$path = '../../../php/';
}
require_once $path . 'Evolver.php';
$evolver = new Evolver();

$genes = $_POST['genes'];
$parent_id = $_POST['parent_id'];
$name = $_POST['name'];
$generation = $_POST['generation'];

$user_ip = '';
if( isset( $_SERVER['REMOTE_ADDR'] ) ) {
	$userIP = $_SERVER['REMOTE_ADDR'];
}

echo $evolver->saveSeed( $genes, $parent_id, $name, $user_ip, $generation );

echo "</seed>\n";

?>