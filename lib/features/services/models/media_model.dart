import '../../../core/models/base_model.dart';

/// Media model for images and files
class MediaModel extends BaseModel {
  final String id;
  final String? name;
  final String url;
  final String? thumb;
  final String? icon;
  final String? size;

  const MediaModel({
    required this.id,
    this.name,
    required this.url,
    this.thumb,
    this.icon,
    this.size,
  });

  factory MediaModel.fromJson(Map<String, dynamic> json) {
    // Fix old domain URLs
    String fixUrl(String? url) {
      if (url == null || url.isEmpty) {
        return 'https://hawacom.sa/admin/public/images/image_default.png';
      }

      String fixed = url;
      fixed = fixed.replaceAll('hawwcom.com', 'hawacom.sa');
      fixed = fixed.replaceAll('http://', 'https://');
      fixed = fixed.replaceAll('/publicstorage/', '/admin/public/storage/');

      return fixed;
    }

    return MediaModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString(),
      url: fixUrl(json['url']?.toString()),
      thumb: fixUrl(json['thumb']?.toString()),
      icon: fixUrl(json['icon']?.toString()),
      size: json['formatted_size']?.toString() ?? json['size']?.toString(),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      if (name != null) 'name': name,
      'url': url,
      if (thumb != null) 'thumb': thumb,
      if (icon != null) 'icon': icon,
      if (size != null) 'formatted_size': size,
    };
  }

  /// Get best available image URL
  String get bestImageUrl => thumb ?? url;

  /// Get icon size image URL
  String get iconUrl => icon ?? thumb ?? url;

  @override
  List<Object?> get props => [id, name, url, thumb, icon, size];
}
