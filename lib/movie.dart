class Movie {
  final bool adult;
  final String backdropPath;
  final List<int> genreIds;
  final int id;
  final String originalLanguage;
  final String originalTitle;
  final String overview;
  final num popularity;
  final String posterPath;
  final String releaseDate;
  final String title;
  final bool video;
  final num voteAverage;
  final num voteCount;

  Movie(
      {this.adult,
      this.backdropPath,
      this.genreIds,
      this.id,
      this.originalLanguage,
      this.originalTitle,
      this.overview,
      this.popularity,
      this.posterPath,
      this.releaseDate,
      this.title,
      this.video,
      this.voteAverage,
      this.voteCount});

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
        adult: json['adult'],
        backdropPath: json['backdrop_path'],
        genreIds: json['genre_ids'].cast<int>(),
        id: json['id'],
        originalLanguage: json['original_language'],
        originalTitle: json['original_title'],
        overview: json['overview'],
        popularity: json['popularity'],
        posterPath: json['poster_path'],
        releaseDate: json['release_date'],
        title: json['title'],
        video: json['video'],
        voteAverage: json['vote_average'],
        voteCount: json['vote_count']);
  }
}

class MovieResponse {
  int page;
  List<Movie> results;
  int totalPages;
  int totalResults;

  MovieResponse({this.page, this.results, this.totalPages, this.totalResults});

  MovieResponse.fromJson(Map<String, dynamic> json) {
    try {
      page = json['page'];
      if (json['results'] != null) {
        results = <Movie>[];
        json['results'].forEach((v) {
          results.add(new Movie.fromJson(v));
        });
      }
      totalPages = json['total_pages'];
      totalResults = json['total_results'];
    } catch (error) {
      print("Error is $error");
    }
  }
}

enum MovieType { popular, latest, now_playing, top_rated, upcoming }

extension MovieTypeExtension on MovieType {
  String get value => toString().split('.').last;
  String get name {
    String name;
    switch(this){

      case MovieType.popular:
        name = "Popular";
        break;
      case MovieType.latest:
        name = "Latest";
        break;
      case MovieType.now_playing:
        name = "Now Playing";
        break;
      case MovieType.top_rated:
        name = "Top rated";
        break;
      case MovieType.upcoming:
        name = "Upcoming";
        break;
    }
    return name;
  }
}
