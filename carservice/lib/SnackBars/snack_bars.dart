import 'package:carservice/packages/packages.dart';

class SnackBars {
  BuildContext context;
  String Msg;
  SnackBars(this.context, this.Msg);

  void showSnackBars() {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.blue,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        behavior: SnackBarBehavior.floating,
        content: Text(Msg),
      ),
    );
  }
}
