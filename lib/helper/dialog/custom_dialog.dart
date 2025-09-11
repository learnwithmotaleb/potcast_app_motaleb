import 'package:flutter/material.dart';

Future<void> showCustomAnimatedDialog({
  required BuildContext context,
  bool isDismissible = true,
  String? title,
  String? subtitle,
  List<Widget>? actionButton,
}) {
  return showGeneralDialog(
    context: context,
    barrierDismissible: isDismissible,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor: Colors.black.withOpacity(0.5),
    transitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (_, __, ___) {
      return const SizedBox.shrink();
    },
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      final curvedValue = Curves.easeOutBack.transform(animation.value);

      return Opacity(
        opacity: animation.value,
        child: Transform.scale(
          scale: curvedValue,
          child: Center(
            child: Dialog(
              backgroundColor: Colors.black,
              insetPadding: const EdgeInsets.symmetric(horizontal: 24),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 20,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (title != null && title.isNotEmpty)
                      Text(
                        title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    if (subtitle != null && subtitle.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Text(
                        subtitle,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey.shade300,
                        ),
                      ),
                    ],
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: actionButton ??
                          [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text("OK",
                                  style: TextStyle(color: Colors.blue)),
                            ),
                          ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    },
  );
}
