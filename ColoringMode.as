package
{
	public class ColoringMode
	{
		public static const NORMAL:int = 0;
		public static const BLACK_WHITE:int = 1;
		public static const SMOOTH:int = 2;
		public static const SIN:int = 3;
		
		private static var functions:Array = new Array(getColorNormal, getColorBlackWhite, getColorSmooth, getColorSin);
		
		public static function getColor(i:int, r:Number = 0, c:Number = 0, maxIterations:int = 1000):uint
		{
			var method:Function = functions[Model.coloringMode];
			var color:uint = method(i, r, c, maxIterations);
			return color;
		}
		
		public static function getColorNormal(i:int, r:Number = 0, c:Number = 0, maxIterations:int = 1000):uint
		{
			return Util.rgbToUint(Math.floor(100 * i / maxIterations), Math.floor(255 * i / maxIterations), Math.floor(50 * i / maxIterations));
		}
		
		public static function getColorBlackWhite(i:int, r:Number = 0, c:Number = 0, maxIterations:int = 1000):uint
		{
			if(i == maxIterations) return 0x000000;
			return 0xffffff;
		}
		
		public static function getColorSmooth(i:int, r:Number = 0, c:Number = 0, maxIterations:int = 1000):uint
		{
			var zn:Number;
			var hue:Number;
			
			zn = Math.sqrt(Math.abs(r*r + c*c));
			if(zn == 0) zn += 0.0005;
			hue = i + 1.0 - Math.log(zn) / Math.log(2.0);
			while(hue > 360.0) hue -= 360.0;
			while(hue < 0.0) hue += 360.0;
			return Util.hsvToUint(hue, 0.8, 1);
		}
		
		public static function getColorSin(i:int, r:Number = 0, c:Number = 0, maxIterations:int = 1000):uint
		{
			var mu:Number = i - Math.log( Math.log(r*r + c*c) ) / Math.log(2);
			
			var sin:Number = Math.sin(mu / 1) / 2 + 0.5;
			var cos:Number = Math.cos(mu / 1) / 2 + 0.5;
			
			return Util.rgbToUint(Math.ceil(cos*255), Math.ceil(sin*255), Math.ceil(cos*255));
		}
	}
}