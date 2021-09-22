import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Haptic feedback
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../base/style/colors.dart';
import '../../../blocs/login/login_bloc.dart';

//enum NumpadActions { add, reset, biometric, forgot }
abstract class NumpadAction extends Equatable {
  const NumpadAction();

  @override
  List<Object> get props {
    return [];
  }
}
class NumpadActionReset extends NumpadAction{
  const NumpadActionReset();
}
class NumpadActionBiometric extends NumpadAction{
  const NumpadActionBiometric();
}
class NumpadActionAdd extends NumpadAction{
  final String keypress;
  const NumpadActionAdd({required this.keypress});

  @override
  List<Object> get props => [keypress];
}

class Numpad extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
      return Container(
        color: (state.onPage == OnPage.inputEmail) ? AppColor.primary : AppColor.white,
        padding: const EdgeInsets.only(top: 16, bottom: 24),
        child: Visibility(
            visible: state.onPage != OnPage.inputEmail,
            maintainSize: true,
            maintainAnimation: true,
            maintainState: true,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Table(
                border: const TableBorder(
                  horizontalInside: BorderSide(color: AppColor.lightGray, width: 2),
                  verticalInside: BorderSide(color: AppColor.lightGray, width: 2),
                ),
                children: <TableRow>[
                  const TableRow(children: [NumpadButton(text: "1"), NumpadButton(text: "2"), NumpadButton(text: "3")]),
                  const TableRow(children: [NumpadButton(text: "4"), NumpadButton(text: "5"), NumpadButton(text: "6")]),
                  const TableRow(children: [NumpadButton(text: "7"), NumpadButton(text: "8"), NumpadButton(text: "9")]),
                  TableRow(children: [
                    TableCell(
                        verticalAlignment: TableCellVerticalAlignment.fill,
                        child: NumpadButton(icon: Icons.backspace, action: const NumpadActionReset())),
                    const NumpadButton(text: "0"),
                    TableCell(
                        verticalAlignment: TableCellVerticalAlignment.fill,
                        child: NumpadButton(icon: Icons.fingerprint, action: const NumpadActionBiometric()))
                  ]),
                ],
              ),
            )),
      );
    });
  }
}

class NumpadButton extends StatelessWidget {
  final String? text;
  final IconData? icon; //TODO iconData set to nullable as it is not used
  final NumpadAction action;

  const NumpadButton(
      {this.text, this.icon, this.action = const NumpadActionAdd(keypress: '')}); //TODO Add required keypress string

  @override
  Widget build(BuildContext context) {
    return FlatButton(
        onPressed: () {
          HapticFeedback.lightImpact();
          //TODO add a case for the last button i.e. biometric/ forgotten
          if (action is NumpadActionAdd) {
            context.read<LoginBloc>().add(LoginNumpadPressed(NumpadActionAdd(keypress: text!)));
          } else {
            context.read<LoginBloc>().add(LoginNumpadPressed(action));
          }
        },
        child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: (icon != null)
                ? Icon(icon, size: 32)
                : Text(text!, style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold))));
  }
}
