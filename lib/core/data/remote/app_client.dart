import 'package:brownyplus/core/data/remote/models/api_model_index.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'app_client.g.dart';

@RestApi()
abstract class AppClient {
  static final _AppClient _instance = _AppClient(
    Dio(
      BaseOptions(
        contentType: 'application/json; charset=utf-8',
        connectTimeout: const Duration(minutes: 1),
        sendTimeout: const Duration(minutes: 1),
        receiveTimeout: const Duration(minutes: 1),
      ),
    ),
  );

  factory AppClient.instance() => _instance;

  factory AppClient.init(ApiConfigs config) {
    return _instance
      ..baseUrl = config.baseUrl
      .._dio.options.headers['Authorization'] = config.token.isEmpty
          ? null
          : 'Bearer ${config.token}'
      .._dio.options.headers['clientVersion'] = config.clientVersion
      .._dio.options.headers['X-Client-Version'] = config.clientVersion;
  }

  @POST('/customer/login')
  Future<HttpResponse<AuthLoginResponse>> login(
    @Body() CustomerCredential credential,
  );

  @POST('/customer/request-otp')
  Future<HttpResponse<RequestOtpResponse>> requestOtp(
    @Body() RequestOtpRequest body,
  );

  @POST('/customer/verify-otp')
  Future<HttpResponse<VerifyOtpResponse>> verifyOtp(
    @Body() VerifyOtpRequest body,
  );

  @PUT('/customer/update-password')
  Future<HttpResponse<BaseResponse>> updatePassword(
    @Body() UpdatePasswordRequest body,
  );

  @GET('/customer/{uuid}/get-pin')
  Future<HttpResponse<GetPinResponse>> getPin(@Path('uuid') String uuid);

  @POST('/customer/set-pin')
  Future<HttpResponse<BaseResponse>> setPin(@Body() PinRequest body);

  @POST('/customer/verify-pin')
  Future<HttpResponse<BaseResponse>> verifyPin(@Body() PinRequest body);
}
