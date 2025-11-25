import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/colors.dart';
import '../../../core/routing/app_routes.dart';
import '../providers/checkout_provider.dart';
import '../../bookings/models/booking_model.dart';
import '../models/payment_method_model.dart';

/// Checkout screen for selecting payment method and processing payment
class CheckoutScreen extends StatefulWidget {
  final BookingModel booking;

  const CheckoutScreen({
    super.key,
    required this.booking,
  });

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<CheckoutProvider>();
      provider.initializeCheckout(widget.booking);
      provider.loadPaymentMethods();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        title: const Text(
          'الدفع',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Consumer<CheckoutProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          if (provider.errorMessage != null) {
            return _buildErrorWidget(provider.errorMessage!);
          }

          if (!provider.hasPaymentMethods) {
            return _buildNoPaymentMethodsWidget();
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildBookingSummaryCard(),
                const SizedBox(height: 16),
                _buildPaymentMethodsSection(provider),
                const SizedBox(height: 24),
                _buildPayButton(provider),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildBookingSummaryCard() {
    return Card(
      color: AppColors.cardBackground,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'ملخص الحجز',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            _buildSummaryRow('الخدمة', widget.booking.service.name),
            const SizedBox(height: 8),
            _buildSummaryRow(
              'المجموع الفرعي',
              '${widget.booking.getSubtotal().toStringAsFixed(2)} ر.س',
            ),
            const SizedBox(height: 8),
            _buildSummaryRow(
              'الضريبة',
              '${widget.booking.getTaxesValue().toStringAsFixed(2)} ر.س',
            ),
            if (widget.booking.getCouponValue() < 0) ...[
              const SizedBox(height: 8),
              _buildSummaryRow(
                'الخصم',
                '${widget.booking.getCouponValue().toStringAsFixed(2)} ر.س',
                valueColor: Colors.green,
              ),
            ],
            const Divider(height: 24, color: AppColors.textSecondary),
            _buildSummaryRow(
              'المجموع الكلي',
              '${widget.booking.getTotal().toStringAsFixed(2)} ر.س',
              isTotal: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value,
      {bool isTotal = false, Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 16 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            color: isTotal ? AppColors.textPrimary : AppColors.textSecondary,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isTotal ? 18 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            color: valueColor ?? (isTotal ? AppColors.primary : AppColors.textPrimary),
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentMethodsSection(CheckoutProvider provider) {
    return Card(
      color: AppColors.cardBackground,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'طريقة الدفع',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            ...provider.paymentMethods.map((method) => _buildPaymentMethodItem(provider, method)),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethodItem(CheckoutProvider provider, PaymentMethodModel method) {
    final isSelected = provider.selectedPaymentMethod?.id == method.id;
    final canSelect = provider.canSelectPaymentMethod(method);

    return InkWell(
      onTap: canSelect ? () => provider.selectPaymentMethod(method) : null,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withOpacity(0.1) : AppColors.background,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.background,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
              color: isSelected ? AppColors.primary : AppColors.textSecondary,
            ),
            const SizedBox(width: 12),
            if (method.logo != null) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Image.network(
                  method.logo!.url,
                  width: 40,
                  height: 40,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => const Icon(
                    Icons.payment,
                    size: 40,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              const SizedBox(width: 12),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    method.name,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected ? AppColors.primary : AppColors.textPrimary,
                    ),
                  ),
                  if (method.description.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      method.description,
                      style: TextStyle(
                        fontSize: 12,
                        color: isSelected ? AppColors.primary : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPayButton(CheckoutProvider provider) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: provider.isProcessingPayment ? null : () => _handlePayment(provider),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: provider.isProcessingPayment
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : const Text(
                'الدفع الآن',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }

  Widget _buildNoPaymentMethodsWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.payment_outlined,
            size: 80,
            color: AppColors.textSecondary.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          const Text(
            'لا توجد طرق دفع متاحة',
            style: TextStyle(
              fontSize: 18,
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'الرجاء التواصل مع الدعم',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: 80,
            color: AppColors.primary,
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              error,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              context.read<CheckoutProvider>().clearError();
              context.read<CheckoutProvider>().loadPaymentMethods();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            child: const Text('إعادة المحاولة'),
          ),
        ],
      ),
    );
  }

  Future<void> _handlePayment(CheckoutProvider provider) async {
    if (provider.requiresExternalGateway()) {
      // Open payment gateway in WebView or external browser
      final url = provider.getPaymentGatewayUrl();
      if (url != null) {
        await _openPaymentGateway(url);
      }
    } else if (provider.isCashPayment()) {
      // Cash payment - just create the payment record
      final success = await provider.processPayment();
      if (success && mounted) {
        _showSuccessAndNavigate();
      }
    } else if (provider.isWalletPayment()) {
      // Wallet payment - TODO: Show wallet selection dialog
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('دفع المحفظة قيد التطوير'),
          backgroundColor: Colors.orange,
        ),
      );
    } else {
      // Default payment processing
      final success = await provider.processPayment();
      if (success && mounted) {
        _showSuccessAndNavigate();
      }
    }
  }

  Future<void> _openPaymentGateway(String url) async {
    // Navigate to WebView screen for payment gateway
    // TODO: Create WebView screen for payment gateways
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('فتح بوابة الدفع: $url'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void _showSuccessAndNavigate() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تم الدفع بنجاح'),
        backgroundColor: Colors.green,
      ),
    );

    // Navigate to booking details
    Navigator.pushReplacementNamed(
      context,
      AppRoutes.bookingDetails,
      arguments: {'bookingId': widget.booking.id},
    );
  }
}
