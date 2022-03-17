/// Navigation enumerated types
/// Author(s): Fariha Choudhury k20059723, Elisabeth Halvorsen k20077737

enum NavigationType { cycling, walking }

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
