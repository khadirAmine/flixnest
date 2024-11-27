class ItemModel {
  ItemModel({
    required this.title,
    required this.imageUrl,
    required this.episode,
    required this.year,
    required this.href,
    required this.isFilm,
  });

  String? title;
  String? imageUrl;
  String? episode;
  String? year;
  String? href;
  bool? isFilm;

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'imageUrl': imageUrl,
      'episode': episode,
      'year': year,
      'href': href,
      'isFilm': isFilm
    };
  }
}
