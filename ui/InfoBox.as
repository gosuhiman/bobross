package ui
{
	import flash.display.Sprite;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class InfoBox extends Sprite
	{
		private var _width:int;
		private var _height:int;
		
		private var _textField:TextField;
		private var _format:TextFormat;
		
		[Embed(source="../../assets/fonts/OpenSans-Regular.ttf", fontFamily="OpenSans", fontName = "OpenSansRegular", mimeType = "application/x-font", fontWeight="normal", fontStyle="normal", embedAsCFF="false")]
		private var OpenSansRegularFont:Class;
		
		
		public function InfoBox(width:int, height:int)
		{
			_width = width;
			_height = height;
			
			graphics.beginFill(0x000000, 0.2);
			graphics.drawRect(0, 0, _width, _height);
			graphics.endFill();
			
			_format = new TextFormat();
			_format.size = 14;
			_format.font = "OpenSansRegular";
			
			_textField = new TextField();
			_textField.embedFonts = true;
			_textField.defaultTextFormat = _format;
			_textField.antiAliasType = AntiAliasType.ADVANCED;
			_textField.text = "";
			_textField.textColor = 0xffffff;
			_textField.selectable = false;
			_textField.width = _width;
			_textField.height = _height;
			_textField.y = 2;
			
			addChild(_textField);
		}
		
		public function set text(text:String):void
		{
			_textField.text = text;
		}
		
		public function get text():String
		{
			return _textField.text;
		}
	}
}