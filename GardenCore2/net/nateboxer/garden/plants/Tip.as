package net.nateboxer.garden.plants {
	
	public class Tip {

		/*

		   l___v___r
		   |      |
		   |      | 
		   |      |
		   |      |

           l(x,y) - left corner
           r(x,y) - right corner
           v(x,y) - vector end point		

		*/

		public var vx:Number;
		public var vy:Number;
		public var lx:Number;
		public var ly:Number;
		public var rx:Number;
		public var ry:Number;
		public var angle:Number;
		public var terminates:Boolean;
		
		public function Tip( vx:Number, vy:Number, lx:Number, ly:Number, rx:Number, ry:Number, angle:Number, terminates:Boolean = false ) {
			this.vx = vx;
			this.vy = vy;
			this.lx = lx;
			this.ly = ly;
			this.rx = rx;
			this.ry = ry;
			this.angle = angle;
			this.terminates = terminates;
		}
		
		public function clone():Tip {
			var tip:Tip = new Tip(vx,vy,lx,ly,rx,ry,angle,terminates);
			return tip;
		}
	}
}