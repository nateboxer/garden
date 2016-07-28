package net.nateboxer.garden.plants {
	import mx.core.Application;
	
	public class Gene {				
		public static const GENE_SPACE:String = "abcdefghijklmnopqrstuvwxyz";
		public static const GENE_RANGE:Number = GENE_SPACE.length;
		
		public static const STEM_TYPE:String = "s";
		public static const STEM_GENE_LENGTH:int = 7;
		
		public static const BRANCH_TYPE:String = "b";
		public static const BRANCH_GENE_LENGTH:int = 4;
		
		public static const FRUIT_TYPE:String = "f";
		public static const FRUIT_GENE_LENGTH:int = 7;
		
		public static const CODON_TYPE:String = "c";
		public static const CODON_GENE_LENGTH:int = 3;
		
		public static const GENE_PREFIX_LENGTH:int = 2;
		
		public static const ALL_TYPES:Array = [ STEM_TYPE, STEM_TYPE, STEM_TYPE, STEM_TYPE, STEM_TYPE, 
												BRANCH_TYPE, BRANCH_TYPE, BRANCH_TYPE, 
												FRUIT_TYPE, FRUIT_TYPE, 
												CODON_TYPE, CODON_TYPE, CODON_TYPE, CODON_TYPE ];
		
		/*
			[gene prefix] [attributes]
			[type, codon_state] [...]
			
			Stem: [s, codon_state] [angle, length, width, color1, color2] (7)
			Branch: [b, codon_state] [angle, style] (4)
			Fruit: [f, codon_state] [style, attribute1, attribute2, color1, color2] (7)
			Codon: [c, codon_state] [codon_state] (3)
		*/
		
		public var type:String;
		public var codonState:int;
		public var attributes:Array;
		
		// Hieran
		public var geneSegment:String;
		public var geneIndex:int;
		
		public function Gene() {}

		public static function parseGenes( plant:Plant ):Array {
			var genes:Array = new Array();
			var geneIndex:int = 0;
			while( geneIndex < (plant.genes.length - GENE_PREFIX_LENGTH) ) {
				var gene:Gene = new Gene();

				// build prefix
				gene.type = getValueForAtt( (plant.genes.charCodeAt( geneIndex ) - 97), plant.pheneTypes );
				gene.codonState = getIndex( plant.genes.charCodeAt( geneIndex + 1 ) - 97, plant.codonRange );
				
				// if we go off the genome end
				if( (geneIndex + gene.geneLength) >= plant.genes.length ) {
					break;
				}
				
				// get attributes
				gene.attributes = new Array();
				for( var i:int = GENE_PREFIX_LENGTH; i < gene.geneLength; i++ ) {
					gene.attributes[i - GENE_PREFIX_LENGTH] = plant.genes.charCodeAt( geneIndex + i ) - 97;
				}

				// Hieran
				gene.geneSegment = plant.genes.substr( geneIndex, gene.geneLength );
				gene.geneIndex = genes.length;
				
				trace( gene.toString() );
				
				genes.push( gene );
				
				geneIndex += gene.geneLength;
			}
			
			return genes;
		}

		public function get geneLength():int {
			if( isStem ) {
				return STEM_GENE_LENGTH;
			} else if( isBranch ) {
				return BRANCH_GENE_LENGTH;
			} else if( isCodon ) {
				return CODON_GENE_LENGTH;
			}
			return FRUIT_GENE_LENGTH;
		}
									
		// returns array member
		public static function getValueForAtt( attribute:int, values:Array ):* {
			return values[ getIndex( attribute, values.length ) ];
		}
		
		// returns int in range
		public static function getIndex( attribute:int, range:int ):int {
			return Math.floor( getRange(attribute) * range );
		}
		
		// returns 0..1
		public static function getRange( attribute:int ):Number {
			return Number( attribute / GENE_RANGE );
		}
		
		public static function getColor( color1:int, color2:int ):uint {
			var totalRange:Number = GENE_RANGE * GENE_RANGE;
			var colorVal:Number = color1 * color2;
			return Math.floor((colorVal / totalRange) * uint.MAX_VALUE);
		}
		
		public function get isStem():Boolean {
			return( type == STEM_TYPE );
		}
		
		public function get isBranch():Boolean {
			return( type == BRANCH_TYPE );
		}
		
		public function get isFruit():Boolean {
			return( type == FRUIT_TYPE );
		}

		public function get isCodon():Boolean {
			return( type == CODON_TYPE );
		}
		
		public function toString():String {
			// Hieran
			var s:String = "";
			s +="Gene " + geneIndex + ": '" + geneSegment
				+ "'";
			s += "\nType: ";
			switch( type ) {
				case Gene.BRANCH_TYPE:
					s += "BRANCH";
					break;
				case Gene.STEM_TYPE:
					s += "STEM";
					break;
				case Gene.FRUIT_TYPE:
					s += "FRUIT";
					break;
				case Gene.CODON_TYPE:
					s += "CODON";
					break;
			}
			s += "\nCodon gate: " + codonState;
			s += "\nAtts: " + attributes;
			return s;
		}
	}
}