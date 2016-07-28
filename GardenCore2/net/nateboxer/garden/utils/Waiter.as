package net.nateboxer.garden.utils
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	public class Waiter
	{
		private var func:Function;
		private var timer:Timer;
		
		public function Waiter()
		{
		}

		public function wait( func:Function, duration:Number = 250 ):void
		{
			this.func = func;
			timer = new Timer( duration, 1 );
			timer.addEventListener( TimerEvent.TIMER, stop );//, false, 0, true );
			timer.start();
		}
		
		private function stop( te:TimerEvent ):void
		{
			timer.removeEventListener( TimerEvent.TIMER, stop );
			timer.stop();
			timer = null;
			func();
		}
	}
}