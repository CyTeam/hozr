function addFlashMessageBehaviour() {
  $('.alert-success').delay(4000).slideUp();
}

function showFlashMessage(message) {
  $('#main').prepend(message);
  addFlashMessageBehaviour();
}
