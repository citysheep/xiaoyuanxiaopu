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
  $("a.hint").tooltip('hide');
  $("a.social-share").click(function(){
    $("a.jiathis_button_renren").click();
    $("a.jiathis_button_weixin").click();
    $("a.jiathis_button_tsina").click();
    $("a.jiathis_button_qzone").click();
  });
});

function renderFollowButtn(){
  $("div#follow-btn").html($(followView.render().el));
  followView.delegateEvents();
}
