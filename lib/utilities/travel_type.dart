/// Navigation enumerated types
/// Author(s): Fariha Choudhury , Elisabeth Halvorsen

enum NavigationType { cycling, walking }

/// Gets corresponding [String] for navigation [type]
String getNavigationType(NavigationType type) {
  switch (type) {
    case NavigationType.cycling:
      return 'cycling';
    case NavigationType.walking:
      return 'walking';
    default:
      return '';
  }
}
