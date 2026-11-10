import 'package:coffeecard/core/styles/app_colors.dart';
import 'package:coffeecard/core/styles/app_text_styles.dart';
import 'package:coffeecard/core/widgets/design/glass_surface.dart';
import 'package:flutter/material.dart';

class AnalogSegment<T> {
  const AnalogSegment(this.value, this.label);
  final T value;
  final String label;
}

/// A full-width choice between a few options (receipt filter, stats period).
///
/// iOS: a glass capsule with an espresso thumb.
/// Android: a Material 3 [SegmentedButton].
class AnalogSegmentedControl<T> extends StatelessWidget {
  const AnalogSegmentedControl({
    required this.segments,
    required this.selected,
    required this.onChanged,
    this.enabled = true,
  });

  final List<AnalogSegment<T>> segments;
  final T selected;
  final ValueChanged<T> onChanged;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    if (!AnalogGlass.isEnabled(context)) {
      return SizedBox(
        width: double.infinity,
        child: SegmentedButton<T>(
          showSelectedIcon: false,
          segments: [
            for (final s in segments)
              ButtonSegment(value: s.value, label: Text(s.label)),
          ],
          selected: {selected},
          onSelectionChanged:
              enabled ? (values) => onChanged(values.first) : null,
        ),
      );
    }

    final animate = !MediaQuery.disableAnimationsOf(context);

    return GlassSurface(
      radius: 22,
      elevated: false,
      padding: const EdgeInsets.all(4),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 36),
        child: Row(
          children: [
            for (final s in segments)
              Expanded(
                child: Semantics(
                  button: true,
                  selected: s.value == selected,
                  inMutuallyExclusiveGroup: true,
                  enabled: enabled,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: enabled ? () => onChanged(s.value) : null,
                    child: AnimatedContainer(
                      duration: animate
                          ? const Duration(milliseconds: 200)
                          : Duration.zero,
                      curve: Curves.easeOutCubic,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 9,
                      ),
                      decoration: BoxDecoration(
                        color: s.value == selected
                            ? AppColors.espresso
                            : AppColors.espresso.withValues(alpha: 0),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Text(
                        s.label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyle.ui(
                          13,
                          weight: 600,
                          color: s.value == selected
                              ? AppColors.cream
                              : AppColors.groundsDark,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
