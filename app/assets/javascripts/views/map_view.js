MyWebMarket.Views.MapView = Backbone.View.extend({  
    tagName: "div",
    
    id: "map-canvas",

    initialize: function(options) {
      this.model = options.model;
      this.clickable = options.clickable;
      this.changable = options.changable;
      this.eventManager = {};
			_.extend(this.eventManager, Backbone.Events);
    },
    
    bindEvents: function() {
    	var delegate = this;
      google.maps.event.addListener(delegate.getMap(), 'mousedown', function(event) {
        delegate.getMap().marker.setPosition(event.latLng);
        if(delegate.changable) delegate.model.set("location", event.latLng);
        delegate.eventManager.trigger("mapClick", event.latLng);
      });
    },
    
    render: function() {
      var map = new google.maps.Map($(this.el)[0], this.model.toJSON()); 
      this.model.set("map", map);    
      map.marker = this.newMarker();  
      if(this.clickable) this.bindEvents();
      return this;
    },
    
    newMarker: function(){
      return new google.maps.Marker({
        position: this.getLocation(), 
        map: this.getMap(),
        title:"当前地点"
      });
    },
    
    getMap: function(){
      return this.model.get("map");
    },
    
    getLocation: function(){
      return this.model.get("location");     
    },
    
    getMarkerLocation: function(){
    		return this.getMap().marker.getPosition();
    }
});
