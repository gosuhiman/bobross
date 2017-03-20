package
{
	import com.adobe.images.PNGEncoder;
	import com.greensock.TweenMax;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.net.FileReference;
	import flash.ui.Keyboard;
	import flash.utils.ByteArray;
	
	import ui.RadioBox;
	import ui.InfoBox;
	import ui.ClickedPoint;
	
	public class Painting extends Sprite
	{
		protected var _width:int;
		protected var _height:int;
		
		public var _bitmapData:BitmapData;
		public var _bitmapDataBufor:BitmapData;
		protected var _bitmap:Bitmap;
		protected var _bitmapBufor:Bitmap;
		
		private var _currentBitmapData:BitmapData;
		
		protected var _xFrom:Number;
		protected var _xTo:Number;
		protected var _yFrom:Number;
		protected var _yTo:Number;
		
		protected var _zoom:Number = 1;
		
		protected var _infoBox:InfoBox;
		protected var _infoBox2:InfoBox;
		protected var _radioBox:RadioBox;
		protected var _clickedPoint:ClickedPoint;
		
		private var _mx:Number;
		private var _my:Number;
		private var _progress:Number;
		
		private const VAL_ROUND:int = 1000000;
		
		public function Painting(width:int, height:int)
		{
			_width = width;
			_height = height;
			
			_mx = 0;
			_my = 0;
			_progress = 0;
			
			graphics.beginFill(0x000000);
			graphics.drawRect(0, 0, _width, _height);
			graphics.endFill();
			
			_bitmapData = new BitmapData(_width, _height, false, 0x000000);
			_bitmap = new Bitmap(_bitmapData);
			_bitmap.smoothing = true;
			
			_bitmapDataBufor = new BitmapData(_width, _height, false, 0x000000);
			_bitmapBufor = new Bitmap(_bitmapDataBufor);
			_bitmapBufor.smoothing = true;
			_bitmapBufor.alpha = 0;
			
			setDefaultZoom();
			
			addChild(_bitmapBufor);
			addChild(_bitmap);
			
			_infoBox = new InfoBox(120, 70);
			_infoBox.x = 0;
			_infoBox.y = 0;
			addChild(_infoBox);
			
			_infoBox2 = new InfoBox(240, 25);
			_infoBox2.x = 0;
			_infoBox2.y = _height - 25;
			_infoBox2.text = "p = save view, space = reset zoom";
			addChild(_infoBox2);
			
			_radioBox = new RadioBox(new Array("normal", "black&white", "smooth", "smooth&sin"), 120, 120, draw);
			_radioBox.x = 0;
			_radioBox.y = 80;
			addChild(_radioBox);
			
			_clickedPoint = new ClickedPoint(20, 20);
			addChild(_clickedPoint);
		}
		
		protected function handleMove(e:MouseEvent):void
		{
			_mx = Util.round(Util.translateCoords(e.stageX, _width, _xFrom, _xTo), VAL_ROUND);
			_my = Util.round(Util.translateCoords(e.stageY, _height, _yFrom, _yTo), VAL_ROUND);
			_infoBox.text = "x = " + _mx + "\ny = " + _my + "\np = " + _progress;
		}
		
		protected function handleClick(e:MouseEvent):void
		{
			var mx:Number = Util.translateCoords(e.stageX, _width, _xFrom, _xTo);
			var my:Number = Util.translateCoords(e.stageY, _height, _yFrom, _yTo);
			zoomTo(mx, my);
			//_clickedPoint.handleClick(e.stageX, e.stageY);
		}
		
		protected function handleKeyDown(e:KeyboardEvent):void
		{
			var key:uint = e.keyCode;
			if(key == Keyboard.SPACE) 
			{
				setDefaultZoom();
				draw();
			}
			else if(key == Keyboard.O)
			{
				Model.coloringMode = ColoringMode.BLACK_WHITE;
				draw();
			}
			else if(key == Keyboard.I)
			{
				Model.coloringMode = ColoringMode.SMOOTH;
				draw();
			}
			else if(key == Keyboard.U)
			{
				Model.coloringMode = ColoringMode.SIN;
				draw();
			}
			else if(key == Keyboard.Y)
			{
				Model.coloringMode = ColoringMode.NORMAL;
				draw();
			}
			else if(key == Keyboard.P) 
			{
				if(_currentBitmapData)
				{
					var BAR_HEIGHT:int = 50;
					
					var screenshot:Sprite = new Sprite();
					screenshot.graphics.beginFill(0x000000);
					screenshot.graphics.drawRect(0, _height, _width, BAR_HEIGHT);
					screenshot.graphics.endFill();
					screenshot.addChild(new Bitmap(_currentBitmapData));
					var screenInfoBox:InfoBox = new InfoBox(_width, BAR_HEIGHT);
					screenInfoBox.y = _height;
					screenInfoBox.text = "oto zbiór mandelbrota x = [" + _xFrom + " : " + _xTo + "], y = [" + _yFrom + " : " + _yTo + "]\npozdrawiam pieroszkuf!";
					screenshot.addChild(screenInfoBox);
					
					var bitmapData:BitmapData = new BitmapData(_width, _height + BAR_HEIGHT);
					bitmapData.draw(screenshot);
					
					var file:FileReference = new FileReference();
					var fileName:String = "mandelbrot_" + Util.rndString(8) + ".png";
					file.save(PNGEncoder.encode(bitmapData), fileName);
				}
			}
		}
		
		protected function handleEnterFrame(e:Event):void
		{
			
		}
		
		protected function zoomTo(zx:Number, zy:Number):void
		{
			var xDiff:Number = Math.abs(_xTo - _xFrom);
			var yDiff:Number = Math.abs(_yTo - _yFrom);
			_xFrom = zx - xDiff / 4;
			_xTo = zx + xDiff / 4;
			_yFrom = zy - yDiff / 4;
			_yTo = zy + yDiff / 4;
			draw();
		}
		
		protected function setDefaultZoom():void
		{
			_xFrom = -5;
			_xTo = 5;
			_yFrom = -5;
			_yTo = 5;
		}
		
		public function setPixels(imageBytes:ByteArray):void
		{
			var ANIMATION_TIME:Number = 0.4;
			
			if(_bitmap.alpha == 1)
			{
				_currentBitmapData = _bitmapDataBufor;
				
				_bitmapDataBufor.lock();
				_bitmapDataBufor.setPixels(_bitmapDataBufor.rect, imageBytes);
				_bitmapDataBufor.unlock();
				
				TweenMax.to(_bitmap, ANIMATION_TIME, {alpha:0});
				TweenMax.to(_bitmapBufor, ANIMATION_TIME, {alpha:1, onComplete:function():void{ addListeners(); }});
			}
			else
			{
				_currentBitmapData = _bitmapData;
				
				_bitmapData.lock();
				_bitmapData.setPixels(_bitmapData.rect, imageBytes);
				_bitmapData.unlock();
				
				TweenMax.to(_bitmapBufor, ANIMATION_TIME, {alpha:0});
				TweenMax.to(_bitmap, ANIMATION_TIME, {alpha:1, onComplete:function():void{ addListeners(); }});
			}
		}
		
		public function addListeners():void
		{
			addEventListener(MouseEvent.MOUSE_MOVE, handleMove);
			addEventListener(MouseEvent.CLICK, handleClick);
			//addEventListener(Event.ENTER_FRAME, handleEnterFrame);
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, handleKeyDown);
		}
		
		public function removeListeners():void
		{
			removeEventListener(MouseEvent.MOUSE_MOVE, handleMove);
			removeEventListener(MouseEvent.CLICK, handleClick);
			//removeEventListener(Event.ENTER_FRAME, handleEnterFrame);
			
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, handleKeyDown);
		}
		
		public function draw():void
		{
			removeListeners();
		}
		
		public function setProgress(progress:Number):void
		{
			_progress = Util.round(progress, VAL_ROUND);
			//_clickedPoint.setProgress(_progress);
			_infoBox.text = "x = " + _mx + "\ny = " + _my + "\np = " + _progress;
		}
	}
}