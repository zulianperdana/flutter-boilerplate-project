import 'package:boilerplate/data/network/exceptions/network_exceptions.dart';
import 'package:boilerplate/data/repository.dart';
import 'package:catcher/model/report_mode.dart';
import 'package:catcher/model/report.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomDialogReportMode extends ReportMode {
  @override
  void requestAction(Report report, BuildContext context) {
    _showDialog(report, context);
  }

  Future _showDialog(Report report, BuildContext context) async {
    await Future.delayed(Duration.zero);
    if (report.error is AuthException) {
      await Provider.of<Repository>(context, listen: false)
          .authRepository
          .logout();
      Navigator.of(context).pushNamedAndRemoveUntil('login', (r) => false);
      super.onActionRejected(report);
      return;
    }
    if (report.error is NetworkException) {
      super.onActionRejected(report);
      showDialog(
          context: context,
          builder: (BuildContext build) {
            return AlertDialog(
              title: const Text('Network Error'),
              content: Text((report.error as NetworkException).message),
              actions: <Widget>[
                FlatButton(
                  child: const Text('Ok'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            );
          });
      return;
    }
    showDialog(
        context: context,
        builder: (BuildContext build) {
          return AlertDialog(
            title: Text(localizationOptions.dialogReportModeTitle),
            content: Text(localizationOptions.dialogReportModeDescription),
            actions: <Widget>[
              FlatButton(
                child: Text(localizationOptions.dialogReportModeAccept),
                onPressed: () => _acceptReport(context, report),
              ),
              FlatButton(
                child: Text(localizationOptions.dialogReportModeCancel),
                onPressed: () => _cancelReport(context, report),
              ),
            ],
          );
        });
  }

  void _acceptReport(BuildContext context, Report report) {
    super.onActionConfirmed(report);
    Navigator.pop(context);
  }

  void _cancelReport(BuildContext context, Report report) {
    super.onActionRejected(report);
    Navigator.pop(context);
  }

  @override
  bool isContextRequired() {
    return true;
  }
}
