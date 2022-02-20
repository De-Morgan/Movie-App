import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_app/env_config.dart';

import 'providers.dart';

void main() {
  runApp(ProviderScope(child: MyMovieApp()));
}

class MyMovieApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Riverpod Movie App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: Scaffold(
        appBar: AppBar(
          title: Title(),
        ),
        body: Column(
          children: [
            MovieTags(),
            Expanded(child: MovieList()),
          ],
        ),
      ),
    );
  }
}

class Title extends ConsumerWidget {

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final movieType = ref.watch(movieTypeProvider.state).state;
    return Text("${movieType.name} movies");
  }
}

class MovieTags extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final movieType = ref.watch(movieTypeProvider.state).state;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: MovieType.values
          .map((type) => InkWell(
                onTap: () => ref.read(movieTypeProvider.state).state = type,
                child: Chip(
                  label: Text(
                    "${type.name}",
                  ),
                  backgroundColor: type == movieType ? Colors.blue : null,
                ),
              ))
          .toList(),
    );
  }
}



class MovieList extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final moviesAsyncValue = ref.watch(moviesProvider);
    return moviesAsyncValue.maybeWhen(
        orElse: () => Center(child: CircularProgressIndicator()),
        data: (movies) => Center(
              child: GridView.builder(
                  itemCount: movies?.length ?? 0,
                  itemBuilder: (BuildContext context, int index) {
                    final movie = movies[index];
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProviderScope(overrides: [
                                      movieProvider.overrideWithValue(movie)
                                    ], child: MovieDetailsPage())));
                      },
                      child: Card(
                        child: Container(
                          margin: const EdgeInsets.all(4),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: NetworkImage(
                                            "${EnvironmentConfig.IMAGE_BASE_URL}${movie.posterPath}",
                                          ))),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text("${movie.title}")
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2)),
            ));
  }
}

class MovieDetailsPage extends StatelessWidget {
  const MovieDetailsPage();
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext context,
          ref, Widget child) {
        final movie = ref.watch(movieProvider);
        return Scaffold(
          appBar: AppBar(
            title: Text('${movie.title}'),
            elevation: 0,
          ),
          body: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                Stack(
                  overflow: Overflow.visible,
                  children: [
                    Container(
                      height: 200,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: NetworkImage(
                                  '${EnvironmentConfig.IMAGE_BASE_URL}${movie.backdropPath}'),
                              fit: BoxFit.cover)),
                    ),
                    Positioned(
                      left: 20,
                      bottom: -80,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            height: 120,
                            width: 100,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: NetworkImage(
                                        '${EnvironmentConfig.IMAGE_BASE_URL}${movie.posterPath}'),
                                    fit: BoxFit.cover)),
                          ),
                          const SizedBox(width: 20),
                          Column(
                            children: [
                              Text(
                                "${movie.title}",
                                style: Theme.of(context).textTheme.headline6,
                              ),
                              const SizedBox(height: 20),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text("${movie.releaseDate}"),
                                  const SizedBox(width: 50),
                                  Icon(
                                    Icons.star,
                                    size: 18,
                                  ),
                                  Text("${movie.voteAverage}/10"),
                                ],
                              )
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 100),
                Divider(
                  thickness: 1.5,
                ),
                const SizedBox(height: 10),
                Text("${movie.overview}")
              ],
            ),
          ),
        );
      },
    );
  }
}
