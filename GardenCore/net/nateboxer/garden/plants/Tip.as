package net.nateboxer.garden.plants {
	
	public class Tip {

		public var vx:Number;
		public var vy:Number;
		public var angle:Number;
		public var terminates:Boolean;
		
		public function Tip( vx:Number, vy:Number, angle:Number, terminates:Boolean = false ) {
			this.vx = vx;
			this.vy = vy;
			this.angle = angle;
			this.terminates = terminates;
		}
	}
}