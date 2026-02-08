import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flag/flag.dart';

import 'package:google_fonts/google_fonts.dart';
import '../../../../shared/themes/theme_constants.dart';
import '../../../../shared/widgets/searchable_dropdown.dart';
import '../../../shared/widgets/section_header.dart';
import '../domain/currency_model.dart';
import 'currency_controller.dart';
import 'currency_shimmer.dart';
import '../../settings/presentation/settings_controller.dart';

class CurrencyScreen extends StatefulWidget {
  const CurrencyScreen({super.key});

  @override
  State<CurrencyScreen> createState() => _CurrencyScreenState();
}

class _CurrencyScreenState extends State<CurrencyScreen> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  final TextEditingController _amountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final settings = context.read<SettingsController>();
    settings.addListener(_onSettingsChanged);
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initController();
    });
  }

  @override
  void dispose() {
    final settings = context.read<SettingsController>();
    settings.removeListener(_onSettingsChanged);
    _amountController.dispose();
    super.dispose();
  }

  void _onSettingsChanged() {
    _initController();
  }

  void _initController() {
     final settings = context.read<SettingsController>();
     context.read<CurrencyController>().init(defaultCurrencyCode: settings.defaultCurrencyCode);
  }



  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Currency Exchange')),
      body: Consumer<CurrencyController>(
        builder: (context, controller, child) {
          if (controller.state == CurrencyState.loading) {
            return const CurrencyShimmer();
          }

          if (controller.state == CurrencyState.error) {
            return const Center(child: Text("Error loading currencies."));
          }

          if (controller.state == CurrencyState.loaded) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Base Currency Dropdown
                  Text("Base Currency", style: Theme.of(context).textTheme.titleSmall),
                  const SizedBox(height: 8),
                  _buildCurrencyDropdown(
                    context, 
                    controller.baseCurrency, 
                    controller.currencies, 
                    (val) => controller.setBaseCurrency(val),
                  ),

                  const SizedBox(height: 16),
                  
                  // Swap Button
                  Center(
                    child: CircleAvatar(
                      backgroundColor: Theme.of(context).primaryColor.withAlpha(50),
                      child: IconButton(
                        icon: const Icon(Icons.swap_vert),
                        color: Theme.of(context).primaryColorDark,
                        onPressed: controller.swapCurrencies,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 16),

                  // Target Currency Dropdown
                  Text("Target Currency", style: Theme.of(context).textTheme.titleSmall),
                  const SizedBox(height: 8),
                  _buildCurrencyDropdown(
                    context, 
                    controller.targetCurrency, 
                    controller.currencies, 
                    (val) => controller.setTargetCurrency(val),
                  ),

                  const SizedBox(height: 24),

                  // Exchange Rate Display
                  Center(
                    child: Text(
                      "1 ${controller.baseCurrency?.code} = ${controller.currentRate.toStringAsFixed(2)} ${controller.targetCurrency?.code}",
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                  
                  const SizedBox(height: 24),

                  // Amount Input
                  TextField(
                    controller: _amountController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      labelText: "Enter Amount",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      prefixIcon: const Icon(Icons.calculate),
                    ),
                    onChanged: (val) => controller.updateAmount(val),
                  ),
                  
                  const SizedBox(height: 16),

                  // Result Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: ThemeConstants.goldGradient,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                         BoxShadow(
                           color: ThemeConstants.primaryColor.withAlpha(100),
                           blurRadius: 20,
                           offset: const Offset(0, 10),
                         )
                      ]
                    ),
                    child: Column(
                      children: [
                         Text(
                          "Converted Amount",
                          style: GoogleFonts.poppins(
                            color: Colors.black.withAlpha(150),
                            fontSize: 16,
                            fontWeight: FontWeight.w500
                          ),
                         ),
                         const SizedBox(height: 8),
                         Text(
                           "${controller.targetCurrency?.code} ${controller.convertedAmount.toStringAsFixed(2)}",
                           style: GoogleFonts.poppins(
                             fontSize: 32, 
                             fontWeight: FontWeight.bold,
                             color: Colors.black,
                           ),
                         ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  const SectionHeader(title: "Popular Pairs"),
                  // Mock List of Popular Pairs
                  ListTile(
                    title: const Text("USD / EUR"),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      // Logic to set USD and EUR
                      // This would require finding models from list.
                    },
                  ),
                  ListTile(
                    title: const Text("GBP / USD"),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {},
                  ),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildCurrencyDropdown(
    BuildContext context, 
    CurrencyModel? value, 
    List<CurrencyModel> items, 
    Function(CurrencyModel?) onChanged
  ) {
    return SearchableDropdown<CurrencyModel>(
      value: value,
      items: items,
      hint: "Select Currency",
      labelBuilder: (c) => "${c.code} - ${c.name}",
      iconBuilder: (c) => ClipRRect(
        borderRadius: BorderRadius.circular(4), 
        child: Flag.fromString(c.countryCode, height: 20, width: 30, fit: BoxFit.cover),
      ),
      onChanged: onChanged,
    );
  }
}
