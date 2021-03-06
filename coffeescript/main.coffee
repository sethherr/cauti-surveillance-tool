---
---

$(document).ready ->
  $.ajax
    type: "GET"
    url: "{{ site.baseurl }}/data/questions.json"
    success: (data, textStatus, jqXHR) ->
      window.questions = data.questions
      bindFindQuestionToHashChange()
      findQuestionFromHash()
      # show()

generateQuestionText = (question_id) ->

  question = questions[question_id]
  html_string = ""
  html_string = html_string + "<div class='main_block #{question.type}' id='#{question_id}'><p>#{question.text}</p>"

  if question.criteria?
    html_string = html_string + "<ul>"
    for criteria_items in question.criteria
      html_string = html_string + "<li>#{criteria_items}</li>"
    html_string = html_string + "</ul>"

  if question.options?
    html_string = html_string + "<ul class='option_wrapper'>"
    # for option in question.options  
    #   html_string = html_string + "<li id='#{option.target}' class='option_button'><a href='##{option.target}' class='option_button_link'>#{option.text}</a></li>"
    option_first = question.options[0]  
    html_string = html_string + "<li id='#{option_first.target}' class='option_button first'><a href='##{option_first.target}' class='option_button_link'>#{option_first.text}</a></li>"

    option_second = question.options[1]  
    html_string = html_string + "<li id='#{option_second.target}' class='option_button second'><a href='##{option_second.target}' class='option_button_link'>#{option_second.text}</a></li>"

    html_string = html_string + "</ul>"

  html_string = html_string + "</div>"

  if question.more?
    more(question_id)
  else
    noMore()

  changePageText(html_string)

noMore = ->
  $("#more_block, #more_text, #less_link").hide()
  

more = (question_id) ->
  question = questions[question_id]
  html_string = ""
  html_string = html_string + "<h3>Background</h3><p id='stuff'>#{question.more}</p>"
  $('#more_block').hide().fadeIn('slow')
  $('#more_text').html(html_string)
  show()

show = ->
  $('#more_link, #less_link').click (e) ->
    $('#more_text').slideToggle()
    $('#more_link, #less_link').toggle()
    return
  return

changePageText = (new_string) ->
  $("#question_block").html(new_string)
  $("#body_wrapper").hide().fadeIn('slow')
  setLIHeight()

findQuestionFromHash = ->
  # $("#question_block").fadeOut('fast')
  if window.location.hash != ""
    hash = location.hash
    hash = hash.substring(1)
    generateQuestionText(hash)
  else
    generateQuestionText("start")

bindFindQuestionToHashChange = ->
  $(window).bind 'hashchange', (e) ->
    findQuestionFromHash()

setLIHeight = ->
  maxHeight = 0
  $('.option_wrapper .option_button .option_button_link').each ->
    if maxHeight < $(this).height()
      maxHeight = $(this).height()
    return
  $('.option_wrapper .option_button .option_button_link').height maxHeight
  return
