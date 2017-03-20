package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.system.MessageChannel;
	import flash.system.Worker;
	import flash.system.WorkerDomain;
	import flash.utils.ByteArray;
	
	[SWF(width="1000", height="700", frameRate="60")]
	public class Main extends Sprite
	{
		protected var _mainToWorker:MessageChannel;
		protected var _workerToMain:MessageChannel;
		
		protected var _worker:Worker;
		
		protected var _imageBytes:ByteArray;
		private var _painting:Painting;
		
		protected var _mandelbrotWorker:MandelbrotWorker;
		
		public static var _instance:Main;
		
		
		public function Main()
		{
			if(Worker.current.isPrimordial)
			{
				_instance = this;
				//stage.displayState = StageDisplayState.FULL_SCREEN; 
				
				_worker = WorkerDomain.current.createWorker(this.loaderInfo.bytes);
				
				_mainToWorker = Worker.current.createMessageChannel(_worker);
				_workerToMain = _worker.createMessageChannel(Worker.current);
				
				_worker.setSharedProperty("mainToWorker", _mainToWorker);
				_worker.setSharedProperty("workerToMain", _workerToMain);
				
				_workerToMain.addEventListener(Event.CHANNEL_MESSAGE, handleWorkerToMain);
				
				_painting = new Mandelbrot(Global.WIDTH, Global.HEIGHT);
				addChild(_painting);
				
				_worker.setSharedProperty("width", _painting._bitmapData.width);
				_worker.setSharedProperty("height", _painting._bitmapData.height);
				
				_imageBytes = new ByteArray();
				_imageBytes.shareable = true;
				_painting._bitmapData.copyPixelsToByteArray(_painting._bitmapData.rect, _imageBytes);
				_worker.setSharedProperty("imageBytes", _imageBytes);
				
				_worker.start();
				
				_painting.draw();
			}
			else
			{
				_mandelbrotWorker = new MandelbrotWorker();
			}
		}
		
		public static function sendToWorker(arg:*):void
		{
			_instance._mainToWorker.send(arg);
		}
		
		protected function handleWorkerToMain(event:Event):void
		{
			var msg:* = _workerToMain.receive();
			if(msg == "MANDELBROT_COMPLETE")
			{
				_imageBytes = _workerToMain.receive();
				_imageBytes.position = 0;
				_painting.setPixels(_imageBytes);
				_painting.setProgress(1);
			}
			if(msg == "MANDELBROT_PROGRESS")
			{
				var progress:Number = _workerToMain.receive();
				_painting.setProgress(progress);
			}
		}
		
	}
}