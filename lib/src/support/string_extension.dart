extension EmailValidator on String {
  bool get isValidEmail {
    final RegExp emailRegex = RegExp(
      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
    );
    return emailRegex.hasMatch(this);
  }

  bool get isValidName => RegExp(r'^[a-zA-Z]{1,20}$').hasMatch(this);
}