import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants.dart';

class SearchBarWidget extends StatelessWidget {
  const SearchBarWidget({
    super.key,
    required this.searchController,
    required this.searchQuery,
  });

  final TextEditingController searchController;
  final RxString searchQuery;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: searchController,
      decoration: InputDecoration(
        hintText: 'Search devices by name or IP...',
        prefixIcon: const Icon(Icons.search, color: primaryColr),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: primaryColr),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: primaryColr),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: primaryColr, width: 2),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      onChanged: (value) {
        searchQuery.value = value.toLowerCase();
      },
    );
  }
}
