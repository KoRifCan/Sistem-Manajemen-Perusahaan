import 'dart:js_util' as js_util;

void webReload() {
  js_util.callMethod(js_util.globalThis, 'reloadPage', []);
}

bool webIsStandalone() {
  try {
    final result = js_util.callMethod(js_util.globalThis, 'isStandalone', []);
    return result == true;
  } catch (_) {
    return false;
  }
}

bool webInstallPwa() {
  try {
    final fn = js_util.getProperty(js_util.globalThis, 'installPwa');
    if (fn == null) return false;
    final result = js_util.callMethod(js_util.globalThis, 'installPwa', []);
    return result == true;
  } catch (_) {
    return false;
  }
}
