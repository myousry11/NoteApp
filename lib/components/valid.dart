String? validInput(String? val, String fieldName, int min, int max) {
  if (val == null || val.isEmpty) {
    return "Please enter $fieldName";
  }
  if (val.length < min) {
    return "$fieldName must be at least $min characters";
  }
  if (val.length > max) {
    return "$fieldName must not exceed $max characters";
  }
  return null; // Valid input
}
