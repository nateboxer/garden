package net.nateboxer.garden.desktop {
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.system.System;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	
	import mx.core.UIComponent;
	import mx.graphics.codec.PNGEncoder;
	
	import net.nateboxer.garden.plants.Plant;
	
	public class DnaBrowser extends UIComponent {
		
		public static const NUM_CLIPPINGS:int = 1;
		public static const AUTO_SAVE_ON:Boolean = true;
		
		public static const REDRAW_DELAY:Number = 30;
		public static const PLANT_AREA_WIDTH:int = 400;
		
		private var ground:Sprite;
		private var xmlLoader:URLLoader;
		private var xml:XML;
		private var plants:Array;
		private var timer:Timer;
		private var tickCount:int;
		private var currentPlant:Plant;
		private var drawnPlants:Dictionary;
		private var stats:TextField;
		private var paused:Boolean;
		private var saving:Boolean;
		
		private var pauseCount:int;
		
		public function DnaBrowser() {
			
			timer = new Timer( REDRAW_DELAY );
			timer.addEventListener( TimerEvent.TIMER, tick, false, 0, true );
			
			plants = new Array();
			drawnPlants = new Dictionary( true );

			ground = new Sprite();
			addChild( ground );
		
			stats = new TextField();
			addChild( stats );
			
			paused = false;
			saving = false;
		}

		public function init():void {
			stats.width = width;
			stats.height = 25;
			stats.defaultTextFormat = new TextFormat( "arial", 16, 0x202020 );
			loadDNA();
		}
		
		private function drawNextPlant():void {
			var p:Plant = plants.pop();
			if( p != null ) {
				drawPlant( p );
			} else {
				stats.text = "DONE";
			}
		}
		
		private function savePlants():void {
			saving = true;
			resume();
		}
		
		private function nextPlant():void {
			initPlant( currentPlant.clone() );
			tickCount = 0;
			resume();
		}
		
		private function pause():void {
			timer.stop();
			paused = true;
			stats.appendText( " PAUSED" );
		}
		
		private function resume():void {	
			ground.graphics.clear();
			timer.start();
			paused = false;
			pauseCount = 0;
		}
		
		private function dumpImage():void {
			
			pause();
			
			var p:Plant = null;
			for each( p in drawnPlants ) {
				break;
			}
			if( p == null ) {
				saving = false;
				pause();
				stats.appendText( " SAVED" );
				if( AUTO_SAVE_ON ) {
					drawNextPlant();
				}
				return;
			}
			
			var orig:Point = new Point( p.x, p.y );
			p.x = 0;
			p.y = 0;
			
			var bounds:Rectangle = p.getBounds( ground );
			
			// modify bounds to see if it helps
			bounds.x -= 50;
			bounds.y -= 50;
			bounds.width += 100;
			bounds.height += 100;
			
			//ground.graphics.lineStyle( 1, 0xFFFFFF );
			//ground.graphics.drawRect( bounds.x + orig.x, bounds.y + orig.y, bounds.width, bounds.height );
			
			// move into positive coordinates
			var tx:Number = bounds.x;
			if( tx != 0 ) {
				tx = -tx;
			}
			var ty:Number = bounds.y;
			if( ty != 0 ) {
				ty = -ty;
			}		
			
			// scale
			var scale:Number = 6;
			var newWidth:Number = bounds.width * scale;
			var newHeight:Number = bounds.height * scale;
			while( (newWidth * newHeight) > 10000000 ) {
				scale--;
				newWidth = bounds.width * scale;
				newHeight = bounds.height * scale;					
			}
			//trace( "scale: " + scale );

			var fileName:String = "C:/DATA/evolve beauty/renders/" + scale + "x_";
			fileName += p.parentName;
			fileName += "_" + p.id + ".png";
			var file:File = File.desktopDirectory.resolvePath( fileName );
			
			// Just getting trace for Hieran
			//if( !file.exists && (bounds.height < 800) && (bounds.width < 900) ) {
			if( null ) {
				trace( fileName );
				
				var matrix:Matrix = new Matrix( scale, 0, 0, scale, tx * scale, ty * scale );
				var bmd:BitmapData = new BitmapData( newWidth, newHeight, true, 0 );
				bmd.draw( p, matrix );				
								
				var pngEncoder:PNGEncoder = new PNGEncoder();
				var ba:ByteArray = pngEncoder.encode( bmd );
			
				var fs:FileStream = new FileStream();
				try{
					fs.open( file, FileMode.WRITE );
					fs.writeBytes( ba );
				} catch( e:Error ) {
					trace( e.toString() );
				} finally {
					fs.close();
				}
				
				bmd.dispose();
				matrix = null;
			}
			
			p.x = orig.x;
			p.y = orig.y;
			
			releasePlant( p );
			
			resume();
		}
		
		private function releasePlant( plant:Plant ):void {
			try {
				delete drawnPlants[plant];
				ground.removeChild( plant );
			} catch( e:Error ) {
				trace( e.toString() );
			}
			plant.destroy();
			plant = null;
		}
		
		private function loadDNA():void {
			xmlLoader = new URLLoader();
			var urlRequest:URLRequest = new URLRequest( "http://nateboxer.net/garden/php/dna_feed.xml" );
			//var urlRequest:URLRequest = new URLRequest( "http://localhost/garden/php/dna_feed.xml" );
			urlRequest.method = URLRequestMethod.POST;
			try {
				xmlLoader.load( urlRequest );
			} catch( e:Error ) {
				trace( e.toString() );
			}
			xmlLoader.addEventListener( Event.COMPLETE, xmlLoaded, false, 0, true );
		}
		
		private function xmlLoaded( e:Event ):void {
			xmlLoader.removeEventListener( Event.COMPLETE, xmlLoaded, false );
			if( e is ErrorEvent ) {
				trace( e.toString() );
				return;
			}		
			xml = new XML( e.target.data );
			parseDNA();
		}
		
		private function parseDNA():void {
			for each( var dnaXML:XML in xml.dna ) {
				var plant:Plant = new Plant( 
					dnaXML.@id, 
					0, 
					dnaXML.@maxAge, 
					dnaXML.@maxPhenes,
					dnaXML.@maxTips,
					dnaXML,
					dnaXML.@parentDNAID,
					dnaXML.@name,
					dnaXML.@codonRange,
					dnaXML.@pheneSetSize ); // instead of parent name
				plants.push( plant );
			}
			trace( "Created plants: " + plants.length );
			if( plants.length > 0 ) {
				drawPlant( plants.pop() );
			}
		}
		
		private function drawPlant( plant:Plant ):void {
			initPlant( plant.clone() );
//			if( !timer.running ) {
//				timer.start();
//				paused = false;
//				pauseCount = 0;
//			}
			tickCount = 0;
			//ground.x = PLANT_AREA_WIDTH / 2;
			resume();
		}
		
		private function tick( te:TimerEvent ):void {
			if( paused ) {
				return;
			}
			if( saving ) {
				dumpImage();
				return;
			}
			tickCount++;
			if( (tickCount * 2) < currentPlant.maxAge ) {
				
				// 4 secs per 5 garden ticks
				// 40 draws per 5 garden ticks
				for( var i:int = 0; i < 10; i++ ) {
					if( currentPlant.tipCount > 0 ) {
						currentPlant.draw( false );					
					} else {
						tickCount = 2500;
					}
				}
			} else {
				pause();
				pauseCount++;
				if( AUTO_SAVE_ON ) {
					if( pauseCount < NUM_CLIPPINGS ) {
						nextPlant();
					} else {
						savePlants();
					}		
				}
			}
		}
		
		private function initPlant( plant:Plant ):void {
			if( currentPlant ) {
				currentPlant.destroy();
			}
			currentPlant = plant;
			drawnPlants[currentPlant] = currentPlant;
			var numDrawnPlants:int = 0;
			for each( var p:Plant in drawnPlants ) {
				numDrawnPlants++;
			}
			
			//trace( "num plants: " + plants.length + " drawn: " + numDrawnPlants );
			
			var offset:Number = PLANT_AREA_WIDTH * numDrawnPlants;
			ground.addChild( currentPlant );
			//ground.x = (width / 2) - offset;
			currentPlant.draw( true, 1.5 );
			currentPlant.x = offset;
			currentPlant.y = height - 50;
			
			trace( "Plant: " + currentPlant.parentName );
			
			stats.text = currentPlant.parentName
				+ "  id: " + currentPlant.id
				//+ "  rank: " + plantIndex
				+ "  codon range: " + currentPlant.codonRange
				+ "  phene set: " + currentPlant.pheneTypes.toString()
				//+ "  age: " + (tickCount * 2)
				//+ "  tips: " + currentPlant.tipCount
				//+ "  phenes: " + currentPlant.pheneCount
				+ "  (" + Math.floor( System.totalMemory / 1000000 ) + "MB)";
		}
		
	}
}