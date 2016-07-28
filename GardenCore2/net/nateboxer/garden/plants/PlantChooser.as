package net.nateboxer.garden.plants
{
	import fl.transitions.TweenEvent;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Dictionary;
	
	import mx.core.Application;
	
	import net.nateboxer.garden.evolver.Evolver;
	import net.nateboxer.garden.utils.GardenEvent;
	import net.nateboxer.garden.utils.Tweener;
	import net.nateboxer.garden.utils.Waiter;

	public class PlantChooser extends Sprite
	{
		public static const POT_WIDTH:int = 150;
		public static const POT_HEIGHT:int = 350;
		
		public static const ARROW_LENGTH:int = 8;
		
		public static const TWEEN_DURATION_S:Number = 1.5;
		public static const MAX_POTS_IN_CHOOSER:int = 100;
		
		private var viewWidth:int;
		private var center:Number;
		private var baseLine:Number;
		
		private var panel:Sprite;
		private var arrow:Shape;
		private var pots:Dictionary;
		private var potCount:int;
		
		private var tweenToPot:Pot = null;
		private var centerPot:Pot = null;
		private var chosenPot:Pot = null;
		private var tweenToAfterFinishPot:Pot = null;
		private var lastTweenedToPot:Pot;
		private var originalX:Number;
		private var tweener:Tweener;
		private var drawing:Boolean = false;
		
		private var evolver:Evolver;
		
		private var message:TextField;
		private var hideMessage:Boolean = false;
		
		public function PlantChooser( evolver:Evolver )
		{
			super();
			this.evolver = evolver;
			evolver.addEventListener( GardenEvent.VARIATION_CHOSEN, variationChosen, false, 0, true );
			viewWidth = evolver.width;
			panel = new Sprite();
			addChild( panel );
			panel.mouseEnabled = false;
			pots = new Dictionary( true );
			center = viewWidth / 2;
			potCount = 0;
			tweener = new Tweener();
			initArrow();
			
			message = new TextField();
			message.defaultTextFormat = new TextFormat( "Arial", 13, 0x686060 );
			message.text = "click a seed below a plant to see variations";
			message.width = message.textWidth + 4;
			message.x = center - (message.width / 2);
			message.y = -(Application.application.main.height - message.height) / 2;
			addChild( message );
		}
		
		private function initArrow():void
		{
			arrow = new Shape();
			addChild( arrow );
			arrow.graphics.clear();
			arrow.graphics.lineStyle( 1, 0x909090 );
			baseLine = Pot.TOTAL_VERTICAL_OFFSET + (Evolver.CHOOSER_MARGIN * 3.3);
			arrow.graphics.moveTo( -ARROW_LENGTH, -ARROW_LENGTH );
			arrow.graphics.lineTo( 0, -(ARROW_LENGTH * 2) );
			arrow.graphics.lineTo( ARROW_LENGTH, -ARROW_LENGTH );
			arrow.x = center;
			arrow.y = baseLine;
		}
		
		public function addRandomPlants():void
		{
			addRandomPlant();
		}
		
		public function addPlant( plant:Plant, callback:Function = null ):void
		{
			if( !drawing )
			{
				drawing = true;
				var pot:Pot = new Pot( plant, null );
				panel.addChild( pot );
				pot.x = center + (potCount * POT_WIDTH);
				if( centerPot == null )
				{
					centerPot = pot;
				}
				potCount++;
				if( callback != null )
				{
					pot.addEventListener( GardenEvent.PLANT_DRAWN, callback, false, 0, true );
				}
				pot.drawAll();	
				pots[pot] = pot;
			}
		}
		
		private function addRandomPlant():void
		{
			if( potCount < MAX_POTS_IN_CHOOSER )
			{
				if( drawing )
				{
					var waiter:Waiter = new Waiter();
					waiter.wait( addRandomPlant );
				}
				else
				{
					addPlant( new Plant( 0, Plant.generateRandomGeneString(), 0, "" ), plantDrawn );
				}
			}
		}

		private function variationChosen( ge:GardenEvent ):void
		{
			//debug( "variationChosen: " + ge.data );
			var selectedPot:Pot = Pot(ge.data);
			
			if( hideMessage )
			{
				message.visible = true;
				message.text = "drawing...";
				message.width = message.textWidth + 4;
				message.x = center - (message.width / 2);
				message.y = -(Application.application.main.height / 4);
			}
			else
			{
				message.visible = false;
				hideMessage = true;
			}
			
			var parentPot:Pot = null;
			var potsLeftToRight:Array = new Array();
			for each( var pot:Pot in pots )
			{
				potsLeftToRight.push( pot );
				if( pot.plant.id == selectedPot.parentPlant.id )
				{
					parentPot = pot;
				}
			}
			
			panel.addChild( selectedPot );
			selectedPot.x = parentPot.x + POT_WIDTH;
			selectedPot.y = 0;
			pots[selectedPot] = selectedPot;
			potCount++;
			initPot( selectedPot );
			rollToPot( selectedPot );
			chosenPot = selectedPot;
			firePlantChosenEvent();
			
			potsLeftToRight.sortOn( "x", Array.NUMERIC );
			var rightOfNewPot:Boolean = false;
			for( var i:int = 0; i < potsLeftToRight.length; i++ )
			{
				pot = potsLeftToRight[i];
				if( rightOfNewPot )
				{
					pot.x += POT_WIDTH;
				}
				
				if( pot == parentPot )
				{
					rightOfNewPot = true;
				}
			}
		}	
		
		private function plantDrawn( ge:GardenEvent ):void
		{
			var pot:Pot = Pot(ge.target);
			initPot( pot );
		}
		
		private function initPot( pot:Pot ):void
		{
			pot.seed.addEventListener( MouseEvent.MOUSE_UP, chosePlant, false, 0, true );
			pot.seed.enableMouseBehavior( true );
			if( pot.parentPlant == null )
			{
				pot.label( 
					"id: " + pot.plant.id
					//" draws=" + pot.plant.age 
					//+ " nop=" + pot.plant.totalGeneExpressionFails 
				);
			}
			else
			{
				pot.label( 
					"id:" + pot.plant.id
					+ "  pid:" + pot.parentPlant.id
					+ "  g:" + pot.generation
					//" draws=" + pot.plant.age 
					//+ " nop=" + pot.plant.totalGeneExpressionFails 
				);				
			}
			if( chosenPot == null )
			{
				rollToPot( pot );
			}
			drawing = false;
		}
		
		private function chosePlant( me:MouseEvent ):void
		{
			if( !hideMessage )
			{
				message.visible = true;
				message.text = "select a variation of the plant you clicked";
				message.width = message.textWidth + 4;
				message.x = center - (message.width / 2);
				message.y = -(Application.application.main.height / 4);
			}
			else
			{
				message.visible = true;
				message.text = "drawing...";
				message.width = message.textWidth + 4;
				message.x = center - (message.width / 2);
				message.y = -(Application.application.main.height / 4);
			}
			chosenPot = findPotBySeed( Seed(me.target.parent) );
			rollToPot( chosenPot );
			firePlantChosenEvent();
		}
		
		private function rollToPot( pot:Pot ):void
		{
			//debug( "rollToPot" );
			if( !tweener.tweening )
			{
				lastTweenedToPot = tweenToPot;
				tweenToPot = pot;
				originalX = panel.x;
				
				// TODO: figure out distance and adjust time accordingly
				
				tweener.createRegularTween( TWEEN_DURATION_S, tweenMotionHandler, tweenFinishHandler );
			}
			else
			{
				tweenToAfterFinishPot = pot;
			}
		}
		
		private function tweenMotionHandler( te:TweenEvent ):void
		{
			//var panelBefore:Number = panel.x;
			if( lastTweenedToPot != null )
			{
				panel.x = originalX + (lastTweenedToPot.x - tweenToPot.x) * tweener.t;
			}
			else
			{
				panel.x = originalX + (center - tweenToPot.x) * tweener.t;
			}
			//debug( "panel before=" + panelBefore + " after=" + panel.x );
		}
		
		private function tweenFinishHandler( te:TweenEvent ):void
		{
			//debug( "tweenFinish" );
			tweenToPot.seed.highlight( true );
			tweener.destroyTween();
			if( tweenToAfterFinishPot != null )
			{
				rollToPot( tweenToAfterFinishPot );
				tweenToAfterFinishPot = null;
			}
			else
			{
				addRandomPlant();
			}
		}
						
		private function firePlantChosenEvent():void
		{
			enablePots( false );
			evolver.addEventListener( GardenEvent.VARIATIONS_DRAWN, variationsDrawn, false, 0, true );
			dispatchEvent( GardenEvent.createPlantChosenEvent() );
		}
		
		private function variationsDrawn( ge:GardenEvent ):void
		{
			evolver.removeEventListener( GardenEvent.VARIATIONS_DRAWN, variationsDrawn );
			if( hideMessage )
			{
				message.visible = false;
			}
			enablePots( true );
		}

		private function enablePots( enable:Boolean ):void
		{
			for each( var pot:Pot in pots )
			{
				enablePot( pot, enable );
			}
		}	
		
		private function enablePot( pot:Pot, enable:Boolean ):void
		{
			if( pot != chosenPot && pot != tweenToPot )
			{
				pot.seed.highlight( false );
			}
			pot.seed.enableMouseBehavior( enable );
			if( enable )
			{
				pot.seed.addEventListener( MouseEvent.MOUSE_UP, chosePlant, false, 0, true );
			}
			else
			{
				pot.seed.removeEventListener( MouseEvent.MOUSE_UP, chosePlant );
			}			
		}	
		
		private function findPotBySeed( seed:Seed ):Pot
		{
			for each( var pot:Pot in pots )
			{
				if( pot.seed == seed )
				{
					return pot;
				}
			}
			return null;
		}
		
		public function get currentPot():Pot
		{
			return chosenPot;
		}		
		
		private function debug( msg:Object ):void
		{
			evolver.debug( "" + msg );
		}
	}
}