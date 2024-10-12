import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:my_strore/components/custom_app_bar.dart';

class Statistics extends StatefulWidget {
  const Statistics({super.key});

  @override
  State<Statistics> createState() => _StatisticsState();
}

class _StatisticsState extends State<Statistics> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Map<String, dynamic>? statisticsData; // لتخزين بيانات الإحصائيات

  @override
  void initState() {
    super.initState();
    fetchStatistics();
  }

  Future<void> fetchStatistics() async {
    try {
      final response = await http.get(Uri.parse('http://10.0.2.2:8000/api/statistics'));

      if (response.statusCode == 200) {
        setState(() {
          statisticsData = json.decode(response.body)['data'];
        });
      } else {
        showSnackBar('فشل في تحميل الإحصائيات');
      }
    } catch (e) {
      showSnackBar('حدث خطأ: $e');
    }
  }

  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.redAccent,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: customAppBar(
        title: 'Statistics Page',
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Implement search functionality if needed
            },
          ),
        ],
      ),
      body: statisticsData == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      'Statistics',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            color: Colors.deepPurple[700], // لون أحمر متوسط العتامة
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildStatisticCard('Category', statisticsData!['category']),
                  _buildStatisticCard('Product', statisticsData!['product']),
                  _buildStatisticCard('Order', statisticsData!['order']),
                  _buildStatisticCard('User', statisticsData!['user']),
                ],
              ),
            ),
    );
  }

  Widget _buildStatisticCard(String title, int count) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 4, // إضافة تأثير ظل البطاقة
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12), // زوايا دائرية للبطاقة
      ),
      color: Colors.deepPurple[50], // لون خلفية البطاقة (اللون نفسه المستخدم في الأزرار)
      child: ListTile(
        contentPadding: const EdgeInsets.all(16.0),
        title: Text(title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.deepPurple, // لون النص (اللون نفسه المستخدم في الأزرار)
            )),
        trailing: Text(count.toString(),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.deepPurple, // لون النص (اللون نفسه المستخدم في الأزرار)
            )),
      ),
    );
  }
}
