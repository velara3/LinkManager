package net.flashdan.containers {
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import mx.events.SandboxMouseEvent;
	import mx.managers.CursorManager;
	
	import net.flashdan.containers.events.FlexibleWindowBoundsEvent;
	
	import spark.components.Button;
	import spark.components.TitleWindow;
	import spark.events.TitleWindowBoundsEvent;
	
	[Event(name="windowResizeStart", type="net.flashdan.containers.events.FlexibleWindowBoundsEvent")]
	[Event(name="windowResizing", type="net.flashdan.containers.events.FlexibleWindowBoundsEvent")]
	[Event(name="windowResize", type="net.flashdan.containers.customtitlewindow.TitleWindowBoundsEvent")]
	[Event(name="windowResizeEnd", type="net.flashdan.containers.events.FlexibleWindowBoundsEvent")]
	
	[Style(name="edgeHandleSize", type="Number", inherit="no")]
	[Style(name="cornerHandleSize", type="Number", inherit="no")]
	
	[Style(name="resizeCursorHorizontalSkin", type="Class", inherit="no")]
	[Style(name="resizeCursorHorizontalXOffset", type="Number", inherit="no")]
	[Style(name="resizeCursorHorizontalYOffset", type="Number", inherit="no")]
	
	[Style(name="resizeCursorVerticalSkin", type="Class", inherit="no")]
	[Style(name="resizeCursorVerticalXOffset", type="Number", inherit="no")]
	[Style(name="resizeCursorVerticalYOffset", type="Number", inherit="no")]
	
	[Style(name="resizeCursorTopLeftBottomRightSkin", type="Class", inherit="no")]
	[Style(name="resizeCursorTopLeftBottomRightXOffset", type="Number", inherit="no")]
	[Style(name="resizeCursorTopLeftBottomRightYOffset", type="Number", inherit="no")]
	
	[Style(name="resizeCursorTopRightBottomLeftSkin", type="Class", inherit="no")]
	[Style(name="resizeCursorTopRightBottomLeftXOffset", type="Number", inherit="no")]
	[Style(name="resizeCursorTopRightBottomLeftYOffset", type="Number", inherit="no")]
	
	public class FlexibleWindow extends TitleWindow {
		
		//Resize handle constants
		public static const LEFT:String 				= "left";
		public static const RIGHT:String 				= "right";
		public static const TOP:String 					= "top";
		public static const BOTTOM:String 				= "bottom";
		public static const TOP_LEFT:String 			= "topLeft";
		public static const TOP_RIGHT:String 			= "topRight";
		public static const BOTTOM_LEFT:String 			= "bottomLeft";
		public static const BOTTOM_RIGHT:String 		= "bottomRight";
		
		[SkinPart(required="false")]
		public var resizeHandleTop:Button;
		
		[SkinPart(required="false")]
		public var resizeHandleRight:Button;
		
		[SkinPart(required="false")]
		public var resizeHandleBottom:Button;
		
		[SkinPart(required="false")]
		public var resizeHandleLeft:Button;
		
		[SkinPart(required="false")]
		public var resizeHandleTL:Button;
		
		[SkinPart(required="false")]
		public var resizeHandleTR:Button;
		
		[SkinPart(required="false")]
		public var resizeHandleBR:Button;
		
		[SkinPart(required="false")]
		public var resizeHandleBL:Button;
		
		public var resizeEnabled:Boolean = true;
		public var currentResizeHandle:String;
		public var savedWindowRect:Rectangle;
		public var startResizeBounds:Rectangle;
		private var dragMaxX:Number;
		private var dragMaxY:Number;
		private var dragAmountX:Number;
		private var dragAmountY:Number;
		private var dragStartMouseX:Number;
		private var dragStartMouseY:Number;
		
		public function FlexibleWindow() {
			super();
			enforceBoundaries = true; //default enforceBoundaries to true
		}
		
		private var _enforceBoundaries:Boolean = false;
		public function set enforceBoundaries(value:Boolean):void {
			if(_enforceBoundaries != value){
				_enforceBoundaries = value;
				if(_enforceBoundaries){
					addEventListener(TitleWindowBoundsEvent.WINDOW_MOVING, onTitleWindowMoving);
				}
				else {
					removeEventListener(TitleWindowBoundsEvent.WINDOW_MOVING, onTitleWindowMoving);
				}
			}
		}
		public function get enforceBoundaries():Boolean {
			return _enforceBoundaries;
		}
		
		private var _moveEnabled:Boolean = true;
		public function set moveEnabled(val:Boolean):void {
			if(_moveEnabled != val){
				_moveEnabled = val;
				if(_moveEnabled){
					//remove listener
					removeEventListener(TitleWindowBoundsEvent.WINDOW_MOVE_START, onTitleWindowMoveStart);
				}
				else {
					//add listener so we can intercept move event
					addEventListener(TitleWindowBoundsEvent.WINDOW_MOVE_START, onTitleWindowMoveStart);
				}
				
			}
		}
		public function get moveEnabled():Boolean {
			return _moveEnabled;
		}
		
		protected function onTitleWindowMoveStart(event:TitleWindowBoundsEvent):void {
			if(!moveEnabled){
				event.preventDefault(); //cancel the move
			}
		}
		
		protected function onTitleWindowMoving(event:TitleWindowBoundsEvent):void {
			if(enforceBoundaries){//TODO:probably remove this if statement since this handler only gets added when it is true.
				if (event.afterBounds.left < 0) {
					event.afterBounds.left = 0;
				} else if (event.afterBounds.right > systemManager.stage.stageWidth) {
					event.afterBounds.left = Math.max(0,systemManager.stage.stageWidth - event.afterBounds.width);
				}
				if (event.afterBounds.top < 0) {
					event.afterBounds.top = 0;
				} else if (event.afterBounds.bottom > systemManager.stage.stageHeight) {
					event.afterBounds.top = Math.max(0,systemManager.stage.stageHeight - event.afterBounds.height);
				}
			}
		}
		
		protected function resizeHandle_mouseDownHandler(event:MouseEvent):void {
			if(resizeEnabled && enabled){
				currentResizeHandle = resizeHandleForButton(event.target as Button);
				setCursor(currentResizeHandle);
				dragStartMouseX = event.stageX;
				dragStartMouseY = event.stageY;
				savePanel();
				dragMaxX = savedWindowRect.x + (savedWindowRect.width - minWidth);
				dragMaxY = savedWindowRect.y + (savedWindowRect.height - minHeight);
			
				var sbRoot:DisplayObject = systemManager.getSandboxRoot();
				
				sbRoot.addEventListener(
					MouseEvent.MOUSE_MOVE, resizeHandle_mouseMoveHandler, true);
				sbRoot.addEventListener(
					MouseEvent.MOUSE_UP, resizeHandle_mouseUpHandler, true);
				sbRoot.addEventListener(
					SandboxMouseEvent.MOUSE_UP_SOMEWHERE, resizeHandle_mouseUpHandler)
				
				// add the mouse shield so we can drag over untrusted applications.
				systemManager.deployMouseShields(true);
			}
		}
		
		protected function resizeHandle_mouseMoveHandler(event:MouseEvent):void {
			
			// Check to see if this is the first windowResize
			if (!startResizeBounds){
				// First dispatch a cancellable "windowResizeStart" event
				startResizeBounds = new Rectangle(x, y, width, height);
				var startEvent:FlexibleWindowBoundsEvent = new FlexibleWindowBoundsEvent(FlexibleWindowBoundsEvent.WINDOW_RESIZE_START, false, true, startResizeBounds, null);
				dispatchEvent(startEvent);
				
				if (startEvent.isDefaultPrevented()){
					// Clean up code if entire resize is canceled.
					var sbRoot:DisplayObject = systemManager.getSandboxRoot();
					
					sbRoot.removeEventListener(
						MouseEvent.MOUSE_MOVE, resizeHandle_mouseMoveHandler, true);
					sbRoot.removeEventListener(
						MouseEvent.MOUSE_UP, resizeHandle_mouseUpHandler, true);
					sbRoot.removeEventListener(
						SandboxMouseEvent.MOUSE_UP_SOMEWHERE, resizeHandle_mouseUpHandler);
					
					systemManager.deployMouseShields(false);
					
					startResizeBounds = null;
					currentResizeHandle = null;
					CursorManager.removeCursor(CursorManager.currentCursorID);
					return;
				}
			}
			
			//windowResizeStart event was not canceled, so go ahead and start resizing
			dragAmountX = event.stageX - dragStartMouseX;
			dragAmountY = event.stageY - dragStartMouseY;
			
			var beforeBounds:Rectangle = new Rectangle(x, y, width, height);
			var afterBounds:Rectangle = new Rectangle(x, y, width, height);
			
			if(currentResizeHandle == TOP && event.stageY > 0) {
				afterBounds.y = Math.min(savedWindowRect.y + dragAmountY, dragMaxY);
				afterBounds.height = Math.max(savedWindowRect.height - dragAmountY, minHeight);
			}
			else if(currentResizeHandle == RIGHT && event.stageX < systemManager.stage.stageWidth) {
				afterBounds.width = Math.max(savedWindowRect.width + dragAmountX, minWidth);
			}
			else if(currentResizeHandle == BOTTOM && event.stageY < systemManager.stage.stageHeight) {
				afterBounds.height = Math.max(savedWindowRect.height + dragAmountY, minHeight);
			}
			else if(currentResizeHandle == LEFT && event.stageX > 0) {
				afterBounds.x = Math.min(savedWindowRect.x + dragAmountX, dragMaxX);
				afterBounds.width = Math.max(savedWindowRect.width - dragAmountX, minWidth);
			}
			else if(currentResizeHandle == TOP_LEFT && event.stageX > 0 && event.stageY > 0) {
				afterBounds.x = Math.min(savedWindowRect.x + dragAmountX, dragMaxX);
				afterBounds.y = Math.min(savedWindowRect.y + dragAmountY, dragMaxY);
				afterBounds.width = Math.max(savedWindowRect.width - dragAmountX, minWidth);
				afterBounds.height = Math.max(savedWindowRect.height - dragAmountY, minHeight);
			}
			else if(currentResizeHandle == TOP_RIGHT && event.stageX < systemManager.stage.stageWidth && event.stageY > 0) {
				afterBounds.y = Math.min(savedWindowRect.y + dragAmountY, dragMaxY);
				afterBounds.width = Math.max(savedWindowRect.width + dragAmountX, minWidth);
				afterBounds.height = Math.max(savedWindowRect.height - dragAmountY, minHeight);
			}
			else if(currentResizeHandle == BOTTOM_RIGHT && event.stageX < systemManager.stage.stageWidth && event.stageY < systemManager.stage.stageHeight) {
				afterBounds.width = Math.max(savedWindowRect.width + dragAmountX, minWidth);
				afterBounds.height = Math.max(savedWindowRect.height + dragAmountY, minHeight);
			}
			else if(currentResizeHandle == BOTTOM_LEFT && event.stageX > 0 && event.stageY < systemManager.stage.stageHeight) {
				afterBounds.x = Math.min(savedWindowRect.x + dragAmountX, dragMaxX);
				afterBounds.width = Math.max(savedWindowRect.width - dragAmountX, minWidth);
				afterBounds.height = Math.max(savedWindowRect.height + dragAmountY, minHeight);
			}
			
			var e1:FlexibleWindowBoundsEvent = new FlexibleWindowBoundsEvent(FlexibleWindowBoundsEvent.WINDOW_RESIZING,	false, true, beforeBounds, afterBounds);
			dispatchEvent(e1);
			
			// Move and resize only if the windowResizing event is not canceled.
			if (!(e1.isDefaultPrevented())){
				moveAndResize(afterBounds.x,afterBounds.y, afterBounds.width, afterBounds.height);
			}
			
			event.updateAfterEvent();
		}
		
		protected function moveAndResize(xVal:Number, yVal:Number, widthVal:Number, heightVal:Number):void {
			var beforeBounds:Rectangle = new Rectangle(x, y, width, height);
			
			width = widthVal;
			height = heightVal;
			//call validateNow, the window resize appears jerky/choppy without it.
			validateNow();
			x = xVal;
			y = yVal;
			
			var afterBounds:Rectangle = new Rectangle(x, y, width, height);
			var e2:FlexibleWindowBoundsEvent = new FlexibleWindowBoundsEvent(FlexibleWindowBoundsEvent.WINDOW_RESIZE, false, false, beforeBounds, afterBounds);
			
			dispatchEvent(e2);
		}
		
		protected function resizeHandle_mouseUpHandler(event:Event):void {
			var sbRoot:DisplayObject = systemManager.getSandboxRoot();
			
			sbRoot.removeEventListener(
				MouseEvent.MOUSE_MOVE, resizeHandle_mouseMoveHandler, true);
			sbRoot.removeEventListener(
				MouseEvent.MOUSE_UP, resizeHandle_mouseUpHandler, true);
			sbRoot.removeEventListener(
				SandboxMouseEvent.MOUSE_UP_SOMEWHERE, resizeHandle_mouseUpHandler);
			
			systemManager.deployMouseShields(false);
			
			currentResizeHandle = null;
			
			// Check to see that a resize actually occurred and that the
			// user did not just click on a resize handle
			if (startResizeBounds) {
				// Dispatch "windowResizeEnd" event with the starting bounds and current bounds.
				var endEvent:FlexibleWindowBoundsEvent =
					new FlexibleWindowBoundsEvent(FlexibleWindowBoundsEvent.WINDOW_RESIZE_END,
						false, false, startResizeBounds,
						new Rectangle(x, y, width, height));
				dispatchEvent(endEvent);
				startResizeBounds = null;
				CursorManager.removeCursor(CursorManager.currentCursorID);
			}
			
		}
		
		protected function resizeHandle_mouseRollOverHandler(event:MouseEvent):void {
			if(resizeEnabled && !event.buttonDown){
				setCursor(resizeHandleForButton(event.target as Button));
			}
		}
		
		protected function resizeHandle_mouseRollOutHandler(event:MouseEvent):void {
			if(!event.buttonDown) {
				CursorManager.removeCursor(CursorManager.currentCursorID);
			}
		}
		
		override protected function partAdded(partName:String, instance:Object):void {
			super.partAdded(partName, instance);
			
			if(instance == resizeHandleTop || instance == resizeHandleRight 
				|| instance == resizeHandleBottom || instance == resizeHandleLeft
				|| instance == resizeHandleTL || instance == resizeHandleTR
				|| instance == resizeHandleBR || instance == resizeHandleBL) {
				
				Button(instance).addEventListener(MouseEvent.ROLL_OVER, resizeHandle_mouseRollOverHandler);
				Button(instance).addEventListener(MouseEvent.ROLL_OUT, resizeHandle_mouseRollOutHandler);
				Button(instance).addEventListener(MouseEvent.MOUSE_DOWN, resizeHandle_mouseDownHandler);
			}
		}
		
		override protected function partRemoved(partName:String, instance:Object):void {
			super.partRemoved(partName, instance);
			
			if(instance == resizeHandleTop || instance == resizeHandleRight 
				|| instance == resizeHandleBottom || instance == resizeHandleLeft
				|| instance == resizeHandleTL || instance == resizeHandleTR
				|| instance == resizeHandleBR || instance == resizeHandleBL) {
				
				Button(instance).removeEventListener(MouseEvent.ROLL_OVER, resizeHandle_mouseRollOverHandler);
				Button(instance).removeEventListener(MouseEvent.ROLL_OUT, resizeHandle_mouseRollOutHandler);
				Button(instance).removeEventListener(MouseEvent.MOUSE_DOWN, resizeHandle_mouseDownHandler);
			}
			
		}
		
		protected function savePanel():void {
			savedWindowRect = new Rectangle(x, y, width, height);
		}
		
		private function setCursor(resizeHandle:String):void {
			var styleStub:String;
			
			switch(resizeHandle) {
				case RIGHT:
				case LEFT:
					styleStub = "resizeCursorHorizontal";
					break;
				case TOP:
				case BOTTOM:
					styleStub = "resizeCursorVertical";
					break;
				case TOP_LEFT:
				case BOTTOM_RIGHT:
					styleStub = "resizeCursorTopLeftBottomRight";
					break;
				case TOP_RIGHT:
				case BOTTOM_LEFT:
					styleStub = "resizeCursorTopRightBottomLeft";
					break;
			}
			
			CursorManager.removeCursor(CursorManager.currentCursorID);
			CursorManager.setCursor(Class(this.getStyle(styleStub+"Skin")),
				2,
				Number(getStyle(styleStub+"XOffset")),
				Number(getStyle(styleStub+"YOffset")));
		}
		
		private function resizeHandleForButton(button:Button):String {
			if(button == resizeHandleLeft)
				return LEFT;
			else if(button == resizeHandleRight)
				return RIGHT;
			else if(button == resizeHandleTop)
				return TOP;
			else if(button == resizeHandleBottom)
				return BOTTOM;
			else if(button == resizeHandleTL)
				return TOP_LEFT;
			else if(button == resizeHandleTR)
				return TOP_RIGHT;
			else if(button == resizeHandleBL)
				return BOTTOM_LEFT;
			else if(button == resizeHandleBR)
				return BOTTOM_RIGHT;
			else
				return null;
		}
	}
}