import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:webview_flutter/webview_flutter.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(Loggedout());

  void checkLoginState(WebViewController? controller) async {
    if (controller is Null) {
      return;
    }
    dynamic registerLink = await controller.runJavascriptReturningResult(
        "document.querySelectorAll(\"a[href='https://gruppenstunde.ch/mein-konto/?eael-register=1']\").length;");
    int registerLinkCount = int.tryParse(registerLink) ?? 0;

    if (registerLinkCount > 0) {
      if (state is Loggedout) emit(Loggedin());
    } else {
      if (state is Loggedin) emit(Loggedout());
    }
  }
}
