import 'package:coffeecard/base/style/colors.dart';
import 'package:flutter/material.dart';

// class AppTextField extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return TextField(
//       decoration: InputDecoration(
//         border: UnderlineInputBorder(
//           borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
//           borderSide: BorderSide(color: AppColor.error)
//         ),
//         focusedBorder: UnderlineInputBorder(
//           borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
//           borderSide: BorderSide(
//             color: AppColor.secondary,
//             width: 2
//           )
//         ),
//         labelText: 'Analog Text Field',
//         labelStyle: TextStyle(color: AppColor.secondary),
//         hintStyle: TextStyle(color: AppColor.error),
//         filled: true,
//         fillColor: AppColor.white.withOpacity(0.5),
//         // focusColor: AppColor.white, // Doesn't seem to be working
//         contentPadding: EdgeInsets.only(top: 8, bottom: 12, left: 16, right: 16),
//       ),
//       cursorWidth: 1,
//       style: TextStyle(color: AppColor.primary),
//     );
//   }
// }

class AppTextField extends StatefulWidget {
  final String value;
  final String label;
  final bool disabled;
  final bool? autofocus;

  const AppTextField({
    this.value = '',
    this.label = 'Label',
    this.disabled = false,
    this.autofocus,
  });

  @override
  _AppTextFieldState createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  @override
  Widget build(BuildContext context) {
    const UnderlineInputBorder defaultBorder = UnderlineInputBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      borderSide: BorderSide(color: AppColor.gray),
    );
    return TextField(
      enabled: !widget.disabled,
      decoration: InputDecoration(
        border: defaultBorder,
        enabledBorder: defaultBorder,
        focusedBorder: const UnderlineInputBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
          borderSide: BorderSide(color: AppColor.secondary, width: 2),
        ),
        labelText: widget.label,
        labelStyle: const TextStyle(color: AppColor.secondary),
        filled: true,
        fillColor: AppColor
            .white /*.withOpacity(0.5)*/, // TODO Change depending on focus
        contentPadding:
            const EdgeInsets.only(top: 8, bottom: 12, left: 16, right: 16),
      ),
      cursorWidth: 1,
      style: const TextStyle(color: AppColor.primary),
    );
  }
}
