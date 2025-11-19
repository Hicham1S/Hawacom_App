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
    // Helper function to extract string from multilingual field
    String? extractString(dynamic field) {
      if (field == null) return null;
      if (field is String) return field;
      if (field is Map) {
        // Try Arabic first, then English, then any value
        return field['ar']?.toString() ??
               field['en']?.toString() ??
               field.values.firstWhere((v) => v != null, orElse: () => null)?.toString();
      }
      return field.toString();
    }

    // Extract image URL from media array or image field
    String? getImageUrl() {
      String? url;

      // Check media array first
      if (json['media'] is List && (json['media'] as List).isNotEmpty) {
        final media = (json['media'] as List).first;
        if (media is Map) {
          url = media['url'] ?? media['thumb'] ?? media['icon'];
        }
      }
      // Fallback to image field
      if (url == null && json['image'] is Map) {
        url = json['image']['url'];
      } else if (url == null && json['image'] is String) {
        url = json['image'];
      }

      // Fix old domain URLs (hawwcom.com -> hawacom.sa)
      if (url != null) {
        url = url.replaceAll('hawwcom.com', 'hawacom.sa');
        url = url.replaceAll('http://', 'https://'); // Ensure HTTPS
        // Fix storage path: /publicstorage/ -> /admin/public/storage/
        url = url.replaceAll('/publicstorage/', '/admin/public/storage/');
      }

      return url;
    }

    return SlideModel(
      id: json['id']?.toString() ?? '',
      order: json['order'] ?? 0,
      text: extractString(json['text']),
      button: extractString(json['button']),
      imageUrl: getImageUrl(),
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
