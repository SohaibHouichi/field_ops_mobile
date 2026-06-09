import 'package:field_ops/core/constants/app_color.dart';
import 'package:field_ops/core/enums/customer_priority_enum.dart';
import 'package:field_ops/core/enums/sr_type_enum.dart';
import 'package:field_ops/features/assets/domain/entities/assets_entity.dart';
import 'package:field_ops/features/service_request/domain/entities/service_request_entity.dart';
import 'package:field_ops/features/service_request/domain/usecases/params/create_sr_params.dart';
import 'package:field_ops/features/service_request/domain/usecases/params/update_sr_params.dart';
import 'package:field_ops/features/service_request/presentation/cubit/service_request_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddServiceRequestSheet extends StatelessWidget {
  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final GlobalKey<FormState> formKey;
  final ServiceRequestEntity? sr;
  final List<AssetEntity> assets;

  const AddServiceRequestSheet({
    super.key,
    required this.titleController,
    required this.descriptionController,
    required this.formKey,
    required this.assets,
    this.sr,
  });

  bool get _isEdit => sr != null;

  void _submit(BuildContext context, ServiceRequestCubit cubit) {
    if (!formKey.currentState!.validate()) return;

    final title = titleController.text.trim();
    final description = descriptionController.text.trim().isEmpty
        ? null
        : descriptionController.text.trim();
    final priority = cubit.priorityNotifier.value.value;
    final type = cubit.typeNotifier.value.value;
    final assetId = cubit.assetNotifier.value?.id ?? 1;
    final addressId = cubit.selectedAddressId ??1;

    if (_isEdit) {
      cubit.updateServiceRequest(
        sr!.id,
        UpdateSrParams(
          title: title,
          description: description,
          priority: priority,
          type: type,
          assetId: assetId,
          addressId: addressId,
        ),
      );
    } else {
      cubit.createServiceRequest(
        CreateSrParams(
          title: title,
          description: description,
          priority: priority,
          type: type,
          assetId: assetId,
          addressId: addressId,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ServiceRequestCubit>();

    // Resolve asset notifier once in edit mode
    if (_isEdit &&
        cubit.assetNotifier.value == null &&
        sr?.assetId != null &&
        assets.isNotEmpty) {
      final match = assets.where((a) => a.id == sr!.assetId);
      cubit.assetNotifier.value = match.isNotEmpty ? match.first : null;
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
                // ── Handle ───────────────────────────────────────
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

                // ── Header ───────────────────────────────────────
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
                            : Icons.build_circle_outlined,
                        color: primaryBlue,
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      _isEdit ? 'Edit Service Request' : 'New Service Request',
                      style: const TextStyle(
                        color: primaryText,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // ── Type ──────────────────────────────────────────
                ValueListenableBuilder<ServiceRequestType>(
                  valueListenable: cubit.typeNotifier,
                  builder: (_, type, __) => Column(
                    children: [
                      _SrDropdown<ServiceRequestType>(
                        label: 'Type',
                        icon: Icons.category_outlined,
                        value: type,
                        items: ServiceRequestType.values
                            .where((t) => t != ServiceRequestType.unknown)
                            .toList(),
                        itemLabel: (t) =>
                            t.name[0].toUpperCase() + t.name.substring(1),
                        onChanged: (v) {
                          if (v != null) {
                            // Clear title when switching away from "other"
                            if (v != ServiceRequestType.other) {
                              titleController.clear();
                            }
                            cubit.typeNotifier.value = v;
                          }
                        },
                      ),

                      // ── Title — only visible when type is "other" ─
                      if (type == ServiceRequestType.other) ...[
                        const SizedBox(height: 12),
                        _Field(
                          controller: titleController,
                          label: 'Title',
                          icon: Icons.title_outlined,
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // ── Description ───────────────────────────────────
                _Field(
                  controller: descriptionController,
                  label: 'Description',
                  icon: Icons.notes_outlined,
                  maxLines: 3,
                  required: false,
                ),
                const SizedBox(height: 12),

                // ── Priority ──────────────────────────────────────
                ValueListenableBuilder<CustomerPriority>(
                  valueListenable: cubit.priorityNotifier,
                  builder: (_, priority, __) => _SrDropdown<CustomerPriority>(
                    label: 'Priority',
                    icon: Icons.flag_outlined,
                    value: priority,
                    items: CustomerPriority.values
                        .where((p) => p != CustomerPriority.unknown)
                        .toList(),
                    itemLabel: (p) =>
                        p.name[0].toUpperCase() + p.name.substring(1),
                    onChanged: (v) {
                      if (v != null) cubit.priorityNotifier.value = v;
                    },
                  ),
                ),
                const SizedBox(height: 12),

                // ── Asset ─────────────────────────────────────────
                ValueListenableBuilder<AssetEntity?>(
                  valueListenable: cubit.assetNotifier,
                  builder: (_, asset, __) => _SrDropdown<AssetEntity?>(
                    label: 'Asset',
                    icon: Icons.inventory_2_outlined,
                    value: asset,
                    items: [null, ...assets],
                    itemLabel: (a) => a == null ? 'None' : a.name,
                    onChanged: (v) => cubit.assetNotifier.value = v,
                    required: false,
                  ),
                ),
                const SizedBox(height: 24),

                // ── Submit ────────────────────────────────────────
                BlocConsumer<ServiceRequestCubit, ServiceRequestState>(
                  listener: (context, state) {
                    if (state is ServiceRequestCreated ||
                        state is ServiceRequestUpdated) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            state is ServiceRequestCreated
                                ? 'Service request created successfully'
                                : 'Service request updated successfully',
                          ),
                          backgroundColor: Colors.green,
                        ),
                      );
                    }
                    if (state is ServiceRequestFailure) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(state.message),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  builder: (context, state) {
                    final isLoading = state is ServiceRequestLoading;
                    return SizedBox(
                      height: 48,
                      child: ElevatedButton.icon(
                        onPressed: isLoading
                            ? null
                            : () => _submit(context, cubit),
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
                              : 'Create Request',
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

// ── Reusable field ────────────────────────────────────────────────────
class _Field extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final int maxLines;
  final bool required;

  const _Field({
    required this.controller,
    required this.label,
    required this.icon,
    this.maxLines = 1,
    this.required = true,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      style: const TextStyle(color: primaryText, fontSize: 13),
      validator: required
          ? (v) => (v == null || v.trim().isEmpty) ? '$label is required' : null
          : null,
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

// ── Reusable dropdown ─────────────────────────────────────────────────
class _SrDropdown<T> extends StatelessWidget {
  final String label;
  final IconData icon;
  final T value;
  final List<T> items;
  final String Function(T) itemLabel;
  final ValueChanged<T?> onChanged;
  final bool required;

  const _SrDropdown({
    required this.label,
    required this.icon,
    required this.value,
    required this.items,
    required this.itemLabel,
    required this.onChanged,
    this.required = true,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      value: value,
      onChanged: onChanged,
      validator: required
          ? (v) => v == null ? '$label is required' : null
          : null,
      style: const TextStyle(color: primaryText, fontSize: 13),
      dropdownColor: cardBg,
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
      items: items
          .map((t) => DropdownMenuItem<T>(value: t, child: Text(itemLabel(t))))
          .toList(),
    );
  }
}