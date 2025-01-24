// import 'package:okota_pay/core/imports.dart';

// class Helpers {
//   static saveIsSeen({required isSeen}) async {
//     await secureStorages.write(key: 'isSeen', value: isSeen);
//   }

//   static saveAccessToken({required accessToken}) async {
//     await secureStorages.write(key: 'userToken', value: accessToken);
//   }

//   static saveCurrentDate({required String date}) async {
//     await secureStorages.write(key: 'currentDate', value: date);
//   }

//   static String getCompletePhoneNumber(PhoneNumber phoneNumber) {
//     // String isoCode = phoneNumber.isoCode.toString();
//     String countryCode = phoneNumber.countryCode;
//     String nsn = phoneNumber.nsn;

//     String completeNumber = '+$countryCode$nsn';
//     return completeNumber;
//   }

//   static int highestIndex(listData) {
//     int highestValue = listData.lastIndexWhere((element) => true);

//     return highestValue;
//   }

//   static validateStructure(String value) {
//     Pattern pattern =
//         // r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
//         r'^(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';

//     RegExp regex = RegExp(pattern.toString());
//     if (value.isEmpty) {
//       return 'Please enter password';
//     } else {
//       if (!regex.hasMatch(value)) {
//         return 'Password must contain at least one lowercase letter, one uppercase letter, one number and one special character';
//       } else {
//         return null;
//       }
//     }
//   }

//   static removePlusSign(String number) {
//     return number.replaceAll('+', '');
//   }
// }
