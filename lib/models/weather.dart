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

  Weather.empty()
      : current_temp = 0.0,
        current_feels_like = 0.0,
        current_clouds = 0,
        current_visibility = 0,
        current_wind_speed = 0.0,
        current_description = "",
        current_icon = "";

  Weather.defaultvalue()
      : current_temp = 281.26,
        current_feels_like = 278.77,
        current_clouds = 100,
        current_visibility = 4300,
        current_wind_speed = 4.12,
        current_description = "light intensity drizzle",
        current_icon = "04d";

  String getCurrentWeatherIcon() {
    return current_icon;
  }

  double getCurrentWeatherTemp() {
    return convertKelvinToCelsius(current_temp);
  }

  double getCurrentFeelsLikeTemp() {
    return convertKelvinToCelsius(current_feels_like);
  }

  int getCurrentClouds() {
    return current_clouds;
  }

  int getCurrentVisibility() {
    return current_visibility;
  }

  double getCurrentWindSpeed() {
    return current_wind_speed;
  }

  double convertKelvinToCelsius(double kel) {
    return kel - 273.15;
  }
}
