package ui
{
	import flash.display.Sprite;
	
	public class RadioBox extends Sprite
	{
		private var _width:int;
		private var _height:int;
		
		private var _background:Sprite;
		private var _cnt:Sprite;
		
		private var _options:Array;
		private var _btns:Array;
		
		private var _callback:Function;
		
		private const colorA:uint = 0xf2a30f;
		
		public function RadioBox(options:Array, width:int = 120, height:int = 25, callback:Function = null)
		{
			_width = width;
			_height = height;
			_callback = callback;
			
			_options = options;
			_btns = new Array();
			
			draw();
		}
		
		private function draw():void
		{
			removeChildren();
			_btns = new Array();
			
			_background = new Sprite();
			_background.graphics.beginFill(0x000000, 0.2);
			_background.graphics.drawRect(0, 0, _width, _height);
			_background.graphics.endFill();
			addChild(_background);
			
			_cnt = new Sprite();
			addChild(_cnt);
			
			var btnY:int = 2;
			var index:int = 0;
			
			for each(var option:String in _options)
			{
				var radioBtn:Sprite = new RadioBtn(option, _width, Math.floor(_height / _options.length), index, updateSelections);
				radioBtn.y = btnY;
				addChild(radioBtn);
				_btns.push(radioBtn);
				
				btnY += radioBtn.height;
				index++;
			}
		}
		
		private function updateSelections():void
		{
			for each(var radioBtn:RadioBtn in _btns)
			{
				radioBtn.updateSelection();
			}
			
			if(_callback != null)
			{
				_callback();
			}
		}
	}
}