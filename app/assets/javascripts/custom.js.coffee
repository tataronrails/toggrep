$(document)
  .ajaxStart ->
    $('body').addClass("loading")
  .ajaxStop ->
    $('body').removeClass("loading")

$ ->
  $(".demo.menu .item").tab()
  $(".ui.accordion").accordion()
  $(".ui.dropdown").dropdown()

  $(document).on 'click', '[data-link]', ->
    window.location = $(this).data('link')
