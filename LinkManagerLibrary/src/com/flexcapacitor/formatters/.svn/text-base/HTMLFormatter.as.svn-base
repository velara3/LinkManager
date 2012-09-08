

// Cleans up HTML from some locations like wordpress
// this is by no means a real HTML to FTML convert but a transient until TLF comes out
// 
// Usage 
// <!-- Declare a formatter and specify formatting properties. --> 
// <components:HTMLFormatter id="htmlFormatter"/>
// <mx:Text width="100%" htmlText="Your wordpress content is {htmlFormatter.format(wordpressDescription)}"/> 


package com.flexcapacitor.formatters {
	
	import mx.core.FlexVersion;
	import mx.formatters.Formatter;
	import mx.utils.ObjectUtil;
	import mx.utils.StringUtil;
	import mx.utils.URLUtil;

	public class HTMLFormatter extends Formatter {
		
		// add more here
		public var findLineBreaksPattern:RegExp = /\r?\n+?/g;
   		public var strongStartPattern:RegExp = /<strong>/gi;
   		public var strongEndPattern:RegExp = /<\/strong>/gi;
   		public var emphasizedStartPattern:RegExp = /<em>/gi;
   		public var emphasizedEndPattern:RegExp = /<\/em>/gi;
   		
   		// <span style="text-decoration: underline;">underline</span>
   		public var spanUnderlinePattern:RegExp = /(<span[^>]+style="[^"]*)text-decoration:\s*underline;?([^"]*"[^>]*>)(.*?)(<\/span>)/gi;
   		public var spanUnderlinePatternReplace:String = '$1$2<u>$3</u>$4';
   		
   		// remove span from underline 
   		// <span style=";"><u>underline</u></span>
   		// to <u>underline</u>
   		public var spanUnderlinePatternEmpty:RegExp = /<span\s*style=";?"><u>(.*)<\/u><\/span>/gi;
   		public var spanUnderlinePatternEmptyReplace:String = "<u>$1</u>";
   		
   		// <p style="text-align:left">
   		// to <p align="left">
   		public var styleAlignPattern:RegExp = /<p([^>]+)style="(.*)text-align:\s?(\w+)([^"])"([^>]*)>/gi;
   		public var styleAlignPatternReplace:String = '<p$1style="$2$4" align="$3">';
   		
   		// span styles
   		// <span style="text-align:left;font-weight:bold;">
   		// to <span class="class1" />
   		public var stylesPattern:RegExp = /<(span|p)[^>]+style="([^"]*)"[^>]*>(.*?)(<\/span>)/i;
   		
   		// anchor
   		// <a href="http://google.com">link</a>
   		// to <a href="event:http://google.com">link</a>
   		public var anchorPattern:RegExp = /<a([^>]+)href="([^"]*)"([^>]*)>(.*?)(<\/a>)/i;
   		public var anchorPatternReplace:String = "<a$1href=\"event:$2\"$3>$4$5";
		
		public var imageTag:RegExp = /<img[^>]*>/gi;
		public var imageTagSource:RegExp = /<img[^>]*src="(?P<src>[^"]*)"[^>]*>/gim;
		
		public var imageTagAlign:RegExp = /<img([^>]+)(align|class)="(center|clear|aligncenter+)"([^>]*)>/i;
		
		public var objectEmbedTag:RegExp = /<(embed)([^>]*)><\/embed>/gim;
		
		// remove and add id attribute
		public var imagesWithoutIdsPattern:RegExp = /<(img)\s+?(?!id=")([^>]*)>/i;
		public var imagesWithoutIdsPatternReplace:String = "<img $1>";
		public var removeImagesIdsPattern:RegExp = /<img([^>]+)id="[^"]*"([^>]*)>/gi;
		public var removeImagesIdsPatternReplace:String = "<img$1$2>";
		
		public var mediaHandlerLocation:String = "ImageMedia.swf";
		public var mediaHandlerParameter:String = "?url=";
		public var addMediaPattern:RegExp = /<(img)([^>]+)(src)="(?!ImageMedia.swf)([^"]*(jpg|png|gif))"([^>]*)>/gi;
   		public var addMediaPatternReplace:String = "<$1$2$3=\"" + mediaHandlerLocation + "$4\"$6>";
		
		[Inspectable(category="General", defaultValue="false")]
   		public var addEventToHREF:Boolean = false;
   		
		[Inspectable(category="General", defaultValue="true")]
   		public var replaceStrongTags:Boolean = true;
   		
		[Inspectable(category="General", defaultValue="true")]
   		public var replaceEmphasizedTags:Boolean = true;
   		
		[Inspectable(category="General", defaultValue="true")]
   		public var replaceUnderlineSpan:Boolean = true;
   		
		[Inspectable(category="General", defaultValue="true")]
   		public var replaceLinebreaks:Boolean = true;
   		
		[Inspectable(category="General", defaultValue="true")]
   		public var replaceStyleAlignTags:Boolean = true;
   		
		[Inspectable(category="General", defaultValue="true")]
   		public var replaceListItems:Boolean = true;
   		
		[Inspectable(category="General", defaultValue="true")]
   		public var replaceStyles:Boolean = true;
   		
		[Inspectable(category="General", defaultValue="true")]
   		public var dispatchEventForAnchors:Boolean = true;
		
		[Inspectable(category="General", defaultValue="true")]
		public var supportImageAlignCenter:Boolean = true;
		
		[Inspectable(category="General", defaultValue="true")]
		public var removeExtraLineBreaks:Boolean = true;
		
		[Inspectable(category="General", defaultValue="true")]
		public var supportObjectEmbedCode:Boolean = true;

		// the TextAutoSize components have a cleanWordpressHTML property
		// when this is enabled we use get this instance as a sort of singleton
		// so there is only one instance created for the Text components when they need to use the format command
		// it is accessed like this HTMLFormatter.staticInstance.format(value);
		public static var staticInstance:HTMLFormatter = new HTMLFormatter();
   		
   		// array of classes
   		// we convert styles to a class and then check if a class exists with the same styles
   		public var classes:Array = [];
		
		// if we are using a TLF text area set this to true
		// defaults to true in Flex 4 and greater
		public var isTLF:Boolean = false;
		
		public var isFlex3:Boolean = FlexVersion.compatibilityVersionString=="3.0.0";
		
		
		public function HTMLFormatter() {
			//TODO: implement function
			super();
			
			if (!isFlex3) {
				isTLF = true;
			}
			
		}
		
		// Override format()
		// default is to format HTML to Flash compatible HTML or FTML (flash text markup language)
		// useful for fixing wordpress html
		// set formatString equal to "wordpress" or leave blank for default behavior
        override public function format(value:Object):String { 
			if (value==null) return "";
			var pattern:RegExp;
	        var match:Array;
	        var stylesObject:Object;
	        var spanContent:String = "";
	        var tagName:String = "";
	        var attributes:String = "";
	        var tags:Array = [];
	        var originalContent:String = "";
	        var newString:String = "";
	        var stylesString:String = "";
			
			if (value is XMLList) {
				value = value.toString();
			}
            
            // NOTE: What would probably be better is to grab the styles string and parse it 
            // into an object we can inspect. You can use URLUtils.stringToObject() for this
            
			// replace linebreaks with <br> tags
			if (replaceLinebreaks) {
				value = value.replace(findLineBreaksPattern,"<br/>");
			}
			
			// replace Strong tags with bold tags
			if (replaceStrongTags) {
				value = value.replace(strongStartPattern,"<b>");
				value = value.replace(strongEndPattern,"</b>");
			}
			
			// replace Emphasized tags with italic tags
			if (replaceEmphasizedTags) {
				value = value.replace(emphasizedStartPattern,"<i>");
				value = value.replace(emphasizedEndPattern,"</i>");
			}
			
			// dispatch event for Anchor tags
			// adds "event:" to href
   			// <a href="http://google.com">link</a>
   			// to <a href="event:http://google.com">link</a>
			if (dispatchEventForAnchors) {
				value = value.replace(anchorPattern, anchorPatternReplace);
			}
			
			// replace Span tag with Font tag
			// if paragraph replace styles with attributes
			// if span replace span with font - don't know if this is the best approach
			// thought about passing styles into a class and setting the span to the class
			// but a few problems
			// - have to know about and get reference to textfield to apply the class
			// - forgot second reason - maybe bc it could slow down rendering assuming classes slow down rendering
			match = value.match(stylesPattern);
			
			while (match!=null) {
				match = value.match(stylesPattern);
				if (match==null) continue;
				
				tags.length = 0;
				
	        	originalContent = (match.length>0) ? match[0] : "";
	        	tagName = (match.length>1) ? match[1] : "";
	        	stylesString = (match.length>2) ? match[2].replace(/:/g,"=") : "";
	        	stylesObject = (match.length>2) ? URLUtil.stringToObject(stylesString) : "";
	        	spanContent = (match.length>3) ? match[3] : "";
		        
		        // remove nulls and lowercase style names
		        for (var style:String in stylesObject) {
		        	value = StringUtil.trim(stylesObject[style]);
		        	
	            	// check for and remove parameters with value of "=null;"
	            	if (style!="" && style!=null) {
	            		// create a lowercase property name
						delete(stylesObject[style]);
	            		stylesObject[style.toLowerCase()] = value;
		            }
		            else {
		            	delete(stylesObject[style]);
		            }

		        }
		        
		        // maybe should break these out into methods
		        // if paragraph set attributes
		        if (tagName.toLowerCase()=="p") {
		        	
		        	if (stylesObject.hasOwnProperty("color")) {
		        		// whatever don't care about paragraphs right now
		        	}
		        	newString = originalContent;
		        }
		        
		        // if span set attributes and replace span with font
		        else if (tagName.toLowerCase()=="span") {
		        	attributes = "";
		        	
		        	if (stylesObject.hasOwnProperty("color")) {
		        		attributes += " color=\""+value+"\"";
		        	}
		        	
		        	if (stylesObject.hasOwnProperty("font-family")) {
		        		attributes += " face=\""+value+"\"";
		        		
		        	}
		        	
		        	if (stylesObject.hasOwnProperty("font-size")) {
		        		attributes += " size=\""+value+"\"";
		        		
		        	}
		        	
		        	if (stylesObject.hasOwnProperty("text-align")) {
		        		attributes += " align=\""+value+"\"";
		        		
		        	}
		        	
		        	if (stylesObject.hasOwnProperty("text-decoration") ) {
		        		if (value=="underline") {
		        			tags.push("u");
		        		}
		        	}
		        	
		        	if (stylesObject.hasOwnProperty("font-weight") ) {
		        		if (value=="bold") {
		        			tags.push("b");
		        		}
		        	}
		        	
		        	// add custom tags
		        	for (var i:int = 0;i<tags.length;i++) {
		        		spanContent = "<"+tags[i]+">"+spanContent+"</"+tags[i]+">";
		        	}
		        	
		        	tagName = "font";
		        	
		        	newString = "<"+tagName+attributes+">"+spanContent+"</"+tagName+">";
		        }
		        
		        value = value.replace(stylesPattern, newString);
		        
			}
			
			// replace Text Align style with align attribute 
			// <p style="text-align:left"> to
			// <p align="left">
			if (replaceStyleAlignTags) {
				value = value.replace(styleAlignPattern, styleAlignPatternReplace);
			}
			
			// replace Underline span with Underline tags
			if (replaceUnderlineSpan) {
				value = value.replace(spanUnderlinePattern, spanUnderlinePatternReplace);
				value = value.replace(spanUnderlinePatternEmpty, spanUnderlinePatternEmptyReplace);
			}
			
			// replace list items
			// TODO: do this
			if (replaceListItems) {
				pattern= /<\/li><li>/g;
				value = value.replace(pattern, "</LI><LI>");
				pattern= /<\/li><\/ul>/g;
				value = value.replace(pattern, "</LI>");
				pattern= /<ul><li>/g;
				value = value.replace(pattern, "<LI>");
			}
			
			// replace embed with images
			if (supportObjectEmbedCode) {
				value = value.replace(objectEmbedTag, "<img$2 align=\"center\"/><br/>");
			}
			
			// clear content for images with align=center
			if (supportImageAlignCenter) {
				value = addImageAlignCenter(value);
			}
			
			// replace linebreaks with <br> tags
			if (removeExtraLineBreaks) {
				value = value.replace(/<\/p><br\s?\/?><br\s?\/?>/g,"</p><br/>");
			}

            return String(value); 
        }
        
        // not used
        // was going to be used to parse out styles and apply a class
        // this function would check if an exact same class (same styles) existed
        // if it did then return that class if not then create a new one
        // then pass that class back and assign it to the span or class
        public function addStylesToClass(styles:String):String {
        	var o:Object = URLUtil.stringToObject(styles, null, false);
        	var classFound:Boolean = false;
        	var className:String = "";
        	var stylesClass:Object;
        	
        	for (className in classes) {
        		stylesClass = classes[className];
        		
        		if (ObjectUtil.compare(stylesClass, o)) {
        			classFound = true;
        			break;
        		}
        	}
        	
        	if (classFound) {
        		return className;
        	}
        	else {
        		className = "class" + classes.length;
        		classes[className] = o;
        	}
        	return className;
        }
        
		/**
		 * Returns the source of the first image tag found
		 * Note: Looks for "src" not "source"
		 * */
		public function getImageSource(value:String):String {
			if (value==null) { return ""; }
			
			var matches:Array = new Array();
			
			// get image src
			matches = imageTagSource.exec(value);
			value = (matches!=null && matches.hasOwnProperty("src")) ? matches.src : "";
			return value;
		}
		
		/**
		 * Returns the HTML of the first image tag found in value passed in
		 * */
		public function getImageHTML(value:String):String {
			if (value==null) { return ""; }
			
			var matches:Array;
			
			// get image html markup
			matches = value.match(imageTagSource);
			value = (matches.length > 0) ? matches[0] : "";
			
			return value;
		}
		
		// adds id's to image tags
		public function addImageIds(value:String, prefix:String = "loader", startingIndex:int = 0):String {
			if (value==null) return "";
			var originalContent:String = "";
			var beggining:String = "";
			var attributes:String = "";
			var name:String = "";
			var tag:String = "";
			var index:int = startingIndex;
			var match:Array;
			
			value = value.replace(removeImagesIdsPattern, removeImagesIdsPatternReplace);
			match = value.match(imagesWithoutIdsPattern);
			
			while (match!=null) {
				match = value.match(imagesWithoutIdsPattern);
				if (match==null) continue;
				
				originalContent = (match.length>0) ? match[0] : "";
				tag = (match.length>1) ? match[1] : "";
				attributes = (match.length>2) ? match[2] : "";
				name = prefix + index;
				value = value.replace(originalContent, "<" + tag + " id=\"" + name + "\" " + attributes + ">");
				index++;
			}
			
			return value;
		}
		
		// fix image align center
		public function addImageAlignCenter(value:Object):Object {
			if (value==null) return "";
			var originalContent:String = "";
			var beforeAttributes:String = "";
			var afterAttributes:String = "";
			var alignValue:String = "";
			var newContent:String = "";
			var attributeName:String = "";
			var wrapperBefore:String = "<textformat leading=\"";
			var wrapperAfter:String = "<br/></textformat>";
			var match:Array;
			var heightMatch:Array;
			var height:int = 0;
			
			match = value.match(imageTagAlign);
			
			while (match!=null) {
				match = value.match(imageTagAlign);
				if (match==null) continue;
				
				originalContent = (match.length>0) ? match[0] : "";
				beforeAttributes = (match.length>1) ? match[1] : "";
				attributeName = (match.length>2) ? match[2] : "";
				alignValue = (match.length>3) ? match[3] : "";
				afterAttributes = (match.length>4) ? match[4] : "";
				heightMatch = originalContent.match(/height="([^"]+)"/i);
				if (heightMatch.length>1) {
					height = heightMatch[1];
				}
				newContent = wrapperBefore + height + "\"><formatted_image_match_exp" + beforeAttributes + attributeName + "=\"" + alignValue + "\"" + afterAttributes + ">" + wrapperAfter;
				value = value.replace(originalContent, newContent);
			}
			
			value = value.replace(/<formatted_image_match_exp/g, "<img");
			
			return value;
		}
		
		/**
		 * adds media handler to the src of image tags
		 * for example, <img src="myImage.jpg"/> becomes:
		 * <img src="ImageMedia.swf?url=myImage.jpg"/>
		 * */
		public function addImageMediaHandler(value:String, mediaHandler:String = null, includeId:Boolean = true):String {
			if (value==null) return "";
			
			// add parameters to swf url
			if (mediaHandler!=null) {
				addMediaPatternReplace = addMediaPatternReplace.replace(mediaHandlerLocation, mediaHandler + mediaHandlerParameter);
			}
			else {
				addMediaPatternReplace = addMediaPatternReplace.replace(mediaHandlerLocation, mediaHandlerLocation + mediaHandlerParameter);
			}

			// replace src with swf reference
			value = value.replace(addMediaPattern, addMediaPatternReplace);
			
			return value;
		}
		
		// get the count of images
		public function getImageCount(value:String):int {
			
			var match:Array = value.match(imageTag);
			
			return match.length;
		}
		
		// get matches of images
		// get images only with id's doesn't work yet
		public function getImageMatches(value:String, withID:Boolean = false):Array {
			var matches:Array;
			
			// get images only with id's - doesn't work yet
			if (withID) {
				matches = value.match(imageTag);
			}
			else {
				matches = value.match(imageTag);
			}
			
			return matches;
		}
	}
}