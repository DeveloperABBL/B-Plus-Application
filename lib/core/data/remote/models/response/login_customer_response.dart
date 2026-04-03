import 'package:brownyplus/core/data/remote/models/response/base_response.dart';

class LoginCustomerResponse extends BaseResponse {
  LoginCustomerResponse({
    required super.success,
    super.message,
    super.errorType,
  });
}
