package
{
	public class Util
	{
		public static function rgbToUint(r:uint, g:uint, b:uint):uint
		{
			return ((r << 16) | (g << 8) | b);
		}
		
		public static function hsvToUint(h:Number, s:Number, v:Number):uint
		{
			var r:Number = 0;
			var g:Number = 0;
			var b:Number = 0;
			
			var tempS:Number = s;
			var tempV:Number = v * 255;
			
			var hi:int = Math.floor(h/60) % 6;
			var f:Number = h/60 - Math.floor(h/60);
			var p:Number = (tempV * (1 - tempS));
			var q:Number = (tempV * (1 - f * tempS));
			var t:Number = (tempV * (1 - (1 - f) * tempS));
			
			switch(hi){
				case 0: r = tempV; g = t; b = p; break;
				case 1: r = q; g = tempV; b = p; break;
				case 2: r = p; g = tempV; b = t; break;
				case 3: r = p; g = q; b = tempV; break;
				case 4: r = t; g = p; b = tempV; break;
				case 5: r = tempV; g = p; b = q; break;
			}
			
			return rgbToUint(Math.ceil(r), Math.ceil(g), Math.ceil(b));
		}
		
		public static function translateCoords(val:Number, oldMax:Number, min:Number, max:Number):Number
		{
			return (val / oldMax) * (max - min) + min;
		}
		
		public static function round(val:Number, dec:Number):Number
		{
			return Math.round(val * dec)/dec;
		}
		
		public static function rndString(strlen:Number):String
		{
			var chars:String = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
			var numChars:Number = chars.length - 1;
			var randomChar:String = "";
			for (var i:Number = 0; i < strlen; i++) randomChar += chars.charAt(Math.floor(Math.random() * numChars));
			return randomChar;
		}

	}
}