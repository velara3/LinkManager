


/**
* content loading complete event
* prevent error messages when image source is incorrect
* handles internal links and external links (internal = flash)
* image align center support (clears word wrapping)
* correct content sizing of text height when images are present
* correct content sizing of text when images and swfs are present
* text link color enabled
* text link hover color enabled
* text link underline enabled
* stops inline swfs from continuous playing when invisible
* gives ids to all images and swfs
* access to the images
* load inline swfs / applications and call methods, pass info, dispatch events in them
* converts and then displays embedded flash objects markup
<object src="myswf" 
<embed src="myswf"
--> <img src="myswf" 
* correctly positions images and supports padding
* supports filters on images (drop shadow, glow, etc)
* converts strong to bold
* converts emphasized to italics
* converts text-decoration style to underline
* converts paragraph style text-align:left to align=left
* captures all anchors and passes them to a hook
* supports media handlers (when finding an img with src set to audio it then loads an audio player to play that audio) works for videos, image galleries, etc <-- not finished
* replaces excess linebreaks
* converts many incompatible html markup into flash compatible html markup
 * */

package com.flexcapacitor.controls {
	import com.flexcapacitor.formatters.HTMLFormatter;
	import com.flexcapacitor.managers.LinkManager;
	import com.flexcapacitor.utils.ArrayUtils;
	import com.flexcapacitor.utils.LeadingZeros;
	import com.flexcapacitor.vo.ContentLoadingItem;
	
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.TextEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.media.SoundMixer;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.system.ApplicationDomain;
	import flash.text.StyleSheet;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.utils.Timer;
	import flash.utils.clearInterval;
	import flash.utils.getTimer;
	import flash.utils.setInterval;
	import flash.utils.setTimeout;
	
	import mx.controls.SWFLoader;
	import mx.controls.Text;
	import mx.core.Application;
	import mx.core.FlexVersion;
	import mx.core.UITextField;
	import mx.core.mx_internal;
	import mx.events.FlexEvent;
	import mx.events.SWFBridgeRequest;

	
	/**
	 * 
	 * @author monkeypunch
	 */
	public class TextAutoSize extends mx.controls.Text implements IContentLoadingComponent {
		use namespace mx_internal;
		
		private var intervalId:uint;
		private var starttime:uint = getTimer();
		/**
		 * 
		 * @default 
		 */
		public var timeoutForTextOnly:uint = 1000;
		/**
		 * 
		 * @default 
		 */
		public var timeoutForImages:uint = 10000;
		/**
		 * 
		 * @default 
		 */
		public var timeout:uint = timeoutForImages;
		/**
		 * 
		 * @default 
		 */
		public var autoSizeInterval:uint = 300;
		/**
		 * 
		 * @default 
		 */
		public var cleanHTML:Boolean = true;
		/**
		 * 
		 * @default 
		 */
		public var contentLoader:URLLoader;
		/**
		 * 
		 * @default 
		 */
		public var refreshOnDisplay:Boolean = false;
		/**
		 * 
		 * @default 
		 */
		public var doNotCache:Boolean = false;
		/**
		 * 
		 * @default 
		 */
		public var debug:Boolean = false;
		/**
		 * 
		 * @default 
		 */
		public var images:Array = [];
		/**
		 * 
		 * @default 
		 */
		public var imageMediaHandler:String = "ImageMedia.swf";
		/**
		 * 
		 * @default 
		 */
		public var imageCount:int = 0;
		/**
		 * 
		 * @default 
		 */
		public var swfCount:int = 0;
		/**
		 * 
		 * @default 
		 */
		public var validImageCount:int = 0;
		/**
		 * 
		 * @default 
		 */
		public var addImageHandler:Boolean = false;
		/**
		 * 
		 * @default 
		 */
		public var textFieldReference:UITextField;
		/**
		 * 
		 * @default 
		 */
		public var startingIndex:int = 1;
		/**
		 * 
		 * @default 
		 */
		public var imageFilters:Array = [];
		/**
		 * 
		 * @default 
		 */
		public var contentLoadedDispatched:Boolean = false;
		/**
		 * 
		 * @default 
		 */
		public var contentLoadingItem:ContentLoadingItem = new ContentLoadingItem();
		
		/** 
		 * can be mx.core.UITextField or mx.core.UITLFTextField. default is mx.core.UITextField 
		 * */
		[Inspectable(category="General")]
		/**
		 * 
		 * @default 
		 */
		public var textFieldClass:String = "mx.core.UITextField";
		
		/**
		 * 
		 * @default 
		 */
		public static const CONTENT_JPEG:String = "image/jpeg";
		/**
		 * 
		 * @default 
		 */
		public static const CONTENT_PNG:String = "image/png";
		/**
		 * 
		 * @default 
		 */
		public const CONTENT_APPLICATION:String = "application/x-shockwave-flash";
		/**
		 * 
		 * @default 
		 */
		public const CONTENT_LOADED:String = "contentComplete";
		/**
		 * 
		 * @default 
		 */
		public const CONTENT_CHANGED:String = "contentChanged";
		/**
		 * 
		 * @default 
		 */
		public const CONTENT_UPDATE_COMPLETE:String = "contentUpdateComplete";
		/**
		 * 
		 * @default 
		 */
		public var LOADER_NAME:String = "textfieldloader";
		
		private var _contentLoaded:Boolean = false;
		
		/**
		 * 
		 * @return 
		 */
		public function get contentLoaded():Boolean {
			return _contentLoaded;
		}
		
		/**
		 * 
		 * @param value
		 */
		public function set contentLoaded(value:Boolean):void {
			_contentLoaded = value;
		}
		
		private var _contentLoading:Boolean = false;
		
		/**
		 * 
		 * @return 
		 */
		public function get contentLoading():Boolean {
			return _contentLoading;
		}
		
		/**
		 * 
		 * @param value
		 */
		public function set contentLoading(value:Boolean):void {
			_contentLoading = value;
		}
		
		private var _contentLoadingTimestamp:int = 0;
		
		/**
		 * 
		 * @return 
		 */
		public function get contentLoadingTimestamp():int {
			return _contentLoadingTimestamp;
		}
		
		/**
		 * 
		 * @param value
		 */
		public function set contentLoadingTimestamp(value:int):void {
			_contentLoadingTimestamp = value;
		}

		
		/**
		 * Message to display inside the text field to the user if the content of the source property is not found
		 * */
		public var errorMessage:String = "";
		
		/**
		 * 
		 * @default 
		 */
		public var application:Object;

		private var isFlex3:Boolean = FlexVersion.compatibilityVersionString=="3.0.0";
		
		/**
		 * 
		 */
		public function TextAutoSize() {
			super();
			addEventListener(Event.ADDED_TO_STAGE, addedToStage, false, 0, true);
			addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete, false, 0, true);
			addEventListener(TextEvent.LINK, linkEventHandler, false, 0, true);
			
			if (isFlex3) {
				application = Application['application'];
			}
			else {
				if (ApplicationDomain.currentDomain.hasDefinition("mx.core.FlexGlobals")) {
					application = ApplicationDomain.currentDomain.getDefinition("mx.core.FlexGlobals").topLevelApplication;
				}
				else {
					application = LinkManager.getInstance().document;
				}
			}
			
			application.addEventListener(FlexEvent.UPDATE_COMPLETE, updateComplete, false, 0, true);
			
		}
		
		/**
		 * 
		 * @param event
		 */
		public function updateComplete(event:FlexEvent):void {
			//trace("App Update Complete");
			var linkManager:LinkManager;
			
			if (isContentLoaded && !contentLoadedDispatched) {
				//trace("App Update Complete: Content Loaded");
				dispatchEvent(new Event(CONTENT_UPDATE_COMPLETE));
				removeContentLoadingListeners();
				removeContentLoadingItem();
				contentLoadedDispatched = true;
			}
			
			//trace("--- APP " + getTimer());
			//trace(" text - " + height);
			//trace(event.currentTarget + " - " + Object(event.currentTarget.stage).height);
		}

		override protected function createChildren():void {
			super.createChildren();
			
			textFieldReference = mx_internal::getTextField() as UITextField;
			
			// text field doesn't have this property
			if (textFieldReference.hasOwnProperty("textFieldClass")) {
				textFieldReference["textFieldClass"] = textFieldClass; // mx.core.UITLFTextField
			}
		}

		// add link styles
		private function onCreationComplete(event:FlexEvent) : void {
			var aHover:Object = new Object;
			aHover.textDecoration = "underline";
			aHover.color = "#0000ff";
			
			var ss:StyleSheet = new StyleSheet;
			ss.setStyle("a:hover", aHover);
			
			var aColor:Object = new Object();
			var linkColorObj:Object = getStyle("linkColor");
			var linkColorString: String;
			
			if (linkColorObj is uint ||
				linkColorObj is int ||
				linkColorObj is Number) {
				linkColorString = "#" + LeadingZeros.staticInstance.padString(Number(linkColorObj).toString(16), 6);
			}
			
			if (linkColorObj is String) {
				linkColorString = String(linkColorObj);
			}
			
			if (linkColorObj == null) {
				linkColorString = "#0000FF";
			}
			
			aColor.color = linkColorString;
			ss.setStyle("a", aColor);
			
			mx_internal::getTextField().styleSheet = ss;
		}
		
		// autosize whenever we are added to the display list
		/**
		 * 
		 * @param event
		 */
		public function addedToStage(event:Event):void {
			
			//trace("added to stage");
			if (explicitHTMLTextValue!=null) {
				//autoSize();
				//height = g;
			}
			
			if (refreshOnDisplay) {
				if (contentLoader && _source!=null && _source!="") {
					
					var request:URLRequest = new URLRequest(_source);
					
					// force refresh - need to verify
					if (doNotCache) {
						var header:URLRequestHeader = new URLRequestHeader("pragma", "no-cache");
						request.requestHeaders.push(header);
					}
					
					contentLoader.load(request);
				}
			}
		}
		
		/**
		 * 
		 * @default 
		 */
		public var explicitHTMLTextValue:String = "";
		
		private var _isContentLoaded:Boolean = false;
		
		/**
		 * 
		 * @return 
		 */
		public function get isContentLoaded():Boolean {
			var loaded:Boolean = true;
			
			for each (var imageProperty:ImageProperties in images) {
				if (!imageProperty.loaded) {
					if (imageProperty.failedToLoad) {
						continue;
					}
					loaded = false;
				}
			}
			
			_isContentLoaded = loaded;
			
			return _isContentLoaded;
		}
		
		/**
		 * 
		 * @return 
		 */
		public function get containsSWF():Boolean {
			for each (var item:ImageProperties in images) {
				if (item.contentType==CONTENT_APPLICATION) {
					return true;
				}
			}
			
			return false;
		}
		
		
		override public function set htmlText(value:String):void {
			var imageMatches:Array = [];
			var linkManager:LinkManager = LinkManager.getInstance();
			explicitHTMLTextValue = value;
			contentLoaded = false;
			
			// unload and stop all previous swfs
			unloadAndStop();
			
			// format wordpress html to look right in flash text fields
			if (cleanHTML) {
				value = HTMLFormatter.staticInstance.format(value);
			}
			
			// give id's to images / swfs
			value = HTMLFormatter.staticInstance.addImageIds(value, LOADER_NAME, startingIndex);
			
			// get image matches
			imageMatches = HTMLFormatter.staticInstance.getImageMatches(value);
			
			// create lookup table
			createImagesLookup(imageMatches);
			
			// get image count
			imageCount = HTMLFormatter.staticInstance.getImageCount(value);
			
			swfCount = getSWFCount();
			
			application.addEventListener(FlexEvent.UPDATE_COMPLETE, updateComplete, false, 0, true);
			
			if (imageCount > 0) {
				contentLoaded = false;
				
				// PREVENTS an ERROR# 2006 index out of bounds error because swf is 
				// not a child of the text field 
				// so when you tab into a swf Application the system manager throws that error
				tabChildren = false;
				
				addEventListener(Event.ENTER_FRAME, imageReferenceHandler, false, 0, true);
				
				// add media handlers
				// TODO: add system to dynamically add media handlers (image, sound, video, etc)
				if (addImageHandler) {
					value = HTMLFormatter.staticInstance.addImageMediaHandler(value, imageMediaHandler);
				}
				
			}
			else {
				contentLoaded = true;
			}
			
			contentLoadedDispatched = false;
			
			removeContentLoadingItem(false);
			
			addContentLoadingItem();
			
			super.htmlText = value;
			
			dispatchEvent(new Event(CONTENT_CHANGED));
			
			
		}
		
		/**
		 * 
		 */
		public function unloadAndStop():void {
			
			for each (var item:ImageProperties in images) {
				var loader:Loader = getImageReference(item.id);
				
				if (item.isSWF && loader!=null && loader.hasOwnProperty("unloadAndStop")) {
					loader['unloadAndStop']();
					SoundMixer.stopAll();
				}
			}
		}
		
		/**
		 * 
		 */
		public function addContentLoadingItem():void {
			var linkManager:LinkManager = LinkManager.getInstance();
			var time:Number = getTimer();
			contentLoadingItem.id = (instanceIndex>-1) ? id + instanceIndex : id;
			contentLoadingItem.objectId = id + time;
			contentLoadingItem.path = Object(this).toString();
			contentLoadingItem.hasLoaded = contentLoaded;
			contentLoadingItem.isLoading = !contentLoaded;
			contentLoadingItem.timestamp = time;
			
			linkManager.addContentLoadingItem(contentLoadingItem);
		}
		
		/**
		 * 
		 * @param dispatchEvents
		 */
		public function removeContentLoadingItem(dispatchEvents:Boolean = true):void {
			if (contentLoadingItem==null) return;
			var linkManager:LinkManager = LinkManager.getInstance();
			contentLoadingItem.hasLoaded = contentLoaded;
			contentLoadingItem.isLoading = !contentLoaded;
			linkManager.removeContentLoadingItem(contentLoadingItem, dispatchEvents);
		}
		
		/**
		 * 
		 * @param event
		 */
		public function imageReferenceHandler(event:Event):void {
			validImageCount = 0;
			
			imageCount = HTMLFormatter.staticInstance.getImageCount(htmlText);
			var length:int = imageCount + startingIndex;
			
			if (imageCount > 0) {
				
				for (var i:int=startingIndex;i<length;i++) {
					
					var image:Loader = new Loader();
					var name:String = LOADER_NAME+i;
					
					var itemIndex:int = ArrayUtils.getItemIndexByProperty(images, "id", name);
					
					if (itemIndex!=-1) {
						var imageProperties:ImageProperties = images[itemIndex];
						if (imageProperties.created) {
							continue;
						}
					}
					
					image = textFieldReference.getImageReference(name) as Loader;
					
					if (image!=null) {
						image.name = name;
						if (imageProperties) {
							imageProperties.created = true;
						}
						
						if (!imageProperties.filtersApplied) {
							applyImageFilters(imageProperties);
						}
						
						if (image.contentLoaderInfo.bytesLoaded<image.contentLoaderInfo.bytesTotal || image.contentLoaderInfo.bytesTotal==0) {
							image.contentLoaderInfo.addEventListener(Event.COMPLETE, shimLoaded, false, 0, true);
							image.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler, false, 0, true);
						}
						else {
							addContentListeners(image.contentLoaderInfo);
						}
						
					}
				}
			}
			
			if (contentLoaded) {
				removeEventListener(Event.ENTER_FRAME, imageReferenceHandler, false);
			}
			else {
				contentLoadedHandler();
			}
			
		}
		
		/**
		 * 
		 * @param event
		 */
		public function shimLoaded(event:Event):void {
			// check if its a shim or an image
			// from wikipedia
			// In computer programming, a shim is a small library that transparently intercepts an API, changing the parameters passed, handling the operation itself, or redirecting the operation elsewhere. ...
			//trace("Image loaded ", event.currentTarget);
			addContentListeners(event.currentTarget as LoaderInfo);
		}
		
		/**
		 * 
		 * @param loaderInfo
		 */
		public function addContentListeners(loaderInfo:LoaderInfo):void {
			var name:String = loaderInfo.loader.name;
			var itemIndex:int = ArrayUtils.getItemIndexByProperty(images, "id", name);
			var item:ImageProperties;
			
			if (itemIndex!=-1) {
				item = images[itemIndex];
			}
			else {
				item = new ImageProperties();
				item.id = name;
			}
			
			item.contentType = loaderInfo.contentType;
			
			// IMAGE LOADED
			if (loaderInfo.contentType==CONTENT_JPEG || loaderInfo.contentType==CONTENT_PNG) {
				item.loaded = true;
				item.isSWF = false;
				
				// set actual swf dimensions
				item.actualWidth = loaderInfo.width;
				item.actualHeight = loaderInfo.height;
			}
			
			// SWF APPLICATION LOADED
			else if (loaderInfo.contentType==CONTENT_APPLICATION) {
				item.isSWF = true;
				
				// set actual swf dimensions
				if (!item.actualSizeSpecified) {
					item.actualWidth = loaderInfo.width;
					item.actualHeight = loaderInfo.height;
				}
				
				if (loaderInfo.childAllowsParent && loaderInfo.content!=null && Object(loaderInfo.content).application!=null) {
					Object(loaderInfo.content).application.addEventListener(FlexEvent.APPLICATION_COMPLETE, loadedApplicationComplete, false, 0, true);
				}
				else {
					item.loaded = true;
				}
			}
			
			else {
				item.loaded = true;
			}
			
			contentLoadedHandler();
		}
		
		/**
		 * 
		 * @param event
		 */
		public function loadedApplicationComplete(event:FlexEvent):void {
			var application:Application;
			var loaderName:String = event.currentTarget.parent.name;
			var item:ImageProperties = getImagePropertyObjectByName(loaderName);
			
			// current target is system manager
			// pass in image and load it in
			if (event.currentTarget.hasOwnProperty("application")) {
				event.currentTarget.removeEventListener(FlexEvent.APPLICATION_COMPLETE, loadedApplicationComplete);
				application = event.currentTarget.application;
				
				// if a shim then listen for the loader in the shim
				if (application.hasOwnProperty("setValue")) {
					Object(application).loader.addEventListener(Event.COMPLETE, imageLoaded, false, 0, true);
					Object(application).loader.addEventListener(IOErrorEvent.IO_ERROR, imageLoadedFault, false, 0, true);
					Object(application).setValue(item, event.currentTarget, this);
				}
				else {
					item.loaded = true;
				}
			}
			else {
				item.loaded = true;
			}
			
			contentLoadedHandler();
			
		}
		
		/**
		 * 
		 */
		public function removeContentLoadingListeners():void {
			removeEventListener(Event.ENTER_FRAME, imageReferenceHandler, false);
		}
		
		// passed image is loaded
		/**
		 * 
		 * @param event
		 */
		public function imageLoaded(event:Event):void {
			trace("Media Handler Content Loaded");
			var currentLoaderName:String = event.currentTarget.parent.loaderName;
			var item:ImageProperties = getImagePropertyObjectByName(currentLoaderName);
			var loader:Loader = getImageReference(currentLoaderName);

			item.loaded = true;
			if (item.width==0 && item.height==0) {
				item.width = loader.contentLoaderInfo.width;
				item.height = loader.contentLoaderInfo.height;
			}
			
			if (loader.contentLoaderInfo.contentType==CONTENT_JPEG || loader.contentLoaderInfo.contentType==CONTENT_PNG) {
				
				if (item.clear) {
					//loader.mask.width = width;
					loader.content.x = loader.mask.width/2 - loader.content.width/2 - item.hspace;
					loader.scaleX = 1;
				}
				
			}
			
			// get the requested width and height
			// set the width and height on the img tag - use id
			// replace html text with width and height set - wish there was a better way to do this
		}
		
		// media handler image load failed
		/**
		 * 
		 * @param event
		 */
		public function imageLoadedFault(event:IOErrorEvent):void {
			trace("Media Handler Content Failed to Load");
			var currentLoaderName:String = event.currentTarget.parent.name;
			var item:ImageProperties = getImagePropertyObjectByName(currentLoaderName);
			item.failedToLoad = true;
			// get the requested width and height
			// set the width and height on the img tag - use id
			// replace html text with width and height set - wish there was a better way to do this
		}
		
		/**
		 * 
		 * @param name
		 * @return 
		 */
		public function getImageReference(name:String):Loader {
			return textFieldReference.getImageReference(name) as Loader;
		}
		
		/**
		 * 
		 * @param event
		 */
		public function ioErrorHandler(event:IOErrorEvent):void {
			var name:String = LoaderInfo(event.currentTarget).loader.name;
			
			trace("TextAutoSize: Image not found.", event.text);
			
			var itemIndex:int = ArrayUtils.getItemIndexByProperty(images, "id", name);
			
			if (itemIndex!=-1) {
				var imageProperties:ImageProperties = images[itemIndex];
				imageProperties.failedToLoad = true;
			}
			
			contentLoadedHandler();
			
		}
		
		/**
		 * 
		 * @param name
		 * @return 
		 */
		public function getImagePropertyObjectByName(name:String):ImageProperties {
			for each (var item:ImageProperties in images) {
				if (item.id == name) {
					return item;
				}
			}
			return item;
		}
		
		/**
		 * 
		 * @return 
		 */
		public function getSWFCount():int {
			var swfCount:int = 0;
			for each (var item:ImageProperties in images) {
				if (item.contentType == CONTENT_APPLICATION) {
					swfCount++;
				}
			}
			return swfCount++;
		}
		
		/**
		 * 
		 * @param matches
		 */
		public function createImagesLookup(matches:Array = null):void {
			images.length = 0;
			
			if (matches!=null && matches.length >0) {
				
				for (var i:int=0;i<matches.length;i++) {
					var newImage:ImageProperties = new ImageProperties();
					var xmlNode:XML = new XML("<root>"+matches[i]+"</root>");
					var attributes:XMLList = xmlNode.img.attributes(); //String(matches[i]).split(/\s+/g);
					var id:String = xmlNode.img.@id;
					var itemPair:Array;
					var attNamesList:XMLList = xmlNode.img.@*;
					var attLength:int = XMLList(attributes).length();
					var attributeName:String = "";
					
					for (var j:int = 0; j < attLength; j++) {
						attributeName = String(attributes[j].name()).toString().toLowerCase();
						if (attributeName=="hspace" || attributeName=="vspace" || 
							attributeName=="width" || attributeName=="height") {
							newImage[attributeName] = Number(attributes[j]);
						}
						else if (attributeName=="actualwidth") {
							newImage.actualWidth = Number(attributes[j]);
						}
						else if (attributeName=="actualheight") {
							newImage.actualHeight = Number(attributes[j]);
						}
						else {
							newImage[attributeName] = String(attributes[j]);
						}
					}
					
					if (newImage.width==0 && newImage.height==0) {
						newImage.sizeSpecified = false;
					}
					else {
						newImage.sizeSpecified = true;
					}
					
					if (newImage.actualWidth==0 && newImage.actualHeight==0) {
						newImage.actualSizeSpecified = false;
					}
					else {
						newImage.actualSizeSpecified = true;
					}
					
					// check for wordpress "aligncenter"
					if (newImage.hasOwnProperty('class')) {
						var alignment:String = newImage['class'];
						if (alignment.toLowerCase().indexOf("aligncenter")!=-1) {
							newImage.align = "center";
						}
					}
					
					if (newImage.align=="center" || newImage.align=="clear") {
						newImage.clear = true;
					}
					else {
						newImage.clear = false;
					}
					
					if (newImage.align=="") {
						newImage.align = "left";
					}
					
					newImage.content = matches[i];
					
					images.push(newImage);
				}
			}
		}
		
		/**
		 * 
		 * @param item
		 */
		public function applyImageFilters(item:ImageProperties = null):void {
			var loader:Loader;
			
			if (item!=null) {
				if (item.created) {
					loader = getImageReference(item.id);
					
					if (loader!=null && imageFilters.length!=0) {
						loader.filters = imageFilters;
						item.filtersApplied = true;
					}
				}
			}
			else {
				for each (var item:ImageProperties in images) {
					
					if (item.created) {
						loader = getImageReference(item.id);
						
						if (loader!=null && imageFilters.length!=0) {
							loader.filters = imageFilters;
							item.filtersApplied = true;
						}
					}
				}
			}
		}
		
		/**
		 * 
		 * @param event
		 */
		public function linkEventHandler(event:TextEvent):void {
			var link:String = event.text;
			link = link.replace("event:","");
			
			var linkManager:LinkManager = LinkManager.getInstance();
			linkManager.handleHyperlink(link, "", this);
		}

		
		/** 
		 * lets you point the source of the text to a file or url
		 * */
		[Inspectable(category="General")]
		/**
		 * 
		 * @param value
		 */
		public function set source(value:String):void {
			if (value=="" || value==null) return;
			_source = value;
			
			var request:URLRequest = new URLRequest(_source);
			
			if (!contentLoader) {
				contentLoader = new URLLoader();
				contentLoader.addEventListener(IOErrorEvent.IO_ERROR, sourceLoadFault, false, 0, true);
				contentLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, sourceLoadFault, false, 0, true);
				contentLoader.addEventListener(Event.COMPLETE, sourceLoaded, false, 0, true);
			}

			// force refresh - need to verify this works
			if (doNotCache) {
				var header:URLRequestHeader = new URLRequestHeader("pragma", "no-cache");
				request.requestHeaders.push(header);
			}
			
			try {
				contentLoader.load(request);
			} 
			catch (error:Error) {
				trace("Unable to load requested document at " + _source);
			}

			
			
		}
		
		/**
		 * 
		 * @return 
		 */
		public function get source():String {
			return _source;
		}
		private var _source:String;
		
		/**
		 * 
		 * @param event
		 */
		public function sourceLoaded(event:Event):void {
			var loader:URLLoader = URLLoader(event.target);
			dispatchEvent(event);
			
			htmlText = loader.data;
		}
		
		/**
		 * 
		 * @param event
		 */
		public function sourceLoadFault(event:Event):void {
			
			dispatchEvent(event);
			
			if (errorMessage!="") {
				htmlText = errorMessage;
			}
			
			if (debug) {
				trace("TextAutoSize: " + event.toString());
			}
			
		}
		
		/**
		 * 
		 */
		public function setLoaderSize():void {
			for each (var item:ImageProperties in images) {
				
				if (item.created) {
					var loader:Loader = getImageReference(item.id);
					
					if (item.sizeSpecified && !item.isSWF) {
						loader.width = (item.width!=0) ? item.width : loader.width;
						loader.height = (item.height!=0) ? item.height : loader.height;
					}
					
					else if (item.sizeSpecified && item.actualSizeSpecified && item.isSWF) {
						
						//loader.width = (item.actualWidth!=item.width) ? item.actualWidth : item.width;
						//loader.height = (item.actualHeight!=item.height) ? item.actualHeight : item.height;
					}
					/*
					else if (loader.content!=null) {
						loader.width = loader.contentLoaderInfo.width;
						loader.height = loader.contentLoaderInfo.height;
						
						if (Object(loader.content).hasOwnProperty("application") && Object(loader.content).application!=null) {
							//Object(loader.content).application.width = loader.contentLoaderInfo.width;
						}
						//loader.mask.width = loader.contentLoaderInfo.width;
						//loader.mask.height = loader.contentLoaderInfo.height;
						//loader.stage.scaleMode = StageScaleMode.NO_SCALE;
					}*/
				}
			}
		}
		
		/**
		 * 
		 */
		public function setLoaderScale():void {
			
			for each (var item:ImageProperties in images) {
				if (item.created) {
					var loader:Loader = getImageReference(item.id);
					
					if (!item.isSWF) {
						
						if (item.clear && loader.content!=null) {
							//loader.mask.width = width;
							loader.content.x = loader.mask.width/2 - loader.content.width/2 - item.hspace;
							loader.scaleX = 1;
						}
						
						continue;
					}
						
					else if (item.sizeSpecified && item.actualSizeSpecified && item.isSWF) {
						
						loader.scaleX = (item.actualWidth!=item.width) ? item.width/item.actualWidth : item.width;
						loader.scaleY = (item.actualHeight!=item.height) ? item.height/item.actualHeight : item.height;
						/*var bridge:IEventDispatcher = swfBridge;
						if (bridge)
						{
						var pt:Point = new Point();
						var request:SWFBridgeRequest = new SWFBridgeRequest(SWFBridgeRequest.GET_SIZE_REQUEST);
						bridge.dispatchEvent(request);
						pt.x = request.data.width;
						pt.y = request.data.height;
						}*/
					}
					
					if (loader.contentLoaderInfo.bytesLoaded>0 && 
						loader.contentLoaderInfo.bytesLoaded==loader.contentLoaderInfo.bytesTotal &&
						loader.contentLoaderInfo.childAllowsParent && loader.content!=null) {
						//loader.stage.scaleMode = StageScaleMode.NO_SCALE;
						loader.scaleX = 1;
						loader.scaleY = 1;
					}
					/*
					loader.width = imageProperties.width + 1;
					loader.width = imageProperties.width;
					loader.scaleX = 1;*/
				}
			}
		}
		
		/**
		 * 
		 */
		public function positionImages():void {
			
			for each (var item:ImageProperties in images) {
				if (item.created) {
					var loader:Loader = getImageReference(item.id);

					if (!item.isSWF && item.loaded && loader.width!=0) {
						
						if (loader.contentLoaderInfo.childAllowsParent && loader.contentLoaderInfo.content!=null) {
							// center image
							if (item.align=="center") {
								//loader.mask.width = width;
								loader.content.x = loader.mask.width/2 - loader.content.width/2 - item.hspace;
								loader.scaleX = 1;
							}
							
							// get rid of margin above and to the side of the image
							else if (loader.x!=0 && item.align=="left") {
								loader.content.x = (item.hspace!=0) ? -(item.hspace/2) : 0;
								loader.content.y = (item.vspace!=0) ? -(item.vspace/2) : 0;
							}
							
							else if (!item.contentPositioned && item.align=="right") {
								loader.content.x = (item.hspace!=0) ? (item.hspace/2) : 0;
								loader.content.y = (item.vspace!=0) ? -(item.vspace/2) : 0;
								item.contentPositioned = true;
							}
						}
						
						else if(!loader.contentLoaderInfo.childAllowsParent && loader.filters.length==0) {
							
							// center image
							if (item.align=="center") {
								//loader.mask.width = width;
								loader.x = loader.mask.width/2 - loader.contentLoaderInfo.width/2 - item.hspace;
								loader.scaleX = 1;
							}
							
							// get rid of margin above and to the side of the image
							else if (item.align=="left") {
								loader.x = 5;
								loader.y = 5;
							}
							
							else if (item.align=="right") {
								loader.x = 5;
								loader.y = 5;
							}
						}
					}
				}
			}
		}
		
		private function unScaleContent(loader:Loader):void {
			loader.scaleX = 1.0;
			loader.scaleY = 1.0;
			loader.x = 0;
			loader.y = 0;
		}
		
		/**
		 * 
		 */
		public function contentLoadedHandler():void {
		
			if (isContentLoaded) {
				//trace("ALL CONTENT LOADED");
				contentLoaded = true;
				dispatchEvent(new Event(CONTENT_LOADED));
				removeContentLoadingListeners();
				// force update of display
				height = 1;
				if (textFieldReference.width!=width) {
					textFieldReference.width = width;
				}
				positionImages();
				var timer:Timer = new Timer(50, 40);
				timer.addEventListener(TimerEvent.TIMER, updateFilters, false, 0, true);
				timer.addEventListener(TimerEvent.TIMER_COMPLETE, updateFiltersComplete, false, 0, true);
				timer.start();
			}
			
		}
		
		/**
		 * 
		 * @param event
		 */
		public function updateFilters(event:TimerEvent):void {
			event.updateAfterEvent();
			applyImageFilters();
			validateHeightNow();
		}
		
		/**
		 * 
		 * @param event
		 */
		public function updateFiltersComplete(event:TimerEvent):void {
			event.updateAfterEvent();
		}
		
		/**
		 * 
		 */
		public function validateHeightNow():void {
			invalidateDisplayList();
			validateNow();
		}
		
		/**
		 * 
		 * @return 
		 */
		public function getTextFieldHeight():int {
			var textFieldHeight:int = 0;
			
			if (textFieldReference.width!=width) {
				textFieldReference.width = width;
			}
			
			textFieldReference.autoSize = TextFieldAutoSize.LEFT;
			textFieldHeight = textFieldReference.height + 3;
			
			//trace("TFH " + textFieldHeight);
			textFieldReference.invalidateDisplayList();
			textFieldReference.validateNow();
			textFieldHeight = textFieldReference.height + 3;
			//trace("TFH V " + textFieldHeight);
			
			return textFieldHeight;
		}
		
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
			var textFieldHeight:int = getTextFieldHeight();
			
			// CONTAINS NO IMAGES
			if (imageCount==0) {
				
				if (textFieldHeight!=unscaledHeight) {
					height = textFieldHeight;
				}
				else {
					super.updateDisplayList(unscaledWidth, unscaledHeight);
				}
				
				return;
			}
			
			// CONTAINS IMAGES
			if (imageCount>0 && !containsSWF) {
				
				if (textFieldHeight!=unscaledHeight) {
					height = textFieldHeight;
				}
				else {
					super.updateDisplayList(unscaledWidth, unscaledHeight);
				}
				positionImages();
				return;
			}
			
			// CONTAINS SWFS
			if (imageCount>0 && containsSWF) {
				setLoaderSize();
				textFieldHeight = getTextFieldHeight();
				//setLoaderScale();
				
				if (textFieldHeight!=unscaledHeight) {
					validateNow();
					height = textFieldHeight;
					//super.updateDisplayList(unscaledWidth, textFieldHeight);
				}
				else {
					super.updateDisplayList(unscaledWidth, unscaledHeight);
				}
				positionImages();
				return;
			}
		}

	}
}