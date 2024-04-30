class MetaImageDto {
  final String? imageId;
  final String? updateTime;

  MetaImageDto({
    required this.imageId,
    required this.updateTime,
  });

  factory MetaImageDto.fromJson(Map<String, dynamic> json) {
    return MetaImageDto(
      imageId: json['imageId'],
      updateTime: json['updateTime'],
    );
  }
}
