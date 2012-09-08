package com.flexcapacitor.utils {
	import flash.display.DisplayObject;
	import flash.system.ApplicationDomain;
	
	import mx.core.Application;
	import mx.core.FlexGlobals;
	import mx.core.FlexVersion;
	import mx.core.UIComponent;
	
	
	public class ApplicationUtils {
		
		public function ApplicationUtils() {
			
		}
		
		/**
		 * Gets the top level application. This may not be the application you are expecting.
		 * If you load application B into application A then this method will always get application A 
		 * */
		public static function getTopLevelApplication():Object {
			var isFlex3:Boolean = FlexVersion.compatibilityVersionString=="3.0.0";
			var application:Object;
			
			if (isFlex3) {
				application = Application['application'];
			}
			else {
				if (ApplicationDomain.currentDomain.hasDefinition("mx.core.FlexGlobals")) {
					application = ApplicationDomain.currentDomain.getDefinition("mx.core.FlexGlobals").topLevelApplication;
				}
			}
			
			return application;
		}
		
		/**
		 * Same as getApplication. deprecated
		 * 
		 * */
		public static function getInstance():Object {
			
			return getApplication();
		}
		
		/**
		 * Requires display object on the display list
		 * Get's a reference to the application in the current domain.
		 * If you load app B into app A when you call this method from app B
		 * you'll get app B application. When calling from app A you get app A application.
		 * */
		public static function getApplication(anything:Object = null):Object {
			
			var isFlex3:Boolean = FlexVersion.compatibilityVersionString=="3.0.0";
			var application:Object;
			
			if (anything!=null && anything.hasOwnProperty("parentApplication") && anything.parentApplication!=null) {
				application = anything.parentApplication;
			}
			else {
				if (isFlex3) {
					application = Application['application'];
				}
				else {
					if (ApplicationDomain.currentDomain.hasDefinition("mx.core.FlexGlobals")) {
						application = ApplicationDomain.currentDomain.getDefinition("mx.core.FlexGlobals").topLevelApplication;
					}
				}
			}
			
			return application;
		}
	}
}