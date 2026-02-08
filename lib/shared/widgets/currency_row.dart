import 'package:flutter/material.dart';
import 'package:flag/flag.dart';
import 'package:google_fonts/google_fonts.dart';

class CurrencyRow extends StatelessWidget {
  final String countryCode;
  final String currencyCode;
  final String currencyName;
  final String rate;
  final VoidCallback? onTap;

  const CurrencyRow({
    super.key,
    required this.countryCode,
    required this.currencyCode,
    required this.currencyName,
    required this.rate,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(5),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: Flag.fromString(
            countryCode,
            height: 32,
            width: 48,
            fit: BoxFit.cover,
            replacement: const Icon(Icons.flag), 
          ),
        ),
        title: Text(
          currencyCode, 
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 16),
        ),
        subtitle: Text(
          currencyName,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        trailing: Text(
          rate,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Theme.of(context).textTheme.bodyLarge?.color,
          ),
        ),
      ),
    );
  }
}
