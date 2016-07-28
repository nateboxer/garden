package net.nateboxer.garden.utils {
	import flash.filters.DropShadowFilter;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class TextUtils {
		
		public static const VALID_CHARS:String = ",.:-!$%*+?~@#^&' abcdefghijklmnopqrstuvwxyz0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
		
		public static const NORMAL_FONT_SIZE:int = 14;
		public static const SMALL_FONT_SIZE:int = 10;
		
		public function TextUtils() {}

		public static function insertCommas( number:Number ):String {
			var numberWithCommas:String = "" + number;
			if( numberWithCommas.length > 3 ) {
				var parts:Array = new Array();
				while( numberWithCommas.length > 0 ) {
					if( numberWithCommas.length < 3 ) {
						parts.push( numberWithCommas );
						break;
					}
					parts.push( numberWithCommas.substr( numberWithCommas.length - 3 ) );
					numberWithCommas = numberWithCommas.substring( 0, numberWithCommas.length - 3 );
				}
				numberWithCommas = '';
				var firstTime:Boolean = true;
				for( var i:int = parts.length - 1; i >= 0 ; i-- ) {
					if( !firstTime ) {
						numberWithCommas += ",";
					} else {
						firstTime = false;
					}
					numberWithCommas += parts[i];
				}					
			}
			return numberWithCommas;
		}
		
		public static function cleanText( textIn:String ):String {
			var cleanName:String = "";
			for( var i:int = 0; i < textIn.length; i++ ) {
				if( VALID_CHARS.indexOf( textIn.charAt(i) ) > -1 ) {
					cleanName += textIn.charAt(i);
				}
			}
			return cleanName;			
		}
		
		public static function formatTextFormat( tf:TextField, fontSize:Number, dropShadow:Boolean = true, color:uint = 0xFFFFFF ):void {
			tf.embedFonts = true;
			tf.defaultTextFormat = new TextFormat( "oldparks", fontSize, color );
			if( dropShadow ) {
				tf.filters = [ new DropShadowFilter( 2, 45, 0, 1, 3, 3, 1 ) ];			
			}
		}
		
		public static function formatAsYouWish( tf:TextField, text:String, fontSize:Number, dropShadow:Boolean = true, color:uint = 0xFFFFFF ):void {
			formatTextFormat( tf, fontSize, dropShadow, color );
			tf.text = text;
			tf.width = tf.textWidth + 4;			
			tf.height = tf.textHeight + 4;
		}
		
		public static function formatTextFormatNormal( tf:TextField ):void {
			formatTextFormat( tf, NORMAL_FONT_SIZE );
		}
		
		public static function formatNormal( tf:TextField, text:String ):void {
			formatTextFormatNormal( tf );
			tf.text = text;
			tf.width = tf.textWidth + 4;			
			tf.height = tf.textHeight + 4;
		}
		
		public static function setText( tf:TextField, text:String ):void {
			tf.text = text;
			tf.width = tf.textWidth + 4;			
			tf.height = tf.textHeight + 4;
		}
	}
}