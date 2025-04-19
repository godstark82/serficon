import 'package:flutter/material.dart';
import 'package:conference_admin/features/registrations/data/models/registration_model.dart';
import 'package:conference_admin/features/registrations/data/repositories/regisration_repo.dart';
import 'package:intl/intl.dart';
// ignore: deprecated_member_use, avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'package:excel/excel.dart';
import 'dart:typed_data';

class RegistrationsPage extends StatefulWidget {
  const RegistrationsPage({super.key});

  @override
  State<RegistrationsPage> createState() => _RegistrationsPageState();
}

class _RegistrationsPageState extends State<RegistrationsPage> {
  final RegistrationRepository _repository = RegistrationRepository();
  String _searchQuery = '';
  String _filterCategory = 'All';
  List<String> _categories = ['All'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Conference Registrations'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.file_download),
            tooltip: 'Export to Excel',
            onPressed: () => _exportToExcel(context),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchAndFilterBar(),
          Expanded(
            child: FutureBuilder<List<RegistrationModel>>(
              future: _repository.getRegistrations(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline,
                            size: 60, color: Colors.red),
                        const SizedBox(height: 16),
                        Text(
                          'Error loading registrations: ${snapshot.error}',
                          style: const TextStyle(fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => setState(() {}),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text(
                      'No registrations found',
                      style: TextStyle(fontSize: 18),
                    ),
                  );
                }

                // Process data for filtering and categories
                final registrations = snapshot.data!;
                _updateCategories(registrations);
                final filteredRegistrations =
                    _filterRegistrations(registrations);

                return _buildRegistrationsList(filteredRegistrations);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilterBar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search by name or email',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 12.0),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value.toLowerCase();
                    });
                  },
                ),
              ),
              const SizedBox(width: 16),
              ElevatedButton.icon(
                icon: const Icon(Icons.file_download),
                label: const Text("Export Excel"),
                onPressed: () => _exportToExcel(context),
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                const Text('Filter by category: ',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(width: 8),
                ..._categories
                    .map((category) => Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: ChoiceChip(
                            label: Text(category),
                            selected: _filterCategory == category,
                            onSelected: (selected) {
                              if (selected) {
                                setState(() {
                                  _filterCategory = category;
                                });
                              }
                            },
                          ),
                        ))
                    ,
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRegistrationsList(List<RegistrationModel> registrations) {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: registrations.length,
      itemBuilder: (context, index) {
        final registration = registrations[index];
        return Card(
          elevation: 2,
          margin: const EdgeInsets.only(bottom: 16.0),
          child: ExpansionTile(
            title: Text(
              registration.name,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            subtitle: Text(registration.email),
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).primaryColor,
              child: Text(
                registration.name.isNotEmpty
                    ? registration.name[0].toUpperCase()
                    : '?',
                style: const TextStyle(color: Colors.white),
              ),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoRow('Affiliation', registration.affiliation),
                    _buildInfoRow('Category', registration.category),
                    _buildInfoRow('Days', registration.days),
                    _buildInfoRow(
                        'Presenting Paper', registration.presentingPaper),
                    _buildInfoRow('Country', registration.country),
                    _buildInfoRow('Registration Date',
                        _formatDate(registration.registrationDate)),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(value.isEmpty ? 'Not specified' : value),
          ),
        ],
      ),
    );
  }

  void _updateCategories(List<RegistrationModel> registrations) {
    final categories = registrations
        .map((reg) => reg.category)
        .where((category) => category.isNotEmpty)
        .toSet()
        .toList();

    categories.sort();
    _categories = ['All', ...categories];
  }

  List<RegistrationModel> _filterRegistrations(
      List<RegistrationModel> registrations) {
    return registrations.where((registration) {
      // Apply search filter
      final matchesSearch = _searchQuery.isEmpty ||
          registration.name.toLowerCase().contains(_searchQuery) ||
          registration.email.toLowerCase().contains(_searchQuery);

      // Apply category filter
      final matchesCategory =
          _filterCategory == 'All' || registration.category == _filterCategory;

      return matchesSearch && matchesCategory;
    }).toList();
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('MMM dd, yyyy').format(date);
    } catch (e) {
      return dateString;
    }
  }

  void _exportToExcel(BuildContext context) async {
    try {
      final registrations = await _repository.getRegistrations();

      // Create a new Excel document
      final excel = Excel.createExcel();
      final sheet = excel.sheets[excel.getDefaultSheet()];

      if (sheet == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to create Excel sheet')),
        );
        return;
      }

      // Add headers
      final headers = [
        'Name',
        'Email',
        'Affiliation',
        'Category',
        'Days',
        'Presenting Paper',
        'Country',
        'Registration Date'
      ];

      for (var i = 0; i < headers.length; i++) {
        sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0))
            .value = TextCellValue(headers[i]);
      }

      // Add data
      for (var i = 0; i < registrations.length; i++) {
        final reg = registrations[i];
        final rowIndex = i + 1;

        sheet
            .cell(
                CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: rowIndex))
            .value = TextCellValue(reg.name);
        sheet
            .cell(
                CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: rowIndex))
            .value = TextCellValue(reg.email);
        sheet
            .cell(
                CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: rowIndex))
            .value = TextCellValue(reg.affiliation);
        sheet
            .cell(
                CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: rowIndex))
            .value = TextCellValue(reg.category);
        sheet
            .cell(
                CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: rowIndex))
            .value = TextCellValue(reg.days);
        sheet
            .cell(
                CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: rowIndex))
            .value = TextCellValue(reg.presentingPaper);
        sheet
            .cell(
                CellIndex.indexByColumnRow(columnIndex: 6, rowIndex: rowIndex))
            .value = TextCellValue(reg.country);
        sheet
            .cell(
                CellIndex.indexByColumnRow(columnIndex: 7, rowIndex: rowIndex))
            .value = TextCellValue(reg.registrationDate);
      }

      // Generate the file
      final fileBytes = excel.encode();
      if (fileBytes == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to generate Excel file')),
        );
        return;
      }

      // Create download
      final dateFormat = DateFormat('yyyy-MM-dd');
      final fileName =
          'conference_registrations_${dateFormat.format(DateTime.now())}.xlsx';

      final blob = html.Blob([Uint8List.fromList(fileBytes)]);
      final url = html.Url.createObjectUrlFromBlob(blob);
      html.AnchorElement(href: url)
        ..setAttribute('download', fileName)
        ..click();

      html.Url.revokeObjectUrl(url);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Excel file downloaded successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error exporting data: $e')),
      );
    }
  }
}
