package net.nateboxer.garden.plants
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	public class Seed extends Sprite
	{
		public static const NUM_FRUITS:int = 5;
		public static const RADIUS:int = PlantDrawer.PETAL_LENGTH_RANGE + PlantDrawer.PETAL_LENGTH_MIN;
		public static const HIT_MARGIN:int = 20;
		
		private var plant:Plant;
		
		public function Seed( plant:Plant )
		{
			super();
			this.plant = plant;
		}
		
		public function draw():void
		{			
			var lineColor:uint = Gene.getValueForAtt( plant.genes[0].attributes[3], PlantDrawer.STEM_COLORS );
			graphics.beginFill( Gene.getValueForAtt( plant.genes[0].attributes[4], PlantDrawer.STEM_COLORS ) );
			graphics.drawCircle( 0, 0, RADIUS );
			graphics.endFill();				

			var drawCount:int = 0;
			var angle:int = 0;
			var angleStep:int = Math.floor(360 / NUM_FRUITS);
			var geneCount:int = 0;
			for each( var gene:Gene in plant.genes )
			{
				geneCount++;
				if( gene.isFruit && (geneCount % 5 == 0) )
				{
					drawCount++;
					angle += angleStep;
					var tip:Tip = new Tip( 0, 0, 0, 0, 0, 0, angle, false );
					PlantDrawer.drawFruit( gene, null, tip, graphics );
					if( drawCount > NUM_FRUITS )
					{
						break;
					}
				}
			}
			
			var hitty:Sprite = new Sprite();
			hitty.graphics.beginFill( 0x00FF00, 0 );
			hitty.graphics.drawCircle( 0, 0, RADIUS + HIT_MARGIN );
			hitty.graphics.endFill();
			addChild( hitty );
			hitArea = hitty;
						
			graphics.lineStyle( 2, lineColor, .6 );
			graphics.drawCircle( 0, 0, RADIUS );
			
			rollOut();
		}
		
		public function enableMouseBehavior( enable:Boolean ):void
		{
			buttonMode = enable;
			if( enable )
			{
				addEventListener( MouseEvent.MOUSE_OVER, rollOver, false, 0, true );
				addEventListener( MouseEvent.MOUSE_OUT, rollOut, false, 0, true );
			}
			else
			{
				removeEventListener( MouseEvent.MOUSE_OVER, rollOver );
				removeEventListener( MouseEvent.MOUSE_OUT, rollOut );
			}
		}
		
		public function highlight( show:Boolean ):void
		{
			if( show )
			{
				rollOver();
			}
			else
			{
				rollOut();
			}
		}
		
		private function rollOver( me:MouseEvent = null ):void
		{
			alpha = 1;
		}
		
		private function rollOut( me:MouseEvent = null ):void
		{
			alpha = .6;
		}
		
		public function destroy():void
		{
			this.mask = null;
			enableMouseBehavior( false );
			graphics.clear();
		}
	}
}