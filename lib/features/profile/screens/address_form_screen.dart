import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/colors.dart';
import '../../../core/localization/app_localizations.dart';
import '../providers/address_provider.dart';
import '../models/address_model.dart';

/// Screen for adding or editing an address
class AddressFormScreen extends StatefulWidget {
  final AddressModel? address;

  const AddressFormScreen({super.key, this.address});

  @override
  State<AddressFormScreen> createState() => _AddressFormScreenState();
}

class _AddressFormScreenState extends State<AddressFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _descriptionController;
  late TextEditingController _addressController;
  late TextEditingController _latitudeController;
  late TextEditingController _longitudeController;
  bool _isDefault = false;
  bool _isSubmitting = false;

  bool get isEditMode => widget.address != null;

  @override
  void initState() {
    super.initState();
    _descriptionController = TextEditingController(
      text: widget.address?.description ?? '',
    );
    _addressController = TextEditingController(
      text: widget.address?.address ?? '',
    );
    _latitudeController = TextEditingController(
      text: widget.address?.latitude?.toString() ?? '',
    );
    _longitudeController = TextEditingController(
      text: widget.address?.longitude?.toString() ?? '',
    );
    _isDefault = widget.address?.isDefault ?? false;
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _addressController.dispose();
    _latitudeController.dispose();
    _longitudeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          elevation: 0,
          title: Text(
            isEditMode ? 'تعديل العنوان' : 'إضافة عنوان جديد',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Description field
              _buildTextField(
                controller: _descriptionController,
                label: AppLocalizations.of(context)!.addressFormDescriptionLabel,
                hint: AppLocalizations.of(context)!.addressFormDescriptionHint,
                icon: Icons.label_outline,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return AppLocalizations.of(context)!.addressFormDescriptionRequired;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Address field
              _buildTextField(
                controller: _addressController,
                label: AppLocalizations.of(context)!.addressFormFullAddressLabel,
                hint: AppLocalizations.of(context)!.addressFormFullAddressHint,
                icon: Icons.location_on_outlined,
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return AppLocalizations.of(context)!.addressFormFullAddressRequired;
                  }
                  if (value.trim().length < 10) {
                    return AppLocalizations.of(context)!.addressFormFullAddressTooShort;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Coordinates section
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.my_location,
                          color: AppColors.primary,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          AppLocalizations.of(context)!.addressFormCoordinatesTitle,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            controller: _latitudeController,
                            label: AppLocalizations.of(context)!.addressFormLatitudeLabel,
                            hint: '0.0',
                            keyboardType: TextInputType.numberWithOptions(decimal: true),
                            validator: (value) {
                              if (value != null && value.isNotEmpty) {
                                final lat = double.tryParse(value);
                                if (lat == null) {
                                  return AppLocalizations.of(context)!.addressFormInvalidNumber;
                                }
                                if (lat < -90 || lat > 90) {
                                  return AppLocalizations.of(context)!.addressFormOutOfRange;
                                }
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildTextField(
                            controller: _longitudeController,
                            label: AppLocalizations.of(context)!.addressFormLongitudeLabel,
                            hint: '0.0',
                            keyboardType: TextInputType.numberWithOptions(decimal: true),
                            validator: (value) {
                              if (value != null && value.isNotEmpty) {
                                final lng = double.tryParse(value);
                                if (lng == null) {
                                  return AppLocalizations.of(context)!.addressFormInvalidNumber;
                                }
                                if (lng < -180 || lng > 180) {
                                  return AppLocalizations.of(context)!.addressFormOutOfRange;
                                }
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Default address switch
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.grey.withValues(alpha: 0.2),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.star_outline,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'تعيين كعنوان افتراضي',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    Switch(
                      value: _isDefault,
                      onChanged: (value) {
                        setState(() {
                          _isDefault = value;
                        });
                      },
                      activeTrackColor: AppColors.primary,
                      activeThumbColor: Colors.white,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Submit button
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isSubmitting
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          isEditMode ? 'حفظ التعديلات' : 'إضافة العنوان',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),

              if (isEditMode) ...[
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text(
                    'إلغاء',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    IconData? icon,
    int maxLines = 1,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: icon != null ? Icon(icon, color: AppColors.primary) : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.withValues(alpha: 0.3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.withValues(alpha: 0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    // Parse coordinates
    double? lat;
    double? lng;
    if (_latitudeController.text.isNotEmpty) {
      lat = double.tryParse(_latitudeController.text);
    }
    if (_longitudeController.text.isNotEmpty) {
      lng = double.tryParse(_longitudeController.text);
    }

    // Create address model
    final address = AddressModel(
      id: widget.address?.id ?? '',
      description: _descriptionController.text.trim(),
      address: _addressController.text.trim(),
      latitude: lat,
      longitude: lng,
      isDefault: _isDefault,
    );

    final provider = context.read<AddressProvider>();
    bool success;

    if (isEditMode) {
      success = await provider.updateAddress(widget.address!.id, address);
    } else {
      success = await provider.createAddress(address);
    }

    setState(() {
      _isSubmitting = false;
    });

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isEditMode ? 'تم تحديث العنوان بنجاح' : 'تم إضافة العنوان بنجاح',
          ),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.of(context).pop(true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            provider.errorMessage ??
                (isEditMode ? 'فشل تحديث العنوان' : 'فشل إضافة العنوان'),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
