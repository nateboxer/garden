package net.nateboxer.garden.plants {
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.GlowFilter;
	
	import mx.core.Application;
	
	public class Plant extends Sprite {
							
		public static const GENE_ATTEMPTS:int = 19;
		
		/* model */
		public var id:Number;
		public var xPos:int;
		public var genes:String;
		public var parentDNAID:Number;
		public var parentName:String;

		// extracted from genes

		// TODO: 3 - 5, subsumes codonRange
		public var numStages:int; 
		
		// TODO: get from genes
		public var maxAge:int;
		public var maxPheneCount:int; //
		public var maxTips:int; //
		public var codonRange:int; // Determines and replaces Gene.CODON_RANGE
		public var pheneSetSize:int; // Determines number of chars in gene prefix become Gene.PHENE_TYPES array
		public var pheneTypes:Array; // = [ Gene.STEM_TYPE, Gene.STEM_TYPE, Gene.BRANCH_TYPE, Gene.FRUIT_TYPE, Gene.CODON_TYPE ]; // Determined from gene prefix

		/* class */
				
		public var keepAlive:Boolean; // indicates plant is still alive after server refresh
		public var onHold:Boolean; // indicates properties is open, do not delete
		
		private var indicator:Shape;
		private var phenes:Array;
		private var parsedGenes:Array;
		private var myScale:Number;
		private var alphaFade:Boolean;
		private var totalPheneCount:int;
		
		private var geneIndex:int;
		private var age:int;
		private var oneThirdAge:int;
		private var twoThirdsAge:int;
		private var oneThirdGenes:int;
		private var twoThirdsGenes:int;
		
		public function Plant( id:Number, xPos:int, maxAge:int, maxPheneCount:int, maxTips:int, genes:String, parentDNAID:Number, parentName:String, codonRange:int, pheneSetSize:int ) {
			this.id = id;
			this.xPos = xPos;
			this.maxAge = maxAge;
			this.maxPheneCount = maxPheneCount;
			this.maxTips = maxTips;
			this.genes = genes;
			this.parentDNAID = parentDNAID;
			this.parentName = parentName;
			this.codonRange = codonRange;
			this.pheneSetSize = pheneSetSize;
			
			buttonMode = true;
			cacheAsBitmap = true;
			
			indicator = new Shape();
			addChild( indicator );
			indicator.graphics.lineStyle( 1, 0x371111 );
			indicator.graphics.beginFill( 0xFC4543 );
			indicator.graphics.moveTo( 0, 0 );
			indicator.graphics.lineTo( -7, 9 );
			indicator.graphics.lineTo( 7, 9 );
			indicator.graphics.lineTo( 0, 0 );
			indicator.graphics.endFill();
			indicator.y = 2;
			indicator.visible = false;
			
			release();
			
			// phene type arrangement is determined by gene prefix
			pheneTypes = new Array();
			for( var i:int = 0; i < pheneSetSize; i++ ) {
				var gene:int = genes.charCodeAt( i ) - 97;
				pheneTypes.push( Gene.getValueForAtt( gene, Gene.ALL_TYPES ) );
			}
			
			parsedGenes = Gene.parseGenes( this );
			
			// metrics for 3 stages of plant growth
			oneThirdGenes = Math.floor( parsedGenes.length / 3 );
			twoThirdsGenes = Math.floor( parsedGenes.length * 2 / 3 );		
			oneThirdAge = Math.floor( maxAge / 3 );
			twoThirdsAge = Math.floor( maxAge * 2 / 3 );		
		}
		
		public function die():void {
			alphaFade = true;
			phenes = new Array();
		}

		public function draw( redrawAll:Boolean, useScale:Number = -1 ):void {			
			if( redrawAll ) {
				graphics.clear();
				phenes = new Array();
				alphaFade = false;
				totalPheneCount = 0;

				geneIndex = -1;
				age = 1;
				
				if( useScale == -1 ) {
					myScale = 1 + (Math.random() / 2);
					scaleX = myScale;
					scaleY = myScale;
				} else {
					scaleX = useScale;
					scaleY = useScale;
				}
				var rootPhene:Phene = new Phene(
										Gene.STEM_TYPE,
										0,
										[new Tip(0,0,0)],
										0,
										true );
				phenes.push( rootPhene );		
			} else {
				expressPhene();
			}
		}
		
		private function expressPhene():void {
			if( (phenes.length > 0) && (totalPheneCount < maxPheneCount) ) {
				
				age++;
				
				// get random phene
				var pheneIndex:int = Math.floor(phenes.length * Math.random());
				var phene:Phene = phenes[pheneIndex];
				phenes.splice( pheneIndex, 1 );
				
				var grewNewPhene:Boolean = false;
				for each( var tip:Tip in phene.tips ) {
					if( !tip.terminates ) {
						
						var gene:Gene = null;

						var numTries:int = GENE_ATTEMPTS;
						while( numTries > 0 ) {
							geneIndex++;
							
							// As a plant ages, it accesses more of its genes
							// divide range into thirds
							if( age < oneThirdAge ) {
								if( geneIndex > oneThirdGenes ) {
									geneIndex = 0;
								}
							} else if( age < twoThirdsAge ) {
								if( geneIndex > twoThirdsGenes ) {
									geneIndex = oneThirdGenes;
								} 
							} else {
								if( geneIndex >= parsedGenes.length ) {
									geneIndex = twoThirdsGenes;
								}
							}				
							//if( geneIndex >= Math.floor(parsedGenes.length * (age / maxAge)) ) {							
							//if( geneIndex >= parsedGenes.length ) {
								//geneIndex = 0;
							//}			
							var g:Gene = parsedGenes[ geneIndex ];
							if( (g.codonState == phene.codonState) &&
								(!g.isBranch || !phene.isBranch)
								) {
								gene = g;
								break;
							}	
							numTries--;
						}
						
						if( gene ) {
							
							// Hieran
							trace( "Age: " + age + " Drawing " + gene.toString() );
							
							var newPhene:Phene = drawGene( gene, phene, tip );
							if( newPhene ) {
								
								if( tipCount < maxTips ) {
									phenes.push( newPhene );
									totalPheneCount++;
								}
								grewNewPhene = true;
							}
							if( gene.isFruit ) {
								grewNewPhene = true; // fruit returns no phene
							}
						}		
					}
				}
				if( !grewNewPhene ) {
					
					// put unexpressed phene back on stack
					// if it has unterminated tips
					if( phene.unterminatedTipCount > 0 ) {
						phenes.push( phene );
					}
				}
			} else {
				phenes = new Array();
				if( alphaFade && (alpha > 0) ) {
					alpha -= .1;
					if( alpha <= 0 ) {
						Application.application.main.releasePlant( this );
					}
				}
			}
		}
		
		private function drawGene( gene:Gene, phene:Phene, tip:Tip ):Phene {			
			if( gene.isStem ) {
				return PlantDrawer.drawStem( gene, phene, tip, graphics );
			} else if( gene.isBranch ) {
				return PlantDrawer.drawBranch( gene, phene, tip, graphics );
			} else if( gene.isFruit ) {
				return PlantDrawer.drawFruit( gene, phene, tip, graphics );
			} else if( gene.isCodon ) {
				return drawCodon( gene, phene );
			}
			return phene;
		}
		
		private function drawCodon( gene:Gene, phene:Phene ):Phene {
			var newState:int = Gene.getIndex( gene.attributes[0], codonRange );
			phene.codonState = newState;
			
			// Hieran
			trace( "Codon state: " + newState );
			
			return phene; // codon just changes state, throw phene back on heap
		}
		
		public function hold():void {
			onHold = true;
			bigHighlight();
			Application.application.main.dimPlants( true, this );	
		}
		
		public function release( undimPlants:Boolean = false ):void {
			onHold = false;				
			normalHighlight( undimPlants );		
		}
		
		private function click( me:MouseEvent ):void {
			if( Application.application.main.wasDrag ) {
				return;
			}
			// hide vote if clicking selected plant
			if( Application.application.props.plant ) {
				if( Application.application.props.plant.id == this.id ) {
					Application.application.props.hideProps();
					return;
				}
			}
			Application.application.props.showProps( this );
			Application.application.main.dimPlants( true, Application.application.props.plant );	
		}

		private function highlight( me:MouseEvent ):void {
			if( !onHold ) {
				if( me && (me.type == MouseEvent.MOUSE_OVER) ) {
					bigHighlight();
				} else {
					if( Application.application.props.plant ) {
						normalHighlight( false );
						Application.application.main.dimPlants( true, Application.application.props.plant );	
					} else {
						normalHighlight( me != null );
					}
				}
			}
		}

		private function bigHighlight():void {	
			//Application.application.main.dimPlants( true, this );	
			this.filters = [new GlowFilter( 0xFFFFFF, .8, 9, 9, 4, BitmapFilterQuality.HIGH ) ];
			scaleX = myScale * 1.01;
			scaleY = myScale * 1.01;						
			indicator.visible = true;
		}
		
		private function normalHighlight( restorePlants:Boolean = false ):void {
			if( restorePlants ) {
				Application.application.main.dimPlants( false );	
			}
			this.filters = null; //[new GlowFilter( 0xFFFFFF, .5, 5, 5, 1, BitmapFilterQuality.LOW ) ];
			scaleX = myScale;
			scaleY = myScale;		
			indicator.visible = false;
		}
		
		public function enableClientListeners( enable:Boolean ):void {
			if( enable ) {
				addEventListener( MouseEvent.MOUSE_UP, click, false, 0, true );
				addEventListener( MouseEvent.MOUSE_OVER, highlight, false, 0, true );
				addEventListener( MouseEvent.MOUSE_OUT, highlight, false, 0, true );
			} else {
				removeEventListener( MouseEvent.MOUSE_UP, click, false );
				removeEventListener( MouseEvent.MOUSE_OVER, highlight, false );
				removeEventListener( MouseEvent.MOUSE_OUT, highlight, false );				
			}
		}
		
		public function destroy():void {
			graphics.clear();
			try {
				removeChild( indicator );
			} catch( e:Error ) {}
			cacheAsBitmap = false;
			enableClientListeners( false );
			phenes = null;
			parsedGenes = null;
			pheneTypes = null;
			genes = null;
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
		
		public function clone():Plant {
			var p:Plant = 
				new Plant( id, xPos, maxAge, maxPheneCount, maxTips, genes, parentDNAID, parentName, codonRange, pheneSetSize );
			return p;
		}
		
		public override function toString():String {
			var s:String = "Plant:";
			s += " id=" + id;
			s += ", maxAge=" + maxAge;
			return s;
		}
	}
}