bool hasValue(String value) =>
    value.trim().isNotEmpty &&
    !{'not available', 'n/a', 'null'}.contains(value.trim().toLowerCase());

class Giveaway {
  const Giveaway({
    required this.id,
    required this.title,
    this.thumbnail = '',
    this.image = '',
    this.type = '',
    this.platforms = '',
    this.worth = '',
    this.endDate = '',
    this.description = '',
    this.instructions = '',
    this.url = '',
  });
  final int id;
  final String title, thumbnail, image, type, platforms, worth;
  final String endDate, description, instructions, url;

  factory Giveaway.fromJson(Map<String, dynamic> json) {
    String text(String key) =>
        json[key] is String ? (json[key] as String).trim() : '';
    final id = json['id'];
    if (id is! int || text('title').isEmpty) {
      throw const FormatException('Invalid giveaway record.');
    }
    return Giveaway(
      id: id,
      title: text('title'),
      thumbnail: text('thumbnail'),
      image: text('image').isEmpty ? text('thumbnail') : text('image'),
      type: text('type'),
      platforms: text('platforms'),
      worth: text('worth'),
      endDate: text('end_date'),
      description: text('description'),
      instructions: text('instructions'),
      url: text('open_giveaway_url').isEmpty
          ? text('open_giveaway')
          : text('open_giveaway_url'),
    );
  }
}
