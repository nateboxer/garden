<?php
require_once 'Gardener.php';
require_once 'Plant.php';
require_once 'DNA.php';

class Garden {
	const NORMAL_POP = 618;
	const GARDEN_WIDTH = 100000;
	const MIN_TICK_INTERVAL = 1; // seconds
	const BIRTHS_PER_TICK = 100;
 	const DNA_RANK_BY_TIME_LIMIT = 5000;//1000;
 	//const DNA_RANK_BY_VOTE_LIMIT = 50;
 	const VB_RANK_BY_TIME_LIMIT = 2500;
 	//const VB_RANK_BY_VOTE_LIMIT = 100;
 	const VB_TOTAL_BY_TIME = 7;
 	const VB_TOTAL_BY_VOTE = 1; // NA
 	const VB_TOTAL = 8; // 1 is random, or more if time and vote are not enough
    const RECOMBINES_PER_DNA_BY_PLANT = 4;
    const RECOMBINES_PER_DNA_BY_NAME = 1;
    const CHILD_X_RANGE = 10000;
    
    private static $instance;
    
    public $ticks = 0;
    public $lastTime;
    public $plantCount = 0;
    public $birthCount = 0;
    public $gardenerCount = 0;
    
    private function __construct() {
 		$db = mysql_connect( "xxx", "xxx", "xxx" );
		if( $db ) {
			if( !mysql_select_db( "garden", $db ) ) {
				echo 'error selecting db';
			}
		} else {
			echo 'mysql connect error';
		}
	}
	
	public function init() {
		$this->getGardenInfo();
		$this->getPlantAndGardenerCount();
	}

	public static function instance() {
        if (!isset(self::$instance)) {
            $c = __CLASS__;
            self::$instance = new $c;
        }
        return self::$instance;
	}
		
	private function getGardenInfo() {
		$query = "select * from global";
		$result = mysql_query( $query );
		if( $result ) {
			$row = mysql_fetch_assoc( $result );
			$this->ticks = $row['ticks'];
			$this->lastTime = $row['last_time'];
		} else {
			echo 'problem getting global info';
		}
	}
    
    public function notTooSoon() {
    	if( $this->lastTime <= (time() - Garden::MIN_TICK_INTERVAL) ) {
    		return true;
    	}
    	return false;
    }
    
    public function tick() {
    	$this->ticks++;
    }

	public function commit() {
    	$query = 'update global'
    		. ' set ticks = ' . $this->ticks
    		. ', last_time = ' . time();
		$result = mysql_query( $query );
		if( !$result ) {
			echo 'unable to update global: ' . $query;
			return;
		}
	}
	
	public function cullPlants() {
		$query = 'delete from plants where (' 
			. $this->ticks . ' - start_tick) > max_age';
		$result = mysql_query( $query );
		if( !$result ) {
			echo 'unable to update plants: ' . $query;
			return;
		}		
 	}
	 
    public function getPlants( $x1, $x2 ) {
    	if( $x2 >= $x1 ) {
    		$query = "select * from plants where x >= $x1 and x <= $x2";
    	} else {
    		$query = "select * from plants where x >= $x1 or x <= $x2";
    	}
		$plants = array();
		if( $result = mysql_query( $query ) ) {
			while( $row = mysql_fetch_assoc( $result ) ) {
				$plant = new Plant();
				$plant->parseRow( $row );
				array_push( $plants, $plant );
			}
		}
		return $plants;
    }
    
    private function getPlantAndGardenerCount() {
		$this->plantCount = 0;
    	$query ="select count(*) from plants";
    	if( $result = mysql_query( $query ) ) {
    		$row = mysql_fetch_array( $result );
    		if( $row[0] ) {
    			$this->plantCount = $row[0];
    		}
    	}
		$this->gardenerCount = 0;
//    	$query ="select count(*) from gardeners";
//    	if( $result = mysql_query( $query ) ) {
//    		$row = mysql_fetch_array( $result );
//    		if( $row[0] ) {
//    			$this->gardenerCount = $row[0];
//    		}
//    	}
    }
    
    // returns true if plants created
    public function checkPlantPop() {
		if( $this->plantCount < Garden::NORMAL_POP ) {
			$this->createPlants();
			return true;
		}
		return false;
   }
    
