package net.nateboxer.garden.plants {
	import flash.display.Graphics;
	
	import mx.core.Application;
	
	
	public class PlantDrawer {

		public static const FRUIT_COLORS:Array = [
			0xCF3C00, 0xFF490D, 0xFF9E26, 0xFFBD2F, 0xFF7040,
			0xF2E5B4, 0xB9B5FC, 0xF09678, 0xE32C5E, 0x371111,
			0xDDE2FC, 0x012730, 0x0D8FA2, 0x3A9799, 0xFCFBE3,
			0x4A3049, 0x851D5B, 0xFF2457, 0xFFD900, 0xFFEA00,
			0xFE6265, 0xFC4543, 0xD11944, 0xFD9705, 0xFBCE2C,
			0xCCF390 ];
		public static const STEM_COLORS:Array = [
			0x1F1212, 0x402625, 0x473000, 0x012730, 0xA8B891,
			0x262604, 0x224E15, 0x1B8557, 0xC2C591, 0xB3A131,
			0x450201, 0x1C1413, 0x901F0F, 0xC85A1F,
			0x261D02, 0x5E4806, 0xC99C14, 0x462512,
			0x59241E, 0x70342E, 0x855620, 0x787625,
			0x003333, 0x266640, 0x4D994D, 0x73CC59 ];
					
		public static const RADS:Number = Math.PI / 180;
		
		public static const STEM_ANGLES:Array = [ -15, -10, -5, 0, 5, 10, 15 ];	
		public static const STEM_LENGTH_BASE:Number = 13;
		public static const STEM_WIDTH_BASE:Number = 7; // 0..7 straight, 8..15 convex, 16..23 concave
			
		public static const BRANCH_ANGLES:Array = [ 15, 30, 45, 60, 75, 90 ];
		public static const BRANCH_STYLES:int = 4;	
		
		public static const FRUIT_STYLES:int = 12;
		public static const FRUIT_FROND_COUNTS:Array = [ 1, 3, 5, 7 ];
		public static const FRUIT_RADIUS_BASE:Number = 6;
		public static const FRUIT_FROND_LENGTH_BASE:Number = 21;
		public static const FRUIT_BERRY_SIZE_BASE:Number = 5;
		public static const FRUIT_BERRY_SIZE_MIN:Number = 1;
		public static const FRUIT_BERRY_COUNTS:Array = [ 1, 2, 3 ];
		
		public static const LEAF_LENGTH_BASE:Number = 17;
		public static const LEAF_ANGLE_RANGE:Number = 150;
		public static const LEAF_ANGLE_MIN:Number = 90;

		public static const FLOWER_ARCS:Array = [ 120, 90, 72, 60, 51.43 ];
		public static const PETAL_CONTROL_ANGLE:Number = 110;
		public static const PETAL_LENGTH_RANGE:Number = 7;
		public static const PETAL_LENGTH_MIN:Number = 2;
	
		public function PlantDrawer() {
		}

		public static function drawStem( gene:Gene, phene:Phene, tip:Tip, graphics:Graphics ):Phene {
			var angle:Number = Gene.getValueForAtt( gene.attributes[0], STEM_ANGLES ) + tip.angle;			
			var stemLength:Number = (Gene.getRange( gene.attributes[1] ) * STEM_LENGTH_BASE) + 1;
			var stemWidth:Number = Gene.getRange( gene.attributes[2] ) * STEM_WIDTH_BASE;
			var color1:uint = Gene.getValueForAtt( gene.attributes[3], STEM_COLORS );			
			var color2:uint = Gene.getValueForAtt( gene.attributes[4], STEM_COLORS );			
			
			// Hieran
			trace( "Angle: " + angle + " Length: " + Math.round(stemLength) 
				+ " Width: " + Math.round(stemWidth) + " Line: " + color2 + " Fill: " + color1 );
			
			var vx:Number = tip.vx + (stemLength * Math.sin( angle * RADS ));
			var vy:Number = tip.vy + (stemLength * -Math.cos( angle * RADS ));
			
			// terminate if below ground
			var terminates:Boolean = (vy > 0) || (vy < -(Application.application.main.height * 1.2));

			var halfWidth:Number = stemWidth / 2;
			
			var TLx:Number = vx + (halfWidth * Math.sin( (angle - 90) * RADS ));
			var TLy:Number = vy + (halfWidth * -Math.cos( (angle - 90) * RADS ));

			var TRx:Number = vx + (halfWidth * Math.sin( (angle + 90) * RADS ));
			var TRy:Number = vy + (halfWidth * -Math.cos( (angle + 90) * RADS ));

			if( !phene.isRoot ) {
				halfWidth = phene.stemWidth / 2;
			}
			
			var BLx:Number = tip.vx + (halfWidth * Math.sin( (tip.angle - 90) * RADS ));
			var BLy:Number = tip.vy + (halfWidth * -Math.cos( (tip.angle - 90) * RADS ));
			
			var BRx:Number = tip.vx + (halfWidth * Math.sin( (tip.angle + 90) * RADS ));
			var BRy:Number = tip.vy + (halfWidth * -Math.cos( (tip.angle + 90) * RADS ));
			
			graphics.lineStyle( 1, color2, .4, true );
			graphics.beginFill( color1 );
						
			graphics.moveTo( BLx, BLy );
			graphics.lineTo( TLx, TLy );
			graphics.lineTo( TRx, TRy );
			graphics.lineTo( BRx, BRy );
			graphics.lineTo( BLx, BLy );
			
			graphics.endFill();
			
			var newPhene:Phene = new Phene(
				gene.type,
				stemWidth,
				[new Tip(vx,vy,angle,terminates)], 
				phene.codonState );
				
			return newPhene;
		}	
		
		public static function drawBranch( gene:Gene, phene:Phene, tip:Tip, graphics:Graphics ):Phene {
			var angle:Number = Gene.getValueForAtt( gene.attributes[0], BRANCH_ANGLES );			
			var style:int = Gene.getIndex( gene.attributes[1], BRANCH_STYLES );
			
			var tips:Array = new Array();
			var lTip:Tip;
			var rTip:Tip;
			switch( style ) {
				case 0:
					lTip = new Tip( tip.vx, tip.vy, tip.angle - angle );
					tips.push( lTip );
					rTip = new Tip( tip.vx, tip.vy, tip.angle + angle );
					tips.push( rTip );
					
					// Hieran
					trace( "Angle: " + angle + " Style: left, right" );
					
					break;
				case 1:
					lTip = new Tip( tip.vx, tip.vy, tip.angle );
					tips.push( lTip );
					rTip = new Tip( tip.vx, tip.vy, tip.angle + angle );
					tips.push( rTip );

					
					// Hieran
					trace( "Angle: " + angle + " Style: straight, right" );

					break;
				case 2:
					lTip = new Tip( tip.vx, tip.vy, tip.angle - angle );
					tips.push( lTip );
					rTip = new Tip( tip.vx, tip.vy, tip.angle );
					tips.push( rTip );
					
					// Hieran
					trace( "Angle: " + angle + " Style: left, straight" );
					
					break;
				case 3:
					lTip = new Tip( tip.vx, tip.vy, tip.angle - angle );
					tips.push( lTip );
					rTip = new Tip( tip.vx, tip.vy, tip.angle + angle );
					tips.push( rTip );
					var cTip:Tip = new Tip( tip.vx, tip.vy, tip.angle );
					tips.push( cTip );
						
					// Hieran
					trace( "Angle: " + angle + " Style: left, straight, right" );

					break;
			}
						
			var newPhene:Phene = new Phene(
				gene.type,
				phene.stemWidth,
				tips,
				phene.codonState );
			return newPhene;
		}
		
		public static  function drawFruit( gene:Gene, phene:Phene, tip:Tip, graphics:Graphics ):Phene {
			var style:int = Gene.getIndex( gene.attributes[0], FRUIT_STYLES );
			var att1:int = gene.attributes[1];
			var att2:int = gene.attributes[2];
			var color1:uint = Gene.getValueForAtt( gene.attributes[3], FRUIT_COLORS );			
			var color2:uint = Gene.getValueForAtt( gene.attributes[4], FRUIT_COLORS );			
			
			var vx:Number;
			var vy:Number;
			switch( style ) {
				
				case 0: // draw a berry at the tip
					
					var radius:Number = Gene.getRange( att1 ) * FRUIT_RADIUS_BASE;
					vx = tip.vx + (radius * Math.sin( tip.angle * RADS ));
					vy = tip.vy + (radius * -Math.cos( tip.angle * RADS ));
					
					graphics.lineStyle( 1, color2, .5 );
					graphics.beginFill( color1 );
					graphics.drawCircle( vx, vy, radius );
					graphics.endFill();
					
					// Hieran
					trace( "Type: Berry Radius: " + Math.round(radius) 
						+ " Line: " + color2 + " Fill: " + color1 );
					
					break;
					
				case 1: // draw some fronds
				case 2:
					
					var frondLength:Number = Gene.getRange( att1 ) * FRUIT_FROND_LENGTH_BASE;
					vx = tip.vx + (frondLength * Math.sin( tip.angle * RADS ));
					vy = tip.vy + (frondLength * -Math.cos( tip.angle * RADS ));
					
					// Hieran
					trace( "Type: Front Length: " + Math.round(frondLength) 
						+ " Line: " + color2 + " Fill: " + color1 );
	
					// always draw 1 frond														
					graphics.lineStyle( 1, color1 );
					graphics.moveTo( tip.vx, tip.vy );
					graphics.lineTo( vx, vy );
	
					var frondCount:Number = Gene.getValueForAtt( att2, FRUIT_FROND_COUNTS );
					if( frondCount > 1 ) {
						var frondPairs:int = (frondCount - 1) / 2;
						var frondStep:Number = frondLength / 4;						
						for( var f:int = 1; f <= frondPairs; f++ ) {

							var frondStepCada:int = frondStep * f;
							
							vx = tip.vx + ((frondLength - (f * f)) * Math.sin( tip.angle * RADS ));
							vy = tip.vy + ((frondLength - (f * f)) * -Math.cos( tip.angle * RADS ));

							var lx:Number = vx + (frondStepCada * Math.sin( (tip.angle - 90) * RADS ));
							var ly:Number = vy + (frondStepCada * -Math.cos( (tip.angle - 90) * RADS ));
							graphics.moveTo( tip.vx, tip.vy );
							graphics.lineTo( lx, ly );
							
							var rx:Number = vx + (frondStepCada * Math.sin( (tip.angle + 90) * RADS ));
							var ry:Number = vy + (frondStepCada * -Math.cos( (tip.angle + 90) * RADS ));
							graphics.moveTo( tip.vx, tip.vy );
							graphics.lineTo( rx, ry );
						}
					}	
					break;
					
				case 3: // multiple berries
				
					var berryCount:Number = Gene.getValueForAtt( att1, FRUIT_BERRY_COUNTS );
					var berrySize:Number = (Gene.getRange( att2 ) * (FRUIT_BERRY_SIZE_BASE / berryCount)) + FRUIT_BERRY_SIZE_MIN;
					
//					var blx:Number = tip.vx + ((phene.stemWidth / 2) * Math.sin( (tip.angle - 90) * RADS ));
//					var bly:Number = tip.vy + ((phene.stemWidth / 2) * -Math.cos( (tip.angle - 90) * RADS ));
//					var brx:Number = tip.vx + ((phene.stemWidth / 2) * Math.sin( (tip.angle + 90) * RADS ));
//					var bry:Number = tip.vy + ((phene.stemWidth / 2) * -Math.cos( (tip.angle + 90) * RADS ));

					var blx:Number = tip.vx + (berrySize * Math.sin( (tip.angle - 90) * RADS ));
					var bly:Number = tip.vy + (berrySize * -Math.cos( (tip.angle - 90) * RADS ));
					var brx:Number = tip.vx + (berrySize * Math.sin( (tip.angle + 90) * RADS ));
					var bry:Number = tip.vy + (berrySize * -Math.cos( (tip.angle + 90) * RADS ));

					// Hieran
					trace( "Type: Berries Count: " + Math.round(berryCount) + " Size: " + Math.round(berrySize)
						+ " Line: " + color2 + " Fill: " + color1 );

					graphics.lineStyle( 1, color2, .5 );
					graphics.beginFill( color1 );
					graphics.drawCircle( blx, bly, berrySize );
					graphics.endFill();

					graphics.beginFill( color1 );
					graphics.drawCircle( brx, bry, berrySize );
					graphics.endFill();

					for( var b:int = 1; b < berryCount; b++ ) {
						
						blx += ((berrySize * 2) * Math.sin( tip.angle * RADS ));
						bly += ((berrySize * 2) * -Math.cos( tip.angle * RADS ));

						brx += ((berrySize * 2) * Math.sin( tip.angle * RADS ));
						bry += ((berrySize * 2) * -Math.cos( tip.angle * RADS ));

						graphics.beginFill( color1 );
						graphics.drawCircle( blx, bly, berrySize );
						graphics.endFill();

						graphics.beginFill( color1 );
						graphics.drawCircle( brx, bry, berrySize );
						graphics.endFill();						
					}
					break;
					
				case 4: // leaf
				case 5:
				case 6:
				case 7:
				
					// use stem colors for leave
					color1 = Gene.getValueForAtt( gene.attributes[3], STEM_COLORS );			
					color2 = Gene.getValueForAtt( gene.attributes[4], STEM_COLORS );			

					var leafLength:Number = Gene.getRange( att1 ) * LEAF_LENGTH_BASE;
					var leafAngle:Number = (Gene.getRange( att2 ) * LEAF_ANGLE_RANGE) + LEAF_ANGLE_MIN;


					// Hieran
					trace( "Type: Leaf Length: " + Math.round(leafLength) + " Angle: " + Math.round( leafAngle)
						+ " Line: " + color2 + " Fill: " + color1 );
					
					// tip target
					var tx:Number = tip.vx + (leafLength * Math.sin( tip.angle * RADS ));
					var ty:Number = tip.vy + (leafLength * -Math.cos( tip.angle * RADS ));
					
					// control point 1
					var ax1:Number = tx + (leafLength * Math.sin( (tip.angle - leafAngle) * RADS ));
					var ay1:Number = ty + (leafLength * -Math.cos( (tip.angle - leafAngle) * RADS ));
		
		
					// control point 2
					var ax2:Number = tx + (leafLength * Math.sin( (tip.angle + leafAngle) * RADS ));
					var ay2:Number = ty + (leafLength * -Math.cos( (tip.angle + leafAngle) * RADS ));
					
					graphics.lineStyle( 1, color2, .5 );
					graphics.beginFill( color1 );
					
					graphics.moveTo( tip.vx, tip.vy );
					graphics.curveTo(  ax1, ay1, tx, ty );
				
					graphics.moveTo( tip.vx, tip.vy );
					graphics.curveTo(  ax2, ay2, tx, ty );
					
					graphics.endFill();
					
					break;
					
				case 8: // flower
				
					var flowerArc:Number = Gene.getValueForAtt( att1, FLOWER_ARCS );
					var petalLength:Number = (Gene.getRange( att2 ) * PETAL_LENGTH_RANGE) + PETAL_LENGTH_MIN;			

					// Hieran
					trace( "Type: Flower Length: " + Math.round(petalLength) + " Arc: " + Math.round( flowerArc)
						+ " Line: " + color2 + " Fill: " + color1 );
				
					// combine stem and fruit colors for flowers
					color1 = Gene.getValueForAtt( gene.attributes[3], FRUIT_COLORS );			
					color2 = Gene.getValueForAtt( gene.attributes[4], STEM_COLORS );			
					
					var petalPower:Number = 100 / flowerArc;
		
					var i:Number = 0;
					if( (flowerArc == 60) || (flowerArc == 90) ) {
						i += flowerArc / 2;
					}
					while( i < 360 ) {					
						drawPetal( tip.vx, tip.vy, tip.angle + i, petalLength, PETAL_CONTROL_ANGLE, petalPower, color1, color2, graphics );
						i += flowerArc;
					}		
					break;
			}
		
			// fruit always terminates
			return null;	
		}

		private static function drawPetal( vx:Number, vy:Number, angle:Number, petalLength:Number, petalAngle:Number, petalPower:Number, color1:uint, color2:uint, graphics:Graphics ):void {

			// tip target
			var targetLength:Number = petalLength + (petalPower * 2);
			var tx:Number = vx + (targetLength * Math.sin( angle * RADS ));
			var ty:Number = vy + (targetLength * -Math.cos( angle * RADS ));
			
			// control point 1
			var controlLength:Number = petalLength / petalPower;
			var ax1:Number = tx + (controlLength * Math.sin( (angle - petalAngle) * RADS ));
			var ay1:Number = ty + (controlLength * -Math.cos( (angle - petalAngle) * RADS ));
			
			// control point 2
			var ax2:Number = tx + (controlLength * Math.sin( (angle + petalAngle) * RADS ));
			var ay2:Number = ty + (controlLength * -Math.cos( (angle + petalAngle) * RADS ));

			graphics.lineStyle( 1.5, 0xFFFFFF, .1 );
			graphics.beginFill( color1, 1 );
			graphics.moveTo( vx, vy );
			graphics.curveTo( ax1, ay1, tx, ty );
			graphics.moveTo( vx, vy );
			graphics.curveTo( ax2, ay2, tx, ty );
			graphics.endFill();
			
			// stamen
			var stamenLength:Number = petalLength / 3;
			var sx:Number = vx + (stamenLength * Math.sin( angle * RADS ));
			var sy:Number = vy + (stamenLength * -Math.cos( angle * RADS ));
			
			graphics.lineStyle( 1, color2 );
			graphics.beginFill( color2 );
			graphics.drawCircle( vx, vy, petalLength / 10 );
			graphics.endFill();
			graphics.moveTo( vx, vy );
			graphics.lineTo( sx, sy );
		}

	}
}