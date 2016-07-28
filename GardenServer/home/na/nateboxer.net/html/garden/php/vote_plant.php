<?php

$path = '/home/na/nateboxer.net/php/';
if( $_SERVER['SERVER_NAME'] == "localhost" ) {
	$path = '../../../php/';
}
require_once $path . 'Garden.php';
require_once $path . 'DNA.php';

$garden = Garden::instance();
$garden->init();

$dna = new DNA();

if( isset( $_REQUEST['maxAge'] ) ) {
	$dna->maxAge = $_REQUEST['maxAge'];
} else {
	exit( 0 );
}

if( isset( $_REQUEST['maxPhenes'] ) ) {
	$dna->maxPhenes = $_REQUEST['maxPhenes'];
} else {
	exit( 0 );
}

if( isset( $_REQUEST['maxTips'] ) ) {
	$dna->maxTips = $_REQUEST['maxTips'];
} else {
	exit( 0 );
}

if( isset( $_REQUEST['genes'] ) ) {
	$dna->genes = $_REQUEST['genes'];
} else {
	exit( 0 );
}

if( isset( $_REQUEST['pDNAID'] ) ) {
	$dna->parentID = $_REQUEST['pDNAID'];
} else {
	exit( 0 );
}

if( isset( $_REQUEST['pName'] ) ) {
	$dna->parentName = $_REQUEST['pName'];
} else {
	exit( 0 );
}

if( isset( $_REQUEST['source'] ) ) {
	$dna->source = $_REQUEST['source'];
} else {
	exit( 0 );
}

if( isset( $_REQUEST['codonRange'] ) ) {
	$dna->codonRange = $_REQUEST['codonRange'];
} else {
	exit( 0 );
}

if( isset( $_REQUEST['pheneSetSize'] ) ) {
	$dna->pheneSetSize = $_REQUEST['pheneSetSize'];
} else {
	exit( 0 );
}

$naughty = array( 'set ', 'drop ', 'where ', 'select ', 'update ', 'delete ', ';', "'", '=' );

if( isset( $_REQUEST['name'] ) ) {
	$name = $_REQUEST['name'];
	$name = str_replace( $naughty, '', $name );
	$dna->name = $name;
} else {
	exit( 0 );
}

if( isset( $_REQUEST['userX'] ) ) {
	$dna->x = $_REQUEST['userX'];
} else {
	exit( 0 );
}

if( isset( $_REQUEST['plantID'] ) ) {
	$dna->plantID = $_REQUEST['plantID'];
} else {
	exit( 0 );
}

if( isset( $_SERVER['REMOTE_ADDR'] ) ) {
	$dna->userIP = $_SERVER['REMOTE_ADDR'];
}

$checkPriorVote = true;
if( isset( $_REQUEST['ignorePriorVote'] ) ) {
	$checkPriorVote = false;
}

$dna->votes = 1;

echo "<?xml version=\"1.0\" encoding=\"utf-8\"?>\n";
echo "<garden>\n";

// check for same vote, same plant_id && same user_ip
//$newPlant = true;
if( $checkPriorVote ) {
	$query = "select id from dna where user_ip = '$dna->userIP' and plant_id = $dna->plantID";
	$result = mysql_query( $query );
	if( $result ) {
		if( mysql_num_rows( $result ) > 0 ) {
			
			$row = mysql_fetch_assoc( $result );
			$dna->id = $row['id'];
			
			// just up votes
			$query = "update dna set votes = (votes + 1) where id = $dna->id";
			$result = mysql_query( $query );
			if( !$result ) {
				echo 'error updating dna votes: ' . $query;
			} else {
				echo "<result>DNA votes incremented</result>\n";
			}			
			
			//$newPlant = false;
		} else {
			$dna->insert();
		}
	} else {
		echo 'error checking dna dupes: ' . $query;
	}
} else {
	$dna->insert();	
}

echo '</garden>';

//if( $newPlant ) {
//	// seed 10 plants just voted for within 10000 pixels of user/dna
//	for( $i = 0; $i < 5; $i++ ) {
//		$x = round($dna->x + (mt_rand(0, 5000) - 2500));
//		if( $x < 0 ) {
//			$x += Garden::GARDEN_WIDTH;
//		} else if( $x > Garden::GARDEN_WIDTH ) {
//			$x -= Garden::GARDEN_WIDTH;
//		}
//		$plant = new Plant();
//		$plant->recombine( $dna, $x );
//	}
//}

?>
