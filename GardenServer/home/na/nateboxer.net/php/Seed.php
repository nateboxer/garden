<?php
class Seed {
	
	public $id = -1;
	public $parent_id = 0;
	public $name = '';
	public $user_ip = '';
	public $created = '';
	public $genes = '';
	public $children = 0;
	public $views = 1;
	public $generation = 1;
	
	public function Seed() {}
	
	public function parseRow( $row ) {
		$this->id = $row['id'];
		$this->parent_id = $row['parent_id'];
		$this->name = $row['name'];
		$this->user_ip = $row['user_ip'];
		$this->created = $row['created'];
		$this->genes = $row['genes'];
		$this->children = $row['children'];
		$this->views = $row['views'];
		$this->generation = $row['generation'];
	}
	
	public function toXML() {
		$xml = '<seed'
			. ' id="' . $this->id . '"'
			. ' parent_id="' . $this->parent_id . '"'
			. ' name="' . $this->name . '"'
			. ' user_ip="' . $this->user_ip . '"'
			. ' created="' . $this->created . '"'
			. ' children="' . $this->children . '"'
			. ' views="' . $this->views .'"'
			. ' generation="' . $this->generation . '"'
			. '>'
			. $this->genes
			. "</seed>\n";
		return $xml;
	}
}