/** 
	So the idea behind this component is to let you easily add context menus 
	to components with menu items that are similar to what's available to
	html links and images in the browser. 
	
	The menu items are based off the context menu items in Firefox 3
	
	Menus created are:
		- Open in new Window
		- Bookmark This Link
		- Save This Link
		- Send Link
		- Copy This Location
		
		- View Image
		- Copy Image Location
		- Save Image As
	
	You can enable or disable these menus. You can also add your own.
	
	How to Use:
	<ContextMenu />
	
	To add your own menu item:
	
	To add your own look at the code in the menuSelect function
	Then add your own "enableMyItem" variable like the other "enable" variables and
	Add your own "myMenuText" variable
	
	ROLES
	
	When we right click on a link we want to offer the user options depending on the kind of link. 
	We list the options we show for each link type:

	When the user right clicks on the following we show: 

	Application
		- Back
		- Forward
		- Reload
		
		- Bookmark This Page
		- Save Page As... (generate a PDF and prompt the user to download it)
		- Send Link...
		
		- View Background Image
		- Select All
		
		- View Page Source
		- View Page Info
		- Properties
	
	Text Link
		- Open in new Window
		- Bookmark This Link
		- Save This Link
		- Send Link
		- Copy This Location
	
	Image
		- View Image
		- View Image in Browser*
		- Copy Image Location
		- Save Image As
	
	Video
		- Play Video
		- Stop Video
		- Rewind Video
	
	File
		- Open in new Window
		- Save This Link
		- Send Link
		- Copy This Location

*/

