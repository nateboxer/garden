package net.nateboxer.garden.plants
{
	import flash.display.Sprite;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	import flash.utils.Timer;
	
	import mx.core.Application;
	
	import net.nateboxer.garden.utils.GardenEvent;
	import net.nateboxer.garden.utils.TextUtils;

	public class Pot extends Sprite
	{
		public static const DRAW_DELAY_MS:Number = 40;
	
		public static const SEED_VERTICAL_OFFSET:int = Seed.RADIUS * 3;
		public static const TOTAL_VERTICAL_OFFSET:int = Seed.RADIUS * 5;
		
		public var plant:Plant;
		public var seed:Seed;
		public var index:int;
		public var drawn:Boolean;
		
		private var potLabel:TextField;
		
		public var toDestroy:Boolean = false;

		public var generation:int = 0;
		public var percentDif:Number = 100;
		public var parentPlant:Plant;
		
		private var timer:Timer;
				
		public function Pot( plant:Plant, parentPlant:Plant, index:int = -1, createSeed:Boolean = true )
		{
			super();
			this.plant = plant;
			this.parentPlant = parentPlant;
			addChild( plant );
			this.index = index;
			this.drawn = false;
			
			if( createSeed )
			{
				seed = new Seed( plant );
				addChild( seed );
				seed.y = SEED_VERTICAL_OFFSET;
			}
			
			potLabel = new TextField();
			addChild( potLabel );
			potLabel.defaultTextFormat = new TextFormat( "Courier New", 12, 0x6F6E6D, true, false, false, "", "", "left", 5, 5 );
			potLabel.y = Seed.RADIUS * 5;
			potLabel.autoSize = TextFieldAutoSize.CENTER;
			potLabel.maxChars = Plant.MAX_CHARS_IN_NAME;
			potLabel.borderColor = 0x404040;
			potLabel.addEventListener( MouseEvent.CLICK, clickedLabel, false, 0, true );
			enableNameInput( false );
		}
		
		private function clickedLabel( me:MouseEvent ):void
		{
			enableNameInput( true );
		}
		
		public function enableNameInput( enable:Boolean ):void
		{
			if( enable )
			{
				if( plant.plantName != "" && plant.plantName != Plant.DEFAULT_NAME && (parentPlant == null || plant.plantName != parentPlant.plantName) )
				{
					return;
				}
			}
			potLabel.border = enable;
			if( enable )
			{
				potLabel.type = TextFieldType.INPUT;
				Application.application.stage.focus = potLabel;
				potLabel.setSelection( 0, potLabel.text.length );
				potLabel.addEventListener( TextEvent.TEXT_INPUT, handleName, false, 0, true );
				potLabel.addEventListener( KeyboardEvent.KEY_UP, handleKey, false, 0, true );
				potLabel.addEventListener( FocusEvent.FOCUS_OUT, lostFocus, false, 0, true );
			}
			else
			{
				potLabel.type = TextFieldType.DYNAMIC;
				potLabel.removeEventListener( TextEvent.TEXT_INPUT, handleName );				
				potLabel.removeEventListener( KeyboardEvent.KEY_UP, handleKey );
				potLabel.removeEventListener( FocusEvent.FOCUS_OUT, lostFocus );
				deselectLabel();
			}
		}
		
		private function lostFocus( fe:FocusEvent ):void
		{
			enableNameInput( false );
		}
		
		private function handleKey( ke:KeyboardEvent ):void
		{
			if( ke.keyCode == Keyboard.ENTER )
			{
				enableNameInput( false );
				var newName:String = potLabel.text;
				if( newName != "" )
				{
					newName = TextUtils.cleanText( newName );
					if( newName != "" )
					{
						plant.plantName = newName;
						Application.application.main.updateSeed( this );
					}
				}
			}
		}
		
		private function handleName( te:TextEvent ):void
		{
			formatLabel();
		}
		
		public function drawAll():void
		{
			plant.init();
			label( "drawing..." );
			if( seed != null )
			{
				seed.draw();
			}
			drawn = true;
			
			timer = new Timer( DRAW_DELAY_MS );
			timer.addEventListener( TimerEvent.TIMER, drawPlant, false, 0, true );
			timer.start();
		}
		
		private function drawPlant( te:TimerEvent ):void {
			if( !plant.draw() ) {
				timer.stop();
				timer.removeEventListener( TimerEvent.TIMER, drawPlant );
				timer = null;
				potLabel.text = "";
				dispatchEvent( GardenEvent.createPlantDrawnEvent() );
			}
		}
				
		public function destroy():void
		{
			plant.destroy();
			removeChild( plant );
			plant = null;
			
			enableNameInput( false );
			potLabel.removeEventListener( MouseEvent.CLICK, clickedLabel );
			
			if( seed != null )
			{
				seed.destroy();
				removeChild( seed );
				seed = null;
			}
			
			if( timer != null ) {
				timer.stop();
				timer.removeEventListener( TimerEvent.TIMER, drawPlant );
				timer = null;
			}
		}

		public function deselectLabel():void
		{
			potLabel.setSelection( 0, 0 );
		}
		
		public function label( msg:String ):void
		{
			potLabel.text = msg;// + " " + Math.floor(System.totalMemory / 1000000) + "MB";
			formatLabel();
		}
			
		private function formatLabel():void
		{
			if( potLabel.text == "" )
			{
				potLabel.text = Plant.DEFAULT_NAME;
			}
			potLabel.width = potLabel.textWidth + 4;
			potLabel.height = potLabel.textHeight + 4;
			potLabel.x = -( potLabel.width / 2 );
		}		
	}
}