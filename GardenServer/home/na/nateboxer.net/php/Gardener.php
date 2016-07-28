<?php
require_once 'Garden.php';

class Gardener {
	const SESSION_THRESHOLD = 300; // if >= 5 min since lastTime, sessionCount++
	
	public $ip;
	public $x1;
	public $x2;
	public $firstTime;
	public $lastTime;
	public $sessionCount;
	public $notes;

	public function Gardener() {}
	
	public static function browse( $ip, $x1, $x2 ) {	
		$query = "select * from gardeners where ip = '$ip'";
		if( $result = mysql_query( $query ) ) {
			$g = new Gardener();
			if( mysql_num_rows( $result ) < 1 ) {
				$g->ip = $ip;
				$g->x1 = $x1;
				$g->x2 = $x2;
				$g->insert();
			} else {
				if( $row = mysql_fetch_assoc( $result ) ) {
					$g->parseRow( $row );
					$g->checkAttention( $x1, $x2 );
				} else {
					echo 'Error fetching row: ' . $query;
				}
			}
		} else {
			echo 'Error accessing gardeners: ' . $query;
		}		
	}
	
	private function checkAttention( $x1, $x2 ) {	
	   	if( $this->lastTime <= (time() - Garden::MIN_TICK_INTERVAL) ) {
			
			// if new session
			$newSession = false;
			if( time() >= ($this->lastTime + Gardener::SESSION_THRESHOLD) ) {
				$this->sessionCount++;
				$newSession = true;
			}
			
			// if gardener is active
			if( ($x1 != $this->x1) || ($x2 != $this->x2) || $newSession ) {
				$this->x1 = $x1;
				$this->x2 = $x2;
			}
			
			$this->lastTime = time();
			
			$this->update();
	   	}
	}

	public function parseRow( $row ) {
		$this->ip = $row['ip'];
		$this->x1 = $row['x1'];
		$this->x2 = $row['x2'];
		$this->firstTime = $row['first_time'];
		$this->lastTime = $row['last_time'];
		$this->sessionCount = $row['session_count'];
		$this->notes = $row['notes'];
	}
		
	private function insert() {
		$query = 'insert into gardeners ( ip, x1, x2, first_time, last_time, session_count ) values ('
			. "'$this->ip',"
			. $this->x1 . ','
			. $this->x2 . ','
			. time() . ','
			. time() . ','
			. '1' . ' )';
			
		$result = mysql_query( $query );
		if( !$result ) {
			echo "error inserting gardener: " . $query;
		}
	}
	
	private function update() {
		$query = 'update gardeners set'
			. " x1 = $this->x1,"
			. " x2 = $this->x2,"
			. " last_time = $this->lastTime,"
			. " session_count = $this->sessionCount"
			. " where ip = '$this->ip'";
		if( !mysql_query( $query ) ) {
			echo "error updating gardener: " . $query;
		}
	}
	
	public static function isFirstTime( $ip ) {
		$query = 'select ip from gardeners where ip = '
			. "'$ip'";
		$result = mysql_query( $query );
		if( $result ) {
			if( mysql_num_rows( $result ) > 0 ) {
				return true;
			}
		}
		return false; 
	}
}
?>
