import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flag/flag.dart';
import '../../../../shared/themes/theme_provider.dart';
import '../../../../core/data/country_data.dart';
import '../../../../shared/widgets/searchable_dropdown.dart';

import 'settings_controller.dart';
import '../../gold/presentation/gold_controller.dart';
import '../../currency/presentation/currency_controller.dart';
import '../../currency/domain/currency_model.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Access Providers
    final themeProvider = Provider.of<ThemeProvider>(context);
    final settingsController = Provider.of<SettingsController>(context);
    
    // We access these just to get the lists, not mainly for state
    final goldController = Provider.of<GoldController>(context, listen: false);
    final currencyController = Provider.of<CurrencyController>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: settingsController.isLoading 
          ? const Center(child: CircularProgressIndicator()) 
          : ListView(
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              "General",
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.public),
            title: const Text("Default Country"),
            subtitle: Text(settingsController.defaultCountry),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              _showCountrySelectionDialog(context, settingsController, goldController.countryList);
            },
          ),
          ListTile(
            leading: const Icon(Icons.attach_money),
            title: const Text("Default Currency"),
            subtitle: Text(settingsController.defaultCurrencyCode),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () async {
               if (currencyController.currencies.isEmpty) {
                 await currencyController.init(defaultCurrencyCode: settingsController.defaultCurrencyCode);
               }
               if (context.mounted) {
                 _showCurrencySelectionDialog(context, settingsController, currencyController.currencies);
               }
            },
          ),
          const Divider(),
          
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Text(
              "Appearance",
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
            ),
          ),
          SwitchListTile(
            secondary: const Icon(Icons.dark_mode),
            title: const Text("Dark Mode"),
            value: themeProvider.isDarkMode,
            onChanged: (bool value) {
              themeProvider.toggleTheme(value);
            },
          ),
          const Divider(),
          
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Text(
              "About",
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text("Version"),
            subtitle: const Text("1.0.0"),
          ),
          ListTile(
            leading: const Icon(Icons.person_outline),
            title: const Text("Developer"),
            subtitle: const Text("Flutter Dev"),
          ),
        ],
      ),
    );
  }

  void _showCountrySelectionDialog(BuildContext context, SettingsController settings, List<Country> countries) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SearchableSelectionSheet<Country>(
        title: "Select Default Country",
        items: countries,
        labelBuilder: (c) => c.name,
        iconBuilder: (c) => ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: Flag.fromString(c.isoCode, height: 20, width: 30, fit: BoxFit.cover),
        ),
        onChanged: (Country? c) {
          if (c != null) settings.updateDefaultCountry(c.name);
        },
      ),
    );
  }

  void _showCurrencySelectionDialog(BuildContext context, SettingsController settings, List<CurrencyModel> currencies) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SearchableSelectionSheet<CurrencyModel>(
        title: "Select Default Currency",
        items: currencies,
        labelBuilder: (c) => "${c.code} - ${c.name}",
        iconBuilder: (c) => ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: Flag.fromString(c.countryCode, height: 20, width: 30, fit: BoxFit.cover),
        ),
        onChanged: (CurrencyModel? c) {
           if (c != null) settings.updateDefaultCurrency(c.code);
        },
      ),
    );
  }
}
