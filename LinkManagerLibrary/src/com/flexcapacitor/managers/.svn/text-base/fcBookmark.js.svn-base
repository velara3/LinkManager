function fcSetWindowStatus(url) {
	window.status = url;
}

function fcBookmark (title, url) {
	var message = 'Bookmarks do not work with the file:// protocol.\nTest on a http:// server.\n';
	message += '\nTitle: ' + title + '\nBookmark Location: ' + url;
	
	// firefox 
	if (window.sidebar) {
		if (String(document.location).indexOf('file://')>-1) { 
			alert(message);
			return;
		}
		// don't know if this will work in ff3 on mac
		// if not we need to show them a message
		window.sidebar.addPanel(title, url, '');
	}
	else if(window.opera && window.print) {
		var elem = document.createElement('a');
		elem.setAttribute('href',url);
		elem.setAttribute('title',title);
		elem.setAttribute('rel','sidebar');
		elem.click();
	}
	else if(document.all) {
		window.external.AddFavorite(url, title);
	}
};
