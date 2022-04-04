import 'package:flutter_test/flutter_test.dart';
import 'package:veloplan/models/weather.dart';
import 'package:veloplan/providers/weather_manager.dart';

/// Tests that test the weather functionality
/// Author: Nicole Lehchevska k20041914
void main() {
  final WeatherManager weatherManager = WeatherManager();
  Weather test_weather = Weather(
      281.26, 278.77, 100, 4300, 4.12, "light intensity drizzle", "09d");
  setUp() {}

  test('Calling method on a empty weather', () {
    expect(weatherManager.all_weather_data.getCurrentClouds(), 100);
    expect(weatherManager.all_weather_data.getCurrentFeelsLikeTemp(),
        5.6200000000000045);
    expect(weatherManager.all_weather_data.getCurrentVisibility(), 4300);
    expect(weatherManager.all_weather_data.getCurrentWeatherIcon(), "04d");
    expect(weatherManager.all_weather_data.getCurrentWeatherTemp(),
        8.110000000000014);
    expect(weatherManager.all_weather_data.getCurrentWindSpeed(), 4.12);
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
  test('Default Weather is returned correctly', () {
    expect(weatherManager.all_weather_data.getCurrentClouds(), 100);
    expect(weatherManager.all_weather_data.getCurrentFeelsLikeTemp(),
        5.6200000000000045);
    expect(weatherManager.all_weather_data.getCurrentVisibility(), 4300);
    expect(weatherManager.all_weather_data.getCurrentWeatherIcon(), "04d");
    expect(weatherManager.all_weather_data.getCurrentWeatherTemp(),
        8.110000000000014);
    expect(weatherManager.all_weather_data.getCurrentWindSpeed(), 4.12);
    expect(weatherManager.all_weather_data.convertKelvinToCelsius(278.77),
        5.6200000000000045);
  });
}
