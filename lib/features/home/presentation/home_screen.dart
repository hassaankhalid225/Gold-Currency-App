import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../shared/widgets/price_card.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../shared/widgets/currency_row.dart';
import '../../../shared/widgets/error_widget.dart';
import '../../../shared/themes/theme_constants.dart';
import 'home_controller.dart';
import 'home_shimmer.dart';
import '../../gold/presentation/gold_controller.dart';
import '../../currency/presentation/currency_controller.dart';
import '../../currency/domain/currency_model.dart';
import '../../../shared/providers/navigation_provider.dart';
import '../../settings/presentation/settings_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  
  int _currentGoldIndex = 0;

  @override
  void initState() {
    super.initState();
    final settingsController = context.read<SettingsController>();
    settingsController.addListener(_onSettingsChanged);

    // Fetch data once when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  @override
  void dispose() {
    final settingsController = context.read<SettingsController>();
    settingsController.removeListener(_onSettingsChanged);
    super.dispose();
  }

  void _onSettingsChanged() {
    _loadData();
  }

  void _loadData() {
    final settings = context.read<SettingsController>();
    context.read<HomeController>().loadDashboardData(
      settings.defaultCountry,
      settings.defaultCurrencyCode,
    );
  }



  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gold & Currency Tracker'),
      ),
      body: Consumer<HomeController>(
        builder: (context, controller, child) {
          if (controller.state == HomeState.loading) {
            return const HomeShimmer();
          }

          if (controller.state == HomeState.error) {
            return AppErrorWidget(
              errorMessage: controller.errorMessage ?? "An unknown error occurred",
              onRetry: () => _loadData(),
            );
          }

          if (controller.state == HomeState.loaded && controller.data != null) {
            final data = controller.data!;
            return SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                   const SectionHeader(title: "Gold Prices"),
                   if (data.goldPrices.isNotEmpty) ...[
                     Builder(
                       builder: (context) {
                         final effectiveIndex = (_currentGoldIndex >= data.goldPrices.length) ? 0 : _currentGoldIndex;
                         final goldPrice = data.goldPrices[effectiveIndex];
                         return Padding(
                           padding: const EdgeInsets.symmetric(horizontal: 8.0),
                           child: Row(
                             children: [
                               IconButton(
                                 icon: const Icon(Icons.arrow_back_ios, size: 20),
                                 onPressed: () {
                                   setState(() {
                                     _currentGoldIndex = (_currentGoldIndex - 1 + data.goldPrices.length) % data.goldPrices.length;
                                   });
                                 },
                               ),
                               Expanded(
                                 child: PriceCard(
                                   title: "Gold Price (${goldPrice.country})",
                                   value: "${goldPrice.currency} ${goldPrice.price.toStringAsFixed(2)}",
                                   unit: "per tola",
                                   backgroundGradient: ThemeConstants.goldGradient,
                                   textColor: Colors.black, // Dark text on Gold
                                   subtitle: "Last Update: ${goldPrice.timestamp.hour}:${goldPrice.timestamp.minute}",
                                   onTap: () {
                                     // Sync Gold Country if possible (optional, as Gold tab specific)
                                     context.read<GoldController>().changeCountry(goldPrice.country);
                                     context.read<NavigationProvider>().setIndex(1); // Index 1 is Gold
                                   },
                                 ),
                               ),
                               IconButton(
                                 icon: const Icon(Icons.arrow_forward_ios, size: 20),
                                 onPressed: () {
                                   setState(() {
                                     _currentGoldIndex = (_currentGoldIndex + 1) % data.goldPrices.length;
                                   });
                                 },
                               ),
                             ],
                           ),
                         );
                       }
                     ),
                   ],
                   SectionHeader(
                     title: "My Currencies",
                     actionWidget: IconButton(
                       icon: const Icon(Icons.add_circle, color: ThemeConstants.primaryColor),
                       onPressed: () {
                         _showAddCurrencyBottomSheet(context, data.topCurrencies);
                       },
                     ),
                   ),
                   ListView.builder(
                     shrinkWrap: true,
                     physics: const NeverScrollableScrollPhysics(),
                     itemCount: controller.displayedCurrencies.length,
                     itemBuilder: (context, index) {
                       final currency = controller.displayedCurrencies[index];
                       return CurrencyRow(
                         countryCode: currency.countryCode,
                         currencyCode: currency.code,
                         currencyName: currency.name,
                         rate: currency.rate.toStringAsFixed(2),
                         onTap: () {
                            context.read<CurrencyController>().setBaseCurrencyByCode(currency.code);
                            context.read<NavigationProvider>().setIndex(3); // Index 3 is Currency (moved because Silver is 2)
                         },
                       );
                     },
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
  void _showAddCurrencyBottomSheet(BuildContext context, List<CurrencyModel> allCurrencies) {
    // Current selected codes
    final currentSelected = context.read<HomeController>().userSelectedCurrencyCodes;
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return _CurrencyPickerSheet(
          allCurrencies: allCurrencies,
          initialSelected: currentSelected,
          onSave: (List<String> newSelected) {
            context.read<HomeController>().updateUserCurrencies(newSelected);
          },
        );
      },
    );
  }
}

class _CurrencyPickerSheet extends StatefulWidget {
  final List<CurrencyModel> allCurrencies;
  final List<String> initialSelected;
  final Function(List<String>) onSave;

  const _CurrencyPickerSheet({
    required this.allCurrencies,
    required this.initialSelected,
    required this.onSave,
  });

  @override
  State<_CurrencyPickerSheet> createState() => _CurrencyPickerSheetState();
}

class _CurrencyPickerSheetState extends State<_CurrencyPickerSheet> {
  late List<String> _selectedCodes;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _selectedCodes = List.from(widget.initialSelected);
  }

  @override
  Widget build(BuildContext context) {
    final filteredCurrencies = widget.allCurrencies.where((c) {
      final query = _searchQuery.toLowerCase();
      return c.name.toLowerCase().contains(query) || c.code.toLowerCase().contains(query);
    }).toList();

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16, 
        right: 16, 
        top: 16
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Select Currencies", style: Theme.of(context).textTheme.titleLarge),
              IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close)),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            decoration: InputDecoration(
              hintText: "Search currency...",
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            ),
            onChanged: (val) {
              setState(() {
                _searchQuery = val;
              });
            },
          ),
          const SizedBox(height: 16),
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.5,
            ),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: filteredCurrencies.length,
              itemBuilder: (context, index) {
                final currency = filteredCurrencies[index];
                final isSelected = _selectedCodes.contains(currency.code);
                return CheckboxListTile(
                  value: isSelected,
                  title: Text("${currency.code} - ${currency.name}"),
                  onChanged: (bool? val) {
                    setState(() {
                      if (val == true) {
                        _selectedCodes.add(currency.code);
                      } else {
                        _selectedCodes.remove(currency.code);
                      }
                    });
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                  child: const Text("Cancel"),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    widget.onSave(_selectedCodes);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ThemeConstants.primaryColor,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text("Add"),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
