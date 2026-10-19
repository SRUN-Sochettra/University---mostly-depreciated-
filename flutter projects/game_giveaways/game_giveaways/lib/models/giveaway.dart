// Data model. Optional API fields have readable fallbacks.
class Giveaway {
  final int id;
  final String title, thumbnail, image, description, instructions;
  final String platforms, type, worth, endDate, status, url;

  const Giveaway({
    required this.id,
    required this.title,
    required this.thumbnail,
    required this.image,
    required this.description,
    required this.instructions,
    required this.platforms,
    required this.type,
    required this.worth,
    required this.endDate,
    required this.status,
    required this.url,
  });

  factory Giveaway.fromJson(Map<String, dynamic> json) {
    String text(String key, [String fallback = 'Not available']) {
      final value = json[key];
      return value is String && value.trim().isNotEmpty ? value : fallback;
    }

    final id = json['id'];
    if (id is! int || json['title'] is! String) {
      throw const FormatException('Invalid giveaway data.');
    }
    return Giveaway(
      id: id,
      title: text('title'),
      thumbnail: text('thumbnail', ''),
      image: text('image', text('thumbnail', '')),
      description: text('description'),
      instructions: text('instructions'),
      platforms: text('platforms'),
      type: text('type'),
      worth: text('worth'),
      endDate: text('end_date'),
      status: text('status'),
      url: text('open_giveaway_url', text('open_giveaway', '')),
    );
  }
}
