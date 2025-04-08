import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String firstName = "Elango";
  String lastName = "Karthi";
  String email = "elangokarthi9902@gmail.com";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        elevation: 0,
        title: Text('Settings'),
        leading: BackButton(color: Colors.white),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 20),
          _buildProfileHeader(),
          const SizedBox(height: 30),

          _buildEditableField("FIRST NAME", firstName, (val) {
            setState(() => firstName = val);
          }),
          _buildEditableField("LAST NAME", lastName, (val) {
            setState(() => lastName = val);
          }),
          _buildEditableField("EMAIL", email, (val) {
            setState(() => email = val);
          }),

          _buildDivider(),
          _buildSettingTile("WORKOUT LENGTH", icon: Icons.lock, enabled: false),
          _buildSettingTile("TRAINING GOALS"),
          _buildSettingTile("PUSH NOTIFICATIONS"),
          _buildToggleTile("SOUND EFFECTS", value: true, onChanged: (_) {}),
          _buildSettingTile("LANGUAGE"),
          _buildSettingTile("DARK MODE"),
          _buildDivider(),
          _buildSettingTile("HELP"),
          _buildSettingTile("FEEDBACK"),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Center(
      child: Column(
        children: [
          CircleAvatar(
            radius: 45,
            backgroundImage: AssetImage(
              'assets/profile.png',
            ), // Replace with NetworkImage if needed
            backgroundColor: Colors.grey[800],
          ),
          const SizedBox(height: 10),
          Text(
            "$firstName $lastName",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(email, style: TextStyle(color: Colors.white60, fontSize: 13)),
        ],
      ),
    );
  }

  Widget _buildEditableField(
    String label,
    String value,
    Function(String) onSaved,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    color: Colors.cyanAccent,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.edit, color: Colors.white70),
            onPressed: () => _showEditDialog(label, value, onSaved),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(String label, String value, Function(String) onSaved) {
    TextEditingController controller = TextEditingController(text: value);
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            backgroundColor: Colors.grey[900],
            title: Text('Edit $label', style: TextStyle(color: Colors.white)),
            content: TextField(
              controller: controller,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Enter $label',
                hintStyle: TextStyle(color: Colors.white30),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel', style: TextStyle(color: Colors.white70)),
              ),
              TextButton(
                onPressed: () {
                  onSaved(controller.text.trim());
                  Navigator.pop(context);
                },
                child: Text('Save', style: TextStyle(color: Colors.cyanAccent)),
              ),
            ],
          ),
    );
  }

  Widget _buildSettingTile(
    String title, {
    IconData? icon,
    bool enabled = true,
  }) {
    return ListTile(
      enabled: enabled,
      title: Text(title, style: TextStyle(color: Colors.white)),
      trailing:
          icon != null
              ? Icon(icon, color: Colors.white54, size: 20)
              : Icon(Icons.arrow_forward_ios, color: Colors.white38, size: 16),
      onTap: enabled ? () {} : null,
    );
  }

  Widget _buildToggleTile(
    String title, {
    required bool value,
    required Function(bool) onChanged,
  }) {
    return SwitchListTile(
      title: Text(title, style: TextStyle(color: Colors.white)),
      value: value,
      onChanged: onChanged,
      activeColor: Colors.cyan,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
    );
  }

  Widget _buildDivider() {
    return Divider(
      color: Colors.white10,
      thickness: 1,
      indent: 16,
      endIndent: 16,
    );
  }
}
