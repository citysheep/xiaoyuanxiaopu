MyWebMarket.Models.Follow = Backbone.Model.extend({
  url: function() {
    return this.id ? '/follows/' + this.id : '/follows';
  }
});
