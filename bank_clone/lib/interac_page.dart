import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';

class InteracPaymentPage extends StatefulWidget {
  final Map<String, double> balances;

  const InteracPaymentPage({super.key, required this.balances});

  @override
  State<InteracPaymentPage> createState() => _InteracPaymentPageState();
}

class _InteracPaymentPageState extends State<InteracPaymentPage> {
  String? _selectedAccount;
  final _amountController = TextEditingController();
  final _recipientController = TextEditingController();

  void _sendPayment() {
    if (_selectedAccount == null) {
      _showSnackbar('Please select an account.');
      return;
    }
    if (!EmailValidator.validate(_recipientController.text) ||
        _recipientController.text.isEmpty) {
      _showSnackbar('Please enter a valid recipient email.');
      return;
    }
    if (_amountController.text.isEmpty) {
      _showSnackbar('Please enter an amount.');
      return;
    }

    final double? paymentAmount = double.tryParse(_amountController.text);
    if (paymentAmount == null || paymentAmount <= 0) {
      _showSnackbar('Please enter a valid amount greater than zero.');
      return;
    }

    final String selectedAccount = _selectedAccount!;
    final String recipient = _recipientController.text;

    if (widget.balances[selectedAccount]! >= paymentAmount) {
      Navigator.pop(context, {
        'account': selectedAccount,
        'amount': paymentAmount,
        'recipient': recipient,
      });
    } else {
      _showSnackbar('Insufficient funds in the selected account.');
    }
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.redAccent,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Send Interac Payment'),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 6,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Select Account',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      value: _selectedAccount,
                      items: widget.balances.keys
                          .where((account) => account != 'Credit')
                          .map((account) => DropdownMenuItem(
                                value: account,
                                child: Text(account),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedAccount = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Select an account',
                        filled: true,
                        fillColor: Colors.blue[50],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Recipient Email',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _recipientController,
                      decoration: InputDecoration(
                        prefixIcon:
                            const Icon(Icons.email, color: Colors.blueAccent),
                        hintText: 'Enter recipient email',
                        filled: true,
                        fillColor: Colors.blue[50],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Amount',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _amountController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                            Icons.attach_money, color: Colors.blueAccent),
                        hintText: 'Enter the amount',
                        filled: true,
                        fillColor: Colors.blue[50],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _sendPayment,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                    horizontal: 40, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                backgroundColor: Colors.blueAccent,
                foregroundColor: Colors.white,
                elevation: 5,
              ),
              child: const Text(
                'Send Payment',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    _recipientController.dispose();
    super.dispose();
  }
}
