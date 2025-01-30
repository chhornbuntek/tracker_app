bool validatePassword(String password) {
  RegExp regex = RegExp(r'^[0-9]+$');
  return regex.hasMatch(password);
}

bool validateEmail(String email) {
  RegExp regex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
  return regex.hasMatch(email);
}
