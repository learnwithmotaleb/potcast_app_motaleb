import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:podcast/core/route/routes.dart';
import 'package:podcast/helper/toast_message/toast_message.dart';

class PaymentWebViewScreen extends StatefulWidget {
  const PaymentWebViewScreen({super.key, required this.paymentUrl});
  final String paymentUrl;

  @override
  State<PaymentWebViewScreen> createState() => _PaymentWebViewScreenState();
}

class _PaymentWebViewScreenState extends State<PaymentWebViewScreen> {
  double _progress = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
      ),
      body: Stack(
        children: [
          InAppWebView(
            initialUrlRequest: URLRequest(url: WebUri(widget.paymentUrl)),
            onProgressChanged: (controller, progress) {
              setState(() {
                _progress = progress / 100;
              });
            },
            shouldOverrideUrlLoading: (controller, navigationAction) async {
              final url = navigationAction.request.url.toString();
              bool isSuccess = url.contains('/success');
              bool isHttps = url.contains('https');
              if (isSuccess) {
                toastMessage(message: "Payment Successful");
                AppRouter.route.pop();
              }
              if (isHttps) {
                return NavigationActionPolicy.ALLOW;
              } else {
                return NavigationActionPolicy.CANCEL;
              }
            },
            onLoadStop: (controller, url) {
              setState(() {
                _progress = 1.0;
              });
            },
          ),
          if (_progress < 1.0)
            Center(child: CircularProgressIndicator(value: _progress)),
        ],
      ),
    );
  }
}
