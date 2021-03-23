import 'dart:async';

import 'package:bloc/bloc.dart';

import 'bloc.dart';
import '../data/weather_repository.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final WeatherRepository repository;

  WeatherBloc(this.repository);

  @override
  WeatherState get initialState => WeatherInitial();

  @override
  Stream<WeatherState> mapEventToState(WeatherEvent event) async* {
    yield WeatherLoading();

    if (event is GetWeather) {
      try {
        final weather = await repository.fetchWeather(event.cityName);
        yield WeatherLoaded(weather);
      } on NetworkError {
        yield WeatherError("Couldn't not fetch weather. Is the device online?");
      }
    } else if (event is GetDetailedWeather) {
      try {
        final weather = await repository.fetchDetailedWeather(event.cityName);
        yield WeatherLoaded(weather);
      } on NetworkError {
        yield WeatherError("Couldn't not fetch weather. Is the device online?");
      }
    } else {
      yield WeatherError("");
    }
  }
}
