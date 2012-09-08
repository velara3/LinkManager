





package com.flexcapacitor.utils {
	import flash.events.MouseEvent;
	
	import spark.components.Group;

	public class ResizeManager {

		public var resizeGroup:Group;
		
		private var _target:Object;
		
		[Bindable]
		public function set target(value:Object):void {
			_target = value;
			
			if (value==null) return;
			resizeGroup = new Group();
			resizeGroup.mouseEnabledWhereTransparent = true;
			resizeGroup.right = 0;
			resizeGroup.bottom = 0;
			resizeGroup.addEventListener(MouseEvent.MOUSE_DOWN, startResize, false, 0, true);
			_target.addChild(resizeGroup);
		}
		
		public function get target():Object {
			return _target;
		}
		

		public function ResizeManager() {

		}

		private function startResize(event:MouseEvent=null):void {
			if (_target && _target.stage) {
			_target.stage.addEventListener(MouseEvent.MOUSE_MOVE, resize, false, 0, true);
			_target.stage.addEventListener(MouseEvent.MOUSE_UP, stopResize, false, 0, true);
			resizeGroup.addEventListener(MouseEvent.MOUSE_UP, stopResize, false, 0, true);
			resizeGroup.startDrag();
			}
		}

		private function stopResize(mouseEvent:MouseEvent):void {
			resizeGroup.removeEventListener(MouseEvent.MOUSE_UP, stopResize);
			_target.stage.removeEventListener(MouseEvent.MOUSE_MOVE, resize);
			_target.stage.removeEventListener(MouseEvent.MOUSE_UP, stopResize);
			resizeGroup.stopDrag();
		}

		private function resize(mouseEvent:MouseEvent):void {
			if (_target && target.parent) {
				target.height = target.parent.mouseY;
				target.width = target.parent.mouseX;
			}
		}
	}
}