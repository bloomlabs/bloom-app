# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).ready ->
  $("#signup_reason_other_field").change -> $("#signup_reason_other").val(this.value)
  $("#education_status_other_field").change -> $("#education_status_other").val(this.value)
  $(".education_status").change -> if $(this).val() == "university" || $(this).val().indexOf('graduate') != -1 then $("#user_profile_university_degree,#user_profile_university").parents('.field').show() else $("#user_profile_university_degree,#user_profile_university").val('').parents('.field').hide()