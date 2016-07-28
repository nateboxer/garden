package net.nateboxer.garden.utils
{
	import flash.events.Event;
	
	import net.nateboxer.garden.plants.Pot;

	public class GardenEvent extends Event
	{
		public static const PLANT_CHOSEN:String = "plantChosen";
		public static const PLANT_DRAWN:String = "plantDrawn";

		public static const VARIATIONS_DRAWN:String = "variationsDrawn";
		public static const VARIATION_CHOSEN:String = "variationChosen";

		public static const BUTTON_CLICKED:String = "buttonClicked";
		
		public var data:Object;
		
		public function GardenEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		public static function createPlantDrawnEvent():GardenEvent
		{
			var ge:GardenEvent = new GardenEvent( PLANT_DRAWN );
			return ge;
		}

		public static function createPlantChosenEvent():GardenEvent
		{
			var ge:GardenEvent = new GardenEvent( PLANT_CHOSEN );
			return ge;
		}

		public static function createVariationsDrawnEvent():GardenEvent
		{
			var ge:GardenEvent = new GardenEvent( VARIATIONS_DRAWN );
			return ge;
		}

		public static function createVariationChosenEvent( pot:Pot ):GardenEvent
		{
			var ge:GardenEvent = new GardenEvent( VARIATION_CHOSEN );
			ge.data = pot;
			return ge;
		}
		
		public static function createButtonClickedEvent():GardenEvent
		{
			var ge:GardenEvent = new GardenEvent( BUTTON_CLICKED );
			return ge;
		}
	}
}