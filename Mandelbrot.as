package
{
	public class Mandelbrot extends Painting
	{
		public function Mandelbrot(width:int, height:int)
		{
			super(width, height);
		}
		
		override public function draw():void
		{
			super.draw();
			Main.sendToWorker("MANDELBROT");
			Main.sendToWorker(Model.coloringMode);
			Main.sendToWorker(_xFrom);
			Main.sendToWorker(_xTo);
			Main.sendToWorker(_yFrom);
			Main.sendToWorker(_yTo);
		}
		
		override protected function setDefaultZoom():void
		{
			_xFrom = -2.5;
			_xTo = 1;
			_yFrom = -1;
			_yTo = 1;
		}
	}
}