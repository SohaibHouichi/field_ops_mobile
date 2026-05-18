import 'package:field_ops/core/constants/app_color.dart';
import 'package:field_ops/core/di/di_container.dart';
import 'package:field_ops/core/routes/shell_/shell_config.dart';
import 'package:field_ops/features/assets/domain/entities/assets_entity.dart';
import 'package:field_ops/features/assets/presentation/cubit/assets_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddAssetsSheet extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController brandController;
  final TextEditingController modelController;
  final TextEditingController serialController;
  final TextEditingController noteController;
  final GlobalKey<FormState> formKey;
  final AssetEntity? asset; // null = add, not null = edit

  const AddAssetsSheet({
    super.key,
    required this.nameController,
    required this.brandController,
    required this.modelController,
    required this.serialController,
    required this.noteController,
    required this.formKey,
    this.asset,
  });

  bool get _isEdit => asset != null;

  @override
  Widget build(BuildContext context) {
    final config = DiContainer.getIt<ShellConfig>().routeConfiguration(context);
    final cubit = context.read<AssetsCubit>();

    // fill fields if edit mode
    if (_isEdit) {
      config.showFloatingButton = false;
      nameController.text = asset!.name;
      brandController.text = asset!.brand ?? '';
      modelController.text = asset!.model ?? '';
      serialController.text = asset!.serialNumber ?? '';
      noteController.text = asset!.note ?? '';
    }

    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Form(
            key: formKey,
            child: ListView(
              controller: scrollController,
              padding: EdgeInsets.fromLTRB(
                20,
                12,
                20,
                MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              children: [
                // ── Handle ─────────────────────────────────────────
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: inputBorder,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // ── Title ──────────────────────────────────────────
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: primaryBlue.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        _isEdit
                            ? Icons.edit_outlined
                            : Icons.inventory_2_outlined,
                        color: primaryBlue,
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      _isEdit ? 'Edit Asset' : 'Add Asset',
                      style: const TextStyle(
                        color: primaryText,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // ── Fields ─────────────────────────────────────────
                _Field(
                  controller: nameController,
                  label: 'Name',
                  icon: Icons.label_outline,
                ),
                const SizedBox(height: 12),
                _Field(
                  controller: brandController,
                  label: 'Brand',
                  icon: Icons.branding_watermark_outlined,
                ),
                const SizedBox(height: 12),
                _Field(
                  controller: modelController,
                  label: 'Model',
                  icon: Icons.devices_outlined,
                ),
                const SizedBox(height: 12),
                _Field(
                  controller: serialController,
                  label: 'Serial Number',
                  icon: Icons.qr_code_outlined,
                ),
                const SizedBox(height: 12),
                _Field(
                  controller: noteController,
                  label: 'Note',
                  icon: Icons.notes_outlined,
                  maxLines: 3,
                ),
                const SizedBox(height: 24),

                // ── Submit ─────────────────────────────────────────
                BlocConsumer<AssetsCubit, AssetsState>(
                  listener: (context, state) {
                    if (state is AssetsSuccess) Navigator.pop(context);
                    if (state is EditAssetsSuccessfuly) Navigator.pop(context);
                    if (state is AssetsError) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(state.message),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  builder: (context, state) {
                    final isLoading = state is AssetsLoading;
                    return SizedBox(
                      height: 48,
                      child: ElevatedButton.icon(
                        onPressed: isLoading
                            ? null
                            : () {
                                if (formKey.currentState!.validate()) {
                                  if (_isEdit) {
                                  
                                    cubit.editAssets(
                                      id: asset!.id,
                                      name: nameController.text.trim(),
                                      brand: brandController.text.trim(),
                                      model: modelController.text.trim(),
                                      note: noteController.text.trim(),
                                      serialNumber: serialController.text
                                          .trim(),
                                    );
                                      config.showFloatingButton = true;
                                  } else {
                                    cubit.addAssets(
                                      name: nameController.text.trim(),
                                      brand: brandController.text.trim(),
                                      model: modelController.text.trim(),
                                      serialNumber: serialController.text
                                          .trim(),
                                      note: noteController.text.trim(),
                                    );
                                  }
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryBlue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        icon: isLoading
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : Icon(
                                _isEdit ? Icons.save_outlined : Icons.add,
                                color: Colors.white,
                                size: 18,
                              ),
                        label: Text(
                          isLoading
                              ? 'Saving...'
                              : _isEdit
                              ? 'Save Changes'
                              : 'Add Asset',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _Field extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final int maxLines;

  const _Field({
    required this.controller,
    required this.label,
    required this.icon,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      style: const TextStyle(color: primaryText, fontSize: 13),
      validator: (v) =>
          (v == null || v.trim().isEmpty) ? '$label is required' : null,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: secondaryText, fontSize: 13),
        prefixIcon: Icon(icon, color: secondaryText, size: 18),
        filled: true,
        fillColor: cardBg,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: inputBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: inputBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: primaryBlue),
        ),
      ),
    );
  }
}
