// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
// Autogenerated from Pigeon (v22.4.1), do not edit directly.
// See also: https://pub.dev/packages/pigeon
// ignore_for_file: public_member_api_docs, non_constant_identifier_names, avoid_as, unused_import, unnecessary_parenthesis, prefer_null_aware_operators, omit_local_variable_types, unused_shown_name, unnecessary_import, no_leading_underscores_for_local_identifiers

import 'dart:async';
import 'dart:typed_data' show Float64List, Int32List, Int64List, Uint8List;

import 'package:flutter/foundation.dart' show ReadBuffer, WriteBuffer;
import 'package:flutter/services.dart';

PlatformException _createConnectionError(String channelName) {
  return PlatformException(
    code: 'channel-error',
    message: 'Unable to establish connection on channel: "$channelName".',
  );
}

List<Object?> wrapResponse(
    {Object? result, PlatformException? error, bool empty = false}) {
  if (empty) {
    return <Object?>[];
  }
  if (error == null) {
    return <Object?>[result];
  }
  return <Object?>[error.code, error.message, error.details];
}

/// Pigeon equivalent of [CameraLensDirection].
enum PlatformCameraLensDirection {
  front,
  back,
  external,
}

/// Pigeon equivalent of [DeviceOrientation].
enum PlatformDeviceOrientation {
  portraitUp,
  portraitDown,
  landscapeLeft,
  landscapeRight,
}

/// Pigeon equivalent of [ExposureMode].
enum PlatformExposureMode {
  auto,
  locked,
}

/// Pigeon equivalent of [FocusMode].
enum PlatformFocusMode {
  auto,
  locked,
}

/// Pigeon equivalent of [CameraDescription].
class PlatformCameraDescription {
  PlatformCameraDescription({
    required this.name,
    required this.lensDirection,
    required this.sensorOrientation,
  });

  String name;

  PlatformCameraLensDirection lensDirection;

  int sensorOrientation;

  Object encode() {
    return <Object?>[
      name,
      lensDirection,
      sensorOrientation,
    ];
  }

  static PlatformCameraDescription decode(Object result) {
    result as List<Object?>;
    return PlatformCameraDescription(
      name: result[0]! as String,
      lensDirection: result[1]! as PlatformCameraLensDirection,
      sensorOrientation: result[2]! as int,
    );
  }
}

/// Data needed for [CameraInitializedEvent].
class PlatformCameraState {
  PlatformCameraState({
    required this.previewSize,
    required this.exposureMode,
    required this.focusMode,
    required this.exposurePointSupported,
    required this.focusPointSupported,
  });

  PlatformSize previewSize;

  PlatformExposureMode exposureMode;

  PlatformFocusMode focusMode;

  bool exposurePointSupported;

  bool focusPointSupported;

  Object encode() {
    return <Object?>[
      previewSize,
      exposureMode,
      focusMode,
      exposurePointSupported,
      focusPointSupported,
    ];
  }

  static PlatformCameraState decode(Object result) {
    result as List<Object?>;
    return PlatformCameraState(
      previewSize: result[0]! as PlatformSize,
      exposureMode: result[1]! as PlatformExposureMode,
      focusMode: result[2]! as PlatformFocusMode,
      exposurePointSupported: result[3]! as bool,
      focusPointSupported: result[4]! as bool,
    );
  }
}

/// Pigeon equivalent of [Size].
class PlatformSize {
  PlatformSize({
    required this.width,
    required this.height,
  });

  double width;

  double height;

  Object encode() {
    return <Object?>[
      width,
      height,
    ];
  }

  static PlatformSize decode(Object result) {
    result as List<Object?>;
    return PlatformSize(
      width: result[0]! as double,
      height: result[1]! as double,
    );
  }
}

class _PigeonCodec extends StandardMessageCodec {
  const _PigeonCodec();
  @override
  void writeValue(WriteBuffer buffer, Object? value) {
    if (value is int) {
      buffer.putUint8(4);
      buffer.putInt64(value);
    } else if (value is PlatformCameraLensDirection) {
      buffer.putUint8(129);
      writeValue(buffer, value.index);
    } else if (value is PlatformDeviceOrientation) {
      buffer.putUint8(130);
      writeValue(buffer, value.index);
    } else if (value is PlatformExposureMode) {
      buffer.putUint8(131);
      writeValue(buffer, value.index);
    } else if (value is PlatformFocusMode) {
      buffer.putUint8(132);
      writeValue(buffer, value.index);
    } else if (value is PlatformCameraDescription) {
      buffer.putUint8(133);
      writeValue(buffer, value.encode());
    } else if (value is PlatformCameraState) {
      buffer.putUint8(134);
      writeValue(buffer, value.encode());
    } else if (value is PlatformSize) {
      buffer.putUint8(135);
      writeValue(buffer, value.encode());
    } else {
      super.writeValue(buffer, value);
    }
  }

