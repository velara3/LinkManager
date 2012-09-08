
package net.flashdan.containers.events {
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	import spark.events.TitleWindowBoundsEvent;
	
	public class FlexibleWindowBoundsEvent extends TitleWindowBoundsEvent {
		
		public static const WINDOW_RESIZE_START:String 			= "windowResizeStart";
		public static const WINDOW_RESIZING:String 				= "windowResizing";
		public static const WINDOW_RESIZE:String 				= "windowResize";
		public static const WINDOW_RESIZE_END:String 			= "windowResizeEnd";
		
		public function FlexibleWindowBoundsEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false, beforeBounds:Rectangle=null, afterBounds:Rectangle=null) {
			super(type, bubbles, cancelable, beforeBounds, afterBounds);
		}
		
		override public function clone():Event {
			return new FlexibleWindowBoundsEvent(type, bubbles, cancelable, beforeBounds, afterBounds);
		}
		
	}
}