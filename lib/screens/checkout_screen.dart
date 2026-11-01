import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../providers/order_provider.dart';
import 'order_success_screen.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});
  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _phone = TextEditingController();
  final _address = TextEditingController();
  bool _placingOrder = false;

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    _address.dispose();
    super.dispose();
  }

  String? _required(String? value) =>
      value == null || value.trim().isEmpty ? 'This field is required' : null;

  void _placeOrder() async {
    if (!_formKey.currentState!.validate()) return;
    final cart = context.read<CartProvider>();
    if (cart.items.isEmpty) return;
    setState(() => _placingOrder = true);
    final orderId = DateTime.now().millisecondsSinceEpoch.toString();
    context.read<OrderProvider>().placeOrder(
        customerName: _name.text.trim(),
        address: _address.text.trim(),
        items: cart.items.values.toList(),
        total: cart.total);
    cart.clear();
    if (!mounted) return;
    setState(() => _placingOrder = false);
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => OrderSuccessScreen(orderId: orderId)),
        (route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    return Scaffold(
        appBar: AppBar(title: const Text('Checkout')),
        body: Form(
            key: _formKey,
            child: ListView(padding: const EdgeInsets.all(20), children: [
              const Text('Delivery details',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 18),
              TextFormField(
                  controller: _name,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                      labelText: 'Full name',
                      prefixIcon: Icon(Icons.person_outline),
                      border: OutlineInputBorder()),
                  validator: _required),
              const SizedBox(height: 14),
              TextFormField(
                  controller: _phone,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                      labelText: 'Phone number',
                      prefixIcon: Icon(Icons.phone_outlined),
                      border: OutlineInputBorder()),
                  validator: (v) =>
                      v == null || !RegExp(r'^\d{10}$').hasMatch(v.trim())
                          ? 'Enter a valid 10-digit phone number'
                          : null),
              const SizedBox(height: 14),
              TextFormField(
                  controller: _address,
                  minLines: 3,
                  maxLines: 4,
                  decoration: const InputDecoration(
                      labelText: 'Full delivery address',
                      alignLabelWithHint: true,
                      prefixIcon: Icon(Icons.location_on_outlined),
                      border: OutlineInputBorder()),
                  validator: _required),
              const SizedBox(height: 24),
              const Text('Payment method',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(Icons.payments_outlined),
                  title: Text('Cash on delivery'),
                  subtitle:
                      Text('Demo checkout — no real payment is processed.')),
              const Divider(height: 28),
              Row(children: [
                const Expanded(
                    child: Text('Order total',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold))),
                Text('₹${cart.total.toStringAsFixed(2)}',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold))
              ]),
              const SizedBox(height: 20),
              SizedBox(
                  height: 50,
                  child: FilledButton(
                      onPressed: _placingOrder ? null : _placeOrder,
                      child: _placingOrder
                          ? const CircularProgressIndicator()
                          : const Text('Place demo order'))),
            ])));
  }
}
