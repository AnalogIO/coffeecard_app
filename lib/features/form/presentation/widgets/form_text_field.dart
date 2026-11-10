part of 'form.dart';

class _FormTextField extends StatefulWidget {
  final String label;
  final String? initialValue;
  final String? hint;
  final int? maxLength;
  final TextFieldType type;
  final bool loading;
  final bool showCheckMark;
  final void Function(String) onChanged;
  final void Function()? onEditingComplete;
  final List<InputValidator> inputValidators;

  const _FormTextField({
    required this.label,
    required this.onChanged,
    this.initialValue,
    this.hint,
    this.maxLength,
    this.type = TextFieldType.text,
    this.loading = false,
    this.showCheckMark = false,
    this.onEditingComplete,
    this.inputValidators = const [],
  });

  @override
  _FormTextFieldState createState() => _FormTextFieldState();
}

class _FormTextFieldState extends State<_FormTextField> {
  double opacityLevel = 0.5;
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onOnFocusNodeEvent);
  }

  void _onOnFocusNodeEvent() {
    _changeOpacity(_focusNode.hasFocus ? 1.0 : 0.5);
  }

  void _changeOpacity(double opacity) {
    setState(() => opacityLevel = opacity);
  }

  bool get _isPasscode => widget.type == TextFieldType.passcode;

  TextInputType get _keyboardType {
    if (widget.type == TextFieldType.email) return TextInputType.emailAddress;
    if (widget.type == TextFieldType.passcode) return TextInputType.number;
    return TextInputType.text;
  }

  OutlineInputBorder get _defaultBorder {
    return const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(20)),
      borderSide: BorderSide(color: Color(0xffD4CDC3)),
    );
  }

  Widget? get _suffixIcon {
    if (widget.loading) {
      return _FormTextFieldSpinner();
    }
    if (widget.showCheckMark) {
      return const Icon(
        Icons.check_circle_outline,
        color: AppColors.secondary,
      );
    }
    return null;
  }

  List<TextInputFormatter>? get _inputFormatters {
    if (!_isPasscode) return null;

    return <TextInputFormatter>[
      FilteringTextInputFormatter.digitsOnly,
      LengthLimitingTextInputFormatter(4),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FormBloc, FormState>(
      builder: (context, state) {
        final maybeError = state.error.fold((l) => l, (r) => null);

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          child: TextFormField(
            initialValue: widget.initialValue,
            focusNode: _focusNode,
            autofocus: true,
            inputFormatters: _inputFormatters,
            keyboardType: _keyboardType,
            obscureText: _isPasscode,
            obscuringCharacter: '⬤',
            textInputAction: TextInputAction.done,
            onChanged: (input) => widget.onChanged(input),
            onEditingComplete: widget.onEditingComplete,
            cursorWidth: 1,
            style: TextStyle(
              color: AppColors.primary,
              letterSpacing: _isPasscode ? 3 : 0,
            ),
            maxLength: widget.maxLength,
            decoration: InputDecoration(
              border: _defaultBorder,
              enabledBorder: _defaultBorder,
              focusedBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                borderSide: BorderSide(color: AppColors.espresso, width: 2),
              ),
              labelText: widget.label,
              labelStyle: const TextStyle(
                color: AppColors.secondary,
                letterSpacing: 0,
              ),
              filled: true,
              fillColor: AppColors.paper.withValues(alpha: opacityLevel),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 18,
                horizontal: 18,
              ),
              helperText: widget.hint,
              helperMaxLines: 2,
              helperStyle: AppTextStyle.ui(
                12,
                weight: 500,
                color: AppColors.secondary,
              ),
              errorText: state.shouldDisplayError ? maybeError : null,
              errorMaxLines: 2,
              suffixIcon: _suffixIcon,
            ),
          ),
        );
      },
    );
  }
}

class _FormTextFieldSpinner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(16),
      child: SizedBox(
        width: 12,
        height: 12,
        child: Center(
          child: CircularProgressIndicator(
            color: AppColors.secondary,
            strokeWidth: 2.2,
          ),
        ),
      ),
    );
  }
}
