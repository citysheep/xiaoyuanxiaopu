MyWebMarket.Models.Location = Backbone.Model.extend({
	
	url: "/location.json",
	
	getLocation: function(){
		return new google.maps.LatLng(this.get("lat"), this.get("lng"));
	}
	
});
