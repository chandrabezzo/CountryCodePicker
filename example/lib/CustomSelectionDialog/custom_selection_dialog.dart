import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';

class CustomSelectionDialog extends StatefulWidget {
  /// The full list of country codes from the parent SelectionDialog.
  final List<CountryCode> elements;

  /// Optional favorite country codes.
  final List<CountryCode>? favoriteElements;

  /// Header text (if any) to show at the top.
  final String? headerText;

  /// Callback when a country code is selected.
  final ValueChanged<CountryCode>? onSelected;

  final bool hideCountryTitle;

  const CustomSelectionDialog({
    Key? key,
    required this.elements,
    this.favoriteElements,
    this.headerText,
    this.onSelected,
    this.hideCountryTitle = false,
  }) : super(key: key);

  @override
  _CustomSelectionDialogState createState() => _CustomSelectionDialogState();
}

class _CustomSelectionDialogState extends State<CustomSelectionDialog> {
  late List<CountryCode> filteredElements;
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredElements = widget.elements;
  }

  void _filterElements(String query) {
    setState(() {
      final lowerQuery = query.toLowerCase();
      filteredElements = widget.elements.where((code) {
        return (code.name?.toLowerCase().contains(lowerQuery) ?? false) ||
            (code.dialCode?.contains(query) ?? false) ||
            (code.code?.toLowerCase().contains(lowerQuery) ?? false);
      }).toList();
    });
  }

  Widget _buildOption(CountryCode code) {
    return ListTile(
      leading: code.flagUri != null
          ? ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Image.asset(
                code.flagUri!,
                package: 'country_code_picker',
                width: 32,
                height: 24,
                fit: BoxFit.cover,
              ),
            )
          : null,
      title: Text(
        widget.hideCountryTitle
            ? code.dialCode!
            : "${code.name} (${code.dialCode})",
        style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black),
      ),
      onTap: () {
        widget.onSelected?.call(code);
        Navigator.pop(context, code);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          // Header with title and close button.
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (widget.headerText != null)
                Text(
                  widget.headerText!,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              IconButton(
                icon: Icon(Icons.close,
                    color: Colors.black),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Modern search field.
          TextField(
            style: TextStyle(
                color: Colors.black),
            controller: searchController,
            decoration: InputDecoration(
              hintText: 'Search country',
              hintStyle: TextStyle(
                  color: Colors.black),
              prefixIcon: Icon(Icons.search,
                  color: Colors.black),
              filled: true,
              fillColor: Colors.white,
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: BorderSide.none,
              ),
            ),
            onChanged: _filterElements,
          ),
          const SizedBox(height: 16),
          // Optional favorites.
          if (widget.favoriteElements != null &&
              widget.favoriteElements!.isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...widget.favoriteElements!.map((code) => _buildOption(code)),
                const Divider(),
              ],
            ),
          // List of filtered country codes.
          Expanded(
            child: filteredElements.isEmpty
                ? Center(
                    child: Text(
                      'No country found',
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  )
                : ListView.builder(
                    itemCount: filteredElements.length,
                    itemBuilder: (context, index) {
                      return _buildOption(filteredElements[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
