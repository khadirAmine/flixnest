class ItemModel {
  ItemModel({
    required this.title,
    required this.imageUrl,
    required this.episode,
    required this.year,
    required this.href,
  });

  String? title;
  String? imageUrl;
  String? episode;
  String? year;
  String? href;

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'imageUrl': imageUrl,
      'episode': episode,
      'year': year,
      'href': href
    };
  }
}
