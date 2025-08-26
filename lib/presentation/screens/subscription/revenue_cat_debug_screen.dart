import 'package:flutter/material.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class RevenueCatDebugScreen extends StatefulWidget {
  const RevenueCatDebugScreen({super.key});

  @override
  State<RevenueCatDebugScreen> createState() => _RevenueCatDebugScreenState();
}

class _RevenueCatDebugScreenState extends State<RevenueCatDebugScreen> {
  Offerings? _offerings;
  CustomerInfo? _customerInfo;
  bool _loading = true;
  String _message = "";

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() => _loading = true);
    try {
      final offerings = await Purchases.getOfferings();
      final customerInfo = await Purchases.getCustomerInfo();

      setState(() {
        _offerings = offerings;
        _customerInfo = customerInfo;
        _message =
        "User ID: ${customerInfo.originalAppUserId}\nActive Entitlements: ${customerInfo.entitlements.active.keys.join(", ")}";
      });
    } catch (e) {
      setState(() {
        _message = "Error fetching data: $e";
      });
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _purchasePackage(Package package) async {
    setState(() => _loading = true);
    try {
      final customerInfo = await Purchases.purchasePackage(package);
      setState(() {
        _customerInfo = customerInfo;
        _message =
        "Purchase successful!\nActive Entitlements: ${customerInfo.entitlements.active.keys.join(", ")}";
      });
    } on PurchasesErrorCode catch (e) {
      setState(() {
        _message = "Purchase error: ${e.toString()}";
      });
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("RevenueCat Debug"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchData,
          )
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _message,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              if (_offerings?.current != null)
                ..._offerings!.current!.availablePackages.map(
                      (pkg) => Card(
                    child: ListTile(
                      title: Text(
                          "${pkg.product.title} - ${pkg.product.priceString}"),
                      subtitle: Text(pkg.identifier),
                      trailing: ElevatedButton(
                        child: const Text("Buy"),
                        onPressed: () => _purchasePackage(pkg),
                      ),
                    ),
                  ),
                )
              else
                const Text(
                  "No offerings configured in RevenueCat.",
                  style: TextStyle(color: Colors.red),
                )
            ],
          ),
        ),
      ),
    );
  }
}
