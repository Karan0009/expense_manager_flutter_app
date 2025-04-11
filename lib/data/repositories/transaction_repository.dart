// import 'dart:developer';

// import 'package:expense_manager/core/base/rest_client.dart';
// import 'package:expense_manager/data/models/otp.dart';
// import 'package:expense_manager/data/repositories/shared_prefs_repository.dart';

// class TransactionRepository {
//   final BaseRepository _baseRepository;
//   final SharedPrefsRepo _sharedPrefsRepo;
//   TransactionRepository(
//       {required BaseRepository baseRepository,
//       required SharedPrefsRepo sharedPrefsRepo})
//       : _baseRepository = baseRepository,
//         _sharedPrefsRepo = sharedPrefsRepo;

//   Future<dynamic> getSummarizedTransactions(
//     String onDate,
//     String summaryType,
//   ) async {
//     try {
//       final endpoint = 'v1/transaction/summary';
//       // final queryParams = {"on_date": onDate, "summary_type": summaryType};
//       final response =
//           await _baseRepository.getRequest(url: endpoint, requireAuth: true);
//       if (response.isRight()) {
//         final responseData = response.fold((_) => null, (r) => r.data);
//         if (responseData != null && responseData["success"]) {
//           return Otp.fromJson({
//             'code': responseData["data"]["otp_code"].toString(),
//             'retry_after': responseData["data"]["retry_after"].toString(),
//             'valid_till': responseData["data"]["valid_till"].toString(),
//           });
//         } else {
//           log("Received empty response data for OTP request.");
//           return null;
//         }
//       }
//       return null;
//     } catch (e) {
//       log("Error during login: $e");
//       rethrow;
//     }
//   }

//   Future<bool> verifyOtp(String phoneNumber, String otp, String code) async {
//     try {
//       final endpoint = 'v1/auth/otp/verify';
//       final body = {
//         "phone_number": phoneNumber,
//         "otp": otp,
//         "code": code,
//       };
//       final response = await _baseRepository.postRequest(
//         url: endpoint,
//         body: body,
//         requireAuth: false,
//       );

//       if (response.isLeft()) {
//         return false;
//       }
//       final responseData = response.fold((_) => null, (r) => r.data);

//       if (responseData != null &&
//           responseData["success"] &&
//           responseData["data"] != null) {
//         await _sharedPrefsRepo
//             .setAccessToken(responseData["data"]["access_token"]);
//         await _sharedPrefsRepo
//             .setRefreshToken(responseData["data"]["refresh_token"]);

//         return true;
//       }

//       return false;
//     } catch (e) {
//       log("Error during OTP verification: $e");
//       rethrow;
//     }
//   }

//   Future<bool> logout() async {
//     try {
//       final refreshToken = await _sharedPrefsRepo.getRefreshToken();

//       final endpoint = 'v1/auth/logout';
//       final body = {
//         "refresh_token": refreshToken,
//       };
//       final response = await _baseRepository.postRequest(
//         url: endpoint,
//         body: body,
//         requireAuth: false,
//       );

//       if (response.isLeft()) {
//         await _sharedPrefsRepo.clear();
//         return false;
//       }
//       final responseData = response.fold((_) => null, (r) => r.data);

//       if (responseData != null && responseData["success"]) {
//         await _sharedPrefsRepo.clear();

//         return true;
//       }

//       return false;
//     } catch (e) {
//       log("Error during logout: $e");
//       await _sharedPrefsRepo.clear();
//       rethrow;
//     }
//   }
// }
