import 'package:flutter/material.dart';
import 'package:hire_me/service/themeprovider.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Search'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 8),
        child: Hero(
          tag: 'searchBar',
          child: Material(
            color: Colors.transparent,
            child: TextField(
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                hintText: 'Search services...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: themeProvider.isDarkMode ? Colors.white : Colors.black,
                    width: 1,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                suffixIcon: const Icon(Icons.search),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

