class NavItem {
  final String id;
  final String title;
  final String path;
  final bool isExternal;
  final List<NavItem> children;
  final String? parentId;
  final int order;
  final String? pageId;

  NavItem({
    required this.id,
    required this.title,
    required this.path,
    this.isExternal = false,
    required this.children,
    this.parentId,
    this.order = 0,
    this.pageId,
  });

  factory NavItem.fromJson(Map<String, dynamic> json, String id) {
    return NavItem(
      id: id,
      title: json['title'] ?? '',
      path: json['path'] ?? '',
      isExternal: json['isExternal'] ?? false,
      children: ((json['children'] as List<dynamic>?) ?? [])
          .map((child) =>
              NavItem.fromJson(child as Map<String, dynamic>, child['id']))
          .toList(),
      parentId: json['parentId'],
      order: json['order'] ?? 0,
      pageId: json['pageId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'path': path,
      'isExternal': isExternal,
      'children': children.map((child) => child.toJson()).toList(),
      'parentId': parentId,
      'order': order,
      'pageId': pageId,
    };
  }
}
