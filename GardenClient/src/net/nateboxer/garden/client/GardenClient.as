package net.nateboxer.garden.client {
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.text.TextField;
	import flash.ui.Keyboard;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	
	import mx.core.Application;
	import mx.core.UIComponent;
	import mx.events.ResizeEvent;
	
	import net.nateboxer.garden.plants.Plant;
	import net.nateboxer.garden.utils.TextUtils;

	public class GardenClient extends UIComponent {
		
		public static const HILL_COLOR:uint = 0xACACB4;//0x5C5C6A;
		public static const LAND_COLOR:uint = 0x807070;
		
		public static const CRLF:String = String.fromCharCode( 10 );
		
		public static const TICK_DELAY:int = 100; // 50;
		public static const GARDEN_TICK_TICKS:int = 19; // 39; // where G_T_T * tickCount <= 2 seconds
		public static const GARDEN_TICK_TIMEOUT:int = GARDEN_TICK_TICKS * 5;
		public static const DRAW_PLANTS_TICKS:int = 2; // tune to 4 if we get to scrolling
		
		private var xmlLoader:URLLoader;
		private var xml:XML;
		private var xmlLoading:Boolean;
		private var status:TextField;
		private var help:TextField;
		private var gardenWidth:Number;
		private var console:TextField;
		private var tickTimer:Timer;
		private var tickCount:int;
		
		private var infoPanel:Sprite;
		private var ground:Sprite;
		private var groundMouseArea:Sprite;
		private var hills:Shape;
		private var land:Shape;
		private var dragging:Boolean;
		public var wasDrag:Boolean;
		private var lastX:Number;
		private var viewX:Number;
		private var requestLastViewX:Boolean;
		
		private var plants:Dictionary;
		private var lastTime:Number = new Date().time;
		private var renderStart:Number;
		private var renderEnd:Number;		
		private var inViewPlantCount:int;
		
		private var debugMode:Boolean = false;
		private var splashCount:Number = 120; // splashCount * tickDelay = splash delay
				
		private var marker:Sprite;
		private var kpx:TextField;
		
		private var highestPlantChildIndex:int = 0;
		
		public function GardenClient() {
			super();

			ground = new Sprite();
			addChild( ground );
			
			groundMouseArea = new Sprite();
			ground.addChild( groundMouseArea );
			ground.hitArea = groundMouseArea;
			ground.buttonMode = true;
			
			hills = new Shape();
			ground.addChild( hills );

			marker = new Sprite();
			ground.addChild( marker );

			land = new Shape();
			ground.addChild( land );
			
			dragging = false;
			
			infoPanel = new Sprite();
			addChild( infoPanel );
			infoPanel.mouseEnabled = false;
			
			status = new TextField();
			infoPanel.addChild( status );
			TextUtils.formatAsYouWish( status, " ", 16 );
			status.mouseEnabled = false;

			help = new TextField();
			infoPanel.addChild( help );
			TextUtils.formatAsYouWish( help, " ", 14 );
			help.mouseEnabled = false;
			
			plants = new Dictionary( true );
			
			viewX = 5;
			gardenWidth = 10000;
			requestLastViewX = true;
			xmlLoading = false;
			
			tickCount = GARDEN_TICK_TICKS / 2;
			tickTimer = new Timer( TICK_DELAY );
			tickTimer.addEventListener( TimerEvent.TIMER, loadGarden, false, 0, true );
			tickTimer.start();
		}
		
		public function init():void {
//			var params:Object = Application.application.stage.loaderInfo.parameters;
//			for( var key:String in params ) {
//				if( key == "debug" ) {
//					debugMode = (params[key] == "true");
					if( debugMode ) {
						console = new TextField();
						infoPanel.addChild( console );
						TextUtils.formatTextFormat( console, TextUtils.SMALL_FONT_SIZE );
						console.multiline = true;
						//console.mouseEnabled = false;
						console.selectable = true;
						console.wordWrap = true;
						console.x = 0;
						console.y = 0;
						console.width = 400;
						console.height = 500;						
					}
//				}
//			}
			updateStatus( "Loading plants..." );

			addEventListener( ResizeEvent.RESIZE, handleResize, false, 0, true );
			addEventListener( Event.RESIZE, handleResize, false, 0, true );
			
			Application.application.splash.visible = true;			

			initDisplay();
		}
		
		private function enableDrag():void {
			ground.addEventListener( MouseEvent.MOUSE_DOWN, pickUp, false, 0, true );
			ground.addEventListener( MouseEvent.MOUSE_UP, letGo, false, 0, true );
			
			Application.application.stage.addEventListener( KeyboardEvent.KEY_UP, handleKey, false, 0, true );
		}
		
		private function handleKey( ke:KeyboardEvent ):void {
			var newPlant:Plant;
			var newX:Number;
			switch( ke.keyCode ) {
				case Keyboard.LEFT:
					if( Application.application.props.plant == null ) {
						newPlant = findPlantLeftOf( width / 2 );
					} else {
						newPlant = findPlantLeftOf( Application.application.props.plant.x );
					}
					if( newPlant ) {
						Application.application.props.showProps( newPlant );
//						if( newPlant.x < 0 ) {
//							newX = newPlant.x + viewX - 50;
//							if( newX < 0 ) {
//								newX += gardenWidth;
//							}
//							newViewX( newX );
//						}
						newX = newPlant.x + viewX - (width / 2);
						if( newX < 0 ) {
							newX += gardenWidth;
						}
						newViewX( newX );
						updateHelp();
					}
					break;
				case Keyboard.RIGHT:
					if( Application.application.props.plant == null ) {
						newPlant = findPlantRightOf( width / 2 );
					} else {
						newPlant = findPlantRightOf( Application.application.props.plant.x );
					}
					if( newPlant ) {
						Application.application.props.showProps( newPlant );
//						if( newPlant.x > width ) {
//							newX = (newPlant.x - width) + viewX + 50;
//							if( newX > gardenWidth ) {
//								newX -= gardenWidth;
//							}
//							newViewX( newX );
//						}
						newX = (newPlant.x - width) + viewX + (width / 2);
						if( newX > gardenWidth ) {
							newX -= gardenWidth;
						}
						newViewX( newX );
						updateHelp();
					}
					break;
				case Keyboard.ESCAPE:
					Application.application.props.hideProps();
					break;
			}
		}
		
		public function dimPlants( dim:Boolean = true, exceptPlant:Plant = null ):void {
			//debug( "dimPlants( " + dim + ", " + exceptPlant + " )" );
			for each( var plant:Plant in plants ) {
				if( dim ) {
					if( !plant || (plant != exceptPlant) ) {
						plant.alpha = .4;
					} else {
						plant.alpha = 1;
						try {
							ground.setChildIndex( plant, highestPlantChildIndex );
						} catch( e:Error ) {}
					}
				} else {
					plant.alpha = 1;
				}
			}
		}
		
		private function findPlantLeftOf( leftX:Number ):Plant {
			var closestPlant:Plant;
			var closestX:Number = 10000;
			var dif:Number;
			for each( var p:Plant in plants ) {
				if( (p.x >= 0) && (p.x < leftX) ) {
					dif = leftX - p.x;
					if( dif < closestX ) {
						closestX = dif;
						closestPlant = p;
					}
				} else if( p.x < 0 ) {
					dif = leftX + (-p.x);
					if( dif < closestX ) {
						closestX = dif;
						closestPlant = p;
					}					
				}
			}
			return closestPlant;			
		}

		private function findPlantRightOf( rightX:Number ):Plant {
			var closestPlant:Plant;
			var closestX:Number = 10000;
			for each( var p:Plant in plants ) {
				if( p.x > rightX ) {
					var dif:Number = p.x - rightX;
					if( dif < closestX ) {
						closestX = dif;
						closestPlant = p;
					}
				}
			}
			return closestPlant;			
		}
		
		private function loadGarden( te:TimerEvent = null ):void {
			tickCount++;
			if( tickCount > GARDEN_TICK_TICKS ) {	
				if( !xmlLoading || (tickCount > GARDEN_TICK_TIMEOUT) ) {
					if( xmlLoading ) {
						xmlLoader.removeEventListener( Event.COMPLETE, xmlLoaded, false );
						try {
							xmlLoader.close();
						} catch( e:Error ) {}
					}
					tickCount = 0;	
					xmlLoading = true;
					xmlLoader = new URLLoader();
					var urlRequest:URLRequest = new URLRequest( "php/browse_garden.php" );
					var urlVars:URLVariables = new URLVariables();
					
					urlVars.width = width;
					if( requestLastViewX ) {
						urlVars.requestLastViewX = 1;
					} else {
						urlVars.x = viewX;
					}
									
					urlRequest.data = urlVars;
					urlRequest.method = URLRequestMethod.POST;
					try {
						xmlLoader.load( urlRequest );
					} catch( e:Error ) {}
					xmlLoader.addEventListener( Event.COMPLETE, xmlLoaded, false, 0, true );
				}
			} else if( (tickCount % DRAW_PLANTS_TICKS) == 0 ) {
				drawPlantsWhileWaiting();
			}
		}
		
		private function xmlLoaded( e:Event ):void {
			if( xmlLoading ) {
				xmlLoading = false;
				xmlLoader.removeEventListener( Event.COMPLETE, xmlLoaded, false );
				if( e is ErrorEvent ) {
					xml = null;
					debug( e.toString() );
					return;
				}		
				xml = new XML( e.target.data );
				if( xml.elements( "too_soon" ).length() > 0 ) {
					lastTime = new Date().time;	
					return;
				}
				gardenWidth = Number( xml.width );
				if( requestLastViewX ) {
					requestLastViewX = false;
					viewX = Number( xml.lastViewX );
					//debug( "viewX: " + viewX + " " + xml.lastViewX );
					updateHelp();
					enableDrag();
					drawLand();
				}
				drawPlants();
				debug( "[ pop=" + xml.pop + " brn=" + xml.births + " loc=" + inViewPlantCount + " srv=" + xml.elapsed + " rnd=" + ((renderEnd - renderStart) / 1000) + " tot=" + (((new Date().time) - lastTime) / 1000) + " ]" );
				lastTime = new Date().time;	
			}
		}
		
		private function drawPlantsWhileWaiting():void {
			var canSee:int = 0;
			inViewPlantCount = 0;
			for each( var plant:Plant in plants ) {
				if( !dragging ) {
					plant.draw( false );
				}
				inViewPlantCount++;
				if( (plant.x > 0) && (plant.x < width) ) {
					canSee++;
				}
			}
			if( canSee < 1 ) {
				updateStatus( "Loading plants..." );
			} else {
				updateStatus( "" );
			}
			if( Application.application.splash.alpha > 0 ) {
				splashCount--;
				if( splashCount < 1 ) {
					Application.application.splash.alpha -= .05;
					if( Application.application.splash.alpha <= 0 ) {
						Application.application.splash.visible = false;
					}
				}
			}
		}
		
		private function drawPlants():void {
			renderStart = new Date().time;
			for each( var plantInMemory:Plant in plants ) {
				plantInMemory.keepAlive = false;
			}
			for each( var plantXML:XML in xml.plant ) {
				var plant:Plant = new Plant( 
					plantXML.@id, 
					plantXML.@x, 
					plantXML.@maxAge, 
					plantXML.@maxPhenes,
					plantXML.@maxTips,
					plantXML,
					plantXML.@parentDNAID,
					plantXML.@parentName,
					plantXML.@codonRange,
					plantXML.@pheneSetSize );
				var foundPlant:Boolean = false;
				for each( plantInMemory in plants ) {
					if( plantInMemory.id == plant.id ) {
						plantInMemory.keepAlive = true;
						if( !dragging ) {
							plantInMemory.draw( false );
						}
						foundPlant = true;
						break;
					}
				}
				if( !foundPlant ) {
					plant.keepAlive = true;
					plant.y = height - Land.GROUND[Math.round(plant.xPos / Land.LAND_STEP)] + 1;
					plant.draw( true );
					plants[plant] = plant;						
					ground.addChild( plant );
					highestPlantChildIndex = ground.getChildIndex( plant );
					plant.enableClientListeners( true );
				}
			}
			for each( plantInMemory in plants ) {
				if( !plantInMemory.keepAlive ) {
					if( !plant || (plantInMemory.id != plant.id) ) {
						plantInMemory.die();
					}
				}
			}
			locatePlants();
			renderEnd = new Date().time;
		}
		
		private function locatePlants( andRemove:Boolean = false ):void {
			var widthTen:Number = width * 10;
			for each( var plant:Plant in plants ) {
				if( (viewX + width) >= gardenWidth ) {
					if( (plant.xPos >= 0) && (plant.xPos < widthTen) ) { // must take into width the size browse_garden is returning
						plant.x = (gardenWidth - viewX) + plant.xPos;
					} else {
						plant.x = plant.xPos - viewX;
					}
				} else {
					if( (viewX < width) && (plant.xPos > widthTen) ) {
						plant.x = plant.xPos - gardenWidth - viewX;
					} else if( (viewX <= gardenWidth - width) && (viewX >= widthTen) && (plant.xPos >= 0) && (plant.xPos <= width) ) {
						plant.x = gardenWidth - viewX + plant.xPos;
					} else {
						plant.x = plant.xPos - viewX;
					}
				}
			}			
		}
				
		public function releasePlant( plant:Plant ):void {
			try {
				ground.removeChild( plant );
			} catch( e:Error ) {} finally {
				plant.destroy();
			}			
			delete plants[plant];
		}
		
		public function updateStatus( text:String ):void {
 			TextUtils.setText( status, text );
			status.x = this.width - status.width;
			status.y = 0;
		}

		private function updateHelp():void {
			var px:int = viewX + Math.round(width / 2);
			if( px > gardenWidth ) {
				px -= gardenWidth;
			}
 			var text:String = TextUtils.insertCommas( px ) + "px";
			TextUtils.setText( help, text );
			help.x = (width - help.width) / 2;
			help.y = 0;
		}
		
		public function debug( text:String ):void {
			if( debugMode ) {
				console.appendText( text + " *\n" );
				if( (console.textHeight + 4) >= console.height ) {
					var t:String = console.text;
					var l:int = t.indexOf( "*" ) + 2;
					if( l > -1 ) {
						console.replaceText( 0, l, "" );
					}
				}
			}
		}

		private function pickUp( e:Event ):void {
			if( !dragging ) {
				dragging = true;
				wasDrag = false;
				ground.startDrag( false, new Rectangle( -width, 0, width * 2, 0 ) );
				lastX = Application.application.stage.mouseX;
				Application.application.props.hideProps();
			}
		}
		
		public function letGo( e:Event ):void {
			if( dragging ) {
				dragging = false;
				ground.stopDrag();
				if( lastX != Application.application.stage.mouseX ) {
					viewX -= ground.x;
					wasDrag = true;
					if( viewX < 0 ) {
						viewX += gardenWidth;
					}
					if( viewX > gardenWidth ) {
						viewX -= gardenWidth;
					}
					ground.x = 0;
					newViewX( viewX );
					updateHelp();
				}
			}
		}
			
		private function newViewX( newX:Number ):void {
			viewX = newX;
			drawLand();
			locatePlants( true );
			if( Application.application.props.plant ) {
				var plant:Plant = Application.application.props.plant;
				if( (plant.x < -(width * 3)) || (plant.x > (width * 4)) ) {
					Application.application.props.hideProps();
				}
			}			
		}
				
		private function initDisplay():void {
			drawMouseArea();	
			locateSplash();
			initMarker();
		}
		
		private function handleResize( e:Event ):void {
			drawMouseArea();		
			if( !requestLastViewX ) {
				drawLand();
			}
			locateSplash();
		}

		private function locateSplash():void {
			Application.application.splash.x = (width - Application.application.splash.width) / 2;
			Application.application.splash.y = 50;			
		}		
		
		private function drawMouseArea():void {			
			groundMouseArea.graphics.clear();			
			groundMouseArea.graphics.beginFill( 0xFF0000, 0 );
			groundMouseArea.graphics.drawRect( 0, 0, width, height );
			groundMouseArea.graphics.endFill();			
		}
		
		private function drawLand():void {
			
			land.graphics.clear();
			hills.graphics.clear();
			
			var startX:Number = viewX - width;
			if( startX < 0 ) {
				startX += gardenWidth;
			}
			var offset:Number = startX % Land.LAND_STEP;
			var vx:int = Math.floor(startX / Land.LAND_STEP);
			
			var i:int = 0;
			var iterations:int = (width * 3) / Land.LAND_STEP;
			while( i < iterations ) {

				var screenX:Number = (i * Land.LAND_STEP) - width + (Land.LAND_STEP - offset);
				 
				hills.graphics.beginFill( HILL_COLOR );
				hills.graphics.drawRect( screenX, height, Land.LAND_STEP, -Land.HILLS[vx] );
				hills.graphics.endFill();

				land.graphics.beginFill( LAND_COLOR );
				land.graphics.drawRect( screenX, height, Land.LAND_STEP, -Land.GROUND[vx] );
				land.graphics.endFill();
				
				i++;
				vx++;
				if( vx >= Land.HILLS.length ) {
					vx -= Land.HILLS.length;
				}
				
				var landPos:Number = (vx * Land.LAND_STEP);
				if( (landPos % 5000) == 0 ) {
					showMiles( landPos, screenX, Land.GROUND[vx] );
				}
			}			
		}
		
		private function showMiles( landX:Number, screenX:Number, landHeight:int ):void {
			
			TextUtils.setText( kpx, "" + (landX / 1000) );
			kpx.x = (marker.width - kpx.width - 2) / 2;

			marker.x = screenX - (marker.width / 2);
			marker.y = height - landHeight - marker.height + 5;
		}
		
		private function initMarker():void {
			marker.mouseEnabled = false;
			
			marker.graphics.lineStyle( 1, 0x61361D );
			marker.graphics.beginFill( 0x774E24 );
			marker.graphics.drawRect( 7, 65, 5, 40 );
			marker.graphics.endFill();
			marker.graphics.beginFill( 0x774E24 );
			marker.graphics.drawRect( 33, 65, 5, 40 );
			marker.graphics.endFill();

			marker.graphics.lineStyle( 3, 0xFFFFFF, 1, true );
			marker.graphics.beginFill( 0x61361D );
			marker.graphics.drawRoundRect( 0, 0, 45, 65, 20 );
			marker.graphics.endFill();
			
			kpx = new TextField();
			marker.addChild( kpx );
			TextUtils.formatAsYouWish( kpx, "50", 24, false );			
			kpx.mouseEnabled = false;
			
			kpx.x = (marker.width - kpx.width - 2) / 2;
			kpx.y = 8;
			
			var label:TextField = new TextField();
			marker.addChild( label );
			TextUtils.formatAsYouWish( label, "Kpx", 14, false );
			label.mouseEnabled = false;
			
			label.x = (marker.width - label.width - 2) / 2;
			label.y = kpx.y + kpx.height;
			
			marker.x = -1000;
		}

		public function get centerScreen():Number {
			var center:Number = viewX + (width / 2);
			if( center > gardenWidth ) {
				center -= gardenWidth;
			}
			return center;
		}
	}
}