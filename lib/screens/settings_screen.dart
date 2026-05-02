import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../services/app_settings_service.dart';
import '../services/quick_add_settings_service.dart';
import '../theme/app_theme.dart';
import '../utils/currency_utils.dart';
import '../widgets/quick_add_customize_dialog.dart';
import '../widgets/top_message.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final QuickAddSettingsService _quickAddSettingsService =
      QuickAddSettingsService();
  final AppSettingsService _appSettingsService = AppSettingsService();
  bool _darkMode = false;
  String _currencyCode = kDefaultCurrencyCode;
  bool _roundUpEnabled = kDefaultRoundUpEnabled;
  bool _loadingPrefs = true;

  @override
  void initState() {
    super.initState();
    _loadPrefs();
  }

  Future<void> _loadPrefs() async {
    final String code = await _appSettingsService.loadCurrencyCode();
    final bool roundUp = await _appSettingsService.loadRoundUpEnabled();
    if (!mounted) return;
    setState(() {
      _currencyCode = code;
      _roundUpEnabled = roundUp;
      _loadingPrefs = false;
    });
  }

  Future<void> _openQuickCustomizeDialog() async {
    final bool? saved = await showQuickAddCustomizeDialog(
      context: context,
      service: _quickAddSettingsService,
    );
    if (saved != true || !mounted) return;
    HapticFeedback.lightImpact();
    showTopMessage(context, message: 'Quick buttons updated');
  }

  void _comingSoon(String label) {
    showTopMessage(context, message: '$label coming soon');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF050608),
      appBar: AppBar(
        backgroundColor: const Color(0xFF050608),
        foregroundColor: Colors.white,
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: <Widget>[
          const _SectionTitle('Settings'),
          _SettingsGroup(
            children: <Widget>[
              _SwitchRow(
                icon: Icons.dark_mode,
                title: 'Dark Mode',
                value: _darkMode,
                onChanged: (bool value) => setState(() => _darkMode = value),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const _SectionTitle('Billing'),
          _SettingsGroup(
            children: <Widget>[
              if (_loadingPrefs)
                const ListTile(
                  leading: Icon(Icons.payments_outlined, color: Color(0xFFE0E0E0)),
                  title: Text(
                    'Loading billing settings...',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                  ),
                )
              else ...<Widget>[
                _CurrencyRow(
                  icon: Icons.attach_money,
                  title: 'Currency',
                  value: _currencyCode,
                  items: kSupportedCurrencyCodes,
                  onChanged: (String code) async {
                    setState(() => _currencyCode = code);
                    await _appSettingsService.saveCurrencyCode(code);
                    if (!mounted) return;
                    HapticFeedback.selectionClick();
                    showTopMessage(context, message: 'Currency set to $code');
                  },
                ),
                _SwitchRow(
                  icon: Icons.rounded_corner,
                  title: 'Round Up',
                  subtitle: 'Round tip amounts to whole numbers when saving',
                  value: _roundUpEnabled,
                  onChanged: (bool value) async {
                    setState(() => _roundUpEnabled = value);
                    await _appSettingsService.saveRoundUpEnabled(value);
                  },
                ),
              ],
            ],
          ),
          const SizedBox(height: 16),
          const _SectionTitle('General'),
          _SettingsGroup(
            children: <Widget>[
              _ActionRow(
                icon: Icons.tune,
                title: 'Customize quick buttons',
                onTap: _openQuickCustomizeDialog,
              ),
              _ActionRow(
                icon: Icons.mail,
                title: 'Contact Us',
                onTap: () => _comingSoon('Contact'),
              ),
              _ActionRow(
                icon: Icons.notifications,
                title: 'Notifications',
                onTap: () => _comingSoon('Notifications'),
              ),
              _ActionRow(
                icon: Icons.restore,
                title: 'Restore Purchases',
                onTap: () => _comingSoon('Restore purchases'),
              ),
              _ActionRow(
                icon: Icons.storage,
                title: 'Backup & Restore',
                onTap: () => _comingSoon('Backup and restore'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const _SectionTitle('Policy and application terms'),
          _SettingsGroup(
            children: <Widget>[
              _ActionRow(
                icon: Icons.description,
                title: 'Privacy policy',
                onTap: () => _comingSoon('Privacy policy'),
              ),
              _ActionRow(
                icon: Icons.description,
                title: 'Terms and conditions',
                onTap: () => _comingSoon('Terms and conditions'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _SettingsGroup(
            children: <Widget>[
              _ActionRow(
                icon: Icons.feedback,
                title: 'Leave feedback',
                subtitle: 'Let us know what you think of the app.',
                onTap: () => _comingSoon('Feedback'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _SettingsGroup extends StatelessWidget {
  const _SettingsGroup({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0A0D10),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF2A2F35)),
      ),
      child: Column(children: children),
    );
  }
}

class _ActionRow extends StatelessWidget {
  const _ActionRow({
    required this.icon,
    required this.title,
    required this.onTap,
    this.subtitle,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: const Color(0xFFE0E0E0)),
      title: Text(
        title,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
      ),
      subtitle: subtitle == null
          ? null
          : Text(
              subtitle!,
              style: const TextStyle(color: Color(0xFFB8B8B8)),
            ),
    );
  }
}

class _SwitchRow extends StatelessWidget {
  const _SwitchRow({
    required this.icon,
    required this.title,
    required this.value,
    required this.onChanged,
    this.subtitle,
  });

  final IconData icon;
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFFE0E0E0)),
      title: Text(
        title,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
      ),
      subtitle: subtitle == null
          ? null
          : Text(
              subtitle!,
              style: const TextStyle(color: Color(0xFFB8B8B8)),
            ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeThumbColor: AppTheme.brandOrange,
      ),
    );
  }
}

class _CurrencyRow extends StatelessWidget {
  const _CurrencyRow({
    required this.icon,
    required this.title,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  final IconData icon;
  final String title;
  final String value;
  final List<String> items;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFFE0E0E0)),
      title: Text(
        title,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
      ),
      trailing: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          dropdownColor: const Color(0xFF1A1F24),
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          items: items
              .map(
                (String code) => DropdownMenuItem<String>(
                  value: code,
                  child: Text(currencyDisplayLabel(code)),
                ),
              )
              .toList(),
          onChanged: (String? next) {
            if (next == null) return;
            onChanged(next);
          },
        ),
      ),
    );
  }
}
