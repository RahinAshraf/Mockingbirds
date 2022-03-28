/// Alert enumerated types

enum AlertType { warning, question }

extension AlertTypeString on AlertType {
  String get imagePath {
    switch (this) {
      case AlertType.warning:
        return "assets/images/popup_warning.png";
      case AlertType.question:
        return "assets/images/popup_question.png";
    }
  }
}