    private function createPlants() {
 		$dnas = $this->getDNAForRecombination();
   		$this->birthCount = 0;   		
		
		$i = 0;
		while( $i < Garden::BIRTHS_PER_TICK ) {
			
			// pick random dna from top 100
			$dna = $dnas[ mt_rand( 0, count( $dnas )- 1 ) ];
			
			// do simple build of plant with mutation
			//$num = mt_rand( 2, Garden::RECOMBINES_PER_DNA );
			for( $j = 0; $j < Garden::RECOMBINES_PER_DNA_BY_PLANT; $j++ ) {
				$plant = new Plant();
				$plant->recombine( $dna, $this->getChildX( $dna->x ), Plant::MUTATE_RATE );
				$this->birthCount++;
				$i++;
			}
			
			// search for same species and recombine
			for( $k = 0; $k < count( $dnas ); $k++ ) {
				if( ($dna->parentName == $dnas[$k]->parentName) && ($dna->id != $dnas[$k]->id ) ) {
					//$num = mt_rand( 2, Garden::RECOMBINES_PER_DNA );
					for( $j = 0; $j < Garden::RECOMBINES_PER_DNA_BY_NAME; $j++ ) {
						$dna->recombine( $dnas[$k] );
						$plant = new Plant();
						$plant->recombine( $dna, $this->getChildX( $dna->x ), Plant::MUTATE_RATE );
						$this->birthCount++;
						$i++;
					}
					break;
				}
			}		
		}

		// seed random 10 plants
   		for( $i = 0; $i < 10; $i++ ) {
   			
   			$plant = Plant::createRandomPlant( $this->ticks - 1 );
		
			$query = 'insert into plants ( start_tick, x, max_age, max_phenes, max_tips, genes, parent_dna_id, parent_name, codon_range, phene_set_size ) values ('
				. $plant->startTick . ','
				. $plant->x . ','
				. $plant->maxAge . ','
				. $plant->maxPhenes . ','
				. $plant->maxTips . ','
				. "'" . $plant->genes . "',"
				. $plant->parentDNAID . ','
				. "'" . $plant->parentName . "',"
				. $plant->codonRange . ','
				. $plant->pheneSetSize
				. ')';
			    			
			if( !mysql_query( $query ) ) {
				echo '<error>' . $query . '</error>';
				break;
			}
   		}
    }
 
 	private function getChildX( $x ) {
		$x += ( mt_rand( 0, Garden::CHILD_X_RANGE ) - (Garden::CHILD_X_RANGE / 2) );
		if( $x > Garden::GARDEN_WIDTH ) {
			$x -= Garden::GARDEN_WIDTH;
		} else if( $x < 0 ) {
			$x += Garden::GARDEN_WIDTH;
		}
		return $x;
	}
 	
 	// used by vb_feed.xml and VotingBooth
    public function getDNAForVotingBooth() {
 		$dnas = array();    	
    	$ids = array();
    	
    	$query = 'select id from dna';
    	$result = mysql_query( $query );
    	if( !$result ) {
    		echo "error accessing plants: " + $query;
    	}
		while( $row = mysql_fetch_assoc( $result ) ) {
   			array_push( $ids, $row['id'] ); 	
		}
		for( $i = 0; $i < Garden::VB_TOTAL_BY_TIME; $i++ ) {
			$id = $ids[ mt_rand( 0, count( $ids ) - 1 ) ];
	    	$query = 'select * from dna where id = ' . $id;
	    	//echo( "<query>" . $query . "</query>" );
			if( $result = mysql_query( $query ) ) {
				if( $row = mysql_fetch_assoc( $result ) ) {
					$dna = new DNA();
					$dna->parseRow( $row );
					$parentID = $dna->id;
					$dna->x = $this->getChildX( $dna->x );
					$plant = new Plant();
					$plant->recombineWithoutInsert( $dna, $dna->x, (Plant::MUTATE_RATE * 3) );
					$dna = DNA::createDNAFromPlant( $plant, $dna->userIP );
					$dna->parentID = $parentID;
					array_push( $dnas, $dna );
				}
			}
		}
		
/*     		
   		// grab from most recent
    	$query = 'select * from dna order by created desc limit 0, ' . Garden::VB_RANK_BY_TIME_LIMIT;
    	$result = mysql_query( $query );
    	if( !$result ) {
    		echo "error accessing plants: " + $query;
    	}
    	$byTimecount = 0;
    	$threshold = Garden::VB_TOTAL_BY_TIME * 3;
		while( $row = mysql_fetch_assoc( $result ) ) {
			if( mt_rand(0, Garden::VB_RANK_BY_TIME_LIMIT) < $threshold ) {
				$dna = new DNA();
				$dna->parseRow( $row );
				$parentID = $dna->id;
				$dna->x = $this->getChildX( $dna->x );
				$plant = new Plant();
				$plant->recombineWithoutInsert( $dna, $dna->x );
				$dna = DNA::createDNAFromPlant( $plant, $dna->userIP );
				$dna->parentID = $parentID;
				array_push( $dnas, $dna );
				$byTimecount++;
				if( $byTimecount >= Garden::VB_TOTAL_BY_TIME ) {
					break;
				}
			}
		}
*/

//		// grab from top votes
//    	$query = 'select * from dna order by votes desc limit 0, ' . Garden::VB_RANK_BY_VOTE_LIMIT;
//    	$result = mysql_query( $query );
//    	if( !$result ) {
//    		echo "error accessing plants: " + $query;
//    	}
//    	$byVoteCount = 0;
//		while( $row = mysql_fetch_assoc( $result ) ) {
//			if( mt_rand( 0, 100 ) < 30 ) {
//				$dna = new DNA();
//				$dna->parseRow( $row );
//				$dna->x = $this->getChildX( $dna->x );
//				$plant = new Plant();
//				$plant->recombineWithoutInsert( $dna, $dna->x );
//				$dna = DNA::createDNAFromPlant( $plant, $dna->userIP );
//				array_push( $dnas, $dna );
//				$byVoteCount++;
//				if( $byVoteCount >= Garden::VB_TOTAL_BY_VOTE ) {
//					break;
//				}
//			}
//		}
//		
		// prepare random
		$dif = Garden::VB_TOTAL - count( $dnas );
		for( $i = 0; $i < $dif; $i++ ) {
			$plant = Plant::createRandomPlant( $this->ticks - 1 );
			$dna = DNA::createDNAFromPlant( $plant, 'void' );
			$dna->x = mt_rand( 0, Garden::GARDEN_WIDTH );
			array_push( $dnas, $dna );
		}
   		
		return $dnas;
    }
    
