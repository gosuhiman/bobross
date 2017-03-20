package ui
{
	import com.greensock.TweenMax;
	
	import flash.display.Sprite;
	
	public class ClickedPoint extends Sprite
	{
		private var _width:int;
		private var _height:int;
		
		private var _progress:Number;
		
		private var _progressIndicator:Sprite;
		private var _circle:Sprite;
		
		private const COLOR_BLUE:uint = 0x2089a4;
		private const COLOR_ORANGE:uint = 0xeca02f;
		
		private const INDICATOR_WIDTH:int = 0;
		
		
		public function ClickedPoint(width:int, height:int)
		{
			_width = width;
			_height = height;
			
			alpha = 0;
			_progress = 0;
			
			_circle = new Sprite();
			_circle.graphics.beginFill(0x000000);
			_circle.graphics.drawCircle(0, 0, Math.ceil(_width / 2));
			_circle.graphics.endFill();
			addChild(_circle);
			
			_progressIndicator = new Sprite();
			_progressIndicator.graphics.beginFill(0xffffff);
			_progressIndicator.graphics.drawCircle(0, 0, Math.ceil(_width / 2) + INDICATOR_WIDTH);
			_progressIndicator.graphics.endFill();
			addChild(_progressIndicator);
		}
		
		public function handleClick(mx:Number, my:Number):void
		{
			var ANIMATION_TIME:Number = 0.4;
			
			x = mx;
			y = my;
			
			_circle.alpha = 0;
			
			TweenMax.to(this, ANIMATION_TIME, {alpha:1});
		}
		
		public function setProgress(progress:Number):void
		{
			var ANIMATION_TIME:Number = 0.2;
			
			_progress = progress;
			_progressIndicator.alpha = _progress;
			if(_progress == 1)
			{
				TweenMax.to(this, ANIMATION_TIME, {alpha:0});
			}
		}
	}
}