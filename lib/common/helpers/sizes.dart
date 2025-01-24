import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppSizes {
  /// The function returns the height of a given size.
  ///
  /// Args:
  ///   size (double): The parameter "size" is likely an object or a data structure that contains
  /// information about the size of an application or a component. The ".h" property of the "size"
  /// object is likely the height of the application or component. The function "appHeight" takes in
  /// this "size" object

  /// Returns:
  ///   The function `appHeight` is returning the height value of the `size` object.
  ///  example
  ///  AppSizes.appHeight(10.0)
  static appHeight(double size) {
    return size.h;
  }

  /// The function returns the width of the app based on a given size.
  ///
  /// Args:
  ///   size (double): The parameter "size" is likely an object that contains information about the size
  /// of the app or a specific widget within the app. The ".w" property is likely a property of the
  /// "size" object that represents the width of the app or widget. The function "appWidth" is likely
  /// used
  ///
  /// Returns:
  ///   The function `appWidth` takes a `size` parameter and returns the width of the `size` object. The
  /// specific syntax used (`size.w`) suggests that `size` is an object with a `w` property representing
  /// its width. Therefore, the function returns the value of `size.w`.
  ///   example
  ///  AppSizes.appWidth(10.0)
  static appWidth(double size) {
    return size.w;
  }

  /// The function returns a radius value for a given size in Dart programming language.
  ///
  /// Args:
  ///   size (double): The parameter `size` is a double value representing the size of the radius of a
  /// circle. The function `appRadius` takes this size as input and returns a `Radius` object with the
  /// same size. The `r` property of the `Radius` object represents the radius of a circle.
  ///
  /// Returns:
  ///   The function `appRadius` is returning a `BorderRadius` object with a radius value of `size`.
  ///  example
  ///  ``` AppSizes.appRadius(10.0) ```
  static appRadius(double size) {
    return size.r;
  }

  /// The function converts a given size value to scaled pixels (sp) for use in Flutter app development.
  ///
  /// Args:
  ///   size (double): The parameter "size" is a double value representing a size in some unit of
  /// measurement.
  ///
  /// Returns:
  ///   The function `appCustomSize` is returning a value that is the input `size` converted to a font
  /// size in scaled pixels (sp).
  /// example
  ///  AppSizes.appCustomSize(10.0)
  /// Mainly to be used in the padding and margin and font-sizes of the app.
  static appCustomSize(double size) {
    return size.sp;
  }


/// The function `textHeight` calculates the height of text based on two input sizes.
/// 
/// Args:
///   size1 (double): The `size1` parameter represents the font size in points (pt) that you want to
/// convert to another unit of measurement.
///   size2 (double): Size2 is the reference font size in points (pt) that you want to compare with
/// size1 in order to calculate the text height.
/// 
/// Returns:
///   The function `textHeight` is returning the result of dividing `size1` by `size2`.
    static textHeight({required double height, required double fontsize}) {
    return height.sp / fontsize ;
  }




  static letterSpacingPercentage({required double percentage,required double fontSize}) {
    return (percentage/100) *  fontSize ;
  }
  
}
