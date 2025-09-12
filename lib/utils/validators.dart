class Validators {
  // Validate digits
  static String? validateDigits(String value, String type, int length) {
    final pattern = r'^[0-9]+$';
    final regExp = RegExp(pattern);

    if (value.isEmpty) {
      return "$type is required.";
    } else if (value.length != length) {
      return "$type must be exactly $length digits.";
    } else if (!regExp.hasMatch(value)) {
      return "$type must be numeric. Example: 1234";
    }
    return null;
  }

  // Validate amount
  static String? validateAmount(
      int? value, String minMessage, String maxMessage) {
    if (value == null || value < 10) {
      return minMessage;
    } else if (value > 200) {
      return maxMessage;
    }
    return null;
  }

  // Validate characters
  static String? validateCharacter(String value, String type, int length) {
    final pattern = r'^[a-zA-Z0-9]{8,16}$';
    final regExp = RegExp(pattern);

    if (value.isEmpty) {
      return "$type is required.";
    } else if (value.length != length) {
      return "$type must be exactly $length characters.";
    } else if (!regExp.hasMatch(value)) {
      return "$type contains invalid characters.";
    }
    return null;
  }

  // Validate required fields
  static String? validateRequired(String value, String type) {
    if (value.isEmpty) {
      return "$type is required.";
    }
    return null;
  }

  // Validate mobile number
  static String? validateMobile(String value) {
    final pattern = r'^[+]?[0-9]{10,12}$';
    final regExp = RegExp(pattern);

    if (value.isEmpty) {
      return "Mobile number is required.";
    } else if (!regExp.hasMatch(value)) {
      return "Invalid mobile number.";
    }
    return null;
  }

  // Validate GST number
  static String? validateGSTNumber(String value) {
    final pattern =
        r'^[0-9]{2}[A-Z]{5}[0-9]{4}[A-Z]{1}[1-9A-Z]{1}Z[0-9A-Z]{1}$';
    final regExp = RegExp(pattern);

    if (value.isEmpty) {
      return "GST Number is required.";
    } else if (!regExp.hasMatch(value)) {
      return "Invalid GST Number. Format: 12ABCD3456E1Z2";
    }
    return null;
  }

  static String? validateURL(String? value) {
    // Regular expression pattern for URL validation
    final pattern = r'^(https?:\/\/)?([\w\d\-]+\.)+[\w\-]{2,4}\/?.*$';
    final regExp = RegExp(pattern, caseSensitive: false);

    if (value == null || value.isEmpty) {
      return "URL is required.";
    } else if (!regExp.hasMatch(value)) {
      return "Please enter a valid URL.";
    }
    return null;
  }

  // Validate email
  static String? validateEmail(String? value) {
    final pattern = r'^[^@]+@[^@]+\.[^@]+$';
    final regExp = RegExp(pattern);

    if (value == null || value.isEmpty) {
      return "Email is required.";
    } else if (!regExp.hasMatch(value)) {
      return "Invalid email address.";
    }
    return null;
  }

  // Validate account deletion reason
  static String? validateDeletionReason(String? value) {
    if (value == null || value.isEmpty) {
      return "Please provide a reason for your account deletion request.";
    }
    return null;
  }

  // Validate text
  static String? validateText({String? value, String? text, int? maxLen}) {
    if (value == null || value.isEmpty) {
      return "$text is required.";
    } else if (value.length < 3) {
      return "$text must be at least 3 characters.";
    } else if (maxLen != null && value.length > maxLen) {
      return "$text exceeds the maximum length of $maxLen characters.";
    }
    return null;
  }

// Validate password
//   static String? validatePassword(String value) {
//     final pattern =
//         r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[!@#$%^&*()\-_=+{};:,<.>]).{8,}$';
//     final regExp = RegExp(pattern);
//
//     if (value.isEmpty) {
//       return "Password is required.";
//     } else if (!regExp.hasMatch(value)) {
//       return "Password must be at least 8 characters long, contain uppercase and lowercase letters, a number, and a special character.";
//     }
//     return null;
//   }

  static String? validatePassword(String value) {
    if (value.isEmpty) {
      return "Password is required.";
    } else if (value.length < 6) {
      return "Password must be at least 6 characters long.";
    } else if (value.length > 32) {
      return "Password must not exceed 32 characters.";
    }
    return null;
  }

// Validate confirm password
  static String? validateConfirmPassword(String value, String password) {
    if (value.isEmpty) {
      return "Confirm Password is required.";
    } else if (value != password) {
      return "Passwords do not match.";
    }
    return null;
  }

  static String? validateName(String value) {
    // Regular expression for names (letters, spaces, hyphens, and apostrophes) without leading or trailing spaces
    final pattern = r"^[A-Za-z][A-Za-z\s\-']*[A-Za-z]$";
    final regExp = RegExp(pattern);

    if (value.isEmpty) {
      return "Name is required.";
    } else if (!regExp.hasMatch(value)) {
      return "Name can only contain letters, spaces, hyphens, and apostrophes, and cannot start or end with a space.";
    }
    return null;
  }

  static String? validateOtp(String value) {
    // Regular expression for exactly 4 digits
    final pattern = r'^\d{4}$';
    final regExp = RegExp(pattern);

    if (value.isEmpty) {
      return "OTP is required.";
    } else if (!regExp.hasMatch(value)) {
      return "OTP must be exactly 4 digits.";
    }
    return null;
  }

  // Validate business mobile
  static String? validateBusinessMobile(String value) {
    final pattern = r'^[0-9]{10}$';
    final regExp = RegExp(pattern);

    if (value.isEmpty) {
      return "Business mobile number is required.";
    } else if (!regExp.hasMatch(value)) {
      return "Business mobile number must be 10 digits.";
    }
    return null;
  }

  // Validate established year
  static String? validateEstablishedYear(String value) {
    final pattern = r'^[0-9]{4}$';
    final regExp = RegExp(pattern);

    if (!regExp.hasMatch(value)) {
      return "Year must be a 4-digit number.";
    }

    final userYear = int.tryParse(value) ?? 0;
    final currentYear = DateTime.now().year;

    if (userYear < 1850 || userYear > currentYear) {
      return "Year must be between 1850 and $currentYear.";
    }
    return null;
  }

  // Validate license number
  static String? validateLicenseNumber(String value) {
    if (value.isEmpty) {
      return "License number is required.";
    }
    return null;
  }

  // Validate number of employees
  static String? validateNumberOfEmployees(String value) {
    final pattern = r'^[1-9]\d{0,3}$';
    final regExp = RegExp(pattern);

    if (value.isEmpty) {
      return "Number of employees is required.";
    } else if (value.length > 4) {
      return "Number of employees cannot exceed 9999.";
    } else if (!regExp.hasMatch(value)) {
      return "Number of employees must be a positive integer.";
    }
    return null;
  }

  // Validate date
  static String? validateDate(String value) {
    final pattern = r'^\d{4}-\d{2}-\d{2}$';
    final regExp = RegExp(pattern);

    if (value.isEmpty) {
      return "Date is required.";
    } else if (!regExp.hasMatch(value)) {
      return "Date must be in YYYY-MM-DD format.";
    }
    return null;
  }

  // Validate license issuing authority
  static String? validateLicenseIssuingAuthority(String value) {
    final pattern = r'^[a-zA-Z ]+$';
    final regExp = RegExp(pattern);

    if (value.isEmpty) {
      return "License issuing authority is required.";
    } else if (!regExp.hasMatch(value)) {
      return "License issuing authority must contain only letters and spaces.";
    }
    return null;
  }
}
