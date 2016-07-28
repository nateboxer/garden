package net.nateboxer.garden.plants {
	import mx.core.Application;
	
	public class Gene {			
			
		public static const GENE_SPACE:String = "abcdefghijklmnopqrstuvwxyz";
		public static const GENE_RANGE:Number = GENE_SPACE.length;
		
		public static const STEM_TYPE:String = "s";
		public static const BRANCH_TYPE:String = "b";
		public static const FRUIT_TYPE:String = "f";
		public static const CODON_TYPE:String = "c";
		
		public static const GENE_PREFIX_LENGTH:int = 3;
		public static const GENE_SUFFIX_LENGTH:int = 5;
		public static const GENE_LENGTH:int = GENE_PREFIX_LENGTH + GENE_SUFFIX_LENGTH;
		public static const ALL_TYPES:Array = [ STEM_TYPE, STEM_TYPE, STEM_TYPE, STEM_TYPE, BRANCH_TYPE, BRANCH_TYPE, FRUIT_TYPE, FRUIT_TYPE, CODON_TYPE, CODON_TYPE, CODON_TYPE ];
		
		public static const CODON_RANGE:int = 4;//5;
		
		/*
			[gene prefix] [attributes]
			[type, codon_state, dist_root] [...]
			
			Stem: [s, codon_state, dist_root] [angle, length, width, color1, color2]
			Branch: [b, codon_state, dist_root] [angle, style, unused, unused, unused]
			Fruit: [f, codon_state, dist_root] [style, attribute1, attribute2, color1, color2]
			Codon: [c, codon_state, dist_root] [codon_state, unused, unused, unused, unused]
		*/
		
		public var type:String;
		public var codonState:int;
		public var distancePhase:int;
		public var attributes:Array;
		
		// Hieran
		public var geneSegment:String;
		public var geneIndex:int;
		
		public function Gene() {}

		public static function parseGenes( plant:Plant ):Array {
			var geneIndex:int = 0;
			var genes:Array = new Array();
			var firstGene:Boolean = true; // first gene is always a stem
			while( geneIndex < (plant.geneString.length - GENE_PREFIX_LENGTH) ) {
				var gene:Gene = new Gene();

				// build prefix
				
				gene.type = getValueForAtt( (plant.geneString.charCodeAt( geneIndex ) - 97), ALL_TYPES );
				if( firstGene ) {
					firstGene = false;
					gene.type = STEM_TYPE;
				}
				
				gene.codonState = getIndex( plant.geneString.charCodeAt( geneIndex + 1 ) - 97, CODON_RANGE );
				
				gene.distancePhase = plant.geneString.charCodeAt( geneIndex + 2 ) - 97;
				
				// if we go off the genome end
				if( (geneIndex + GENE_LENGTH) >= plant.geneString.length ) {
					break;
				}
				
				// get attributes
				gene.attributes = new Array();
				for( var a:int = GENE_PREFIX_LENGTH; a < GENE_LENGTH; a++ ) {
					gene.attributes[a - GENE_PREFIX_LENGTH] = plant.geneString.charCodeAt( geneIndex + a ) - 97;
				}

				// Hieran
				gene.geneSegment = plant.geneString.substr( geneIndex, GENE_LENGTH );
				gene.geneIndex = genes.length;
				trace( gene.toString() );
				
				genes.push( gene );
				
				geneIndex += GENE_LENGTH;
			}
			return genes;
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