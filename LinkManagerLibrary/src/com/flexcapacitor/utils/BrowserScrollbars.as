





package com.flexcapacitor.utils {
	
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.external.ExternalInterface;
	import flash.geom.Point;
	
	import mx.core.UIComponent;

	public class BrowserScrollbars extends EventDispatcher {			
	
		import mx.events.FlexEvent;
		import mx.core.Application;
		
		// used to set the html body overflow to auto
		// only needs to be called once
		private var ranOnce:Boolean = false;
		
		// read only height of the application
		[Bindable]
		public var applicationHeight:Number = 0;
		
		// read only height of the stage
		[Bindable]
		public var stageHeight:Number = 0;
		
		// read only height of the application the last time the browser window was resized
		[Bindable]
		public var lastApplicationHeight:Number = 0;
		
		// read only height of the stage the last time the browser window was resized
		[Bindable]
		public var lastStageHeight:Number = 0;
		
		// read only of the target height
		[Bindable]
		public var targetHeight:uint = 0;
		
		// we enter a target so that we can base the height of the window (and thus scrollbars) 
		// to the location of a specific component or container
		// so for example, if we have a footer component whose top location is dynamically set based on the content
		// then we can use that to determine the window viewport size of the content plus the footer
		// in that case set the target to the footer component 
		[Bindable]
		public var target:UIComponent;
		
		public function BrowserScrollbars(target:IEventDispatcher=null) {
			super(target);
		}
		
		public function init():void {
			application.addEventListener(FlexEvent.CREATION_COMPLETE, resizeApplication, false, 0, false);
			application.addEventListener(FlexEvent.UPDATE_COMPLETE, resizeApplication, false, 0, false);
			application.verticalScrollPolicy = "off";
		}
		
		public function resizeApplication(event:FlexEvent):void {
			resizeBrowser()
		}
		
		public function resizeBrowser():void {
			
			if (!ranOnce) {
				ExternalInterface.call("eval", "document.body.style.overflow='auto'");
				ranOnce = true;
			}
			
			// what happens if the stage is smaller than the browser view port?
			if (stageHeight <= applicationHeight) {
				// ignore for now
			}
			
			if (target) {
				var point:Point = target.localToGlobal(new Point(0,0));
				targetHeight = point.y + target.height;
			}
			else {
				targetHeight = application.stage.height;
			}
			
			ExternalInterface.call("eval", "document.body.style.height='" + targetHeight + "px'");
			
			// save last height values
			lastApplicationHeight = applicationHeight;
			lastStageHeight = lastStageHeight;
			
			// store current height values
			stageHeight = application.stage.height;
			applicationHeight = application.height;
		}

		public function scrollTo(x:int=0, y:int=0):void {
			ExternalInterface.call("eval", "window.scrollTo(" + x + "," + y + ")");
		}
		
		public function get application():Object {
			return ApplicationUtils.getInstance();
		}
	}
}