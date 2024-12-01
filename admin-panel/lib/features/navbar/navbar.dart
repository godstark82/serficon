import 'package:conference_admin/core/models/nav_bar_model.dart';
import 'package:conference_admin/features/about/presentation/bloc/about_bloc.dart';
import 'package:conference_admin/features/navbar/functions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NavbarPage extends StatefulWidget {
  const NavbarPage({super.key});

  @override
  State<NavbarPage> createState() => _NavbarPageState();
}

class _NavbarPageState extends State<NavbarPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<NavItem> navItems = [];
  Map<String, bool> expandedItems = {};

  @override
  void initState() {
    super.initState();
    _loadNavItems();
  }

  Future<void> _loadNavItems() async {
    try {
      final snapshot = await _firestore.collection('navigation').get();
      setState(() {
        navItems = snapshot.docs
            .map((doc) => NavItem.fromJson(doc.data(), doc.id))
            .toList();
        // Sort by order
        navItems.sort((a, b) => a.order.compareTo(b.order));
        
        // Initialize expansion state for all items
        for (var item in navItems) {
          if (!expandedItems.containsKey(item.id)) {
            expandedItems[item.id] = false;
          }
        }
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error loading nav items: $e');
      }
    }
  }

  void _toggleExpanded(String itemId) {
    setState(() {
      expandedItems[itemId] = !(expandedItems[itemId] ?? false);
    });
  }



  
  

  Widget _buildNavTree(NavItem item, [int depth = 0]) {
    bool isExpanded = expandedItems[item.id] ?? false;

    return Column(
      key: Key('navTree_${item.id}'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          key: Key('padding_${item.id}'),
          padding: EdgeInsets.only(left: depth * 32.0),
          child: Card(
            key: Key('card_${item.id}'),
            elevation: 2,
            margin: const EdgeInsets.symmetric(vertical: 4),
            child: Column(
              key: Key('column_${item.id}'),
              children: [
                ListTile(
                  key: Key('listTile_${item.id}'),
                  title: Row(
                    children: [
                      if (item.children.isNotEmpty)
                        IconButton(
                          icon: AnimatedRotation(
                            duration: const Duration(milliseconds: 200),
                            turns: isExpanded ? 0.5 : 0,
                            child: const Icon(Icons.expand_more, color: Colors.blue),
                          ),
                          onPressed: () => _toggleExpanded(item.id),
                        ),
                      Expanded(
                        child: Text(
                          item.title,
                          key: Key('title_${item.id}'),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        key: Key('subtitleRow_${item.id}'),
                        children: [
                          Expanded(
                            child: Text(
                              '${item.path} (Order: ${item.order})',
                              key: Key('path_${item.id}'),
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ),
                          if (item.isExternal)
                            const Padding(
                              key: Key('externalIcon'),
                              padding: EdgeInsets.only(left: 8.0),
                              child: Icon(Icons.open_in_new, size: 16, color: Colors.blue),
                            ),
                        ],
                      ),
                      if (item.pageId?.isNotEmpty ?? false)
                        BlocBuilder<AboutBloc, AboutState>(
                          builder: (context, state) {
                            if (state is AboutPagesLoaded) {
                              final page = state.pages.firstWhere(
                                (p) => p.id == item.pageId,
                                orElse: () => state.pages.first,
                              );
                              return Text(
                                'Linked to: ${page.title}',
                                style: const TextStyle(
                                  color: Colors.blue,
                                  fontSize: 12,
                                ),
                              );
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                    ],
                  ),
                  trailing: Row(
                    key: Key('actions_${item.id}'),
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // if (item.parentId != null)
                        IconButton(
                          key: Key('editButton_${item.id}'),
                          icon: const Icon(Icons.edit),
                          tooltip: 'Edit item',
                          onPressed: () => showEditPageDialog(context, _loadNavItems, item),
                        ),
                      if (item.parentId == null)
                        IconButton(
                          key: Key('addButton_${item.id}'),
                          icon: const Icon(Icons.add),
                          tooltip: 'Add sub-item',
                          onPressed: () => showAddPageDialog(context, _loadNavItems, parent: item),
                        ),
                      if (item.parentId != null)
                        IconButton(
                          key: Key('deleteButton_${item.id}'),
                          icon: const Icon(Icons.delete),
                          tooltip: 'Delete item',
                          onPressed: () => deleteNavItem(context, _loadNavItems, item),
                        ),
                    ],
                  ),
                ),
                if (isExpanded && item.children.isNotEmpty)
                  Container(
                    key: Key('childrenSection_${item.id}'),
                    margin: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      key: Key('childrenColumn_${item.id}'),
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              const Icon(Icons.subdirectory_arrow_right, size: 16, color: Colors.grey),
                              const SizedBox(width: 8),
                              Text(
                                'Child Items (${item.children.length})',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Divider(height: 1),
                        ...item.children.map((child) => ListTile(
                          key: Key('childItem_${child.id}'),
                          dense: true,
                          title: Text(child.title),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${child.path} - Order: ${child.order}',
                                style: const TextStyle(fontSize: 12),
                              ),
                              if (child.pageId?.isNotEmpty ?? false)
                                BlocBuilder<AboutBloc, AboutState>(
                                  builder: (context, state) {
                                    if (state is AboutPagesLoaded) {
                                      final page = state.pages.firstWhere(
                                        (p) => p.id == child.pageId,
                                        orElse: () => state.pages.first,
                                      );
                                      return Text(
                                        'Linked to: ${page.title}',
                                        style: const TextStyle(
                                          color: Colors.blue,
                                          fontSize: 12,
                                        ),
                                      );
                                    }
                                    return const SizedBox.shrink();
                                  },
                                ),
                            ],
                          ),
                          trailing: child.isExternal
                              ? const Icon(Icons.open_in_new, size: 14)
                              : null,
                        )),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
        if (isExpanded)
          ...item.children.map((child) => _buildNavTree(child, depth + 1)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: const Key('navbarScaffold'),
      appBar: AppBar(
        key: const Key('navbarAppBar'),
        title: const Text('Navigation Structure'),
        elevation: 2,
      ),
      body: SingleChildScrollView(
        key: const Key('scrollView'),
        padding: const EdgeInsets.all(16),
        child: Column(
          key: const Key('mainColumn'),
          children: navItems
              .where((item) => item.parentId == null)
              .map((item) => _buildNavTree(item))
              .toList(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showAddPageDialog(context, _loadNavItems),
        tooltip: 'Add root navigation item',
        child:  const Icon(Icons.add),
      ),
    );
  }
}
