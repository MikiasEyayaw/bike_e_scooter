import 'package:flutter/material.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/loading_instructor.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String? phoneNumber;

  const OtpVerificationScreen({super.key, this.phoneNumber});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final List<TextEditingController> _otpControllers =
      List.generate(6, (_) => TextEditingController());
  bool _isLoading = false;
  String? _displayPhone;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // ✅ Safely access ModalRoute here instead of initState()
    if (_displayPhone == null || _displayPhone!.isEmpty) {
      final routeArgs = ModalRoute.of(context)?.settings.arguments;

      if (routeArgs != null) {
        if (routeArgs is Map) {
          _displayPhone = (routeArgs['phone'] ??
                  routeArgs['phoneNumber'] ??
                  routeArgs['idNumber'])
              ?.toString();
        } else {
          _displayPhone = routeArgs.toString();
        }
      }
    }

    // Fallback: if still null, use constructor-provided value
    _displayPhone ??= widget.phoneNumber ?? '';
  }

  void _verifyOtp() async {
    String otp = _otpControllers.map((c) => c.text).join();

    if (otp.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter the 6-digit OTP')),
      );
      return;
    }

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2));
    setState(() => _isLoading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('OTP verified successfully!')),
    );

    Navigator.pushReplacementNamed(context, '/dashboard');
  }

  void _onOtpChanged(int index, String value) {
    if (value.isNotEmpty && index < 5) {
      FocusScope.of(context).nextFocus();
    } else if (value.isEmpty && index > 0) {
      FocusScope.of(context).previousFocus();
    }
  }

  @override
  void dispose() {
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final phoneText = (_displayPhone == null || _displayPhone!.isEmpty)
        ? 'your phone number'
        : _displayPhone!;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'OTP Verification',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            const Text(
              'Enter the 6-digit code sent to',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              phoneText,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 40),

            // OTP boxes
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(6, (index) {
                return SizedBox(
                  width: 45,
                  height: 55,
                  child: TextField(
                    controller: _otpControllers[index],
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    maxLength: 1,
                    onChanged: (value) => _onOtpChanged(index, value),
                    decoration: InputDecoration(
                      counterText: '',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                );
              }),
            ),

            const SizedBox(height: 40),
            _isLoading
                ? const LoadingIndicator()
                : SizedBox(
                    width: double.infinity,
                    child: CustomButton(
                      text: 'Verify OTP',
                      onPressed: _verifyOtp,
                    ),
                  ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('OTP resent!')),
                );
              },
              child: const Text(
                'Resend OTP',
                style: TextStyle(color: Colors.green, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
