class DeleteBankResponse {
  final bool? status;
  final String? message;

  DeleteBankResponse({this.status, this.message});

  factory DeleteBankResponse.fromJson(Map<String, dynamic> json) {
    return DeleteBankResponse(
      status: json['status'],
      message: json['message']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
    };
  }
}
