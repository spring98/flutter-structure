class ResultModel<T> {
  final bool isSuccess;
  final String message;
  final T? data;

  ResultModel({
    required this.isSuccess,
    this.message = 'Data Error',
    this.data,
  });

  factory ResultModel.fromJson(Map<String, dynamic> json) {
    return ResultModel(
      isSuccess: json['isSuccess'],
      message: json['message'],
      data: json['data'],
    );
  }
}
