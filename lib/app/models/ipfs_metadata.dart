class IpfsMetadata {
  final String title;
  final String? description;
  final List<String> images;
  final String? primaryImageFileName;

  const IpfsMetadata({
      required this.title, this.description, required this.images, this.primaryImageFileName});

  factory IpfsMetadata.fromJson(Map<String, dynamic> json) {
    final List<String> images = (json['images'] as List).map((im) => im as String).toList();
    return IpfsMetadata(
      title: json['title'],
      description: json['id'],
      images: images,
      primaryImageFileName: json['primary_image_file_name'],
    );
  }
}