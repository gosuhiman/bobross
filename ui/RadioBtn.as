package ui
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class RadioBtn extends Sprite
	{
		private var _radioBtn:Sprite = new Sprite();
		private var _tf:TextField = new TextField();
		
		private var _index:int;
		private var _width:int;
		private var _height:int;
		
		private var _format:TextFormat;
		
		private var _selected:Boolean;
		
		private var _selection:Sprite;
		
		private var _selectCallback:Function;
		
		[Embed(source="../../assets/fonts/OpenSans-Regular.ttf", fontFamily="OpenSans", fontName = "OpenSansRegular", mimeType = "application/x-font", fontWeight="normal", fontStyle="normal", embedAsCFF="false")]
		private var OpenSansRegularFont:Class;
		
		public function RadioBtn(label:String, width:int, height:int, index:int, selectCallback:Function)
		{
			_width = width;
			_height = height;
			_index = index;
			_selectCallback = selectCallback;
			
			_format = new TextFormat();
			_format.size = 14;
			_format.font = "OpenSansRegular";
			
			_tf.embedFonts = true;
			_tf.defaultTextFormat = _format;
			_tf.antiAliasType = AntiAliasType.ADVANCED;
			_tf.text = label;
			_tf.textColor = 0xffffff;
			_tf.selectable = false;
			_tf.width = width;
			_tf.height = height;
			_tf.x = 20;
			
			_selection = new Sprite();
			_selection.graphics.beginFill(0xffffff);
			_selection.graphics.drawRect(0, 0, 10, 10);
			_selection.graphics.endFill();
			_selection.x = 5;
			_selection.y = 5;
			_selection.alpha = 0;
			
			_selected = Model.coloringMode == _index;
			
			if(_selected)
			{
				_selection.alpha = 1;
			}
			
			addChild(_tf);
			addChild(_selection);
			
			addEventListener(MouseEvent.CLICK, handleClick);
		}
		
		private function handleClick(e:MouseEvent):void
		{
			e.stopPropagation(); 
			
			Model.coloringMode = _index;
			_selectCallback();
		}
		
		public function updateSelection():void
		{
			if(_index == Model.coloringMode)
			{
				_selected = true;
				_selection.alpha = 1;
			}
			else
			{
				_selected = false;
				_selection.alpha = 0;
			}
		}
	}
}