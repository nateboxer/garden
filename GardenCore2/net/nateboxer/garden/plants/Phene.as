package net.nateboxer.garden.plants {
	
	public class Phene {
		
		public static const MAX_ATTEMPTS:int = (Plant.NUM_GENE_CHARS / Gene.GENE_LENGTH) / Plant.GENE_ATTEMPTS;
		
		public var type:String;
		public var stemWidth:Number;
		public var tips:Array;
		public var codonState:int;
		public var isRoot:Boolean;
		public var distanceFromRoot:int;
		
		// determines how many times this phene may be attempted to be drawn
		public var attemptCount:int = MAX_ATTEMPTS;
		
		private var untermTipCount:int;
		
		public function Phene( type:String, stemWidth:Number, tips:Array, distanceFromRoot:int, codonState:int = 0, isRoot:Boolean = false ) {
			this.type = type;
			this.stemWidth = stemWidth;
			this.tips = tips;
			this.codonState = codonState;
			this.isRoot = isRoot;
			this.distanceFromRoot = distanceFromRoot;
			
			untermTipCount = 0;
			if( tips ) {
				for each( var t:Tip in tips ) {
					if( !t.terminates ) {
						untermTipCount++;
					}
				}
			}
		}

		public function get unterminatedTipCount():int {
			return untermTipCount;
		}
		
		public function get isStem():Boolean {
			return( type == Gene.STEM_TYPE );
		}
		
		public function get isBranch():Boolean {
			return( type == Gene.BRANCH_TYPE );
		}
		
		public function get isFruit():Boolean {
			return( type == Gene.FRUIT_TYPE );
		}

		public function get isCodon():Boolean {
			return( type == Gene.CODON_TYPE );
		}
		
		public function toString():String {
			return "Phene: type=" + type;
		}
	}
}