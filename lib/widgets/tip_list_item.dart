import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../models/tip_entry.dart';
import '../theme/app_theme.dart';
import '../utils/currency_utils.dart';

class TipListItem extends StatelessWidget {
  const TipListItem({
    super.key,
    required this.entry,
    this.darkStyle = false,
    this.currencyCode = 'USD',
    this.onLongPress,
  });

  final TipEntry entry;
  final bool darkStyle;
  final String currencyCode;
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    final String typeNormalized =
        entry.type.toLowerCase() == 'card' ? 'card' : 'cash';
    final String typeLabel = typeNormalized == 'card' ? 'Card' : 'Cash';
    final String amountText = formatMoney(
      entry.amount,
      currencyCode: currencyCode,
      decimalDigits: 2,
    );
    final String dateLine = DateFormat('MMM dd').format(entry.date.toLocal());
    final String timeLine = DateFormat('hh:mm a').format(entry.date.toLocal());
    final String? note = entry.notes;

    final ThemeData theme = Theme.of(context);
    final Color bg = darkStyle ? const Color(0xFF0A0D10) : theme.cardColor;
    final Color borderColor =
        darkStyle ? const Color(0xFF2A2F35) : theme.dividerColor;
    final Color secondary = darkStyle
        ? const Color(0xFF90A4AE)
        : (theme.textTheme.bodyMedium?.color ?? AppTheme.textSecondary);
    final Color hint = darkStyle
        ? const Color(0xFF78909C)
        : (theme.textTheme.bodySmall?.color ?? AppTheme.textHint);

    Widget tile = Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: bg,
        elevation: darkStyle ? 0 : 4,
        shadowColor: Colors.black.withValues(alpha: darkStyle ? 0 : 0.08),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderColor),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: Text(
                      amountText,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.brandOrange,
                      ),
                    ),
                  ),
                  Text(
                    dateLine,
                    style: TextStyle(
                      fontSize: 12,
                      color: secondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: Text(
                      note ?? '',
                      style: TextStyle(
                        fontSize: 14,
                        color: note == null || note.isEmpty ? hint : secondary,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: typeNormalized == 'card'
                          ? Colors.blueGrey.withValues(alpha: 0.12)
                          : AppTheme.brandOrange.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(
                        color: typeNormalized == 'card'
                            ? Colors.blueGrey.withValues(alpha: 0.35)
                            : AppTheme.brandOrange.withValues(alpha: 0.35),
                      ),
                    ),
                    child: Text(
                      typeLabel,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: typeNormalized == 'card'
                            ? Colors.blueGrey.shade700
                            : AppTheme.brandOrangeDeep,
                      ),
                    ),
                  ),
                  Text(
                    timeLine,
                    style: TextStyle(
                      fontSize: 12,
                      color: secondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
    if (onLongPress != null) {
      tile = GestureDetector(
        onLongPress: () {
          HapticFeedback.mediumImpact();
          onLongPress!();
        },
        behavior: HitTestBehavior.opaque,
        child: tile,
      );
    }
    return tile;
  }
}
