import 'dart:io';

import 'package:flutter/services.dart';

const _channel = MethodChannel('alisters/storage');
File _file() {
  final env = Platform.environment;
  final base = Platform.isWindows
      ? env['APPDATA']
      : (env['HOME'] == null ? null : '${env['HOME']}/.local/share');
  if (base == null) {
    throw const FileSystemException('Pasta de dados indisponível');
  }
  return File(
    '$base${Platform.pathSeparator}Alisters${Platform.pathSeparator}entries.json',
  );
}

Future<String?> read() async {
  if (Platform.isAndroid || Platform.isIOS) {
    return _channel.invokeMethod<String>('read');
  }
  final file = _file();
  return await file.exists() ? file.readAsString() : null;
}

Future<void> write(String data) async {
  if (Platform.isAndroid || Platform.isIOS) {
    await _channel.invokeMethod<void>('write', data);
    return;
  }
  final file = _file();
  await file.parent.create(recursive: true);
  await file.writeAsString(data, flush: true);
}
