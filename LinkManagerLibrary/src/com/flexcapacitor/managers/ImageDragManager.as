




package com.flexcapacitor.managers {
	
	import com.flexcapacitor.utils.ApplicationUtils;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.IBitmapDrawable;
	import flash.display.InteractiveObject;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.FileReference;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.utils.ByteArray;
	
	import mx.controls.Alert;
	import mx.controls.Image;
	import mx.core.Application;
	import mx.core.Container;
	import mx.core.DragSource;
	import mx.core.FlexLoader;
	import mx.core.IUIComponent;
	import mx.core.UIComponent;
	import mx.core.UITextField;
	import mx.events.CloseEvent;
	import mx.events.DragEvent;
	import mx.events.FlexEvent;
	import mx.managers.DragManager;
	
	public class ImageDragManager extends EventDispatcher {
		
		public static var instance:ImageDragManager;
		
		public var dragThreshold:int = 10;
		
		public var isDragging:Boolean = false;
		
		private var mouseCaptureUpEvent:Boolean = false;
		
		public var dragProxy:Image;
		
		public var startX:int = 0;
		public var startY:int = 0;
		
		public var contentWidth:int = 0;
		public var contentHeight:int = 0;
		
		public var preventDragAndDrop:Boolean = false;
		
		private static var created:Boolean;
		
		public var stage:Stage;
		
		public var currentTarget:InteractiveObject;
		
		public var source:Object;
		
		public var correctMouseButtonBehavior:Boolean = true;
		
		public var alertVisible:Boolean = false;
		
		public function ImageDragManager(target:IEventDispatcher=null) {
			super(target);
			application.addEventListener(FlexEvent.APPLICATION_COMPLETE, applicationComplete, false, 0, true);
			instance = this;
		}
		
		private function applicationComplete(event:Event):void {
			application.removeEventListener(FlexEvent.APPLICATION_COMPLETE, applicationComplete);
			stage = application.stage;
			stage.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown, false, 0, true);
			instance = this;
		}
		
		/**
		 * Returns the one single instance of this class
		 */
		public static function getInstance():ImageDragManager {

			if (instance == null) {
				created = true;
				instance = new ImageDragManager();
			}
			
			return instance;
		}
		
		public function get application():Object {
			return ApplicationUtils.getInstance();
		}
		
		
		public function mouseDown(event:MouseEvent):void {
			if (preventDragAndDrop) return;
			
			currentTarget = InteractiveObject(event.target);
			
			if (currentTarget is TextField) {
				return;
			}
			
			// if the file is on a remote server we can't show a preview
			// exit for now
			try {
				if (currentTarget.hasOwnProperty("childAllowsParent") && !Object(currentTarget).childAllowsParent) {
					return;
				}
				
			}
			catch (event:Event) {
			}
			
			// get item the mouse is over
			// since the item the mouse is over by our stage listener could have another value check it 
			if (event.target!=null && !(event.target is MovieClip)) {
				currentTarget = InteractiveObject(event.target);
				if (currentTarget && currentTarget.hasOwnProperty("source")) {
					source = Image(currentTarget).source.toString();
					contentWidth = Image(currentTarget).contentWidth;
					contentHeight = Image(currentTarget).contentHeight;
				}
			}
			
			// check for images
			if (currentTarget is FlexLoader && currentTarget.parent) {
				currentTarget = currentTarget.parent;
				if (currentTarget.hasOwnProperty("source")) {
					source = Image(currentTarget).source.toString();
					contentWidth = Image(currentTarget).contentWidth;
					contentHeight = Image(currentTarget).contentHeight;
				}
			}
			
			// check for embedded images
			if (currentTarget is Loader) {
				
				if (currentTarget.hasOwnProperty("contentLoaderInfo")) {
					source = Loader(currentTarget).contentLoaderInfo.url.toString();
					contentWidth = Loader(currentTarget).contentLoaderInfo.width;
					contentHeight = Loader(currentTarget).contentLoaderInfo.height;
				}
			}
			
			startX = event.stageX;
			startY = event.stageY;
			
			stage.addEventListener(MouseEvent.MOUSE_MOVE, drag);
			currentTarget.addEventListener(MouseEvent.MOUSE_UP, targetMouseUp);
			
		}
		
		public function drag(event:MouseEvent):void {
			
			var currentX:int = event.stageX;
			var currentY:int = event.stageY;
			
			
			if (isDragging==false && 
				(Point.distance(new Point(currentX, currentY), new Point(startX, startY)) > dragThreshold)) {
				
				// Get the drag initiator component from the event object.
				var dragInitiator:IUIComponent = currentTarget as Image;
				
				if (dragInitiator==null && currentTarget is Loader && currentTarget.hasOwnProperty("parent") && 
					currentTarget.parent is UITextField) {
					dragInitiator = IUIComponent(currentTarget.parent);
					//dragInitiator.mask.width = dragInitiator.width;
					//dragInitiator.mask.height = dragInitiator.height;
					// TODO: add a temporary UIComponent to the stage at the same location and size and use that as the dragInitiator
					//dragInitiator = IUIComponent(event.currentTarget);
					var newUIProxy:UIComponent = new UIComponent();
					newUIProxy.width = contentWidth;
					newUIProxy.height = 400;
					newUIProxy.x = Loader(currentTarget).localToGlobal(new Point(0,0)).x;
					newUIProxy.y = Loader(currentTarget).localToGlobal(new Point(0,0)).y;
					newUIProxy.includeInLayout = false;
					//FlexGlobals.topLevelApplication.addChild(newUIProxy);
					//dragInitiator = newUIProxy;
					//removeListeners();
					//cleanUp();
					//return;
				}
				else if (dragInitiator==null) {
					removeListeners();
					cleanUp();
					return;
				}
				
				// Create a copy of the coin image to use as a drag proxy.
				dragProxy = new Image();
				
				// the following line doesn't work unless the image is embedded
				//dragProxy.source = event.currentTarget.source;
				// line that does work:
				dragProxy.source = new Bitmap(getBitmapData(currentTarget));
				
				
				// Create a DragSource object.
				var dragSource:DragSource = new DragSource();
				
				DragManager.showFeedback(DragManager.COPY);
				
				// Call the DragManager doDrag() method to start the drag. 
				DragManager.doDrag(dragInitiator, dragSource, event, dragProxy);
				
				//addEventListener(MouseEvent.MOUSE_MOVE, drag, false, 0, true);
				stage.addEventListener(Event.MOUSE_LEAVE, mouseLeave, false, 0, true);
				stage.addEventListener(MouseEvent.MOUSE_UP, stageMouseUp, false, 0, true);
				stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpCapture, true, 0, true);
				//FlexGlobals.topLevelApplication.addEventListener(DragEvent.DRAG_OVER, stageDragOver, true, 0, true);
				
				isDragging = true;
				mouseCaptureUpEvent = false;
			}
		}
		
		public function stageDragOver(event:DragEvent):void {
			DragManager.showFeedback(DragManager.COPY);

		}
		
		public function mouseUpCapture(event:Event):void {
			//trace("MOUSE UP CAPTURE");
			mouseCaptureUpEvent = true;
		}
		
		public function targetMouseUp(event:Event):void {
			//trace("TARGET MOUSE UP");
			if (alertVisible) return;
			
			// how to check if we are outside of the browser when this happens
			// on mac we can use the mouse leave event 
			// on pc we listen to stage mouse up when there has been no mouse up during capture phase
			if (isDragging && mouseCaptureUpEvent) {
				promptAlert();
			}
			else {
				cleanUp();
			}
			
			removeListeners();
			
			if (!isDragging) {
				
			}
			isDragging = false;
			
		}
		
		public function stageMouseUp(event:Event):void {
			//trace("STAGE MOUSE UP");
			
			removeListeners();
			
			if (!isDragging) {
				
			}
			else {
				// how to check if we are outside of the browser when this happens
				// on mac we can use the mouse leave event 
				// on pc we listen to stage mouse up when there has been no mouse up during capture phase
				if (!mouseCaptureUpEvent) {
					promptAlert();
				}
				else {
					cleanUp();
				}
			}
			
			cleanUp();
			mouseCaptureUpEvent = false;
		}
		
		public function mouseLeave(event:Event):void {
			
			// it seems this event is called on mac and not on windows and
			// mouse up is called on windows but not on mac
			//trace("MOUSE LEAVE");
			
			if (isDragging) {
				promptAlert();
			}
			else {
				cleanUp();
			}
			
			removeListeners();
			
			isDragging = false;
			
		}
		
		public function removeListeners():void {
			isDragging = false;
			
			stage.removeEventListener(MouseEvent.MOUSE_UP, stageMouseUp);
			stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUpCapture, true);
			stage.removeEventListener(Event.MOUSE_LEAVE, mouseLeave);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, drag);
			if (currentTarget!=null) {
				currentTarget.removeEventListener(MouseEvent.MOUSE_MOVE, drag);
				currentTarget.removeEventListener(MouseEvent.MOUSE_UP, targetMouseUp);
			}
		}
		
		public function promptAlert():void {
			
			var message:String = "Certain actions can only be invoked by a mouse click or button press. ";
			message += "\n\nTo save, click the Save button below";
			
			var okLabel:String = Alert.okLabel = "Save";
			
			// we display an alert because we can't prompt the download without a click event
			Alert.show(message, "Save Image", Alert.OK | Alert.CANCEL, Sprite(application), saveAlertHandler);
			
			Alert.okLabel = okLabel;
			alertVisible = true;
		}
		
		// save the image
		public function saveAlertHandler(event:CloseEvent):void {
			//var source:Object = Object(currentTarget).hasOwnProperty("source") ? Object(currentTarget).source : null;
			
			isDragging = false;
			alertVisible = false;
			
			if (event.detail==Alert.OK) {
				
				// FOR REFERENCED IMAGES
				// Error: Error #2176: Certain actions, such as those that display a pop-up window, 
				// may only be invoked upon user interaction, for example by a mouse click or button press.
				// at flash.net::FileReference/download()
				if (source is String) {
					var request:URLRequest = new URLRequest(String(source));
					var fileReference:FileReference = new FileReference();
					
					try {
						fileReference.save(request);
					}
					catch(event:ErrorEvent) {
						Alert.show(event.toString());
					}
					
				}
				else if (source is Bitmap) {
					
					// exit for now until we can do some testing
					return;
					
					// FOR EMBEDDED IMAGES
					// We are using James Ward's method here because of the security error above
					// if we can change this behavior in the Flash Player we don't need this
					var contentByteArray:ByteArray = new ByteArray();
					content.loaderInfo.bytes.readBytes(contentByteArray, 0, (content.loaderInfo.bytes.length - 17));
					contentByteArray.position = 49;
					
					var newByteArray:ByteArray = new ByteArray();
					while (contentByteArray.bytesAvailable) {
						newByteArray.writeByte(contentByteArray.readUnsignedByte());
					}
					
					try {
						// You are publishing to Flash Player 9
						// Go to Project > Properties > Flex Compiler > Flash Player 10.1 or higher
						if (Object(fileReference).hasOwnProperty("save")) {
							Object(fileReference).save(newByteArray, source.toString());
						}
						else {
							Alert.show("Please upgrade to Flash Player 10 or higher","Cannot save image...");
						}
					}
					catch(event:ErrorEvent) {
						Alert.show(event.toString());
					}
				}
			}
			
			// remove references
			cleanUp();
			if (correctMouseButtonBehavior) {
				resetMouse();
			}
		}
		
		// credits to andrew trice
		public function getBitmapData(target:Object):BitmapData { 
			var bitmapData:BitmapData = new BitmapData(target.width, target.height);
			var matrix:Matrix = new Matrix();
			
			// the next line can cause a security error when dragging images from different domains
			// SecurityError: Error #2122: Security sandbox violation: BitmapData.draw: http://localhost/FlashSite4.swf cannot access http://www.google.com/intl/en_ALL/images/logo.gif. 
			// A policy file is required, but the checkPolicyFile flag was not set when this media was loaded.
			if (target.hasOwnProperty("contentLoaderInfo") && target.contentLoaderInfo.sameDomain) {
				bitmapData.draw(IBitmapDrawable(target), matrix);
			}
			else {
				return bitmapData;
			}
			return bitmapData;
		}
		
		public function cleanUp():void {
			if (alertVisible) return;
			if (currentTarget!=null) {
				currentTarget.removeEventListener(MouseEvent.MOUSE_MOVE, drag);
				currentTarget.removeEventListener(MouseEvent.MOUSE_UP, targetMouseUp);
			}
			source = null;
			currentTarget = null;
			isDragging = false;
			mouseCaptureUpEvent = false;
			
		}
		
		
		// Bug with snow leopard that messes up mouse interaction 
		// trying to fix it here but it doesn't work
		public function resetMouse():void {
			ExternalInterface.call("eval", "window.document[\"" + ExternalInterface.objectID + "\"].style.visibility=\"hidden\"");
			ExternalInterface.call("eval", "try {window.document[\"" + ExternalInterface.objectID + "\"].style.visibility=\"visible\"}catch(e){}");
		}
		
	}
}