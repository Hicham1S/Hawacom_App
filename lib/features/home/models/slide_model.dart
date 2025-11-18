/// Slider/Banner model matching Laravel API response
class SlideModel {
  final String id;
  final int order;
  final String? text;
  final String? button;
  final String? imageUrl;
  final bool enabled;

  SlideModel({
    required this.id,
    required this.order,
    this.text,
    this.button,
    this.imageUrl,
    this.enabled = true,
  });

  factory SlideModel.fromJson(Map<String, dynamic> json) {
    return SlideModel(
      id: json['id']?.toString() ?? '',
      order: json['order'] ?? 0,
      text: json['text'],
      button: json['button'],
      imageUrl: json['image'] is Map ? json['image']['url'] : json['image'],
      enabled: json['enabled'] == true || json['enabled'] == 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order': order,
      if (text != null) 'text': text,
      if (button != null) 'button': button,
      if (imageUrl != null) 'image': imageUrl,
      'enabled': enabled,
    };
  }
}
