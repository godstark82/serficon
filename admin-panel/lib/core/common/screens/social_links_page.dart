import 'package:flutter/material.dart';
import 'package:conference_admin/core/services/admin_services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SocialLinksPage extends StatefulWidget {
  const SocialLinksPage({super.key});

  @override
  _SocialLinksPageState createState() => _SocialLinksPageState();
}

class _SocialLinksPageState extends State<SocialLinksPage> {
  final AdminServices _adminServices = AdminServices();
  List<Map<String, dynamic>> _socialLinks = [];

  @override
  void initState() {
    super.initState();
    _loadSocialLinks();
  }

  Future<void> _loadSocialLinks() async {
    final links = await _adminServices.getSocialLinks();
    setState(() {
      _socialLinks = links;
    });
  }

  Future<void> _editSocialLink(String name, String? currentUrl) async {
    final TextEditingController controller =
        TextEditingController(text: currentUrl ?? '');

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit $name URL'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: "Enter new URL",
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.link),
          ),
        ),
        actions: [
          TextButton(
            child: const Text('Cancel', style: TextStyle(color: Colors.red)),
            onPressed: () => Navigator.of(context).pop(),
          ),
          ElevatedButton(
            child: const Text('Save'),
            onPressed: () async {
              await _adminServices.updateSocialLink(name, controller.text);
              Navigator.of(context).pop();
              _loadSocialLinks();
            },
          ),
        ],
      ),
    );
  }

  IconData _getIconForSocialMedia(String name) {
    switch (name.toLowerCase()) {
      case 'facebook':
        return FontAwesomeIcons.facebook;
      case 'twitter':
        return FontAwesomeIcons.twitter;
      case 'instagram':
        return FontAwesomeIcons.instagram;
      case 'linkedin':
        return FontAwesomeIcons.linkedin;
      default:
        return FontAwesomeIcons.link;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Social Links'),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blue.shade50, Colors.white],
          ),
        ),
        child: ListView.builder(
          itemCount: _socialLinks.length,
          itemBuilder: (context, index) {
            final link = _socialLinks[index];
            return Card(
              elevation: 3,
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.blue.shade100,
                  child: FaIcon(_getIconForSocialMedia(link['name']),
                      color: Colors.blue),
                ),
                title: Text(link['name'],
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(link['url'] ?? 'NOT SET',
                    style: const TextStyle(color: Colors.grey)),
                trailing: IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: () => _editSocialLink(link['name'], link['url']),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
