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
  $("a.hint").tooltip();
  var shopsContainer = document.querySelector('#shops-container');
  var msnry = new Masonry( shopsContainer, {
    columnWidth: 200,
    itemSelector: '.shop'
  });
});

function renderFollowButtn(){
  $("div#follow-btn").html($(followView.render().el));
  followView.delegateEvents();
}
