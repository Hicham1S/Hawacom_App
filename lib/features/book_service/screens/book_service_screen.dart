import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/colors.dart';
import '../../../core/routing/app_routes.dart';
import '../providers/book_service_provider.dart';
import '../../services/models/service_model.dart';
import '../../profile/models/address_model.dart';

/// Book Service Screen - Complete booking flow
class BookServiceScreen extends StatefulWidget {
  final ServiceModel service;

  const BookServiceScreen({
    super.key,
    required this.service,
  });

  @override
  State<BookServiceScreen> createState() => _BookServiceScreenState();
}

class _BookServiceScreenState extends State<BookServiceScreen> {
  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _couponController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize booking with service
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<BookServiceProvider>();
      provider.initializeBooking(widget.service);
      provider.loadAddresses();
    });
  }

  @override
  void dispose() {
    _notesController.dispose();
    _couponController.dispose();
    super.dispose();
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
          'حجز الخدمة',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Consumer<BookServiceProvider>(
        builder: (context, provider, child) {
          if (provider.isLoadingAddresses) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          if (provider.errorMessage != null) {
            return _buildErrorWidget(provider.errorMessage!);
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildServiceCard(),
                const SizedBox(height: 16),
                _buildAddressSection(provider),
                const SizedBox(height: 16),
                _buildScheduleSection(provider),
                const SizedBox(height: 16),
                _buildQuantityDurationSection(provider),
                const SizedBox(height: 16),
                _buildCouponSection(provider),
                const SizedBox(height: 16),
                _buildNotesSection(),
                const SizedBox(height: 16),
                _buildPriceBreakdown(provider),
                const SizedBox(height: 24),
                _buildConfirmButton(provider),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildServiceCard() {
    return Card(
      color: AppColors.cardBackground,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Service image
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: widget.service.media.isNotEmpty
                  ? Image.network(
                      widget.service.media.first.url,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        width: 80,
                        height: 80,
                        color: AppColors.background,
                        child: const Icon(
                          Icons.image_not_supported,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    )
                  : Container(
                      width: 80,
                      height: 80,
                      color: AppColors.background,
                      child: const Icon(
                        Icons.image_not_supported,
                        color: AppColors.textSecondary,
                      ),
                    ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.service.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${widget.service.actualPrice.toStringAsFixed(0)} ر.س / ${widget.service.priceUnit == 'hourly' ? 'ساعة' : 'خدمة'}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddressSection(BookServiceProvider provider) {
    return Card(
      color: AppColors.cardBackground,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'العنوان',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                TextButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.addAddress).then((_) {
                      provider.loadAddresses();
                    });
                  },
                  icon: const Icon(Icons.add, size: 18, color: AppColors.primary),
                  label: const Text(
                    'إضافة عنوان',
                    style: TextStyle(fontSize: 14, color: AppColors.primary),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (provider.addresses.isEmpty)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                  child: Text(
                    'لا توجد عناوين. الرجاء إضافة عنوان.',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                ),
              )
            else
              ...provider.addresses.map((address) => _buildAddressItem(provider, address)),
          ],
        ),
      ),
    );
  }

  Widget _buildAddressItem(BookServiceProvider provider, AddressModel address) {
    final isSelected = provider.selectedAddress?.id == address.id;
    return InkWell(
      onTap: () => provider.selectAddress(address),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withValues(alpha: 0.1) : AppColors.background,
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
            Expanded(
              child: Text(
                address.description.isNotEmpty ? address.description : (address.address.isNotEmpty ? address.address : 'عنوان بدون وصف'),
                style: TextStyle(
                  fontSize: 14,
                  color: isSelected ? AppColors.primary : AppColors.textPrimary,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScheduleSection(BookServiceProvider provider) {
    return Card(
      color: AppColors.cardBackground,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'موعد الخدمة',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => provider.toggleScheduled(false),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: !provider.isScheduled
                            ? AppColors.primary
                            : AppColors.background,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          'الآن',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: !provider.isScheduled
                                ? Colors.white
                                : AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: InkWell(
                    onTap: () => provider.toggleScheduled(true),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: provider.isScheduled
                            ? AppColors.primary
                            : AppColors.background,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          'جدولة لاحقاً',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: provider.isScheduled
                                ? Colors.white
                                : AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            if (provider.isScheduled) ...[
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () => _selectDate(context, provider),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.calendar_today, color: AppColors.primary, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              '${provider.bookingDate.year}/${provider.bookingDate.month}/${provider.bookingDate.day}',
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: InkWell(
                      onTap: () => _selectTime(context, provider),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.access_time, color: AppColors.primary, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              provider.bookingTime.format(context),
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildQuantityDurationSection(BookServiceProvider provider) {
    return Card(
      color: AppColors.cardBackground,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.service.priceUnit == 'hourly' ? 'المدة (بالساعات)' : 'الكمية',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    if (widget.service.priceUnit == 'hourly') {
                      if (provider.duration > 0.5) {
                        provider.setDuration(provider.duration - 0.5);
                      }
                    } else {
                      if (provider.quantity > 1) {
                        provider.setQuantity(provider.quantity - 1);
                      }
                    }
                  },
                  icon: const Icon(Icons.remove_circle, color: AppColors.primary, size: 32),
                ),
                const SizedBox(width: 24),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    widget.service.priceUnit == 'hourly'
                        ? provider.duration.toStringAsFixed(1)
                        : provider.quantity.toString(),
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                const SizedBox(width: 24),
                IconButton(
                  onPressed: () {
                    if (widget.service.priceUnit == 'hourly') {
                      provider.setDuration(provider.duration + 0.5);
                    } else {
                      provider.setQuantity(provider.quantity + 1);
                    }
                  },
                  icon: const Icon(Icons.add_circle, color: AppColors.primary, size: 32),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCouponSection(BookServiceProvider provider) {
    return Card(
      color: AppColors.cardBackground,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'كود الخصم',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            if (provider.hasCouponApplied)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green, width: 1),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle, color: Colors.green, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'تم تطبيق كود الخصم: ${provider.couponCode}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        provider.removeCoupon();
                        _couponController.clear();
                      },
                      icon: const Icon(Icons.close, color: Colors.green, size: 20),
                    ),
                  ],
                ),
              )
            else
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _couponController,
                      style: const TextStyle(color: AppColors.textPrimary),
                      decoration: InputDecoration(
                        hintText: 'أدخل كود الخصم',
                        hintStyle: const TextStyle(color: AppColors.textSecondary),
                        filled: true,
                        fillColor: AppColors.background,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        errorText: provider.couponError,
                      ),
                      onChanged: (value) => provider.setCouponCode(value),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: provider.isValidatingCoupon
                        ? null
                        : () => provider.validateCoupon(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: provider.isValidatingCoupon
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text('تطبيق'),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotesSection() {
    return Card(
      color: AppColors.cardBackground,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'ملاحظات إضافية',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _notesController,
              maxLines: 3,
              style: const TextStyle(color: AppColors.textPrimary),
              decoration: InputDecoration(
                hintText: 'أضف أي ملاحظات خاصة بالحجز...',
                hintStyle: const TextStyle(color: AppColors.textSecondary),
                filled: true,
                fillColor: AppColors.background,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) =>
                  context.read<BookServiceProvider>().setNotes(value),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceBreakdown(BookServiceProvider provider) {
    return Card(
      color: AppColors.cardBackground,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'تفاصيل السعر',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            _buildPriceRow(
              'المجموع الفرعي',
              provider.calculateSubtotal(),
            ),
            const SizedBox(height: 8),
            _buildPriceRow(
              'الضريبة (15%)',
              provider.calculateTax(),
            ),
            if (provider.couponDiscount > 0) ...[
              const SizedBox(height: 8),
              _buildPriceRow(
                'الخصم',
                -provider.couponDiscount,
                color: Colors.green,
              ),
            ],
            const Divider(height: 24, color: AppColors.textSecondary),
            _buildPriceRow(
              'المجموع الكلي',
              provider.calculateTotal(),
              isTotal: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceRow(String label, double amount, {bool isTotal = false, Color? color}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 16 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            color: color ?? (isTotal ? AppColors.textPrimary : AppColors.textSecondary),
          ),
        ),
        Text(
          '${amount.toStringAsFixed(2)} ر.س',
          style: TextStyle(
            fontSize: isTotal ? 18 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            color: color ?? (isTotal ? AppColors.primary : AppColors.textPrimary),
          ),
        ),
      ],
    );
  }

  Widget _buildConfirmButton(BookServiceProvider provider) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: provider.isLoading ? null : () => _confirmBooking(provider),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: provider.isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : const Text(
                'تأكيد الحجز',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
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
              context.read<BookServiceProvider>().clearError();
              context.read<BookServiceProvider>().loadAddresses();
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

  Future<void> _selectDate(BuildContext context, BookServiceProvider provider) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: provider.bookingDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              surface: AppColors.cardBackground,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      provider.setBookingDate(picked);
    }
  }

  Future<void> _selectTime(BuildContext context, BookServiceProvider provider) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: provider.bookingTime,
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              surface: AppColors.cardBackground,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      provider.setBookingTime(picked);
    }
  }

  Future<void> _confirmBooking(BookServiceProvider provider) async {
    // Validate address
    if (provider.selectedAddress == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('الرجاء تحديد العنوان'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Create booking
    final booking = await provider.createBooking();

    if (booking != null) {
      // Navigate to checkout to complete payment
      if (mounted) {
        Navigator.pushNamed(
          context,
          AppRoutes.checkout,
          arguments: {'booking': booking},
        );
      }
    } else if (provider.errorMessage != null) {
      // Show error message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(provider.errorMessage!),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
