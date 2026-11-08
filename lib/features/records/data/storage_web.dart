import 'dart:js_interop';
import 'dart:js_interop_unsafe';

const _key = 'alisters.entries';
JSObject get _storage =>
    globalContext.getProperty<JSObject>('localStorage'.toJS);
Future<String?> read() async =>
    _storage.callMethod<JSString?>('getItem'.toJS, _key.toJS)?.toDart;
Future<void> write(String data) async {
  _storage.callMethod<JSAny?>('setItem'.toJS, _key.toJS, data.toJS);
}