    // used by dna_feed.xml and DnaBrowser
    // and by Garden population!!
    public function getDNAForRecombination() {
 		$dnas = array();
   		
   		// grab from most recent
   		
    	$query = 'select * from dna order by created desc limit 0, ' . Garden::DNA_RANK_BY_TIME_LIMIT;

		// just getting Hieran for info graphic
    	//$query = 'select * from dna where id = 11122';
    	
     	//$query = 'select * from dna group by parent_name limit 0, ' . Garden::DNA_RANK_BY_TIME_LIMIT;
     	
    	$result = mysql_query( $query );
    	if( !$result ) {
    		echo "error accessing plants: " + $query;
    	}
		while( $row = mysql_fetch_assoc( $result ) ) {
			$dna = new DNA();
			$dna->parseRow( $row );
			array_push( $dnas, $dna );
		}

		// grab from top votes
//    	$query = 'select * from dna order by votes desc limit 0, ' . Garden::DNA_RANK_BY_VOTE_LIMIT;
//   	$result = mysql_query( $query );
//    	if( !$result ) {
//    		echo "error accessing plants: " + $query;
//    	}
//		while( $row = mysql_fetch_assoc( $result ) ) {
//			$dna = new DNA();
//			$dna->parseRow( $row );
//			array_push( $dnas, $dna );
//		}
   		
		return $dnas;
    }
    
    public function seedGarden( $password, $pop ) {
    	if( $password == 'fish4free' ) {
    		for( $i = 0; $i < $pop; $i++ ) {
    			
    			$query = 'insert into dna ( parent_id, parent_name, user_ip, votes, max_age, max_phenes, max_tips, genes, name, plant_id, x, codon_range, phene_set_size ) values (';
    			
    			$query .= ' 0,';
    			$query .= " 'god',";
    			$query .= " '127.0.0.1',";
    			$query .= ' 0,';
    			$query .= ' ' . mt_rand( Plant::MIN_AGE, Plant::MAX_AGE ) . ',';
    			$query .= ' ' . mt_rand( Plant::MIN_TOTAL_PHENES, Plant::MAX_TOTAL_PHENES ) . ',';
    			$query .= ' ' . mt_rand( Plant::MIN_TIPS, Plant::MAX_TIPS ) . ',';
    			
    			$genes = '';
    			for( $j = 0; $j < Plant::MAX_GENES; $j++ ) {
    				$genes .= Plant::getRandomGene();
    			}

				$query .= " '" . $genes . "',";
				$query .= " 'seed',";
				$query .= ' 0,';
				$query .= ' ' . mt_rand( 0, Garden::GARDEN_WIDTH ) . ',';
				$query .= ' ' . mt_rand( Plant::MIN_CODON_RANGE, Plant::MAX_CODON_RANGE ) . ',';
				$query .= ' ' . mt_rand( Plant::MIN_PHENE_SET_SIZE, Plant::MAX_PHENE_SET_SIZE );
				$query .= " )";
				    			
    			if( !mysql_query( $query ) ) {
    				echo '<error>' . $query . '</error>';
    				break;
    			}
    		}
    		echo '<seeded/>';
    	} else {
    		echo '<incorrect_password/>';
    	}
    }

	public function listGardeners( $password ) {
		if( $password == 'fish4free' ) {
			
			echo '<table border="1">';
				echo '<tr>'
					. '<th>IP</th>'
					. '<th>Last Time</th>'
					. '<th>Sessions</th>'
					. '<th>Notes</th>'
					. '</tr>';
			
			$gardeners = $this->getGardeners();
			for( $i = 0; $i < count( $gardeners ); $i++ ) {
				echo '<tr>'
					. '<td>' . $gardeners[$i]->ip . '</td>'
					. '<td>' . date( DATE_RFC822, $gardeners[$i]->lastTime ) . '</td>'
					. '<td>' . $gardeners[$i]->sessionCount . '</td>'
					. '<td>' . $gardeners[$i]->notes . '</td>'
					. '</tr>';
			}
			
			echo '</table>';
			
		} else {
			echo 'incorrect password.';
		}
	}

    private function getGardeners() {
		$gardeners = array();
    	$query ="select * from gardeners order by last_time desc";
    	if( $result = mysql_query( $query ) ) {
    		while( $row = mysql_fetch_array( $result ) ) {
    			$g = new Gardener();
    			$g->parseRow( $row );
    			array_push( $gardeners, $g );
    		}
    	}
    	return $gardeners;
    }   
}
?>
