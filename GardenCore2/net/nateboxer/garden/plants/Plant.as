package net.nateboxer.garden.plants {
	import flash.display.Sprite;
	
	import net.nateboxer.garden.utils.Twister;
	
	public class Plant extends Sprite {

		public static const DEFAULT_NAME:String = "unnamed";
		
		public static const MAX_DRAW_CYCLES:int = 5000; // should be around 2x expected max age?
		public static const DRAW_CYCLES_PER_DRAW:int = 100;
		
		public static const MUTATE_RATE:Number = .0025; // .0015 = static plants have static genes
		public static const NUM_GENE_CHARS:int = 2000; // 2000 is divisible by 8 250 times hence attempts = 25
		public static const GENE_ATTEMPTS:int = 50;
		public static const MAX_TIPS:int = 13; // 13 seems to be plenty for diversity
		public static const MAX_PHENE_COUNT:int = 2000;
		public static const ROOT_MIN_WIDTH:int = 3;
		
		// These values determine how much of the genome can be expressed by distance from root
		// [ROOT_PHASE_STEP .. +PHASE_RANGE] == Gene.distanceFromRoot
		public static const MAX_DISTANCE_FROM_ROOT:int = 150;
		public static const ROOT_PHASE_STEP:int = MAX_DISTANCE_FROM_ROOT / Gene.GENE_RANGE;
		public static const PHASE_RANGE:int = 3;
		
		public static const MAX_CHARS_IN_NAME:int = 50;
		
		/* model */
		public var id:Number = -1;
		public var parentID:Number = 0;
		public var plantName:String = DEFAULT_NAME;
		public var userIP:String = '';
		public var created:String = '';
		public var geneString:String = '';
		public var children:Boolean = false;
		public var views:int = 1;
		public var generation:int = 1;
		
		/* class */

		private var phenes:Array;
		private var rootPhene:Phene;
		private var parsedGenes:Array;
		private var twister:Twister;
		private var geneIndex:int;
		private var drawCycles:int;

		public var age:int;
		public var totalPheneCount:int;
		public var totalGeneExpressionFails:int;
		
		public function Plant( 
			id:Number, 
			parentID:Number, 
			geneString:String, 
			plantName:String = null, 
			userIP:String = '', 
			created:String = '', 
			children:Boolean = false,
			views:int = 1,
			generation:int = 1 ) {
				
			this.id = id;			
			this.parentID = parentID;
			if( plantName != null )
			{
				this.plantName = plantName;
			}
			this.geneString = geneString;
			this.userIP = userIP;
			this.created = created;
			this.children = children;
			this.views = views;
			this.generation = generation;
			
			cacheAsBitmap = true;
		}
		
		public function clone():Plant {
			var p:Plant = 
				new Plant( id, parentID, geneString, plantName, userIP, created, children, views );
			return p;
		}

		public function init():void {			
			
			parsedGenes = Gene.parseGenes( this );

			graphics.clear();
			phenes = new Array();
			totalPheneCount = 
			totalGeneExpressionFails = 0;
			twister = new Twister();
			
			drawCycles = 0;
			geneIndex = -1;
			age = 1;
			
			var rootGene:Gene = parsedGenes[0];
			var rootWidth:int = (PlantDrawer.STEM_WIDTH_BASE - ROOT_MIN_WIDTH) * Gene.getRange( rootGene.attributes[2] ) + ROOT_MIN_WIDTH;
			var leftCornerX:int = -(rootWidth / 2);
			var rightCornerX:int = rootWidth / 2;
			rootPhene = new Phene(
									Gene.STEM_TYPE,
									rootWidth,
									[new Tip(
												0,0, // v
												leftCornerX,0, // l
												rightCornerX,0, // r
												0 // a
									)],
									0,
									rootGene.codonState,
									true );
			phenes.push( rootPhene );		
		}
			
		public function draw():Boolean {
			var runOfDrawCycles:int = drawCycles + DRAW_CYCLES_PER_DRAW;
			if( (runOfDrawCycles >= MAX_DRAW_CYCLES) ) {
				runOfDrawCycles = MAX_DRAW_CYCLES;
			}
			
			while( expressPhene() && (drawCycles++ < runOfDrawCycles) );
			
			//Application.application.main.debug( "plant.draw( cycles=" + drawCycles + " )" );
			
			if( !expressPhene() ) {
				return false;
			}
			
			return true;
		}
		
		// returns true if alive
		private function expressPhene():Boolean {
			if( (phenes.length > 0) && (totalPheneCount < MAX_PHENE_COUNT) ) { // && (age < maxAge) ) {
				
				age++;
				
				// get random phene
				var pheneIndex:int = Math.floor(phenes.length * twister.nextNumber());
				var phene:Phene = phenes[pheneIndex];
				phenes.splice( pheneIndex, 1 );
				
				var phenePhase:int = Math.floor(phene.distanceFromRoot / ROOT_PHASE_STEP);
				
				var grewNewPhene:Boolean = false;
				for each( var tip:Tip in phene.tips ) {
					if( !tip.terminates ) {
						
						var gene:Gene = null;

						var numTries:int = GENE_ATTEMPTS;
						while( numTries > 0 ) {
							geneIndex++;

							// without age-determined gene set
							if( geneIndex >= parsedGenes.length ) {
								geneIndex = 0;
							}
							
							var g:Gene = parsedGenes[ geneIndex ];
							
							// use distance from root to determine next gene
							if( 
								(g.codonState == phene.codonState) 
								&& 
								(g.distancePhase < phenePhase + PHASE_RANGE)
								&& 
								(g.distancePhase >= phenePhase)
								&& 
								(!g.isBranch || !phene.isBranch)
								&&
								(!g.isCodon || !phene.isCodon)
							) {
								gene = g;
																
								geneIndex += numTries - 1; // Should keep frequency constant, seems to work							
								
								break;
							}	
							
							numTries--;
						}
						
						if( gene ) {
							
							// Hieran
							trace( "Age: " + age + " Drawing " + gene.toString() );
							
							var newPhene:Phene = drawGene( gene, phene, tip );
							if( newPhene ) {
								
								if( tipCount < MAX_TIPS ) {
									phenes.push( newPhene );
									totalPheneCount++;
								}
								grewNewPhene = true;
							}
							// fruit returns no phene
							if( gene.isFruit ) {
								grewNewPhene = true; 
							}
						} else {
							totalGeneExpressionFails++;
						}	
					}
				}
				if( !grewNewPhene ) {
					
					// put unexpressed phene back on stack
					// if it has unterminated tips
					if( phene.unterminatedTipCount > 0 ) {
						phene.attemptCount--;
						if( phene.attemptCount > 0 ) {
							phenes.push( phene );
						}
					}
				}
				return true;
			} else {
				// this is basically death
				phenes = new Array();
				return false;
			}
		}
		
//		private var greatestDistance:int = 0;
		
		private function drawGene( gene:Gene, phene:Phene, tip:Tip ):Phene {			
			if( gene.isStem ) {
			
//				var phenePhase:int = Math.floor(phene.distanceFromRoot / ROOT_PHASE_STEP);
//				if( phenePhase > greatestDistance ) {
//					var tf:TextField = new TextField();
//					tf.text = "" + phenePhase;
//					tf.x = tip.vx;
//					tf.y = tip.vy;
//					tf.mouseEnabled = false;
//					addChild( tf );
//					greatestDistance = phenePhase;
//				}
			
				return PlantDrawer.drawStem( gene, phene, tip, graphics );
			} else if( gene.isBranch ) {
				return PlantDrawer.drawBranch( gene, phene, tip, graphics );
			} else if( gene.isFruit ) {
				return PlantDrawer.drawFruit( gene, phene, tip, graphics );
			} else if( gene.isCodon ) {
				return activateCodon( gene, phene );
			}
			return phene;
		}
		
		private function activateCodon( gene:Gene, phene:Phene ):Phene {
			var newState:int = Gene.getIndex( gene.attributes[0], Gene.CODON_RANGE );
			phene.codonState = newState;
			
			// Hieran
			trace( "Codon state: " + newState );
			
			return phene; // codon just changes state, throw phene back on heap
		}
		
		public function destroy():void {
//			try {
//				while( removeChildAt(0) ) {}
//			} catch( e:Error ) {}
			graphics.clear();
			cacheAsBitmap = false;
			phenes = null;
			parsedGenes = null;
			geneString = null;
		}
		
		public function get genes():Array {
			return parsedGenes;
		}
		
		public function get tipCount():int {
			var tipCount:int = 0;
			for each( var p:Phene in phenes ) {
				tipCount += p.unterminatedTipCount;
			}
			return tipCount;							
		}
		
		public function get pheneCount():int {
			return totalPheneCount;
		}
		
		public static function generateRandomGeneString():String {
			var genes:String = "";
			for( var i:int = 0; i < NUM_GENE_CHARS; i++ )
			{
				genes += Gene.GENE_SPACE.substr( Math.floor(Math.random() * Gene.GENE_SPACE.length), 1 );
			}
			return genes;			
		}
		
		// introduces mutations
		public static function copyGeneString( sourceGeneString:String ):String {
			var geneStringCopy:String = "";
			for( var i:int = 0; i < NUM_GENE_CHARS; i++ )
			{
				if( Math.random() < MUTATE_RATE )
				{
					geneStringCopy += Gene.GENE_SPACE.substr( Math.floor(Math.random() * Gene.GENE_SPACE.length), 1 );
				}
				else
				{
					geneStringCopy += sourceGeneString.substr(i, 1);
				}
			}
			return geneStringCopy;
		}
		
		// recombines parents' genes and optionally introduces mutations
		public static function recombineGeneStrings( geneString1:String, geneString2:String, copyErrors:Boolean = false ):String {
			var recombinedGeneString:String = "";
			for( var i:int = 0; i < NUM_GENE_CHARS; i += Gene.GENE_LENGTH )
			{
				if( (i + Gene.GENE_LENGTH) >= NUM_GENE_CHARS ) 
				{
					break;
				}
				if( Math.random() < .5 ) 
				{
					recombinedGeneString += geneString1.substr( i, Gene.GENE_LENGTH );
				}
				else
				{
					recombinedGeneString += geneString2.substr( i, Gene.GENE_LENGTH );
				}
			}
			if( copyErrors )
			{
				return copyGeneString( recombinedGeneString );
			}
			return recombinedGeneString;
		}
		
		// returns  0 - 100 (%) based on char by car comparison
		public static function compareGeneStrings( geneString1:String, geneString2:String ):Number {
			var difs:Number = 0;
			var step:Number = 4;
			for( var i:int = 0; i < NUM_GENE_CHARS; i += step )
			{
				if( geneString1.substr( i, 1 ) != geneString2.substr( i, 1 ) )
				{
					difs++;
				}
			}				
			return (1-(difs / (geneString1.length / step))) * 100;
		}
		
		// returns string with genes separated by |
		public function toGeneString():String {
			var seq:String = "";
			var count:int = 0;
			for( var i:int = 0; i < NUM_GENE_CHARS; i++ )
			{
				count++;
				seq += geneString.substr( i, 1 );
				if( count >= Gene.GENE_LENGTH )
				{
					seq += "|";
					count = 0;
				}
			}
			return seq;
		}

		public override function toString():String {
			var s:String = "plant ";
			s += name;
			//s += ", maxAge=" + maxAge;
			return s;
		}
	}
}