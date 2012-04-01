window.rabel = {}
window.rabel.trackEvent = (category, action, label) ->
  try
    _gaq.push ['_trackEvent', category, action, label]
  catch error

jQuery ($) ->
  $("#Search input").keyup (ev) ->
    if ev.which == 13
      query = $(this).val()
      return if query.length == 0
      domain = $(this).data('domain')
      window.open "#{window.rabel.search_engine_url}site:#{domain}%20#{query}"

  focus_comment_box = ->
    $("#comment_content").focus()

  $(".fix_cell").find(".cell:last").addClass("inner").removeClass("cell")
  $(".mention_button").click ->
    mention = $(this).data('mention')
    current_content = $("#comment_content").val()
    new_content = ''
    if current_content.length > 0
      new_content = current_content + "\n" + mention + ' '
    else
      new_content = mention + ' '
    focus_comment_box().val(new_content)
  $(".jump_to_comment").click ->
    $.smoothScroll({speed: 700, scrollTarget: '.reply_content:last'})
    focus_comment_box()
  $(".back_to_top").click ->
    $.smoothScroll({speed: 700, scrollTarget: '#Top'})

  $(".track_event").click ->
    window.rabel.trackEvent($(this).data('category'), $(this).data('action'), $(this).data('label'))

  $.datepicker.setDefaults($.datepicker.regional['zh-CN'])
  $(".datepicker").datepicker({showButtonPanel: true})
