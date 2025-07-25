import 'package:flutter/material.dart';
import 'package:remi_kacha/core/constant.dart';
import 'package:remi_kacha/core/utils/navigation_service.dart';
import '../forms/text_input.dart';
import '../rounded_button.dart';

class PinInputBottomSheet extends StatefulWidget {
  final VoidCallback onPinMatched;
  final String correctPin;
  const PinInputBottomSheet({super.key, required this.onPinMatched, required this.correctPin});

  @override
  State<PinInputBottomSheet> createState() => _PinInputBottomSheetState();
}

class _PinInputBottomSheetState extends State<PinInputBottomSheet> {
  final _pinController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late String errorMsg="";

  @override
  void dispose() {
    super.dispose();
    _pinController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        top: 16,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Enter your PIN", style: TextStyle(fontSize: 18)),
            const SizedBox(height: 12),
            RoundedTextFormField(
              controller: _pinController,
               enableObscureTextToggle: true,
              hintText: "Enter your PIN",
              textInputType: TextInputType.number,
              validator: (v) {
                if(v==null||v.isEmpty){
                  return "Enter your PIN";
                }else if(v.length!=4|| hash(v)!=widget.correctPin){
                  return "Invalid PIN";
                }
                return null;
              }
            ),
            const SizedBox(height: 16),
            RoundedButton(
              onPressed:(){
                if(_formKey.currentState?.validate()??false){
                  widget.onPinMatched();
                  NavigationService.pop();
                }
              },
              label: "Confirm",
            )
          ],
        ),
      ),
    );
  }
}
