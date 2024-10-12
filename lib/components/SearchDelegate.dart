import 'package:flutter/material.dart';

class CustomSearchDelegate extends SearchDelegate {
  final List<String> data; // البيانات التي سيتم البحث فيها

  CustomSearchDelegate({required this.data});

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = query.isEmpty
        ? data
        : data.where((item) => item.toLowerCase().contains(query.toLowerCase())).toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final suggestion = suggestions[index];
        return ListTile(
          title: Text(suggestion),
          onTap: () {
            query = suggestion;
            showResults(context);
          },
        );
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = data.where((item) => item.toLowerCase().contains(query.toLowerCase())).toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final result = results[index];
        return ListTile(
          title: Text(result),
          onTap: () {
            // يمكنك تنفيذ أي عملية عند اختيار نتيجة البحث
            // مثلا: Navigator.push(context, MaterialPageRoute(builder: (context) => ResultPage(result: result)));
          },
        );
      },
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null); // يغلق شريط البحث
      },
    );
  }

  @override
  String? get searchFieldLabel => 'بحث...';
}
