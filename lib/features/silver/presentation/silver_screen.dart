
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flag/flag.dart';
import '../../../../core/data/country_data.dart';
import '../../../../shared/widgets/searchable_dropdown.dart';
import '../../../../shared/themes/theme_constants.dart';
import '../../../shared/widgets/price_card.dart';
import '../../../shared/widgets/error_widget.dart';
import 'silver_controller.dart';
import 'silver_shimmer.dart';
import '../../settings/presentation/settings_controller.dart';

class SilverScreen extends StatefulWidget {
  const SilverScreen({super.key});

  @override
  State<SilverScreen> createState() => _SilverScreenState();
}

class _SilverScreenState extends State<SilverScreen> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
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
    super.dispose();
  }

  void _onSettingsChanged() {
    _initController();
  }

  void _initController() {
      final settings = context.read<SettingsController>();
      context.read<SilverController>().init(
        country: settings.defaultCountry,
        currency: settings.defaultCurrencyCode
      );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Silver Prices')),
      body: Consumer<SilverController>(
        builder: (context, controller, child) {
          if (controller.state == SilverState.loading) {
            return const SilverShimmer();
          }

          if (controller.state == SilverState.error) {
            return AppErrorWidget(
              errorMessage: "Failed to fetch silver prices",
              onRetry: () => controller.fetchSilverPrice(controller.selectedCountry),
            );
          }

          if (controller.data != null) {
            final data = controller.data!;
            // Conversions (assuming price is per Ounce)
            final pricePerOunce = data.price;
            final pricePerGram = pricePerOunce / 31.1035;
            final pricePerTola = pricePerGram * 11.6638;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Country Dropdown
                  SearchableDropdown<Country>(
                    value: controller.countryList.firstWhere(
                      (c) => c.name == controller.selectedCountry, 
                      orElse: () => controller.countryList.first
                    ),
                    items: controller.countryList,
                    hint: "Select Country",
                    labelBuilder: (c) => c.name,
                    iconBuilder: (c) => ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: Flag.fromString(c.isoCode, height: 20, width: 30, fit: BoxFit.cover),
                    ),
                    onChanged: (Country? newCountry) {
                      if (newCountry != null) {
                         controller.changeCountry(newCountry.name);
                      }
                    },
                  ),
                  const SizedBox(height: 12),

                  // Currency Dropdown
                  SearchableDropdown<String>(
                    value: controller.currencies.contains(controller.selectedCurrency) ? controller.selectedCurrency : null,
                    items: controller.currencies,
                    hint: "Select Currency",
                    labelBuilder: (val) => val,
                    onChanged: (String? newVal) {
                      if (newVal != null) {
                        controller.changeCurrency(newVal);
                      }
                    },
                  ),
                  const SizedBox(height: 20),

                  // Main Price Card
                  PriceCard(
                    title: "Current Silver Price",
                    value: "${data.currency} ${pricePerOunce.toStringAsFixed(2)}",
                    unit: "per Ounce",
                    subtitle: "Last updated: Just now",
                    // Use a Silver Gradient
                    backgroundGradient: const LinearGradient(
                      colors: [Color(0xFFE0E0E0), Color(0xFFBDBDBD)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    textColor: Colors.black,
                  ),
                  const SizedBox(height: 20),

                  // Unit Cards Row
                  Row(
                    children: [
                      Expanded(
                        child: PriceCard(
                          title: "Per Gram",
                          value: pricePerGram.toStringAsFixed(0),
                          unit: data.currency,
                          backgroundColor: Theme.of(context).cardTheme.color,
                          textColor: Theme.of(context).textTheme.bodyLarge?.color,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: PriceCard(
                          title: "Per Tola",
                          value: pricePerTola.toStringAsFixed(0),
                          unit: data.currency,
                          backgroundColor: Theme.of(context).cardTheme.color,
                           textColor: Theme.of(context).textTheme.bodyLarge?.color,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  
                  // Buy / Sell
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardTheme.color,
                      borderRadius: BorderRadius.circular(20),
                       boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(15), 
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _buildPriceRow("Buy Price", "${data.currency} ${data.buyPrice.toStringAsFixed(2)}", Colors.green, context),
                        Divider(color: Colors.grey.withAlpha(50), thickness: 1, height: 24),
                        _buildPriceRow("Sell Price", "${data.currency} ${data.sellPrice.toStringAsFixed(2)}", Colors.red, context),
                      ],
                    ),
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

  Widget _buildPriceRow(String label, String price, Color color, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Theme.of(context).textTheme.titleMedium),
          Text(price, style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }
}
