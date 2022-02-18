// ignore_for_file: non_constant_identifier_names

class Weather {
  final double current_temp;
  final double current_feels_like;
  final int current_clouds;
  final int current_visibility;
  final double current_wind_speed;
  final String current_description;
  final String current_icon;

  Weather(
      this.current_temp,
      this.current_feels_like,
      this.current_clouds,
      this.current_visibility,
      this.current_wind_speed,
      this.current_description,
      this.current_icon);

  String getCurrentWeatherIcon(Weather w) {
    return w.current_icon;
  }
}
