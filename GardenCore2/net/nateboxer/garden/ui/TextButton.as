package net.nateboxer.garden.ui
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import net.nateboxer.garden.utils.GardenEvent;

	public class TextButton extends Sprite
	{
		public static const HIT_MARGIN:int = 15;
		
		private var label:TextField;
		private var highlight:Shape;
		
		public function TextButton()
		{
			super();
			label = new TextField();
			label.defaultTextFormat = new TextFormat( "Courier New", 12, 0x505050, true );
			addChild( label );
			highlight = new Shape();
			addChild( highlight );
			alpha = .6;
		}
		
		public function enableButton( enable:Boolean ):void
		{
			if( enable ) 
			{
				alpha = 1;
				addEventListener( MouseEvent.MOUSE_DOWN, handleMouse, false, 0, true );
				addEventListener( MouseEvent.MOUSE_UP, handleMouse, false, 0, true );
				addEventListener( MouseEvent.MOUSE_OVER, handleMouse, false, 0, true );
				addEventListener( MouseEvent.MOUSE_OUT, handleMouse, false, 0, true );
			}
			else
			{
				alpha = .6;
				removeEventListener( MouseEvent.MOUSE_DOWN, handleMouse );
				removeEventListener( MouseEvent.MOUSE_UP, handleMouse );
				removeEventListener( MouseEvent.MOUSE_OVER, handleMouse );
				removeEventListener( MouseEvent.MOUSE_OUT, handleMouse );
			}
		}
		
		private function handleMouse( me:MouseEvent ):void
		{
			switch( me.type )
			{
				case MouseEvent.MOUSE_DOWN:
					dull();
					break;
				case MouseEvent.MOUSE_UP:
					bright();
					dispatchEvent( GardenEvent.createButtonClickedEvent() );
					break;
				case MouseEvent.MOUSE_OVER:
					bright();
					break;
				case MouseEvent.MOUSE_OUT:
				default:
					dull();
					break;
			}
		}
		
		private function bright():void
		{
			//alpha = 1;
			highlight.alpha = 1;
		}
		
		private function dull():void
		{
			//alpha = .8;
			highlight.alpha = .6;	
		}
		
		public function setLabel( labelString:String ):void
		{
			label.text = labelString;
			label.width = label.textWidth + 4;
			label.height = label.textHeight + 4;
			
			var hitty:Sprite = new Sprite();
			hitty.graphics.beginFill( 0xFF0000, 0 );
			hitty.graphics.drawRect( -HIT_MARGIN, -HIT_MARGIN, label.width + (HIT_MARGIN * 2), label.height + (HIT_MARGIN * 2) );
			hitty.graphics.endFill();
			addChild( hitty );
			hitArea = hitty;

			var lineMargin:int = HIT_MARGIN / 2;
			highlight.graphics.clear();
			highlight.graphics.lineStyle( 2, 0xD0D0D0 );
			highlight.graphics.drawRoundRect( -lineMargin, -lineMargin, label.width + (lineMargin * 2), label.height + (lineMargin * 2), 10 );
			
			dull();
		}
		
	}
}