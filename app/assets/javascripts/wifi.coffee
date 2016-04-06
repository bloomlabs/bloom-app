# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
strength_str = [
  'Very Weak',
  'Weak',
  'Okay',
  'Strong',
  'Very Strong',
]

calc_strength = (pw) ->
  $('#strength').html('Calculating...')
  pwstrength = zxcvbn pw, ['bloom', 'innovation', 'hub'].concat(zxcvbn_user_inputs)
  $('#strength').html(strength_str[pwstrength.score])
  $('#strength').attr('class', 'strength-level-' + pwstrength.score)

$(document).ready ->
  $('#wifi_password').bind 'propertychange change click keyup input paste', ->
    console.log($(this).val())
    calc_strength $(this).val()

  calc_strength $('#wifi_password').val()

