class ImageDto {
  final String? imageId;
  final String? updateTime;

  ImageDto({
    required this.imageId,
    required this.updateTime,
  });

  factory ImageDto.fromJson(Map<String, dynamic> json) {
    return ImageDto(
      imageId: json['imageId'],
      updateTime: json['updateTime'],
    );
  }
}
