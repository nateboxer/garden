<?php

$start_time = microtime(true);

echo "<?xml version=\"1.0\" encoding=\"utf-8\"?>\n";
echo "<garden>\n";

$path = '/home/na/nateboxer.net/php/';
if( $_SERVER['SERVER_NAME'] == "localhost" ) {
	$path = '../../../php/';
}
require_once $path . 'Garden.php';
require_once $path . 'Gardener.php';

$garden = Garden::instance();
$garden->init();

if( $garden->notTooSoon() ) {
	for( $i = 0; $i < 5; $i++ ) {
		$garden->tick();
	}
	$garden->commit();
	// either create new plants OR cull plants
	if( !$garden->checkPlantPop() ) {
		$garden->cullPlants();
	}
}

echo '<ticks>' . $garden->ticks . "</ticks>\n";
echo '<pop>' . $garden->plantCount . "</pop>\n";
echo '<births>' . $garden->birthCount . "</births>\n";
echo '<width>' . Garden::GARDEN_WIDTH . "</width>\n";

$userIP = null;
if( isset( $_SERVER['REMOTE_ADDR'] ) ) {
	$userIP = $_SERVER['REMOTE_ADDR'];
	//echo '<ip>' . $userIP . '</ip>';
}

$x1 = mt_rand( 0, Garden::GARDEN_WIDTH );
if( isset( $_REQUEST['x'] ) ) {
	$x1 = $_REQUEST['x'];
}

if( isset( $_REQUEST['requestLastViewX'] ) ) {
	if( $userIP != null ) {
		$query = "select * from gardeners where ip = '" . $userIP . "'";
		$result = mysql_query( $query );
		if( $result ) {
			if( mysql_num_rows( $result ) > 0 ) {
				$row = mysql_fetch_assoc( $result );
				$x1 = $row['x1'];
			}
		}
	}
	if( ($x1 < 0) || ($x1 > Garden::GARDEN_WIDTH) ) {
		$x1 = 0;
	}
	echo '<lastViewX>' . $x1 . "</lastViewX>\n";
}

$width = 1000;
if( isset( $_REQUEST['width'] ) ) {
	$width = $_REQUEST['width'];
}
$x2 = $width + $x1;
if( $x2 > Garden::GARDEN_WIDTH ) {
	$x2 -= Garden::GARDEN_WIDTH;
}

if( $userIP != null ) {
	Gardener::browse( $userIP, $x1, $x2 );
}

// return current plants
$x1 -= ($width * 3);
if( $x1 < 0 ) {
	$x1 += Garden::GARDEN_WIDTH;
}
$x2 += ($width * 3);
if( $x2 > Garden::GARDEN_WIDTH ) {
	$x2 -= Garden::GARDEN_WIDTH;
}

//	echo '<x1>' . $x1 . '</x1>';
//	echo '<x2>' . $x2 . '</x2>';

$plants = $garden->getPlants( $x1, $x2 );
foreach( $plants as $plant ) {
	echo $plant->toXML();
}

$end_time = microtime(true);

echo '<elapsed>' . round(($end_time - $start_time),2) . "</elapsed>\n";

echo '</garden>';

?>