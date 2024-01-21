class Validator {
  static String? validateName(String name) {
    if (name.isEmpty) {
      return 'Please Enter Your Name';
    }

    return null;
  }

  static String? validateEmail(String email) {
    RegExp emailRegex = RegExp(
      r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$',
    );

    if (email.isEmpty) {
      return 'Please enter your email';
    } else if (!emailRegex.hasMatch(email)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  static String? validatePassword(String password) {
    if (password.isEmpty) {
      return 'Please enter your password';
    } else if (password.length < 6) {
      return 'Enter a password with length at least 6';
    }

    return null;
  }

  static String? validateComfirmPassword(String comPassword, String password) {
    if (comPassword.isEmpty) {
      return 'Please enter your password';
    } else if (comPassword.length < 6) {
      return 'Enter a password with length at least 6';
    } else if (comPassword != password) {
      return 'Password did not match';
    }

    return null;
  }

  static String? validateUniversityName(String uniName) {
    if (uniName.isEmpty) {
      return 'Please enter the name of university';
    }

    return null;
  }

  static String? validateUniversityLocation(String uniLocation) {
    if (uniLocation.isEmpty) {
      return 'Please enter the location of university';
    }

    return null;
  }

  static String? validateDescription(String description) {
    if (description.isEmpty) {
      return 'Please enter the description';
    }

    return null;
  }

  static String? validateUniBackground(String uniBackground) {
    if (uniBackground.isEmpty) {
      return 'Please enter the university background';
    }

    return null;
  }

  static String? validateLink(String link) {
    if (link.isEmpty) {
      return 'Please enter the link';
    }

    return null;
  }

  static String? validateProviderName(String name) {
    if (name.isEmpty) {
      return 'Please enter name of the provider';
    }

    return null;
  }

  static String? validateReq(String req) {
    if (req.isEmpty) {
      return 'Please enter the requirements';
    }

    return null;
  }

  static String? validateCourseName(String cName) {
    if (cName.isEmpty) {
      return 'Please enter the course name';
    }

    return null;
  }

  static String? validateAcademicReq(String req) {
    if (req.isEmpty) {
      return 'Please enter the academic requirements';
    }

    return null;
  }

  static String? validateJobOpportunity(String job) {
    if (job.isEmpty) {
      return 'Please enter the job opportunities';
    }

    return null;
  }
}