package com.flexcapacitor.managers {
	import com.flexcapacitor.context.menu.ImageCopyLocation;
	import com.flexcapacitor.context.menu.ImageEdit;
	import com.flexcapacitor.context.menu.ImageSave;
	import com.flexcapacitor.context.menu.ImageView;
	import com.flexcapacitor.context.menu.ImageViewerClose;
	import com.flexcapacitor.context.menu.LinkCopyLocation;
	import com.flexcapacitor.context.menu.LinkOpenInWindow;
	import com.flexcapacitor.context.menu.LinkSave;
	import com.flexcapacitor.context.menu.LinkSend;
	import com.flexcapacitor.context.menu.MenuItem;
	import com.flexcapacitor.context.menu.PageBack;
	import com.flexcapacitor.context.menu.PageBookmark;
	import com.flexcapacitor.context.menu.PageCopyLocation;
	import com.flexcapacitor.context.menu.PageForward;
	import com.flexcapacitor.context.menu.PageReload;
	import com.flexcapacitor.context.menu.PageSave;
	import com.flexcapacitor.context.menu.PageSend;
	import com.flexcapacitor.context.menu.PageViewSource;
	import com.flexcapacitor.controls.Anchor;
	import com.flexcapacitor.controls.ButtonLink;
	import com.flexcapacitor.controls.ImageViewer;
	import com.flexcapacitor.controls.TextAutoSize;
	import com.flexcapacitor.controls.TextLink;
	import com.flexcapacitor.utils.ApplicationUtils;
	
	import flash.debugger.enterDebugger;
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.ContextMenuEvent;
	import flash.events.MouseEvent;
	import flash.system.ApplicationDomain;
	import flash.text.TextField;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	
	import mx.core.FlexLoader;
	import mx.core.FlexVersion;
	import mx.core.UIComponent;
	import mx.core.UITextField;
	import mx.events.FlexEvent;

	public class ContextMenuManager {
		
		import mx.controls.Alert;
		import mx.controls.Image;
		import mx.core.Application;
		
		import com.flexcapacitor.controls.ImageLink;
		import com.flexcapacitor.controls.ImageViewer;
		
		private static var setup:Boolean = false;
		private static var instance:ContextMenuManager;
		private static var created:Boolean;

		public var target:UIComponent = new UIComponent();
		
		[Bindable]
		public var menu:ContextMenu = new ContextMenu();
		
		// reference to the link manager
		public var linkManager:LinkManager = LinkManager.getInstance();
/* 		
		[Bindable]
		[Inspectable(category="General")]
		public var url:String = "about:blank";
		
		[Bindable]
		[Inspectable(category="General")]
		public var urlField:* = ["hyperlink","source","href","link","url"]; 
		
		[Bindable]
		public var dataObject:Object;*/
		
		// enables or disables "Back" menu item
		[Bindable]
		public var enableBack:Boolean = true;
		
		// enables or disables "Forward" menu item
		[Bindable]
		public var enableForward:Boolean = true;
		
		// enables or disables "Reload" menu item
		[Bindable]
		public var enableReload:Boolean = true;
		
		// enables or disables "View Background Image" menu item
		[Bindable]
		public var enableViewBackgroundImage:Boolean = true;
		
		// enables or disables "Select All" menu item
		[Bindable]
		public var enableSelectAll:Boolean = true;
		
		// enables or disables "View Source" menu item
		[Bindable]
		public var enableViewSource:Boolean = true;
		
		// enables or disables "View Info" menu item
		[Bindable]
		public var enableViewInfo:Boolean = true;
		
		// enables or disables "Properties" menu item
		[Bindable]
		public var enableProperties:Boolean = true;
		
		// enables or disables "Open in New Window" menu item
		[Bindable]
		public var enableOpenInNewWindow:Boolean = true;
		
		// enables or disables "Bookmark this Link" menu item
		[Bindable]
		public var enableBookmarkThisLink:Boolean = true;
		
		// enables or disables "Save This Link" menu item
		[Bindable]
		public var enableSaveThisLink:Boolean = true;
		
		// enables or disables "Send Link" menu item
		[Bindable]
		public var enableSendLink:Boolean = true;
		
		// enables or disables "Bookmark this Page" menu item
		[Bindable]
		public var enableBookmarkThisPage:Boolean = true;
		
		// enables or disables "Save This Page" menu item
		[Bindable]
		public var enableSaveThisPage:Boolean = true;
		
		// enables or disables "Send Page" menu item
		[Bindable]
		public var enableSendPage:Boolean = true;
		
		// enables or disables "Copy This Location" menu item
		[Bindable]
		public var enableCopyThisLocation:Boolean = true;
		
		// enables or disables "Test Menu" menu item. Used for easy testing
		[Bindable]
		public var enableTestMenu:Boolean = false;
		
		// enables or disables "Print" menu item
		[Bindable]
		public var enablePrint:Boolean = true;
		
		// enables or disables "View Image" menu item
		[Bindable]
		public var enableViewImage:Boolean = true;
		
		// enables or disables "Copy Image Location" menu item
		[Bindable]
		public var enableCopyImageLocation:Boolean = true;
		
		// enables or disables "Save Image As" menu item
		[Bindable]
		public var enableSaveImageAs:Boolean = true;
		
		// uses the download dialog provided by the browser instead of the flash player dialog
		[Bindable]
		public var useBrowserDownloadDialog:Boolean = true;

		
		// text displayed for "Open in a New Window" menu item
		public static var openInNewWindowText:String = "Open in a New Window";
		
		// text displayed for "Bookmark this Link" menu item
		public static var bookmarkThisLinkText:String = "Bookmark this Page";
		
		// text displayed for "Save Link As..." menu item
		public static var saveLinkAsText:String = "Save Link As...";
		
		// text displayed for "Send Link..." menu item
		public static var sendLinkText:String = "Send Link...";
		
		// text displayed for "Copy Link Location" menu item
		public static var copyLinkLocationText:String = "Copy Link Location";
		
		// text displayed for "Bookmark this Page" menu item
		public static var bookmarkThisPageText:String = "Bookmark this Page";
		
		// text displayed for "Save Page As..." menu item
		public static var savePageAsText:String = "Save Page As...";
		
		// text displayed for "Send Page..." menu item
		public static var sendPageText:String = "Send Page...";
		
		// text displayed for "Copy Page Location" menu item
		public static var copyPageLocationText:String = "Copy Page Location";
		
		// text displayed for "View Image" menu item
		public static var viewImageText:String = "View Image";
		
		// text displayed for "Copy Image Location" menu item
		public static var copyImageLocationText:String = "Copy Image Location";
		
		// text displayed for "Save Image As..." menu item
		public static var saveImageAsText:String = "Save Image As...";
		
/* 		// if the url is in a repeater we can use this 
		// may be obsolete with the url property
		public var isRepeater:Boolean = false; 
		
		// used to display preview image
		public static var viewImageImage:ImageLink;
		
		// used to display preview image text
		public static var viewImageTextField:TextInput;*/
		
		// point to the location that contains the files to let the user download the page
		// Comments - downloading the swf and html page isn't the best idea since the swf will 
		// not run correctly on the client due to security issues (swf can't access javascript)...
		// you'd probably want to point to a script that creates a zip of all the files
		// or point to the view source url 
		// or create a pdf of the current page and download that
		public var savePageAsURL:String = "";
		
		// used to save the page as 
		public var savePageAsPDF:Boolean = false;
		
/* 		// used to get the url from the target component
		// you can create your own urlFunction and return a string
		[Bindable]
		public var urlFunction:Function = defaultUrlFunction;
	 */	
/* 		// used to initiate a download 
		public static var fileReference:FileReference = new FileReference();
		
		// used to pass in the url to the download
		public static var request:URLRequest; */
/* 		
		// opens the image in the browser rather than in the flex app 
		public var openViewImageInBrowser:Boolean = false;
 */		
		
		// locations to place separators
		public var separatorIndexes:Array = [1];
		
		public var stage:Stage;
		
		public var currentTarget:Object;
		
		public var currentCaptureTarget:Object;
		
		
		// IMAGE items
		public static var imageCopyLocation:ImageCopyLocation = new ImageCopyLocation();
		
		public static var imageSave:ImageSave = new ImageSave();
		
		public static var imageView:ImageView = new ImageView();
		
		public static var imageEdit:ImageEdit = new ImageEdit();
		
		public static var imageViewerClose:ImageViewerClose = new ImageViewerClose();
		
		// LINK items
		public static var linkOpenInWindow:LinkOpenInWindow = new LinkOpenInWindow();
		
		public static var linkSave:LinkSave = new LinkSave();
		
		public static var linkSend:LinkSend = new LinkSend();
		
		public static var linkCopyLocation:LinkCopyLocation = new LinkCopyLocation();
		
		// PAGE items
		public static var pageBack:PageBack = new PageBack();
		
		public static var pageBookmark:PageBookmark = new PageBookmark();
		
		public static var pageForward:PageForward = new PageForward();
		
		public static var pageReload:PageReload = new PageReload();
		
		public static var pageSave:PageSave = new PageSave();
		
		public static var pageSend:PageSend = new PageSend();
		
		public static var pageCopyLocation:PageCopyLocation = new PageCopyLocation();
		
		public static var pageViewSource:PageViewSource = new PageViewSource();
		
		private var isFlex3:Boolean = FlexVersion.compatibilityVersionString=="3.0.0";
		
		/**
		 * Used internally to remove menu items managed by this class
		 * */
		public var internalMenuItemsArray:Array = [imageCopyLocation,imageSave,imageView,imageEdit,imageViewerClose,
			linkOpenInWindow,linkSave,linkSend,linkCopyLocation,pageBack,pageBookmark,pageForward,pageReload,
			pageSave,pageSend,pageCopyLocation,pageViewSource];
		
		// don't know if i should create single instance or not
		public function ContextMenuManager() {
			/* if (!created) {
				throw new Error("ContextMenuManager class cannot be instantiated");
			}*/
			
			
			if (!setup) {
				menu = new ContextMenu();
				menu.addEventListener(ContextMenuEvent.MENU_SELECT, menuSelect, false, 0, false);
				
				application.addEventListener(FlexEvent.APPLICATION_COMPLETE, applicationCreated);
			}
		}
		
		private var _customMenuItems:Array;
		
		[Bindable]
		[ArrayElementType("com.flexcapacitor.context.menu.MenuItem")]
		public function set customMenuItems(value:Array):void {
			_customMenuItems = value;
			for (var i:int=0;i<_customMenuItems.length;i++) {
				internalMenuItemsArray.push(_customMenuItems[i]);
			}
		}
		
		public function get customMenuItems():Array {
			return _customMenuItems;
		}
		
		/**
		 * Returns the one single instance of this class
		 */
		public static function getInstance():ContextMenuManager {
			//trace("in getInstance");
			if (instance == null) {
				created = true;
				instance = new ContextMenuManager();
				//created = false;
			}
			
			return instance;
		}
		
		public function get application():Object {
			return ApplicationUtils.getInstance();
		}
		
		public function applicationCreated(event:FlexEvent):void {
			//trace("in applicationCreated");
			setupContextMenu();
		}
		
		public function setupContextMenu():void {
			//trace("in setupContextMenu");
			
			/*if (application.contextMenu) {
				menu = application.contextMenu;
				menu.addEventListener(ContextMenuEvent.MENU_SELECT, menuSelect, false, 0, false);
			}
			else {
				menu = new ContextMenu();
				menu.addEventListener(ContextMenuEvent.MENU_SELECT, menuSelect, false, 0, false);
				application.contextMenu = menu;
			}*/
			menu = new ContextMenu();
			menu.addEventListener(ContextMenuEvent.MENU_SELECT, menuSelect, false, 0, false);
			application.contextMenu = menu;

			stage = application.stage;
			stage.addEventListener( MouseEvent.MOUSE_MOVE, getItemUnderMouse);
			stage.addEventListener( MouseEvent.MOUSE_MOVE, getItemUnderMouse, true);
			
			
			if (application.viewSourceURL!=null && 
				application.viewSourceURL!="") {
				enableViewSource = true;
			}
			else {
				enableViewSource = false;
			}

		}
		
		// get item under mouse
		public function getItemUnderMouse( event:MouseEvent ):void {
			if (event.target is TextAutoSize) {
				
			}
			
			if (   Object(event.target).hasOwnProperty("parent") 
				&& Object(event.target).parent is TextAutoSize) {
				
				
				/*if (UITextField(event.target).contextMenu==null && false) {
					var menu:ContextMenu = new ContextMenu();
					menu.addEventListener(ContextMenuEvent.MENU_SELECT, menuSelect, false, 0, false);
					UITextField(event.target).contextMenu = menu;
				}*/
			}
			
			currentTarget = event.target;
			
			if (event.eventPhase==2) {
				currentTarget =  event.target ;
			}
			else {
				currentCaptureTarget = event.target;
			}
		}
		
		
		// TODO: We should eventually setup MIME types (some built in) and allow for plug ins for context menus
		// either inline in the application or run through external swf scripts (allow same app domain)
		// - when over this object type show this menu (etc)
		// - when text is selected show this menu (etc)
		// Firefox jetpack looks like a good model to start from
		
		// TODO: This needs to be refactored
		// TODO: Check for links in Textfields (preferably we should skip AS3 Textfields and go straight to TLF Textfields)
		// when we show a context menu we decide what menu items to show
		// we also decide how to handle them 
		public function menuSelect(event:ContextMenuEvent):void {
			//traceConsole("in menuSelect");
			var hyperlinkTarget:String = "";
			var hyperlinkURI:String = "";
			var hyperlink:String = "";
			var source:*;
			var contentWidth:int = 0;
			var contentHeight:int = 0;
			var viewSourceURL:String = application.viewSourceURL;
			var useBrowserDownloadDialog:Boolean = linkManager.useBrowserDownloadDialog;
			var externalCustomItems:Array = [];
			var i:int = 0;
			var menuItem:ContextMenuItem;
			var isNotImageLink:Boolean;
			
			// make sure we get an updated reference to the link manager
			linkManager = LinkManager.getInstance();
			
			// hide build in Flash Player menu items (these aren't meant for Flex)
			ContextMenu(event.currentTarget).hideBuiltInItems();

			// PRINT 
			if (enablePrint) {
				menu.builtInItems.print = true;
			}
			
			// clear out the context menu items we've added
			// we will re add them below in the order we want
			removeOwnedMenuItems();
			if (menu.customItems.length>0) {
				for (i=0;i<menu.customItems.length;i++) {
					externalCustomItems.push(menu.customItems[i]);
				}
				menu.customItems.length = 0;
			}
			
			if (currentTarget is UITextField) {
				return;
			}
			
			// get item the mouse is over
			// Image components show up as movieclips??? 
			// since the item the mouse is over by our stage listener could have another value check it 
			if (event.mouseTarget!=null && !(event.mouseTarget is MovieClip)) {
				currentTarget = event.mouseTarget;
				if (currentTarget && currentTarget.hasOwnProperty("source")
					&& currentTarget.hasOwnProperty("contentWidth")) {
					source = Object(currentTarget).source.toString();
					contentWidth = Object(currentTarget).contentWidth;
					contentHeight = Object(currentTarget).contentHeight;
				}
			}
			
			// check for images - Images are Loaders? 
			if (currentTarget is FlexLoader && currentTarget.parent) {
				currentTarget = currentTarget.parent;
				if (currentTarget.hasOwnProperty("source")) {
					source = Image(currentTarget).source.toString();
					contentWidth = Image(currentTarget).contentWidth;
					contentHeight = Image(currentTarget).contentHeight;
					isNotImageLink = true;
				}
			}
			
			// check for embedded images - Images are Loaders? 
			if (currentTarget is Loader) {

				if (currentTarget.hasOwnProperty("contentLoaderInfo")) {
					source = Loader(currentTarget).contentLoaderInfo.url.toString();
					contentWidth = Loader(currentTarget).contentLoaderInfo.width;
					contentHeight = Loader(currentTarget).contentLoaderInfo.height;
				}
			}
			
			// if current target is a IHyperlink
			if (currentTarget.hasOwnProperty("hyperlink")) {
				hyperlink = currentTarget['hyperlink'];
			}
			
			// get hyperlink target
			if (currentTarget.hasOwnProperty("hyperlinkTarget")) {
				hyperlinkTarget = currentTarget['hyperlinkTarget'];
			}
			
			// check if we are over a Image Viewer
			var checkImageViewer:DisplayObject = DisplayObject(currentTarget);
			var isImageViewer:Boolean = false;
			
			while (checkImageViewer) {
				if (checkImageViewer is ImageViewer) {
					isImageViewer = true;
					break;
				}
				if (checkImageViewer is UIComponent) {
					checkImageViewer = UIComponent(checkImageViewer).owner;
				}
				else {
					checkImageViewer = checkImageViewer.parent;
				}

			}
			
			if (isImageViewer) {
				imageViewerClose.mouseTarget = checkImageViewer;
				menu.customItems.push(imageViewerClose.menu);
				return;
			}
			
			// check if we are in an Anchor component
			var anchorComponent:InteractiveObject = currentTarget as InteractiveObject;
			var isAnchor:Boolean = false;
			
			while (anchorComponent) {
				if (anchorComponent is Anchor) {
					isAnchor = true;
					break;
				}
				if (anchorComponent is UIComponent) {
					anchorComponent = UIComponent(anchorComponent).owner;
				}
				else {
					anchorComponent = anchorComponent.parent;
				}
			}
			
			if (currentTarget in linkManager.anchors) {
				isAnchor = true;
				// get reference to the actual anchor component rather than the 
				// target of the anchor component
				currentTarget = linkManager.anchors[currentTarget];
				anchorComponent = InteractiveObject(currentTarget);
			}
			
			if (isAnchor) {
				hyperlink = Anchor(anchorComponent).hyperlink;
				hyperlinkTarget = Anchor(anchorComponent).hyperlinkTarget;
			}
			
			// get absolute path of hyperlink for:
			// - copy link location
			// - send link location
			// - save link as...
			if (hyperlink!="" && hyperlink!=null) {
				hyperlinkURI = linkManager.getURI(hyperlink, hyperlinkTarget);
			}
			
			if (viewSourceURL!="" && viewSourceURL!=null) {
				viewSourceURL = linkManager.getURI(viewSourceURL, linkManager.BLANK_HYPERLINK);
			}
			
			// check if text link, image link, image or application
			if (currentTarget is TextLink) {
				linkOpenInWindow.hyperlink = hyperlinkURI;
				linkSave.hyperlink = hyperlinkURI;
				linkSave.useBrowserDownloadDialog = useBrowserDownloadDialog;
				linkSend.hyperlink = hyperlinkURI;
				linkCopyLocation.hyperlink = hyperlinkURI;
				linkCopyLocation.hyperlinkTarget = hyperlinkTarget;
				
				menu.customItems.push(linkOpenInWindow.menu);
				menu.customItems.push(linkSave.menu);
				menu.customItems.push(linkSend.menu);
				menu.customItems.push(linkCopyLocation.menu);
				
				separatorIndexes = [1];
				event.stopImmediatePropagation();
			}
			else if (currentTarget is ButtonLink) {
				linkOpenInWindow.hyperlink = hyperlinkURI;
				linkSave.hyperlink = hyperlinkURI;
				linkSave.useBrowserDownloadDialog = useBrowserDownloadDialog;
				linkSend.hyperlink = hyperlinkURI;
				linkCopyLocation.hyperlink = hyperlinkURI;
				linkCopyLocation.hyperlinkTarget = hyperlinkTarget;
				
				menu.customItems.push(linkOpenInWindow.menu);
				menu.customItems.push(linkSave.menu);
				menu.customItems.push(linkSend.menu);
				menu.customItems.push(linkCopyLocation.menu);
				
				separatorIndexes = [1];
				event.stopImmediatePropagation();
				
			}
			// this test was taking forever for some reason???
			// added check to skip past it quicker
			// TODO: figure out what the deal is
			else if (!isNotImageLink && currentTarget is ImageLink) {
				
				if (hyperlink!="") {
					linkOpenInWindow.hyperlink = hyperlinkURI;
					linkSave.hyperlink = hyperlinkURI;
					linkSave.useBrowserDownloadDialog = useBrowserDownloadDialog;
					linkSend.hyperlink = hyperlinkURI;
					linkCopyLocation.hyperlink = hyperlinkURI;
					
					menu.customItems.push(linkOpenInWindow.menu);
					menu.customItems.push(linkSave.menu);
					menu.customItems.push(linkSend.menu);
					menu.customItems.push(linkCopyLocation.menu);
					
					separatorIndexes = [1,4];
				}
				else {
					separatorIndexes = [];
				}
				
				imageView.source = Image(currentTarget).source.toString();
				imageView.hyperlink = hyperlinkURI;
				imageView.width = Image(currentTarget).contentWidth;
				imageView.height = Image(currentTarget).contentHeight;
				
				imageSave.source = Image(currentTarget).source.toString();
				imageSave.hyperlink = hyperlinkURI;
				
				imageCopyLocation.source = Image(currentTarget).source.toString();
				imageCopyLocation.hyperlink = hyperlinkURI;
				
				imageEdit.source = Image(currentTarget).source.toString();
				imageEdit.hyperlink = hyperlinkURI;
				imageEdit.width = Image(currentTarget).contentWidth;
				imageEdit.height = Image(currentTarget).contentHeight;

				menu.customItems.push(imageView.menu);
				menu.customItems.push(imageSave.menu);
				menu.customItems.push(imageCopyLocation.menu);
				menu.customItems.push(imageEdit.menu);
				
			}
			else if (currentTarget is Anchor) {
				linkOpenInWindow.hyperlink = hyperlinkURI;
				linkSave.hyperlink = hyperlinkURI;
				linkSend.hyperlink = hyperlinkURI;
				linkCopyLocation.hyperlink = hyperlinkURI;
				
				menu.customItems.push(linkOpenInWindow.menu);
				menu.customItems.push(linkSave.menu);
				menu.customItems.push(linkSend.menu);
				menu.customItems.push(linkCopyLocation.menu);
				
				
				if (contentWidth) {
					// we should check the source
					imageView.source = source.toString();
					imageView.width = contentWidth;
					imageView.height = contentHeight;
					
					imageSave.source = source.toString();
					imageSave.hyperlink = hyperlinkURI;
					
					imageCopyLocation.source = source.toString();
					imageCopyLocation.hyperlink = hyperlinkURI;
					
					imageEdit.source = Image(currentTarget).source.toString();
					imageEdit.hyperlink = hyperlinkURI;
					imageEdit.width = Image(currentTarget).contentWidth;
					imageEdit.height = Image(currentTarget).contentHeight;
	
					menu.customItems.push(imageView.menu);
					menu.customItems.push(imageSave.menu);
					menu.customItems.push(imageCopyLocation.menu);
					menu.customItems.push(imageEdit.menu);
					separatorIndexes = [1,4];
				}
				else {
					separatorIndexes = [1];
				}
				
			}
			else if (currentTarget is Image) {
				imageView.source = Image(currentTarget).source.toString();
				imageView.hyperlink = hyperlinkURI;
				imageView.width = Image(currentTarget).contentWidth;
				imageView.height = Image(currentTarget).contentHeight;
				
				imageSave.source = Image(currentTarget).source.toString();
				imageSave.hyperlink = hyperlinkURI;
				
				imageCopyLocation.source = Image(currentTarget).source.toString();
				imageCopyLocation.hyperlink = hyperlinkURI;
				
				imageEdit.source = Image(currentTarget).source.toString();
				imageEdit.hyperlink = hyperlinkURI;
				imageEdit.width = Image(currentTarget).contentWidth;
				imageEdit.height = Image(currentTarget).contentHeight;
				
				menu.customItems.push(imageView.menu);
				menu.customItems.push(imageSave.menu);
				menu.customItems.push(imageCopyLocation.menu);
				menu.customItems.push(imageEdit.menu);
				
				separatorIndexes = [0];
			}
			else if (currentTarget is Loader) {
				if (Loader(currentTarget).contentLoaderInfo.contentType.indexOf("image")!=-1) {
					hyperlinkURI = linkManager.getURI(Loader(currentTarget).contentLoaderInfo.url.toString(), linkManager.BLANK_HYPERLINK);
					imageView.source = Loader(currentTarget).contentLoaderInfo.url.toString();
					imageView.hyperlink = hyperlinkURI;
					imageView.width = Loader(currentTarget).contentLoaderInfo.width;
					imageView.height = Loader(currentTarget).contentLoaderInfo.height;
					
					imageCopyLocation.source = Loader(currentTarget).contentLoaderInfo.url.toString();
					imageCopyLocation.hyperlink = hyperlinkURI;
					imageSave.source = Loader(currentTarget).contentLoaderInfo.url.toString();
					imageSave.hyperlink = hyperlinkURI;
					
					menu.customItems.push(imageView.menu);
					menu.customItems.push(imageCopyLocation.menu);
					menu.customItems.push(imageSave.menu);
					
					separatorIndexes = [0];
				}
			}
			else {
				// MENU IS ON THE APPLICATION
				pageBack.hyperlink = hyperlinkURI;
				pageForward.hyperlink = hyperlinkURI;
				pageReload.hyperlink = hyperlinkURI;
				
				pageBookmark.hyperlink = hyperlinkURI;
				pageSave.hyperlink = getSaveAsURL(hyperlinkURI);
				
				pageReload.hyperlink = hyperlinkURI;
				pageSend.hyperlink = hyperlinkURI;
				pageCopyLocation.hyperlink = hyperlinkURI;
				
				pageViewSource.hyperlink = viewSourceURL;
				
				menu.customItems.push(pageBack.menu);
				menu.customItems.push(pageForward.menu);
				menu.customItems.push(pageReload.menu);
				
				menu.customItems.push(pageBookmark.menu);
				menu.customItems.push(pageSave.menu);
				menu.customItems.push(pageSend.menu);
				menu.customItems.push(pageCopyLocation.menu);
				
				if (enableViewSource) {
					menu.customItems.push(pageViewSource.menu);
				}
				
				// next section specific
				enableViewBackgroundImage = true;
				enableSelectAll = true;
				
				// next section specific
				enableViewInfo = true;
				enableProperties = true;
				separatorIndexes = [3,7,9];
			}
			
			
			// show separator in the index specified
			for (i=0;i < menu.customItems.length;i++) {
				var item:ContextMenuItem = menu.customItems[i];
				item.separatorBefore = false;
				for each (var value:Number in separatorIndexes) {
					if (value == i) {
						item.separatorBefore = true;
					}
				}
			}
			
			// add any external menu items back in
			for (i=0;i<externalCustomItems.length;i++) {
				menuItem = externalCustomItems[i];
				if (i==0) menuItem.separatorBefore = true; 
				menu.customItems.push(menuItem);
			}

		}
		
		public function getSaveAsURL(hyperlink:String = ""):String {
			var url:String = "";
			var viewSourceURL:String = application.viewSourceURL;
			
			if (savePageAsPDF) {
				// put code here to get the pdf
			}
			else if (savePageAsURL!="" && savePageAsURL!=null) {
				url = savePageAsURL;
			}
			else if (viewSourceURL!=null && viewSourceURL!="") {
				url = viewSourceURL;
			}
			else {
				url = hyperlink;
			}
			return url;
		}
		
		public function removeOwnedMenuItems():void {
			var menuLength:int = menu.customItems.length;
			var customItem:ContextMenuItem;
			
			for (var i:int=menuLength-1;i>-1;i--) {
				customItem = menu.customItems[i];
				
				for each (var menuItem:MenuItem in internalMenuItemsArray) {
					//trace(menuItem);
					
					if (customItem.caption==menuItem.menu.caption) {
						//menu.customItems[i] = null;
						menu.customItems.splice(i,1);
						continue;
					}
				}
			}
		}
/* 
		private var _menuType:String = "custom";
			
		// so i'm using the default context menu items found in Firefox 3
		// for links and for images
		// if we wanted we could make a context menu plug in architecture
		// dude could enable custom plugins (context menus)
		// and those could be in a shared object 
		// and load in remote or local swf's or code in the shared object
		// its too much to do right now so the developer can 
		// enable and add his own menus in this class 
		
		[Bindable]
		[Inspectable(enumeration="custom,link,image,imagelink,application,file")]
		public function set menuType(value:String):void {
			//trace("in set menuType");
			_menuType = value;
			enableAllMenuItems(false);
			
			// set default values for the application
			if (value=="application") {
				// page specific
				enableBack = true;
				enableForward = true;
				enableReload = true;
				
				// link specific
				enableBookmarkThisLink = true;
				enableSaveThisLink = true;
				enableSendLink = true;
				enableCopyThisLocation = true;
				
				// next section specific
				enableViewBackgroundImage = true;
				enableSelectAll = true;
				
				// next section specific
				enableViewInfo = true;
				enableProperties = true;
				separatorIndexes = [3,7,9];
			}
			
			// set default values for link or image menus
			else if (value=="link") {
				// link specific
				enableOpenInNewWindow = true;
				enableBookmarkThisLink = true;
				enableSaveThisLink = true;
				enableSendLink = true;
				enableCopyThisLocation = true;
				separatorIndexes = [1];
			}
			
			// set default values for link or image menus
			else if (value=="image") {
				// image specific
				enableViewImage = true;
				enableCopyImageLocation = true;
				enableSaveImageAs = true;
				separatorIndexes = [];
			}
			
			// set default values for link or image menus
			else if (value.toLowerCase()=="imagelink") {
				// link specific
				enableOpenInNewWindow = true;
				enableBookmarkThisLink = true;
				enableSaveThisLink = true;
				enableSendLink = true;
				enableCopyThisLocation = true;
				
				// image specific
				enableViewImage = true;
				enableCopyImageLocation = true;
				enableSaveImageAs = true;
				separatorIndexes = [1,5];
			}
		}
		
		public function get menuType():String {
			return _menuType;
		} 
		
		// use to enable or disable all menu items
		private function enableAllMenuItems(value:Boolean = false):void {
			enableBack = value;
			enableBookmarkThisLink = value;
			enableBookmarkThisPage = value;
			enableCopyImageLocation = value;
			enableCopyThisLocation = value;
			enableForward = value;
			enableOpenInNewWindow = value;
			enableProperties = value;
			enableReload = value;
			enableSaveImageAs = value;
			enableSaveThisLink = value;
			enableSaveThisPage = value;
			enableSelectAll = value;
			enableSendLink = value;
			enableSendPage = value;
			enableTestMenu = value;
			enableViewBackgroundImage = value;
			enableViewImage = value;
			enableViewInfo = value;
			enableViewSource = value;
		}
			
 		// this function is used to find the url
		// it contains a check for an item in a repeater
		public function defaultUrlFunction(event:ContextMenuEvent):String {
			var object:Object = new Object();
			var url:String = "about:blank";
			var menu:ContextMenu = event.currentTarget as ContextMenu;
			var owner:* = event.contextMenuOwner;
			//var caption:String = menu.caption;
			
			// if option getRepeater is set then we get the data used in the repeater
			if (isRepeater) {
				object = UIComponent(owner).getRepeaterItem();
			}
			else {
				object = owner;
			}
			
			if (urlField is Array) {
				for each(var prop:String in urlField) {
					if (object.hasOwnProperty(prop)) {
						url = object[prop];
						break;
					}
				}
			}
			else {
				if (object.hasOwnProperty(urlField)) {
					url = object[urlField];
				}
			}
			
			if (event.contextMenuOwner is Image) {
				url = Image(event.contextMenuOwner).source.toString();
			}
			
			// ADD ERROR check here
			// if error then change url to "ERROR:MESSAGE" and display alert
			return url;
		} */
		
	}
}