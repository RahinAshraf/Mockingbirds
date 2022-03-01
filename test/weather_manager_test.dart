import 'package:flutter_test/flutter_test.dart';
import 'package:veloplan/models/weather.dart';
import 'package:veloplan/providers/weather_manager.dart';

void main() {
  final WeatherManager weatherManager = WeatherManager();
  Weather test_weather = Weather(
      281.26, 278.77, 100, 4300, 4.12, "light intensity drizzle", "09d");
  setUp() {
    //Weather test_weather = Weather(
    //  281.26, 278.77, 100, 4300, 4.12, "light intensity drizzle", "09d");
  }

  test('Calling method on a empty weather', () {
    expect(weatherManager.all_weather_data.getCurrentClouds(), 0);
    expect(weatherManager.all_weather_data.getCurrentFeelsLikeTemp(), -273.15);
    expect(weatherManager.all_weather_data.getCurrentVisibility(), 0);
    expect(weatherManager.all_weather_data.getCurrentWeatherIcon(), "");
    expect(weatherManager.all_weather_data.getCurrentWeatherTemp(), -273.15);
    expect(weatherManager.all_weather_data.getCurrentWindSpeed(), 0.0);
    expect(weatherManager.all_weather_data.convertKelvinToCelsius(273.15), 0.0);
  });
  test('Weather is returned correctly', () {
    expect(test_weather.getCurrentClouds(), 100);
    expect(test_weather.getCurrentFeelsLikeTemp(), 5.6200000000000045);
    expect(test_weather.getCurrentVisibility(), 4300);
    expect(test_weather.getCurrentWeatherIcon(), "09d");
    expect(test_weather.getCurrentWeatherTemp(), 8.110000000000014);
    expect(test_weather.getCurrentWindSpeed(), 4.12);
    expect(test_weather.convertKelvinToCelsius(278.77), 5.6200000000000045);
  });
}
