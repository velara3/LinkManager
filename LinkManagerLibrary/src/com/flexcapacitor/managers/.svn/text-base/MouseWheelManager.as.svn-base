/**
 * @author Gabriel Bucknall
 * 
 * Additional work Judah Frangipane
 * - decoupled swfobject requirement
 * - added MXML support
 * 
 * Adds support for mouse wheel on Mac OS
 * 
 * Requirements:
 * Include the javascript file in your html wrapper:
 * 
 * <script src="swfMouseWheel.js" language="javascript"></script>
 * 
 * Usage:
 * <managers:MouseWheelManager />
 */

/*
If you spin the mouse wheel as the flex app is loading up you will get this error:

TypeError: Error #1009: Cannot access a property or method of a null object reference.
	at com.flexcapacitor.managers::MouseWheelManager/_externalMouseEvent()[/Users/flexcapacitor/src/com/flexcapacitor/managers/MouseWheelManager.as:111]

I think the browser is storing the events and then dispatches them 
before flash has an opportunity to create the _externalMouseEvent function...

For the visitor to see this they will have to:
- have the debug flash player installed
- spin the mouse wheel as your application is loading at the right time

In any case the mouse wheel will work still. 

*/
package com.flexcapacitor.managers {

	import com.flexcapacitor.utils.ApplicationUtils;
	
	import flash.display.InteractiveObject;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	import flash.system.ApplicationDomain;
	import flash.system.Capabilities;
	import flash.utils.setTimeout;
	
	import mx.core.Application;
	import mx.core.FlexVersion;
	import mx.events.FlexEvent;
	
	public class MouseWheelManager {
		
		private static var instance:MouseWheelManager;
		private static const EXTERNAL_MOUSE_EVENT:String = 'externalMouseEvent';
		
		private var _stage:Stage;
		private var _currItem:InteractiveObject;
		private var _clonedEvent:MouseEvent;
		private var created:Boolean = false;
		
		// put the swfMouseWheel.js file in the project "src" or "html-template" directory
		// this value is only necessary if you load the js dynamically
		[Inspectable(category="General")]
		public var src:String = "swfMouseWheel.js";
		public var userAgent:String;
		
		// Note:
		// there seems to be a 3 second delay before the file is loaded dynamically
		// it then shows a busy cursor for 2 seconds
		// i'm not sure why this happens but including the js file in the index.template.html page
		// solves it
		[Inspectable(category="General")]
		public var loadDynamically:Boolean = false;
		[Inspectable(category="General")]
		public var loadDynamicallyInterval:int = 0;
		public var application:Object;

		public static function getInstance():MouseWheelManager {
			if (instance == null) instance = new MouseWheelManager( new SingletonEnforcer() );
			return instance;
		}
		
		public function MouseWheelManager( enforcer:SingletonEnforcer=null ) {
			
			application = ApplicationUtils.getInstance();
			
			application.addEventListener(FlexEvent.APPLICATION_COMPLETE, setupMouseManager);
		}
		
		private var _enabled:Boolean = true;

		public function get enabled():Boolean {
			return _enabled;
		}

		public function set enabled(value:Boolean):void {
			_enabled = value;
			if (!created) return;
			
			ExternalInterface.call( "eval", "swfMouseWheel.enable("+value+",'"+ExternalInterface.objectID+"')" );
		}

		
		private function setupMouseManager( event:FlexEvent ):void {
			created = true;
			var isMac:Boolean = Capabilities.os.toLowerCase().indexOf( "mac" ) != -1;
			var caps:Object = Capabilities;
			var os:String = Capabilities.os;
			var userAgent:String = ExternalInterface.call("eval", "navigator.userAgent");
			var browserVersion:Array = (userAgent!=null) ? userAgent.match(/Version\/(\d+).+Safari/) : [];
			var browserMajor:int = browserVersion && browserVersion.length>1 ? browserVersion[1] : 0;
			var browserMinor:int = browserVersion && browserVersion.length>2 ? browserVersion[2] : 0;
			var player:String = Capabilities.version;
			var playerVersion:Array = player.match(/\s+(\d+),(\d+),/);
			var playerMajor:int = playerVersion.length>1 ? playerVersion[1] : 0;
			var playerMinor:int = playerVersion.length>2 ? playerVersion[2] : 0;
			var isFixed:Boolean = false;
			
			
			// in safari 4 and flash 10.1 mouse wheel scrolling is fixed
			if (playerMajor>10 || (playerMajor==10 && playerMinor>0)) {
				if (browserVersion && browserVersion.length>0 && browserMajor>=4) {
					isFixed = true;
				}
			}
			
			// need to test and finish this...
			
			/*if (isFixed) {
				enabled = false;
				return;
			}*/
			
			_stage = application.stage;
			_stage.addEventListener( MouseEvent.MOUSE_MOVE, getItemUnderMouse );
			
			if (ExternalInterface.available) {
				ExternalInterface.addCallback( EXTERNAL_MOUSE_EVENT, _externalMouseEvent );
				
				if (loadDynamically) {
					ExternalInterface.call("eval","swfMouseWheelItems = ['"+ExternalInterface.objectID+"']");
					setTimeout(loadScript, loadDynamicallyInterval);
					//loadScript(); // if we do this the page shows a blank page for a few seconds
				}
				else {
					ExternalInterface.call( "eval", "swfMouseWheel.addItem('"+ExternalInterface.objectID+"')" );
					ExternalInterface.call( "eval", "swfMouseWheel.enable("+enabled+",'"+ExternalInterface.objectID+"')" );
					userAgent = ExternalInterface.call("eval", "navigator.userAgent");
					//trace("userAgent " + userAgent);
					if (userAgent!=null && userAgent.indexOf("safari")>-1 ) {
						
					}
				}
			}
		}
		
		private function loadScript():void {
			ExternalInterface.call("eval","swfMouseWheelScript=document.createElement('script');swfMouseWheelScript.type='text/javascript';swfMouseWheelScript.defer='false';swfMouseWheelScript.src='"+src+"';document.getElementsByTagName('head')[0].appendChild(swfMouseWheelScript);");
		}
		
		private function getItemUnderMouse( e:MouseEvent ):void {
			_currItem = InteractiveObject( e.target );
			_clonedEvent = MouseEvent( e );
		}
		
		private function _externalMouseEvent( delta:Number ):void {
			if (_currItem==null || _clonedEvent==null) return;
			
			var wheelEvent:MouseEvent = new MouseEvent( 
					MouseEvent.MOUSE_WHEEL, 
					true, 
					false, 
					_clonedEvent.localX, 
					_clonedEvent.localY, 
					_clonedEvent.relatedObject, 
					_clonedEvent.ctrlKey, 
					_clonedEvent.altKey, 
					_clonedEvent.shiftKey, 
					_clonedEvent.buttonDown, 
					int( delta )
				);
			_currItem.dispatchEvent( wheelEvent );
		}
	}
}

internal class SingletonEnforcer{}
