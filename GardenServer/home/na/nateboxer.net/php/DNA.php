<?php
class DNA {
	
	public $id;
	public $parentID = 0;
	public $parentName = '';
	public $userIP = '';
	public $votes = 0;
	public $maxAge = 0;
	public $maxPhenes = 0;
	public $maxTips = 0;
	public $genes = '';
	public $name = '';
	public $plantID = 0;
	public $x = 0;
	public $source = 0;
	public $codonRange;
	public $pheneSetSize;
	
	public function DNA() {}
	
	public static function createDNAFromPlant( $plant, $userIP ) {
		$dna = new DNA();
		
		$dna->id = 0; // invalid
		$dna->parentID = $plant->parentDNAID;
		$dna->parentName = $plant->parentName;
		$dna->userIP = $userIP;
		$dna->votes = 0;
		$dna->maxAge = $plant->maxAge;
		$dna->maxPhenes = $plant->maxPhenes;
		$dna->maxTips = $plant->maxTips;
		$dna->genes = $plant->genes;
		$dna->name = $plant->parentName;
		$dna->plantID = $plant->id;
		$dna->x = $plant->x;
		$dna->codonRange = $plant->codonRange;
		$dna->pheneSetSize = $plant->pheneSetSize;
		
		return $dna;
	}
	
	public function insert() {
		$query = 'insert into dna (parent_id, parent_name, user_ip, votes, max_age, max_phenes, max_tips, genes, name, plant_id, x, source, codon_range, phene_set_size) values ('
			. $this->parentID . ','
			. "'" . $this->parentName . "',"
			. "'" . $this->userIP . "',"
			. $this->votes . ','
			. $this->maxAge . ','
			. $this->maxPhenes . ','
			. $this->maxTips . ','
			. "'" . $this->genes . "',"
			. "'" . $this->name . "',"
			. $this->plantID . ','
			. $this->x . ','
			. $this->source . ','
			. $this->codonRange . ','
			. $this->pheneSetSize
			. ')';
		$result = mysql_query( $query );
		if( $result ) {
		
			// get $id
			$query = 'select LAST_INSERT_ID()';
			$result = mysql_query( $query );
			if( !$result ) {
				echo 'error getting last ID';
			} else {
				$row = mysql_fetch_array( $result );
				$this->id = $row[0];
			}
					
			// update parent votes
			$query = 'update dna set votes = (votes + 1) where id = ' . $this->parentID;
			$result = mysql_query( $query );
			if( $result ) {
				echo "<result>DNA added</result>\n";
			} else {
				echo "<result>Error updating parent votes: " . $query . "</result>\n";
			}
		} else {
			echo "<result>Error adding DNA: " . $query . "</result>\n";
		}
	}
	
	public function parseRow( $row ) {
		$this->id = $row['id'];
		$this->parentID = $row['parent_id'];
		$this->parentName = $row['parent_name'];
		$this->userIP = $row['user_ip'];
		$this->votes = $row['votes'];
		$this->maxAge = $row['max_age'];
		$this->maxPhenes = $row['max_phenes'];
		$this->maxTips = $row['max_tips'];
		$this->genes = $row['genes'];
		$this->name = $row['name'];
		$this->plantID = $row['plant_id'];
		$this->x = $row['x'];
		$this->source = $row['source'];
		$this->codonRange = $row['codon_range'];
		$this->pheneSetSize = $row['phene_set_size'];
	}
	
	public function recombine( $dna ) {
		
		// choose which dna's age
		if( mt_rand( 0, 100 ) < 50 ) {
			$this->maxAge = $dna->maxAge;
		}

		// choose which dna's max phenes
		if( mt_rand( 0, 100 ) < 50 ) {
			$this->maxPhenes = $dna->maxPhenes;
		}

		// choose which dna's max phenes
		if( mt_rand( 0, 100 ) < 50 ) {
			$this->maxTips = $dna->maxTips;
		}

		// choose which dna's x pos
		if( mt_rand( 0, 100 ) < 50 ) {
			$this->x = $dna->x;
		}

		// choose which dna's codon range
		if( mt_rand( 0, 100 ) < 50 ) {
			$this->codonRange = $dna->codonRange;
		}

		// choose which dna's phene set size
		if( mt_rand( 0, 100 ) < 50 ) {
			$this->pheneSetSize = $dna->pheneSetSize;
		}
		
		// splice genes, choose longest
		$thisGeneCount = strlen( $this->genes );
		$dnaGeneCount = strlen( $dna->genes );
		$geneLength = $thisGeneCount;
		if( $dnaGeneCount > $geneLength ) {
			$geneLength = $dnaGeneCount;
		}
		$newGenes = '';
		for( $i = 0; $i < $geneLength; $i++ ) {
			if( (mt_rand( 0, 100 ) < 50) && ($i < $thisGeneCount) ) {
				$newGenes .= $this->genes[$i];
			} else if( $i < $dnaGeneCount ) {
				$newGenes .= $dna->genes[$i];
			}
		}
		$this->genes = $newGenes;
	}
	
	public function toXML() {
		$xml = '<dna'
			. ' id="' . $this->id . '"'
			. ' parentDNAID="' . $this->parentID . '"'
			. ' parentName="' . $this->parentName . '"'
			. ' name="' . $this->name . '"'
			. ' userIP="' . $this->userIP . '"'
			. ' votes="' . $this->votes . '"'
			. ' maxAge="' . $this->maxAge . '"'
			. ' maxPhenes="' . $this->maxPhenes . '"'
			. ' maxTips="' . $this->maxTips . '"'
			. ' x="' . $this->x . '"'
			. ' source="' . $this->source . '"'
			. ' codonRange="' . $this->codonRange . '"'
			. ' pheneSetSize="' . $this->pheneSetSize . '"'
			. '>'
			. $this->genes
			. "</dna>\n";
		return $xml;
	}
}
?>