  @override
  Object? readValueOfType(int type, ReadBuffer buffer) {
    switch (type) {
      case 129:
        final int? value = readValue(buffer) as int?;
        return value == null ? null : PlatformCameraLensDirection.values[value];
      case 130:
        final int? value = readValue(buffer) as int?;
        return value == null ? null : PlatformDeviceOrientation.values[value];
      case 131:
        final int? value = readValue(buffer) as int?;
        return value == null ? null : PlatformExposureMode.values[value];
      case 132:
        final int? value = readValue(buffer) as int?;
        return value == null ? null : PlatformFocusMode.values[value];
      case 133:
        return PlatformCameraDescription.decode(readValue(buffer)!);
      case 134:
        return PlatformCameraState.decode(readValue(buffer)!);
      case 135:
        return PlatformSize.decode(readValue(buffer)!);
      default:
        return super.readValueOfType(type, buffer);
    }
  }
}

/// Handles calls from Dart to the native side.
class CameraApi {
  /// Constructor for [CameraApi].  The [binaryMessenger] named argument is
  /// available for dependency injection.  If it is left null, the default
  /// BinaryMessenger will be used which routes to the host platform.
  CameraApi(
      {BinaryMessenger? binaryMessenger, String messageChannelSuffix = ''})
      : pigeonVar_binaryMessenger = binaryMessenger,
        pigeonVar_messageChannelSuffix =
            messageChannelSuffix.isNotEmpty ? '.$messageChannelSuffix' : '';
  final BinaryMessenger? pigeonVar_binaryMessenger;

  static const MessageCodec<Object?> pigeonChannelCodec = _PigeonCodec();

  final String pigeonVar_messageChannelSuffix;

  /// Returns the list of available cameras.
  Future<List<PlatformCameraDescription>> getAvailableCameras() async {
    final String pigeonVar_channelName =
        'dev.flutter.pigeon.camera_android.CameraApi.getAvailableCameras$pigeonVar_messageChannelSuffix';
    final BasicMessageChannel<Object?> pigeonVar_channel =
        BasicMessageChannel<Object?>(
      pigeonVar_channelName,
      pigeonChannelCodec,
      binaryMessenger: pigeonVar_binaryMessenger,
    );
    final List<Object?>? pigeonVar_replyList =
        await pigeonVar_channel.send(null) as List<Object?>?;
    if (pigeonVar_replyList == null) {
      throw _createConnectionError(pigeonVar_channelName);
    } else if (pigeonVar_replyList.length > 1) {
      throw PlatformException(
        code: pigeonVar_replyList[0]! as String,
        message: pigeonVar_replyList[1] as String?,
        details: pigeonVar_replyList[2],
      );
    } else if (pigeonVar_replyList[0] == null) {
      throw PlatformException(
        code: 'null-error',
        message: 'Host platform returned null value for non-null return value.',
      );
    } else {
      return (pigeonVar_replyList[0] as List<Object?>?)!
          .cast<PlatformCameraDescription>();
    }
  }
}

/// Handles calls from native side to Dart that are not camera-specific.
abstract class CameraGlobalEventApi {
  static const MessageCodec<Object?> pigeonChannelCodec = _PigeonCodec();

  /// Called when the device's physical orientation changes.
  void deviceOrientationChanged(PlatformDeviceOrientation orientation);

  static void setUp(
    CameraGlobalEventApi? api, {
    BinaryMessenger? binaryMessenger,
    String messageChannelSuffix = '',
  }) {
    messageChannelSuffix =
        messageChannelSuffix.isNotEmpty ? '.$messageChannelSuffix' : '';
    {
      final BasicMessageChannel<
          Object?> pigeonVar_channel = BasicMessageChannel<
              Object?>(
          'dev.flutter.pigeon.camera_android.CameraGlobalEventApi.deviceOrientationChanged$messageChannelSuffix',
          pigeonChannelCodec,
          binaryMessenger: binaryMessenger);
      if (api == null) {
        pigeonVar_channel.setMessageHandler(null);
      } else {
        pigeonVar_channel.setMessageHandler((Object? message) async {
          assert(message != null,
              'Argument for dev.flutter.pigeon.camera_android.CameraGlobalEventApi.deviceOrientationChanged was null.');
          final List<Object?> args = (message as List<Object?>?)!;
          final PlatformDeviceOrientation? arg_orientation =
              (args[0] as PlatformDeviceOrientation?);
          assert(arg_orientation != null,
              'Argument for dev.flutter.pigeon.camera_android.CameraGlobalEventApi.deviceOrientationChanged was null, expected non-null PlatformDeviceOrientation.');
          try {
            api.deviceOrientationChanged(arg_orientation!);
            return wrapResponse(empty: true);
          } on PlatformException catch (e) {
            return wrapResponse(error: e);
          } catch (e) {
            return wrapResponse(
                error: PlatformException(code: 'error', message: e.toString()));
          }
        });
      }
    }
  }
}

