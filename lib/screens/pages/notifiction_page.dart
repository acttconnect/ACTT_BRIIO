// ignore_for_file: prefer_typing_uninitialized_variables, deprecated_member_use

import 'package:briio_application/widgets/custom_loading.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

import '../../model/new_notification_model.dart';
import '../../utils/api_endpoints.dart';
import '../../utils/globel_veriable.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  var data;

  Future<NewNotificationModel> getNotifiction() async {
    try {
      final response = await http
          .post(Uri.parse('${ApiEndpoints.notifications}?user_id=${GlobalK.userId}'));

      if (response.statusCode == 200) {
        data = jsonDecode(response.body.toString());
        if (data['error'] == false) {
          return NewNotificationModel.fromJson(data);
        }
      }
      return NewNotificationModel(error: false, message: []);
    } catch (e) {
      return NewNotificationModel(error: false, message: []);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios_new,color: Colors.grey.shade700,size: 18,),
        ),
        surfaceTintColor: Colors.white,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          centerTitle: true,
          elevation: 1,
          title: Text('NOTIFICATION',style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade700
          ),)),
      body: (GlobalK.userId == null)
          ? Center(
              child: Container(
                width: double.infinity,
                color: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        shape: BoxShape.circle,
                      ),
                      width: 140,
                      height: 140,
                      child: Center(
                        child: Icon(
                          Icons.notifications_off_outlined,
                          size: 60,
                          color: Colors.grey.shade400,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Text(
                      'No Notification Yet...',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
              ),
            )
          : FutureBuilder<NewNotificationModel>(
        future: getNotifiction(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CustomLoading(width: 40, height: 40));
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error loading notifications', style: TextStyle(color: Colors.grey.shade700)));
          }
          if (!snapshot.hasData || snapshot.data!.message == null || snapshot.data!.message!.isEmpty) {
            return Center(
              child: Container(
                width: double.infinity,
                color: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        shape: BoxShape.circle,
                      ),
                      width: 140,
                      height: 140,
                      child: Center(
                        child: Icon(
                          Icons.notifications_off_outlined,
                          size: 60,
                          color: Colors.grey.shade400,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Text(
                      'No Notification Yet...',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
              ),
            );
          }
          
          return ListView.builder(
            itemCount: snapshot.data!.message!.length,
            itemBuilder: (context, index) {
              final msg = snapshot.data!.message![index];
              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)
                ),
                margin: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (msg.productName != null && msg.productName.toString().trim().isNotEmpty)
                              Text(
                                msg.productName.toString(),
                                style: GoogleFonts.lato(
                                    textStyle: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black,
                                        height: 1.5)),
                              ),
                            if (msg.title != null && msg.title.toString().trim().isNotEmpty)
                              Text(
                                msg.title.toString(),
                                style: GoogleFonts.lato(
                                  textStyle: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black54,
                                  ),
                                ),
                              ),
                            if (msg.message != null && msg.message.toString().trim().isNotEmpty)
                              Text(
                                msg.message.toString(),
                                style: GoogleFonts.lato(
                                  textStyle: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                ),
                              )
                          ],
                        ),
                      ),
                      if (msg.createdAt != null && msg.createdAt!.contains('T'))
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(msg.createdAt!.split('T').first),
                            if (msg.createdAt!.split('T').last.contains('.'))
                              Text(msg.createdAt!.split('T').last.split('.').first.substring(0, 5))
                          ],
                        ),
                    ],
                  ),
                ),
              );
            }
          );
        }
      ),
    );
  }
}
