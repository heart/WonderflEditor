﻿package  
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import net.wonderfl.editor.WonderflEditor;
	
	/**
	 * @author kobayashi-taro
	 */
	public class WEditor extends Sprite
	{
		[Embed(source = '../assets/btn_smallscreen.jpg')]
		private var _image_out_:Class;
		
		[Embed(source = '../assets/btn_smallscreen_o.jpg')]
		private var _image_over_:Class;
		
		private var _scaleDownButton:Sprite;
		private var _editor:WonderflEditor;
		private var _compileTimer:uint;
		private var _mouseUIFlag:Boolean = false;
		
		public function WEditor() 
		{
			addChild(_editor = new WonderflEditor);
			
			_editor.addEventListener(Event.CHANGE, function ():void {
				_compileTimer = setTimeout(compile, 1500);
			});
			
			_editor.setFontSize(12);
			
			addChild(_scaleDownButton = new Sprite);
			_scaleDownButton.addChild(new _image_out_);
			var bm:Bitmap = new _image_over_;
			bm.visible = false;
			focusRect = null;
			
			_scaleDownButton.addChild(bm);
			_scaleDownButton.buttonMode = true;
			_scaleDownButton.tabEnabled = false;
			_scaleDownButton.addEventListener(MouseEvent.CLICK, function ():void {
				if (ExternalInterface.available) ExternalInterface.call("Wonderfl.Compiler.scale_down");
			});
			_scaleDownButton.addEventListener(MouseEvent.MOUSE_OVER, function ():void {
				bm.visible = true;
			});
			_scaleDownButton.addEventListener(MouseEvent.MOUSE_OUT, function ():void {
				bm.visible = false;
			});
			
			
			
			addEventListener(Event.ADDED_TO_STAGE, init);
			
			if (ExternalInterface.available) ExternalInterface.addCallback("xi_get_code", js_xi_get_code);
		}
		
		private function compile():void
		{
			if (ExternalInterface.available && !_mouseUIFlag) ExternalInterface.call("Wonderfl.Compiler.edit_complete");
		}
		
		private function js_xi_get_code():String
		{
			return encodeURIComponent(_editor.text);
		}
		
		private function init(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.addEventListener(Event.RESIZE, onResize);
			stage.dispatchEvent(new Event(Event.RESIZE));
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, function ():void {
				clearTimeout(_compileTimer);
			});
			stage.addEventListener(MouseEvent.MOUSE_DOWN, function ():void {
				clearTimeout(_compileTimer);
				_mouseUIFlag = true;
			});
			stage.addEventListener(Event.MOUSE_LEAVE, function ():void {
				_mouseUIFlag = false;
			});
			stage.addEventListener(MouseEvent.MOUSE_UP, function ():void {
				_mouseUIFlag = false;
			});
			
			if (ExternalInterface.available) {
				var code:String = ExternalInterface.call("Wonderfl.Compiler.get_initial_code");
				_editor.text = (code) ? code : "";
			}
		}
		
		private function onResize(e:Event):void 
		{
			var w:int = stage.stageWidth;
			var h:int = stage.stageHeight;
			var size:Array;
			if (ExternalInterface.available) {
				size = ExternalInterface.call("Wonderfl.Compiler.get_stage_size");
				if (size) {
					w = size[0];
					h = size[1];
				}
			}
			
			_editor.width = w;
			_editor.height = h;
			_scaleDownButton.x = w - _scaleDownButton.width;
			_scaleDownButton.visible = (w > 465 || h > 465);
		}
	}
}