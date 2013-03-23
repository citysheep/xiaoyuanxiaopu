window.fbAsyncInit = function() {
	FB.init({
		appId : '208690692477625', // App ID
		channelUrl : 'http://www.mywebmarket.net/', // Channel File
		status : true, // check login status
		cookie : true, // enable cookies to allow the server to access the session
		xfbml : true  // parse XFBML
	});
	// Additional initialization code here
};
// Load the SDK Asynchronously
( function(d) {
	var js, id = 'facebook-jssdk', ref = d.getElementsByTagName('script')[0];
	if(d.getElementById(id)) {
		return;
	}
	js = d.createElement('script');
	js.id = id;
	js.async = true;
	js.src = "//connect.facebook.net/zh_TW/all.js";
	ref.parentNode.insertBefore(js, ref);
}(document));
