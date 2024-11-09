class ItemDetailsModel {
  ItemDetailsModel({
    required this.title,
    required this.imageUrl,
    required this.year,
    required this.arabicName,
    required this.quality,
    required this.type,
    required this.alsoKnownAs,
    required this.classification,
    required this.duration,
    required this.storyMovie,
    required this.iframe,
    required this.seasions,
    required this.episodes,
    required this.isFilm,
  });
  String? title;
  String? imageUrl;
  String? year;
  String? arabicName;
  String? quality;
  String? type;
  String? duration;
  String? alsoKnownAs;
  String? classification;
  String? storyMovie;
  String? iframe;
  List? seasions;
  List? episodes;
  bool? isFilm;
}
