import 'dart:js_util' as js_util;

void webReload() {
  js_util.callMethod(js_util.globalThis, 'reloadPage', []);
}

void webInstallPwa() {
  js_util.callMethod(js_util.globalThis, 'installPwa', []);
}