/// Handles device-specific calls from native side to Dart.
abstract class CameraEventApi {
  static const MessageCodec<Object?> pigeonChannelCodec = _PigeonCodec();

  /// Called when the camera is initialized.
  void initialized(PlatformCameraState initialState);

  /// Called when an error occurs in the camera.
  void error(String message);

  /// Called when the camera closes.
  void closed();

  static void setUp(
    CameraEventApi? api, {
    BinaryMessenger? binaryMessenger,
    String messageChannelSuffix = '',
  }) {
    messageChannelSuffix =
        messageChannelSuffix.isNotEmpty ? '.$messageChannelSuffix' : '';
    {
      final BasicMessageChannel<
          Object?> pigeonVar_channel = BasicMessageChannel<
              Object?>(
          'dev.flutter.pigeon.camera_android.CameraEventApi.initialized$messageChannelSuffix',
          pigeonChannelCodec,
          binaryMessenger: binaryMessenger);
      if (api == null) {
        pigeonVar_channel.setMessageHandler(null);
      } else {
        pigeonVar_channel.setMessageHandler((Object? message) async {
          assert(message != null,
              'Argument for dev.flutter.pigeon.camera_android.CameraEventApi.initialized was null.');
          final List<Object?> args = (message as List<Object?>?)!;
          final PlatformCameraState? arg_initialState =
              (args[0] as PlatformCameraState?);
          assert(arg_initialState != null,
              'Argument for dev.flutter.pigeon.camera_android.CameraEventApi.initialized was null, expected non-null PlatformCameraState.');
          try {
            api.initialized(arg_initialState!);
            return wrapResponse(empty: true);
          } on PlatformException catch (e) {
            return wrapResponse(error: e);
          } catch (e) {
            return wrapResponse(
                error: PlatformException(code: 'error', message: e.toString()));
          }
        });
      }
    }
    {
      final BasicMessageChannel<
          Object?> pigeonVar_channel = BasicMessageChannel<
              Object?>(
          'dev.flutter.pigeon.camera_android.CameraEventApi.error$messageChannelSuffix',
          pigeonChannelCodec,
          binaryMessenger: binaryMessenger);
      if (api == null) {
        pigeonVar_channel.setMessageHandler(null);
      } else {
        pigeonVar_channel.setMessageHandler((Object? message) async {
          assert(message != null,
              'Argument for dev.flutter.pigeon.camera_android.CameraEventApi.error was null.');
          final List<Object?> args = (message as List<Object?>?)!;
          final String? arg_message = (args[0] as String?);
          assert(arg_message != null,
              'Argument for dev.flutter.pigeon.camera_android.CameraEventApi.error was null, expected non-null String.');
          try {
            api.error(arg_message!);
            return wrapResponse(empty: true);
          } on PlatformException catch (e) {
            return wrapResponse(error: e);
          } catch (e) {
            return wrapResponse(
                error: PlatformException(code: 'error', message: e.toString()));
          }
        });
      }
    }
    {
      final BasicMessageChannel<
          Object?> pigeonVar_channel = BasicMessageChannel<
              Object?>(
          'dev.flutter.pigeon.camera_android.CameraEventApi.closed$messageChannelSuffix',
          pigeonChannelCodec,
          binaryMessenger: binaryMessenger);
      if (api == null) {
        pigeonVar_channel.setMessageHandler(null);
      } else {
        pigeonVar_channel.setMessageHandler((Object? message) async {
          try {
            api.closed();
            return wrapResponse(empty: true);
          } on PlatformException catch (e) {
            return wrapResponse(error: e);
          } catch (e) {
            return wrapResponse(
                error: PlatformException(code: 'error', message: e.toString()));
          }
        });
      }
    }
  }
}