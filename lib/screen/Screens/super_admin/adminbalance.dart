import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../model/Super_Admin_RequestProvider.dart';

class AdminPage extends StatelessWidget {
  const AdminPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<RequestsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('إدارة الطلبات'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('requests')
            .where('isApproved', isEqualTo: false)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('لا توجد طلبات حالية'));
          }

          final requests = snapshot.data!.docs
              .where((doc) => !provider.hiddenRequests.contains(doc.id))
              .toList();

          if (requests.isEmpty) {
            return const Center(child: Text('لا توجد طلبات حالية'));
          }

          return Padding(
            padding:  EdgeInsets.all(16.0.h),
            child: ListView.builder(
              itemCount: requests.length,
              itemBuilder: (context, index) {
                final request = requests[index];
                final requestData = request.data() as Map<String, dynamic>;

                return Card(
                  elevation: 5,
                  margin:  EdgeInsets.symmetric(vertical: 8.w),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.w),
                  ),
                  child: Padding(
                    padding:  EdgeInsets.all(16.0.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('اسم الحساب: ${requestData['accountName']}',
                            style: Theme.of(context).textTheme.bodyMedium),
                         SizedBox(height: 10.h),
                        Text('رقم الحساب: ${requestData['accountNumber']}'),
                        Text('UID: ${requestData['uid']}'),
                        Text('المبلغ: ${requestData['amount']}'),
                        Text('رقم المعاملة: ${requestData['transactionId']}',
                            style: const TextStyle(color: Colors.blue)),
                         SizedBox(height: 16.h),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: provider.isLoading
                                    ? null
                                    : () async {
                                        try {
                                          await provider.approveRequest(
                                            request.id,
                                            requestData['uid'],
                                            requestData['amount'],
                                          );
                                          
                                          // تأجيل عرض SnackBar
                                          WidgetsBinding.instance.addPostFrameCallback((_) {
                                            if (context.mounted) {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                const SnackBar(
                                                  content: Text('تمت الموافقة على الطلب بنجاح'),
                                                ),
                                              );
                                            }
                                          });
                                        } catch (e) {
                                          // تأجيل عرض SnackBar عند الخطأ
                                          WidgetsBinding.instance.addPostFrameCallback((_) {
                                            if (context.mounted) {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(
                                                  content: Text(e.toString()),
                                                ),
                                              );
                                            }
                                          });
                                        }
                                      },
                                child: const Text('موافقة'),
                              ),
                            ),
                             SizedBox(width: 8.w),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: provider.isLoading
                                    ? null
                                    : () async {
                                        try {
                                          await provider.rejectRequest(request.id);
                                          
                                          // تأجيل عرض SnackBar
                                          WidgetsBinding.instance.addPostFrameCallback((_) {
                                            if (context.mounted) {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                const SnackBar(
                                                  content: Text('تم رفض الطلب بنجاح'),
                                                ),
                                              );
                                            }
                                          });
                                        } catch (e) {
                                          // تأجيل عرض SnackBar عند الخطأ
                                          WidgetsBinding.instance.addPostFrameCallback((_) {
                                            if (context.mounted) {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(
                                                  content: Text(e.toString()),
                                                ),
                                              );
                                            }
                                          });
                                        }
                                      },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                ),
                                child: const Text('رفض'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
