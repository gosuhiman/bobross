package
{
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.system.MessageChannel;
	import flash.system.Worker;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	
	public class MandelbrotWorker extends Sprite
	{
		protected var _mainToWorker:MessageChannel;
		protected var _workerToMain:MessageChannel;
		
		protected var _xFrom:Number;
		protected var _xTo:Number;
		protected var _yFrom:Number;
		protected var _yTo:Number;
		
		protected var _imageBytes:ByteArray;
		
		private var _bitmapData:BitmapData;
		
		private var _timer:Timer;
		
		private var _width:int;
		private var _height:int;
		
		public function MandelbrotWorker()
		{
			var worker:Worker = Worker.current;
			
			_mainToWorker = worker.getSharedProperty("mainToWorker");
			_workerToMain = worker.getSharedProperty("workerToMain");
			
			_imageBytes = worker.getSharedProperty("imageBytes");
			_width = worker.getSharedProperty("width");
			_height = worker.getSharedProperty("height");
			
			_imageBytes.position = 0;
			_bitmapData = new BitmapData(_width, _height, false, 0x000000);
			
			_mainToWorker.addEventListener(Event.CHANNEL_MESSAGE, handleMainToWorker);
		}
		
		protected function handleMainToWorker(event:Event):void
		{
			var msg:* = _mainToWorker.receive();
			
			if(msg == "MANDELBROT")
			{
				Model.coloringMode = _mainToWorker.receive();
				_xFrom = _mainToWorker.receive();
				_xTo = _mainToWorker.receive();
				_yFrom = _mainToWorker.receive();
				_yTo = _mainToWorker.receive();
				
				var ix:int = 0;
				var iy:int = 0;
				
				for(ix = 0; ix < _width; ix++)
				{
					_workerToMain.send("MANDELBROT_PROGRESS");
					_workerToMain.send(ix / _width);
					for(iy = 0; iy < _height; iy++)
					{
						var _cx:Number = Util.translateCoords(ix, _width, _xFrom, _xTo);
						var _cy:Number = Util.translateCoords(iy, _height, _yFrom, _yTo);
						
						_bitmapData.setPixel(ix, iy, countPoint(_cx, _cy));
					}
				}
				
				_imageBytes.length = 0;
				_bitmapData.copyPixelsToByteArray(_bitmapData.rect, _imageBytes);
				_workerToMain.send("MANDELBROT_COMPLETE");
				_workerToMain.send(_imageBytes);
			}
		}
		
		private function countPoint(_cx:Number, _cy:Number):uint
		{
			
			var i:int = 0;
			var zx:Number = 0;
			var zy:Number = 0;
			var z2x:Number = 0;
			var z2y:Number = 0;
			var maxIterations:int = 500;
			
			while(zx*zx + zy*zy < 2*2 && i < maxIterations)
			{
				z2x = zx*zx - zy*zy + _cx;
				z2y = 2*zx*zy + _cy;
				if(z2x == zx && z2y == zy)
				{
					i = maxIterations;
					break;
				}
				zx = z2x;
				zy = z2y;
				i++;
			}
			
			return ColoringMode.getColor(i, zx, zy, maxIterations);
		}
	}
}