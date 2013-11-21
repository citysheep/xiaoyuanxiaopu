window.MyWebMarket = {
  Models: {},
  Collections: {},
  Views: {},
  Routers: {},
  init: function() {
  }
};

$(document).ready(function(){
  MyWebMarket.init();
});

function renderFollowButtn(){
  $("div#follow-btn").html($(followView.render().el));
  followView.delegateEvents();
}
