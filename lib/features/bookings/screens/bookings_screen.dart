import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/constants/colors.dart';
import '../providers/booking_provider.dart';
import '../models/booking_model.dart';

/// Screen displaying list of user's bookings with status tabs
class BookingsScreen extends StatefulWidget {
  const BookingsScreen({super.key});

  @override
  State<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen>
    with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    // Load data after the frame is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitialData();
    });
  }

  Future<void> _loadInitialData() async {
    if (!mounted) return;

    final provider = context.read<BookingProvider>();
    await provider.loadBookingStatuses();

    if (!mounted) return;

    if (provider.bookingStatuses.isNotEmpty) {
      // Setup tab controller
      setState(() {
        _tabController = TabController(
          length: provider.bookingStatuses.length,
          vsync: this,
        );
      });

      // Load first status bookings
      final firstStatus = provider.getStatusByOrder(1);
      if (firstStatus != null) {
        await provider.loadBookings(statusId: firstStatus.id, refresh: true);
      }
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      // Load more when reaching bottom
      context.read<BookingProvider>().loadMoreBookings();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('حجوزاتي'),
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        bottom: _buildTabBar(),
      ),
      body: Consumer<BookingProvider>(
        builder: (context, provider, child) {
          if (provider.errorMessage != null) {
            return _buildErrorWidget(provider.errorMessage!);
          }

          if (provider.bookings.isEmpty && provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.bookings.isEmpty && !provider.isLoading) {
            return _buildEmptyWidget();
          }

          return RefreshIndicator(
            onRefresh: () => provider.refreshBookings(),
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: provider.bookings.length + (provider.hasMorePages ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == provider.bookings.length) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                final booking = provider.bookings[index];
                return _buildBookingCard(booking);
              },
            ),
          );
        },
      ),
    );
  }

  PreferredSizeWidget? _buildTabBar() {
    final provider = context.watch<BookingProvider>();
    if (provider.bookingStatuses.isEmpty || _tabController == null) {
      return null;
    }

    return PreferredSize(
      preferredSize: const Size.fromHeight(48),
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        labelColor: AppColors.primary,
        unselectedLabelColor: AppColors.textSecondary,
        indicatorColor: AppColors.primary,
        onTap: (index) {
          final status = provider.bookingStatuses[index];
          provider.changeStatusTab(status.id);
        },
        tabs: provider.bookingStatuses
            .map((status) => Tab(text: status.status))
            .toList(),
      ),
    );
  }

  Widget _buildBookingCard(BookingModel booking) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: AppColors.cardBackground,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(
            context,
            AppRoutes.bookingDetails,
            arguments: {'bookingId': booking.id},
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Service name and status
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      booking.service.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  _buildStatusBadge(booking.status.status),
                ],
              ),
              const SizedBox(height: 8),

              // Service image and details
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Service image
                  if (booking.service.media.isNotEmpty)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        booking.service.media.first.url,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          width: 80,
                          height: 80,
                          color: AppColors.cardBackground,
                          child: const Icon(
                            Icons.image_not_supported,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(width: 12),

                  // Details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.calendar_today,
                                size: 16, color: AppColors.textSecondary),
                            const SizedBox(width: 4),
                            Text(
                              _formatDate(booking.bookingAt),
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.access_time,
                                size: 16, color: AppColors.textSecondary),
                            const SizedBox(width: 4),
                            Text(
                              booking.service.duration ?? 'غير محدد',
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.attach_money,
                                size: 16, color: AppColors.textSecondary),
                            const SizedBox(width: 4),
                            Text(
                              '${booking.getTotal().toStringAsFixed(2)} ر.س',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              // Payment status if available
              if (booking.paymentStatus != null) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.payment, size: 16, color: AppColors.textSecondary),
                    const SizedBox(width: 4),
                    Text(
                      'الدفع: ${booking.paymentStatus}',
                      style: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color backgroundColor;
    Color textColor;

    // Color coding based on status text
    if (status.contains('قيد') || status.contains('pending')) {
      backgroundColor = Colors.orange.shade100;
      textColor = Colors.orange.shade900;
    } else if (status.contains('مقبول') || status.contains('accepted')) {
      backgroundColor = Colors.green.shade100;
      textColor = Colors.green.shade900;
    } else if (status.contains('ملغ') || status.contains('failed') || status.contains('cancel')) {
      backgroundColor = Colors.red.shade100;
      textColor = Colors.red.shade900;
    } else if (status.contains('مكتمل') || status.contains('done')) {
      backgroundColor = Colors.blue.shade100;
      textColor = Colors.blue.shade900;
    } else {
      backgroundColor = Colors.grey.shade100;
      textColor = Colors.grey.shade900;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        status,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
      ),
    );
  }

  Widget _buildEmptyWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.bookmark_border, size: 80, color: AppColors.textSecondary),
          const SizedBox(height: 16),
          const Text(
            'لا توجد حجوزات',
            style: TextStyle(fontSize: 18, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 8),
          const Text(
            'احجز خدمة لعرضها هنا',
            style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
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
          const Icon(Icons.error_outline, size: 80, color: AppColors.primary),
          const SizedBox(height: 16),
          const Text(
            'حدث خطأ',
            style: TextStyle(fontSize: 18, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              error,
              style: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              context.read<BookingProvider>().refreshBookings();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.textPrimary,
            ),
            child: const Text('إعادة المحاولة'),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}
