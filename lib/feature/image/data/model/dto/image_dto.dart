class ImageMetaDto {
  final String? imageId;
  final String? updateTime;

  ImageMetaDto({
    required this.imageId,
    required this.updateTime,
  });

  factory ImageMetaDto.fromJson(Map<String, dynamic> json) {
    return ImageMetaDto(
      imageId: json['imageId'],
      updateTime: json['updateTime'],
    );
  }
}
