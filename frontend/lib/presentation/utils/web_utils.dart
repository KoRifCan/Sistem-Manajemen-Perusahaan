import 'dart:html' as html;

void webReload() {
  html.window.location.reload();
}

void webInstallPwa() {
  html.window.callMethod('installPwa', []);
}
