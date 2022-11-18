import 'dart:io';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class LyPermission {
  static bool isDialogShowing = false;

  /// 录音权限
  static Future<bool> record() async {
    var s = await storage();
    var m = await microphone();
    return s && m;
  }

  /// 麦克风权限
  static Future<bool> microphone() async {
    return await handle(Permission.microphone);
  }

  /// 存储权限
  static Future<bool> storage() async {
    return await handle(Permission.storage);
  }

  /// 相册权限/保存图片
  static Future<bool> photos() async {
    var s = await handle(Permission.storage);
    var h = await handle(Permission.photos);
    return s && h;
  }

  /// 相机权限
  static Future<bool> cameras() async {
    return await handle(Permission.camera);
  }

  /// 相机权限
  static Future<bool> video() async {
    var m = await handle(Permission.microphone);
    var c = await handle(Permission.camera);
    return m && c;
  }

  /// 日历
  static Future<bool> calendar() async {
    return await handle(Permission.calendar);
  }

  /// 通知
  static Future<bool> notification() async {
    return await handle(Permission.notification);
  }

  /// 存储权限
  static Future<bool> phone() async {
    return await handle(Permission.phone);
  }

  /// 存储权限
  static Future<bool> storageM() async {
    return await handle(Permission.accessMediaLocation);
  }

  static Future<bool> handle(Permission permission) async {
    debugPrint(
        "[request permission] => ${permission.value} : ${await permission.status}");
    if (!(await permission.isGranted)) {
      /// 如果没有权限
      debugPrint(
          "[isPermanentlyDenied] => ${await permission.isPermanentlyDenied}");
      if (await permission.isPermanentlyDenied) {
        /// 如果已经永久禁止了,获取受限
        error(permission);
        return false;
      } else {
        /// 没禁止开始申请
        var pr = await permission.request();
        debugPrint("[requested permission pr] => $pr");
        switch (pr) {
          case PermissionStatus.granted:

            /// permission.value == 7 为麦克风
            if (permission.value == 7) {
              // ToastUtil.showToast("已获取权限请尝试重新开始！");
            }
            return true;
          case PermissionStatus.denied:
            // ToastUtil.showToast("权限不足！");
            /// 只有拒绝且不再询问时才去app设置打开权限
            // error(permission);
            return false;
          case PermissionStatus.permanentlyDenied:
            if (Platform.isAndroid) {
              error(permission);
            }
            return false;
          case PermissionStatus.limited:

            /// iOS 允许部分权限，允许用户继续操作
            return true;
          default:
            return false;
        }
      }
    }
    return true;
  }

  static error(Permission permission) {
    String message = '应用权限';
    switch (permission.value) {
      case 0:

        /// 日历
        message = "日历";
        break;
      case 1:

        /// 相机
        message = "相机";
        break;

      case 7:

        /// 麦克风
        message = "麦克风";
        break;
      case 8:

        /// 电话
        message = "电话";
        break;

      case 9:

        /// 相册
        message = "照片";
        break;
      // case 15:
      //
      //   /// 存储
      //   message = "存储";
      //   break;
      case 17:

        /// 通知
        message = "通知";
        break;
    }
    // ToastUtil.showToast(message);
    print(message);
  }
}
