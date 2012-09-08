




package com.flexcapacitor.context.menu {
	
	import com.flexcapacitor.managers.ContextMenuManager;
	import com.flexcapacitor.managers.LinkManager;
	import com.flexcapacitor.utils.ApplicationUtils;
	
	import flash.display.DisplayObject;
	import flash.events.ContextMenuEvent;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.ui.ContextMenuItem;

	public class MenuItem extends EventDispatcher implements IMenuItem {
		
		
		public function MenuItem(target:IEventDispatcher=null) {
			super(target);
			menu.addEventListener('menuItemSelect', handleItemSelect);
		}
		
		private var _menu:ContextMenuItem = new ContextMenuItem("");
		
		public function get menu():ContextMenuItem {
			return _menu;
		}
		
		public function set caption(value:String):void {
			menu.caption = value;
		}
		
		public function get caption():String {
			return menu.caption;
		}
		
		private var _group:String = "";
		public function set group(value:String):void {
			_group = value;
		}
		
		public function get group():String {
			return _group;
		}
		
		public function set separatorBefore(value:Boolean):void {
			menu.separatorBefore = value;
		}
		
		public function get separatorBefore():Boolean {
			return menu.separatorBefore;
		}
		
		public function set enabled(value:Boolean):void {
			menu.enabled = value;
		}
		
		public function get enabled():Boolean {
			return menu.enabled;
		}
		
		public function set visible(value:Boolean):void {
			menu.visible = value;
		}
		
		public function get visible():Boolean {
			return menu.visible;
		}
		
		private var _hyperlink:String = "";
		
		public function set hyperlink(value:String):void {
			_hyperlink = value;
		}
		
		public function get hyperlink():String {
			return _hyperlink;
		}
		
		private var _hyperlinkTarget:String = "";
		
		public function set hyperlinkTarget(value:String):void {
			_hyperlinkTarget = value;
		}
		
		public function get hyperlinkTarget():String {
			return _hyperlinkTarget;
		}
		
		private var _source:String;
	
		[Bindable]
		public function set source(value:String):void {
			_source = value;
		}

		public function get source():String {
			return _source;
		}
		
		private var _mouseTarget:DisplayObject;
	
		[Bindable]
		public function set mouseTarget(value:DisplayObject):void {
			_mouseTarget = value;
		}

		public function get mouseTarget():DisplayObject {
			return _mouseTarget;
		}
		
		public var contextManager:ContextMenuManager;
		
		public var linkManager:LinkManager;
		
		public function get application():Object {
			return ApplicationUtils.getInstance();
		}
		
		private function handleItemSelect(event:ContextMenuEvent):void {
			itemSelectedHandler(event)
		}
		
		public function itemSelectedHandler(event:ContextMenuEvent):void {
			
		}
		
	}
}