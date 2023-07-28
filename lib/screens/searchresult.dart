import 'package:flutter/material.dart';

class SearchResultsScreen extends StatelessWidget {
  final String searchQuery;

  SearchResultsScreen({required this.searchQuery});

  @override
  Widget build(BuildContext context) {
    // Implement the UI to display the search results here.
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Results'),
      ),
      body: Center(
        child: Text('Results for: $searchQuery'),
      ),
    );
  }
}
