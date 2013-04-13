MyWebMarket.Views.FollowView = Backbone.View.extend({ 
	tagName: "a",
	
	className: "btn btn-success",

  events: {
    "click": "toggleFollow"
  },

  initialize: function(options) {
    this.model = options.model;
    this.eventManager = {};
 	 	_.extend(this.eventManager, Backbone.Events);
  },

  render: function() {
  	if(this.model.id){
  		this.$el.html("取消关注");
  	}else{
  		this.$el.html("关注小铺");
  	}
    return this;
  },

  toggleFollow: function() {
  	if(this.model.id){
  		this.model.destroy();
  	}else{
      this.model.save(null, {
        error: function(model, response){
          if(response.status == 401) {
            location.href = "/shops/" + model.get("shop_id") + "?auth=true";
          }
        }
      });
  	}
  }

});