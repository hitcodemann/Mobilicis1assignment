import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:mobilicis/screens/searchresult.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class SearchBar extends StatefulWidget {
  const SearchBar({super.key});

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  final TextEditingController _searchQuery = TextEditingController();
  List<String> _suggestions = [];

  Future<List<String>> _onSearch() async {
    String searchQuery = _searchQuery.text;
    String requestBody = '{ "searchModel": "$searchQuery" }';
    try {
      final response = await Dio().post(
        'https://dev2be.oruphones.com/api/v1/global/assignment/searchModel',
        data: requestBody,
        options: Options(
          contentType: 'application/json',
        ),
      );
      if (response.statusCode == 200) {
        // ignore: use_build_context_synchronously
        setState(() {
          _suggestions = List<String>.from(response.data['models']);
        });
        print(_suggestions);

        return _suggestions;

        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => SearchResultsScreen(searchQuery: searchQuery),
        //   ),
        // );
      } else {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to fetch search results'),
          ),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $error'),
        ),
      );
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      color: const Color(0xFF2c2e43),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Row(
          children: [
            Expanded(
              child: TypeAheadField<String>(
                textFieldConfiguration: TextFieldConfiguration(
                  controller: _searchQuery,
                  autofocus: true,
                  decoration: InputDecoration(
                    prefix: IconButton(
                      icon: Icon(Icons.search, color: Colors.grey),
                      onPressed: _onSearch,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    contentPadding: const EdgeInsets.only(
                        left: 12.0, bottom: 6.0, top: 0.0),
                    hintText: "Search with make and model....",
                    hintStyle: const TextStyle(color: Colors.grey),
                  ),
                ),
                suggestionsCallback: (pattern) async {
                  return await _onSearch();
                },
                itemBuilder: (context, suggestion) {
                  return ListTile(
                    title: Text(suggestion),
                  );
                },
                onSuggestionSelected: (suggestion) {
                  _searchQuery.text = suggestion;
                  _onSearch();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
