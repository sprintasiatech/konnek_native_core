extension EmailValidator on String {
  bool get isValidEmail {
    final RegExp emailRegex = RegExp(
      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
    );
    return emailRegex.hasMatch(this);
  }

  bool get isAllLowercase {
    final lowercaseRegex = RegExp(r'^[a-z]+$');
    return lowercaseRegex.hasMatch(this);
  }

  bool get isAllLowercaseEmail {
    // First check it's a valid email
    final emailRegex = RegExp(r'^[\w\.-]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(this)) return false;

    // Then check if it equals its lowercase version
    return this == this.toLowerCase();
  }

  bool get isValidName => RegExp(r'^[a-zA-Z]{1,20}$').hasMatch(this);
}
