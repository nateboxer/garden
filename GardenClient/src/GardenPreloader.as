package {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import mx.events.FlexEvent;
	import mx.preloaders.DownloadProgressBar;
	
    public class GardenPreloader extends DownloadProgressBar {
    	
	   	private var _preloader:Sprite;
    	
        public function GardenPreloader() {   
            super();
            var loading:TextField = new TextField();
            addChild( loading );
            loading.defaultTextFormat = new TextFormat( "arial", 16, 0x000000, true );
            loading.text = "Loading the Garden...";
            loading.width = loading.textWidth + 4;
            loading.height = loading.textHeight + 4;
//            TextUtils.formatNormal( loading, "Loading the Garden..." );
         }
    
        override public function set preloader( preloader:Sprite ):void {
        	_preloader = preloader;
            preloader.addEventListener( ProgressEvent.PROGRESS, myHandleProgress, false, 0, true );   
            preloader.addEventListener( Event.COMPLETE, myHandleComplete, false, 0, true );
            preloader.addEventListener( FlexEvent.INIT_COMPLETE, myHandleInitEnd, false, 0, true  );
        }
    
        private function myHandleProgress( pe:ProgressEvent ):void {
        	var bytesLoaded:Number = pe.bytesLoaded;
        	if( isNaN( bytesLoaded ) ) {
        		bytesLoaded = 1;
        	}
        	var bytesTotal:Number = pe.bytesTotal;
        	if( isNaN( bytesTotal ) ) {
        		bytesTotal = 250000;
        	}
        	var percent:Number = bytesLoaded / bytesTotal;
        	var rectWidth:Number = stage.stageWidth * percent + 1;
        	graphics.beginFill( 0xA4A4A8, .1 );
			graphics.drawRect( 0, 0, rectWidth, stage.stageHeight );
        	graphics.endFill();
        }
        
         // Event listeners for the FlexEvent.INIT_COMPLETE event.
        private function myHandleInitEnd( event:Event ):void {           
            _preloader.removeEventListener( FlexEvent.INIT_COMPLETE, myHandleInitEnd, false  );
        	dispatchEvent( new Event( Event.COMPLETE ) );
        }
   
        private function myHandleComplete( e:Event ):void {
        	//graphics.clear();
            _preloader.removeEventListener( ProgressEvent.PROGRESS, myHandleProgress, false );   
            _preloader.removeEventListener( Event.COMPLETE, myHandleComplete, false );
        }
    }
}
