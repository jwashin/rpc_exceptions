// Copyright (c) 2021, James Washington.  MIT License.
library rpc_exceptions;

/// Base RPC exception class
///
/// The JSON-RPC specification addresses a few special exceptions that we want
/// to emulate.
class RpcException implements Exception {
  /// maybe an identifying code
  int code;

  /// maybe a helpful message
  String message = '';

  /// maybe useful data
  dynamic data;

  /// Constructor. Message is not optional, everything else is.
  RpcException(this.message, [this.code = 0, this.data]);

  @override
  String toString() {
    return 'RPC Exception: $code $message';
  }

  Map<String, dynamic> toJson() {
    var theMap = <String, dynamic>{'code': code, 'message': message};
    if (data != null) {
      theMap['data'] = data;
    }
    return theMap;
  }
}

/// [MethodNotFoundException] may be thrown when a method cannot be invoked.
///
/// This exception is identified in the JSON-RPC v2 specification.
class MethodNotFoundException extends RpcException {
  /// constructor
  MethodNotFoundException([String msg = '', int newCode = -32601])
      : super(msg, newCode);
}

/// [InvalidParametersException] may be thrown when a method cannot be invoked.
///
/// This exception is identified in the JSON-RPC v2 specification.
class InvalidParametersException extends RpcException {
  /// constructor
  InvalidParametersException([String msg = '', int newCode = -32602])
      : super(msg, newCode);
}

/// Remote facility to communicate application-level response-side exceptions.
///
/// If an application-level server-side exception should be handled on the
/// client side, we can send this info back to the client with an error code,
/// a message, and/or useful data. Look for [checkResponse] in client
/// JSON-RPC v2 implementation. Make sure that data is json-encodable, if you
/// want to send it.
class RuntimeException extends RpcException {
  /// maybe include some useful data

  RuntimeException(String message, [code = -32000, data])
      : super(message, code, data);
  RuntimeException.fromJson(Map<String, dynamic> e) : super('') {
    if (e.containsKey('message')) {
      message = e['message'];
    }
    if (e.containsKey('code')) {
      code = e['code'];
    }
    if (e.containsKey('data')) {
      data = e['data'];
    }
  }
}

/// [TransportStatusError] is an error related to a JSON-RPC transport.
///
/// If you want to identify errors in your network transport,
/// for example, this provides a hook for that purpose.
class TransportStatusError implements Exception {
  /// maybe a helpful message
  String message;

  /// maybe some helpful data
  dynamic data;

  /// maybe the request itself
  dynamic request;

  /// constructor
  TransportStatusError(this.message, [this.request, this.data]);

  @override
  String toString() => '$message';
}
