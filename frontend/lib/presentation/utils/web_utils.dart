import 'dart:js_interop';

void webReload() {
  globalContext.callMethod('reloadPage'.toJS);
}

void webInstallPwa() {
  globalContext.callMethod('installPwa'.toJS);
}
