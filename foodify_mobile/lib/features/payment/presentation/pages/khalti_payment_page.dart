import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/api/api_endpoints.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/providers/core_providers.dart';
import '../../../../core/storage/user_session_service.dart';

class KhaltiPaymentPage extends ConsumerStatefulWidget {
  final double amount;
  final String restaurantName;
  final VoidCallback onPaymentSuccess;

  const KhaltiPaymentPage({
    super.key,
    required this.amount,
    required this.restaurantName,
    required this.onPaymentSuccess,
  });

  @override
  ConsumerState<KhaltiPaymentPage> createState() => _KhaltiPaymentPageState();
}

enum _PaymentStep { phoneAndPin, otp, processing, success }

class _KhaltiPaymentPageState extends ConsumerState<KhaltiPaymentPage>
    with TickerProviderStateMixin {
  _PaymentStep _currentStep = _PaymentStep.phoneAndPin;

  final _phoneController = TextEditingController(text: '9800000001');
  final _otpController = TextEditingController();

  // PIN dots
  String _pin = '';
  static const int _pinLength = 4;

  bool _isLoading = false;
  String? _errorMessage;

  late AnimationController _successAnimController;
  late Animation<double> _successScaleAnim;

  @override
  void initState() {
    super.initState();
    _successAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _successScaleAnim = CurvedAnimation(
      parent: _successAnimController,
      curve: Curves.elasticOut,
    );
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _otpController.dispose();
    _successAnimController.dispose();
    super.dispose();
  }

  // Send OTP via backend
  Future<void> _sendOTP() async {
    if (_phoneController.text.trim().length < 10) {
      setState(() => _errorMessage = 'Enter a valid phone number');
      return;
    }
    if (_pin.length < _pinLength) {
      setState(() => _errorMessage = 'Enter your 4 digit MPIN');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final dioClient = ref.read(dioClientProvider);
      final token = UserSessionService.getToken();

      await dioClient.dio.post(
        ApiEndpoints.khaltiSendOTP,
        data: {
          'phone': _phoneController.text.trim(),
          'amount': widget.amount.toStringAsFixed(0),
          'restaurantName': widget.restaurantName,
        },
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      setState(() {
        _isLoading = false;
        _currentStep = _PaymentStep.otp;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Failed to send OTP. Please try again.';
      });
    }
  }

  // Verify OTP via backend
  Future<void> _verifyOTP() async {
    if (_otpController.text.trim().length != 6) {
      setState(() => _errorMessage = 'Enter the 6 digit OTP');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _currentStep = _PaymentStep.processing;
    });

    try {
      final dioClient = ref.read(dioClientProvider);
      final token = UserSessionService.getToken();

      await dioClient.dio.post(
        ApiEndpoints.khaltiVerifyOTP,
        data: {'otp': _otpController.text.trim()},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      // Show success
      setState(() {
        _isLoading = false;
        _currentStep = _PaymentStep.success;
      });

      _successAnimController.forward();

      // Wait then trigger order creation
      await Future.delayed(const Duration(seconds: 2));
      if (mounted) {
        widget.onPaymentSuccess();
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _currentStep = _PaymentStep.otp;
        _errorMessage = 'Invalid OTP. Please try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF5C2D91), // Khalti purple
      appBar: AppBar(
        backgroundColor: const Color(0xFF5C2D91),
        elevation: 0,
        leading:
            _currentStep != _PaymentStep.processing &&
                _currentStep != _PaymentStep.success
            ? IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  if (_currentStep == _PaymentStep.otp) {
                    setState(() {
                      _currentStep = _PaymentStep.phoneAndPin;
                      _otpController.clear();
                      _errorMessage = null;
                    });
                  } else {
                    Navigator.pop(context);
                  }
                },
              )
            : null,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Text(
                'Khalti',
                style: TextStyle(
                  color: Color(0xFF5C2D91),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              'Secure Payment',
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Amount header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 20),
            color: const Color(0xFF5C2D91),
            child: Column(
              children: [
                const Text(
                  'Amount to Pay',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
                const SizedBox(height: 6),
                Text(
                  'Rs. ${widget.amount.toStringAsFixed(0)}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.restaurantName,
                  style: const TextStyle(color: Colors.white60, fontSize: 13),
                ),
              ],
            ),
          ),

          // Content area
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: _buildCurrentStep(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentStep() {
    switch (_currentStep) {
      case _PaymentStep.phoneAndPin:
        return _buildPhoneAndPinStep();
      case _PaymentStep.otp:
        return _buildOTPStep();
      case _PaymentStep.processing:
        return _buildProcessingStep();
      case _PaymentStep.success:
        return _buildSuccessStep();
    }
  }

  // STEP 1: Phone + MPIN
  Widget _buildPhoneAndPinStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          const Text(
            'Enter your Khalti details',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Use your registered Khalti phone number and MPIN',
            style: TextStyle(fontSize: 13, color: Colors.grey[500]),
          ),

          const SizedBox(height: 28),

          // Phone number field
          const Text(
            'Khalti Phone Number',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              hintText: '98XXXXXXXX',
              prefixIcon: const Icon(Icons.phone, color: Color(0xFF5C2D91)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: Color(0xFF5C2D91),
                  width: 2,
                ),
              ),
              filled: true,
              fillColor: Colors.grey[50],
            ),
          ),

          const SizedBox(height: 24),

          // MPIN
          const Text(
            'MPIN',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Enter your 4 digit Khalti MPIN',
            style: TextStyle(fontSize: 12, color: Colors.grey[500]),
          ),
          const SizedBox(height: 16),

          // PIN dots display
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(_pinLength, (index) {
              final filled = index < _pin.length;
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 12),
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: filled ? const Color(0xFF5C2D91) : Colors.transparent,
                  border: Border.all(
                    color: filled
                        ? const Color(0xFF5C2D91)
                        : Colors.grey.shade400,
                    width: 2,
                  ),
                ),
              );
            }),
          ),

          const SizedBox(height: 24),

          // Number pad
          _buildNumberPad(),

          const SizedBox(height: 16),

          // Error
          if (_errorMessage != null)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _errorMessage!,
                      style: const TextStyle(color: Colors.red, fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),

          const SizedBox(height: 24),

          // Continue button
          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _sendOTP,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF5C2D91),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: _isLoading
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Text(
                      'Continue',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),

          const SizedBox(height: 16),

          // Security note
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.lock, size: 14, color: Colors.grey[400]),
              const SizedBox(width: 4),
              Text(
                '256-bit SSL Secured Payment',
                style: TextStyle(fontSize: 12, color: Colors.grey[400]),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Number pad for MPIN
  Widget _buildNumberPad() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: ['1', '2', '3'].map((n) => _buildPadButton(n)).toList(),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: ['4', '5', '6'].map((n) => _buildPadButton(n)).toList(),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: ['7', '8', '9'].map((n) => _buildPadButton(n)).toList(),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const SizedBox(width: 72),
            _buildPadButton('0'),
            _buildDeleteButton(),
          ],
        ),
      ],
    );
  }

  Widget _buildPadButton(String number) {
    return GestureDetector(
      onTap: () {
        if (_pin.length < _pinLength) {
          setState(() => _pin += number);
        }
      },
      child: Container(
        width: 72,
        height: 56,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            number,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDeleteButton() {
    return GestureDetector(
      onTap: () {
        if (_pin.isNotEmpty) {
          setState(() => _pin = _pin.substring(0, _pin.length - 1));
        }
      },
      child: Container(
        width: 72,
        height: 56,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Center(
          child: Icon(
            Icons.backspace_outlined,
            color: Colors.black54,
            size: 22,
          ),
        ),
      ),
    );
  }

  // STEP 2: OTP entry
  Widget _buildOTPStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 16),

          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: const Color(0xFF5C2D91).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.mark_email_read_outlined,
              color: Color(0xFF5C2D91),
              size: 36,
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            'OTP Verification',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'A 6-digit OTP has been sent to your registered email. Please check your inbox.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
          ),

          const SizedBox(height: 32),

          // OTP field
          TextField(
            controller: _otpController,
            keyboardType: TextInputType.number,
            maxLength: 6,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              letterSpacing: 12,
              color: Color(0xFF5C2D91),
            ),
            decoration: InputDecoration(
              counterText: '',
              hintText: '------',
              hintStyle: TextStyle(
                fontSize: 28,
                letterSpacing: 12,
                color: Colors.grey[300],
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: Color(0xFF5C2D91),
                  width: 2,
                ),
              ),
              filled: true,
              fillColor: Colors.grey[50],
              contentPadding: const EdgeInsets.symmetric(
                vertical: 20,
                horizontal: 16,
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Error
          if (_errorMessage != null)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _errorMessage!,
                      style: const TextStyle(color: Colors.red, fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),

          const SizedBox(height: 24),

          // Verify button
          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _verifyOTP,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF5C2D91),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: _isLoading
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Text(
                      'Verify & Pay',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),

          const SizedBox(height: 20),

          // Resend OTP
          TextButton(
            onPressed: _isLoading
                ? null
                : () {
                    setState(() {
                      _currentStep = _PaymentStep.phoneAndPin;
                      _otpController.clear();
                      _errorMessage = null;
                    });
                  },
            child: const Text(
              'Resend OTP',
              style: TextStyle(
                color: Color(0xFF5C2D91),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // STEP 3: Processing
  Widget _buildProcessingStep() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            color: Color(0xFF5C2D91),
            strokeWidth: 3,
          ),
          const SizedBox(height: 24),
          const Text(
            'Processing Payment...',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Please do not close this screen',
            style: TextStyle(fontSize: 13, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  // STEP 4: Success
  Widget _buildSuccessStep() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ScaleTransition(
            scale: _successScaleAnim,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 64,
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Payment Successful!',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Rs. ${widget.amount.toStringAsFixed(0)} paid successfully',
            style: TextStyle(fontSize: 15, color: Colors.grey[600]),
          ),
          const SizedBox(height: 4),
          Text(
            'to ${widget.restaurantName}',
            style: TextStyle(fontSize: 13, color: Colors.grey[400]),
          ),
          const SizedBox(height: 32),
          const CircularProgressIndicator(
            color: Color(0xFF5C2D91),
            strokeWidth: 2,
          ),
          const SizedBox(height: 16),
          Text(
            'Placing your order...',
            style: TextStyle(fontSize: 13, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }
}
