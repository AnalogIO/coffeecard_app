import 'package:coffeecard/core/styles/app_colors.dart';
import 'package:coffeecard/core/styles/app_text_styles.dart';
import 'package:coffeecard/core/widgets/design/glass_surface.dart';
import 'package:flutter/material.dart';

class AnalogNavItem {
  const AnalogNavItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
  });

  final IconData icon;
  final IconData selectedIcon;
  final String label;
}

/// The app's main navigation.
///
/// iOS: a floating Liquid Glass capsule with a lens behind the active tab.
/// Android: a Material 3 style bar (pill indicator) on a solid tonal surface.
class AnalogNavBar extends StatelessWidget {
  const AnalogNavBar({
    required this.items,
    required this.currentIndex,
    required this.onTap,
  });

  final List<AnalogNavItem> items;
  final int currentIndex;
  final ValueChanged<int> onTap;

  /// Whether the bar floats over the page content. When it does, the
  /// [Scaffold] must use `extendBody: true`.
  static bool floats(BuildContext context) => AnalogGlass.isEnabled(context);

  @override
  Widget build(BuildContext context) {
    if (!floats(context)) {
      return _MaterialNavBar(
        items: items,
        currentIndex: currentIndex,
        onTap: onTap,
      );
    }

    return SafeArea(
      minimum: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: GlassSurface(
        radius: 32,
        padding: const EdgeInsets.all(4),
        child: SizedBox(
          height: 56,
          child: Row(
            children: [
              for (final (index, item) in items.indexed)
                Expanded(
                  child: _GlassTab(
                    item: item,
                    selected: index == currentIndex,
                    onTap: () => onTap(index),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GlassTab extends StatelessWidget {
  const _GlassTab({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  final AnalogNavItem item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.espresso : const Color(0xff5E4F43);
    final animate = !MediaQuery.disableAnimationsOf(context);

    return Semantics(
      button: true,
      selected: selected,
      label: item.label,
      excludeSemantics: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: AnimatedContainer(
          duration: animate ? const Duration(milliseconds: 220) : Duration.zero,
          curve: Curves.easeOutCubic,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            color: selected
                ? Colors.white.withValues(alpha: .78)
                : Colors.white.withValues(alpha: 0),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: AppColors.espresso.withValues(alpha: .08),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                selected ? item.selectedIcon : item.icon,
                size: 24,
                color: color,
              ),
              const SizedBox(height: 2),
              Text(
                item.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textScaler:
                    MediaQuery.textScalerOf(context).clamp(maxScaleFactor: 1.3),
                style: AppTextStyle.ui(
                  10,
                  weight: selected ? 600 : 500,
                  color: color,
                ).copyWith(height: 1.2),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Material 3 style navigation bar for Android.
///
/// Built by hand instead of using [NavigationBar]: in this app the stock
/// widget's indicator pill lagged one tab behind on Android.
class _MaterialNavBar extends StatelessWidget {
  const _MaterialNavBar({
    required this.items,
    required this.currentIndex,
    required this.onTap,
  });

  final List<AnalogNavItem> items;
  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.navSurface,
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 80,
          child: Row(
            children: [
              for (final (index, item) in items.indexed)
                Expanded(
                  child: _MaterialTab(
                    item: item,
                    selected: index == currentIndex,
                    onTap: () => onTap(index),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MaterialTab extends StatelessWidget {
  const _MaterialTab({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  final AnalogNavItem item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.roast : const Color(0xff5E4F43);
    return Semantics(
      button: true,
      selected: selected,
      label: item.label,
      excludeSemantics: true,
      child: InkResponse(
        onTap: onTap,
        containedInkWell: true,
        highlightShape: BoxShape.rectangle,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 64,
              height: 32,
              decoration: BoxDecoration(
                color: selected ? AppColors.navIndicator : null,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                selected ? item.selectedIcon : item.icon,
                size: 24,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              item.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textScaler:
                  MediaQuery.textScalerOf(context).clamp(maxScaleFactor: 1.3),
              style: AppTextStyle.ui(
                12,
                weight: selected ? 600 : 500,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
