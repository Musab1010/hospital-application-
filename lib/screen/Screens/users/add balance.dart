import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../model/balance_provider.dart';

class AddBalance extends StatefulWidget {
  static const String screenRoute = "addbalance";

  const AddBalance({super.key});

  @override
  _AddBalanceState createState() => _AddBalanceState();
}

class _AddBalanceState extends State<AddBalance> {
  final TextEditingController _balanceController = TextEditingController();
  final TextEditingController _transactionIdController = TextEditingController();

  User? user;
  int currentBalance = 0;

  final Map<String, List<String>> _accounts = {
    'بنكك مصعب تاج السر عابدين': ['2070155'],
    'فوري مصعب تاج السر عابدين': ['51583593'],
    'اووكاش مصعب تاج السر عابدين': ['844474'],
  };

  String? _selectedAccountName;
  String? _selectedAccountNumber;
  List<String> _accountNumbers = [];

  @override
  void initState() {
    super.initState();
    fetchCurrentUser();
    listenToRequests();
  }

  void fetchCurrentUser() async {
    user = FirebaseAuth.instance.currentUser;
    if (user != null) fetchUserData();
  }

  void fetchUserData() async {
    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .get();

      setState(() {
        currentBalance = userDoc['balance'] ?? 0;
      });
    } catch (e) {
      debugPrint('Error fetching user data: $e');
    }
  }

  void listenToRequests() {
    if (user == null) return;

    FirebaseFirestore.instance
        .collection('requests')
        .where('uid', isEqualTo: user!.uid)
        .where('isApproved', isEqualTo: true)
        .snapshots()
        .listen((snapshot) {
      for (var doc in snapshot.docs) {
        final amount = doc['amount'];
        updateUserBalance(amount);

        FirebaseFirestore.instance.collection('requests').doc(doc.id).update({
          'isApproved': false,
        });
      }
    });
  }

  Future<void> updateUserBalance(int amount) async {
    if (user == null) return;

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .update({'balance': FieldValue.increment(amount)});

      setState(() {
        currentBalance += amount;
      });
    } catch (e) {
      _showSnackBar('حدث خطأ أثناء تحديث الرصيد: $e');
    }
  }

  Future<void> _handleSubmit() async {
    final amountToAdd = int.tryParse(_balanceController.text) ?? 0;
    final transactionId = int.tryParse(_transactionIdController.text);

    if (transactionId == null) {
      _showSnackBar('يرجى إدخال رقم معاملة صالح');
      return;
    }

    if (_selectedAccountName == null || _selectedAccountNumber == null) {
      _showSnackBar('يرجى اختيار اسم الحساب ورقم الحساب');
      return;
    }

    if (amountToAdd > 0) {
      // استخدام الدالة من Provider لإرسال طلب إضافة الرصيد
      await Provider.of<BalanceProvider>(context, listen: false).createBalanceRequest(
        context,
        amountToAdd,
        transactionId,
        _selectedAccountName!,
        _selectedAccountNumber!,
      );

      // تفريغ الحقول بعد الإرسال
      _resetFields();
    } else {
      _showSnackBar('الرجاء إدخال مبلغ صالح');
    }
  }

  void _resetFields() {
    _balanceController.clear();
    _transactionIdController.clear();
    setState(() {
      _selectedAccountName = null;
      _selectedAccountNumber = null;
      _accountNumbers = [];
    });
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إدارة الرصيد'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding:  EdgeInsets.all(16.0.h),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDropdown(
                hint: 'اختر اسم الحساب',
                value: _selectedAccountName,
                items: _accounts.keys.toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedAccountName = newValue;
                    _accountNumbers = _accounts[newValue] ?? [];
                    _selectedAccountNumber = null;
                  });
                },
              ),
               SizedBox(height: 16.h),
              _buildDropdown(
                hint: 'اختر رقم الحساب',
                value: _selectedAccountNumber,
                items: _accountNumbers,
                onChanged: (newValue) {
                  setState(() {
                    _selectedAccountNumber = newValue;
                  });
                },
              ),
               SizedBox(height: 16.h),
              _buildTextField(
                controller: _balanceController,
                label: 'أدخل المبلغ المراد إضافته',
              ),
               SizedBox(height: 16.h),
              _buildTextField(
                controller: _transactionIdController,
                label: 'رقم المعاملة',
              ),
               SizedBox(height: 16.h),
              Padding(
                padding:  EdgeInsets.all(8.0.h),
                child: ElevatedButton(
                  
                  onPressed: _handleSubmit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.w),
                    ),
                    padding:  EdgeInsets.symmetric(vertical: 15.w),
                  ),
                  child: Padding(
                    padding:  EdgeInsets.all(8.0.h),
                    child:  Text(
                      'طلب إضافة رصيد',
                      style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
               SizedBox(height: 16.h),
              Text(
                'الرصيد الحالي: $currentBalance',
                style: TextStyle(fontSize: 18.sp, color: Colors.blue),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String hint,
    required String? value,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.w),
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.2), spreadRadius: 2, blurRadius: 4),
        ],
      ),
      child: DropdownButton<String>(
        hint: Text(hint, style: TextStyle(color: Colors.grey)),
        value: value,
        isExpanded: true,
        items: items.map((item) {
          return DropdownMenuItem(value: item, child: Text(item));
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.w),
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.2), spreadRadius: 2, blurRadius: 4),
        ],
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.blue),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 16.w),
        ),
      ),
    );
  }
}
