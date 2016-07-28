<?php
require_once 'Garden.php';
require_once 'DNA.php';

class Plant {
	public static $GeneSpace = 'abcdefghijklmnopqrstuvwxyz';
	
	const MAX_GENES = 300; // Must match DB schema
	const MAX_NAME_LENGTH = 30; // must match DB schema

	const MUTATE_RATE = 2; // of 100
	
	const MIN_AGE = 50;
	const MAX_AGE = 450;
	const MIN_TOTAL_PHENES = 50;
	const MAX_TOTAL_PHENES = 500;
	const MIN_TIPS = 3;
	const MAX_TIPS = 13;	
	const MIN_CODON_RANGE = 2;
	const MAX_CODON_RANGE = 5;
	const MIN_PHENE_SET_SIZE = 4;
	const MAX_PHENE_SET_SIZE = 25;
		
	public $id;
	public $maxAge;
	public $maxPhenes;
	public $maxTips;
	public $x;
	public $genes = '';
	public $startTick;
	public $parentDNAID = 0;
	public $parentName = '';
	public $codonRange;
	public $pheneSetSize;
	
	public function Plant() {}
	
	public static function createRandomPlant( $startTick ) {
		$plant = new Plant();
		
		$genes = '';
		for( $j = 0; $j < Plant::MAX_GENES; $j++ ) {
			$genes .= Plant::getRandomGene();
		}
		$plant->genes = $genes;
	
		$plant->id = 0; // invalid
		$plant->startTick = $startTick;
		$plant->x = mt_rand( 0, Garden::GARDEN_WIDTH );
		$plant->maxAge = mt_rand( Plant::MIN_AGE, Plant::MAX_AGE );
		$plant->maxPhenes = mt_rand( Plant::MIN_TOTAL_PHENES, Plant::MAX_TOTAL_PHENES );
		$plant->maxTips = mt_rand( Plant::MIN_TIPS, Plant::MAX_TIPS );
		$plant->parentDNAID = 0;
		$plant->parentName = 'r' . mt_rand( 0, 1000000 );
		$plant->codonRange = mt_rand( Plant::MIN_CODON_RANGE, Plant::MAX_CODON_RANGE );
		$plant->pheneSetSize = mt_rand( Plant::MIN_PHENE_SET_SIZE, Plant::MAX_PHENE_SET_SIZE );
		
		return $plant;
	}
	
	public function recombineWithoutInsert( $dna, $x, $mutateRate ) {
		
		$this->x = $x;
		$this->startTick = Garden::instance()->ticks - 1;
		
		$newGenes = '';
		$dnaGeneLength = strlen( $dna->genes );
		for( $i = 0; $i < Plant::MAX_GENES; $i++ ) {
			if( (mt_rand( 0, 100 ) >= $mutateRate) && ($i < $dnaGeneLength) ) {
				
				// copy gene from dna
				$newGenes .= $dna->genes[$i];
				
			} else {
				
				// change gene letter
				$newGenes .= Plant::getRandomGene();
			}
		}
		$this->genes = $newGenes;

		if( mt_rand( 0, 100 ) < $mutateRate ) {
			$this->maxAge = mt_rand( Plant::MIN_AGE, Plant::MAX_AGE );
		} else {
			$this->maxAge = $dna->maxAge;
		} 

		if( mt_rand( 0, 100 ) < $mutateRate ) {
			$this->maxPhenes = mt_rand( Plant::MIN_TOTAL_PHENES, Plant::MAX_TOTAL_PHENES );
		} else {
			$this->maxPhenes = $dna->maxPhenes;
		} 

		if( mt_rand( 0, 100 ) < $mutateRate ) {
			$this->maxTips = mt_rand( Plant::MIN_TIPS, Plant::MAX_TIPS );
		} else {
			$this->maxTips = $dna->maxTips;
		} 

		if( mt_rand( 0, 100 ) < $mutateRate ) {
			$this->codonRange = mt_rand( Plant::MIN_CODON_RANGE, Plant::MAX_CODON_RANGE );
		} else {
			$this->codonRange = $dna->codonRange;
		} 

		if( mt_rand( 0, 100 ) < $mutateRate ) {
			$this->pheneSetSize = mt_rand( Plant::MIN_PHENE_SET_SIZE, Plant::MAX_PHENE_SET_SIZE );
		} else {
			$this->pheneSetSize = $dna->pheneSetSize;
		} 
			
		$this->parentDNAID = $dna->id;
		$this->parentName = $dna->name;
	}
	
	public function recombine( $dna, $x, $mutateRate ) {
		$this->recombineWithoutInsert( $dna, $x, $mutateRate );		
		$this->insert();		
	}
	
	public static function getRandomGene() {
		return Plant::$GeneSpace[ mt_rand( 0, strlen( Plant::$GeneSpace ) - 1 ) ];
	}
	
	public function parseRow( $row ) {
		$this->id = $row['id'];
		$this->startTick = $row['start_tick'];
		$this->x = $row['x'];
		$this->maxAge = $row['max_age'];
		$this->maxPhenes = $row['max_phenes'];
		$this->maxTips = $row['max_tips'];
		$this->genes = $row['genes'];
		$this->parentDNAID = $row['parent_dna_id'];
		$this->parentName = $row['parent_name'];
		$this->codonRange = $row['codon_range'];
		$this->pheneSetSize = $row['phene_set_size'];
	}
	
	private function insert() {
		$query = 'insert into plants ( start_tick, x, max_age, max_phenes, max_tips, genes, parent_dna_id, parent_name, codon_range, phene_set_size ) values ('
			. $this->startTick . ','
			. $this->x . ','
			. $this->maxAge . ','
			. $this->maxPhenes . ','
			. $this->maxTips . ','
			. "'" . $this->genes . "',"
			. $this->parentDNAID . ','
			. "'" . $this->parentName . "',"
			. $this->codonRange . ','
			. $this->pheneSetSize
			. ')';
		if( !mysql_query( $query ) ) {
			echo 'error inserting plant: ' . $query;
			return;
		}
		//echo $query . ' {} ';
		$query = 'select LAST_INSERT_ID()';
		$result = mysql_query( $query );
		if( !$result ) {
			echo 'error getting last ID';
			return;
		}
		$row = mysql_fetch_array( $result );
		$this->id = $row[0];
	}
	
	public function toXML() {
		$xml = '<plant'
			. ' id="' . $this->id . '"'
			. ' x="' . $this->x . '"'
			. ' maxAge="' . $this->maxAge . '"'
			. ' maxPhenes="' . $this->maxPhenes . '"'
			. ' maxTips="' . $this->maxTips . '"'
			. ' parentDNAID="' . $this->parentDNAID . '"'
			. ' parentName="' . $this->parentName . '"'
			. ' codonRange="' . $this->codonRange . '"'
			. ' pheneSetSize="' . $this->pheneSetSize . '"'
			. '>'
			. $this->genes
			. "</plant>\n";
		return $xml;
	}
}
?>