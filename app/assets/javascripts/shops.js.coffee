$ ->
  $shopZoneModal = $("#shop-zone-modal")
  $shopZoneBtn = $("#choose-zone-btn")
  $shopZoneText = $("#shop-zone-text")

  $("#shop-zone-modal div.modal-footer > a.confirm").click () ->
    $shopZoneText.text($("input[name='shop[zone_id]']:checked").next('input').val())
    $shopZoneBtn.text("更改店铺位置")
    $shopZoneModal.modal('hide')
