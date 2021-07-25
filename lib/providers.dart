import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'env_config.dart';
import 'movie.dart';
export 'movie.dart';

final dioProvider = Provider<Dio>((ref) {
  return Dio(BaseOptions(
    baseUrl: EnvironmentConfig.BASE_URL,
  ));
});

final movieTypeProvider = StateProvider((ref) => MovieType.popular);

final moviesProvider = FutureProvider<List<Movie>>((ref) async {
  final movieType = ref.watch(movieTypeProvider).state;
  final dio = ref.watch(dioProvider);
  final response = await dio.get('movie/${movieType.value}',
      queryParameters: {'api_key': EnvironmentConfig.API_KEY});
  return MovieResponse.fromJson(response.data).results;
});

final movieProvider = ScopedProvider<Movie>((_) => throw UnimplementedError());
