package net.nateboxer.garden.utils
{
	import fl.transitions.Tween;
	import fl.transitions.TweenEvent;
	import fl.transitions.easing.Regular;
	
	import mx.core.Application;
	
	public class Tweener
	{
		public var t:Number = 0;
		public var tweening:Boolean = false;
		public var tween:Tween;
		
		private var motionFunc:Function;
		private var finishFunc:Function;
		
		public function Tweener() {}
		
		public function createRegularTween( durationSeconds:Number, motionFunc:Function, finishFunc:Function ):Tween
		{
			//Application.application.main.debug( "creating tween..." );
			destroyTween();
			this.motionFunc = motionFunc;
			this.finishFunc = finishFunc;
			t = 0;
			tweening = true;
			tween = new Tween( this, "t", Regular.easeInOut, 0, 1, durationSeconds, true );
			tween.addEventListener( TweenEvent.MOTION_CHANGE, motionFunc, false, 0, true );
			tween.addEventListener( TweenEvent.MOTION_FINISH, finishFunc, false, 0, true );
			return this.tween;
		}
		
		public function destroyTween():void
		{
			if( tween != null )
			{
				//Application.application.main.debug( "destroying tween..." );
				tween.removeEventListener( TweenEvent.MOTION_CHANGE, motionFunc );
				tween.removeEventListener( TweenEvent.MOTION_FINISH, finishFunc );
				tween = null;
			}
			tweening = false;
		}
	}
}