import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/constants/app_constants.dart';
import '../../../utils/helpers/date_time_helper.dart';
import '../../controllers/logbook_controller.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/common/app_button.dart';
import '../../widgets/common/app_text_field.dart';
import '../../widgets/common/custom_appbar.dart';

/// Add / Edit flight record form.
class AddFlightView extends GetView<LogbookController> {
  const AddFlightView({super.key});

  bool get _isEdit => controller.selectedRecord.value != null;

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    // Populate initial values from selected record (edit mode) or defaults
    final flightNumberCtrl = TextEditingController(
        text: _isEdit ? controller.formFlightNumber.value : '');
    final depCtrl = TextEditingController(
        text: _isEdit ? controller.formDepartureAirport.value : '');
    final arrCtrl = TextEditingController(
        text: _isEdit ? controller.formArrivalAirport.value : '');
    final typeCtrl = TextEditingController(
        text: _isEdit ? controller.formAircraftType.value : '');
    final regCtrl = TextEditingController(
        text: _isEdit ? controller.formAircraftRegistration.value : '');
    final remarksCtrl = TextEditingController(
        text: _isEdit ? controller.formRemarks.value : '');

    if (!_isEdit) {
      controller.formDate.value =
          DateTime.now().toIso8601String().substring(0, 10);
      controller.formRole.value = AppConstants.crewRoles.first;
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: _isEdit ? 'Edit Flight' : 'Log Flight',
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Date picker
                Obx(() => AppTextField(
                      label: 'Date',
                      readOnly: true,
                      initialValue: controller.formDate.value,
                      prefixIcon:
                          const Icon(Icons.calendar_today_outlined, size: 18),
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: controller.formDate.value.isNotEmpty
                              ? DateTime.parse(controller.formDate.value)
                              : DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime.now(),
                        );
                        if (picked != null) {
                          controller.formDate.value =
                              picked.toIso8601String().substring(0, 10);
                        }
                      },
                    )),
                const SizedBox(height: 14),

                // Flight number
                AppTextField(
                  label: 'Flight Number',
                  hint: 'e.g. VN123',
                  controller: flightNumberCtrl,
                  textInputAction: TextInputAction.next,
                  validator: (v) => v?.isEmpty == true
                      ? 'Flight number is required.'
                      : null,
                  onChanged: (v) =>
                      controller.formFlightNumber.value = v,
                ),
                const SizedBox(height: 14),

                Row(
                  children: [
                    Expanded(
                      child: AppTextField(
                        label: 'From (ICAO)',
                        hint: 'VVTS',
                        controller: depCtrl,
                        textInputAction: TextInputAction.next,
                        validator: (v) => v?.isEmpty == true
                            ? 'Required'
                            : null,
                        onChanged: (v) =>
                            controller.formDepartureAirport.value = v,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Icon(Icons.arrow_forward,
                        color: AppColors.textHint),
                    const SizedBox(width: 12),
                    Expanded(
                      child: AppTextField(
                        label: 'To (ICAO)',
                        hint: 'VVNB',
                        controller: arrCtrl,
                        textInputAction: TextInputAction.next,
                        validator: (v) => v?.isEmpty == true
                            ? 'Required'
                            : null,
                        onChanged: (v) =>
                            controller.formArrivalAirport.value = v,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                Row(
                  children: [
                    Expanded(
                      child: AppTextField(
                        label: 'Aircraft Type',
                        hint: 'e.g. A320',
                        controller: typeCtrl,
                        textInputAction: TextInputAction.next,
                        validator: (v) => v?.isEmpty == true
                            ? 'Required'
                            : null,
                        onChanged: (v) =>
                            controller.formAircraftType.value = v,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: AppTextField(
                        label: 'Registration',
                        hint: 'e.g. VN-A123',
                        controller: regCtrl,
                        textInputAction: TextInputAction.next,
                        validator: (v) => v?.isEmpty == true
                            ? 'Required'
                            : null,
                        onChanged: (v) =>
                            controller.formAircraftRegistration.value = v,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Block time
                _TimePickerRow(
                  label: 'Block Time',
                  minutesObs: controller.formBlockTimeMinutes,
                ),
                const SizedBox(height: 14),

                // Duty time
                _TimePickerRow(
                  label: 'Duty Time',
                  minutesObs: controller.formDutyTimeMinutes,
                ),
                const SizedBox(height: 14),

                // Night time
                _TimePickerRow(
                  label: 'Night Time',
                  minutesObs: controller.formNightTimeMinutes,
                ),
                const SizedBox(height: 14),

                // Landings
                Row(
                  children: [
                    Text('Landings', style: AppTextStyles.titleMedium),
                    const Spacer(),
                    Obx(() => Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove_circle_outline),
                              onPressed: () {
                                if (controller.formLandings.value > 0) {
                                  controller.formLandings.value--;
                                }
                              },
                            ),
                            Text(
                              controller.formLandings.value.toString(),
                              style: AppTextStyles.titleMedium,
                            ),
                            IconButton(
                              icon: const Icon(Icons.add_circle_outline),
                              onPressed: () =>
                                  controller.formLandings.value++,
                            ),
                          ],
                        )),
                  ],
                ),
                const SizedBox(height: 14),

                // Role
                Text('Role', style: AppTextStyles.titleMedium),
                const SizedBox(height: 8),
                Obx(() => DropdownButtonFormField<String>(
                      value: controller.formRole.value.isNotEmpty
                          ? controller.formRole.value
                          : null,
                      hint: const Text('Select role'),
                      items: AppConstants.crewRoles
                          .map((r) => DropdownMenuItem(
                                value: r,
                                child: Text(r),
                              ))
                          .toList(),
                      onChanged: (v) {
                        if (v != null) controller.formRole.value = v;
                      },
                      validator: (v) =>
                          v == null ? 'Role is required.' : null,
                    )),
                const SizedBox(height: 14),

                // Off duty toggle
                Obx(() => SwitchListTile(
                      title: const Text('Off Duty'),
                      subtitle: const Text(
                          'Mark this entry as an off-duty period'),
                      contentPadding: EdgeInsets.zero,
                      value: controller.formIsOffDuty.value,
                      onChanged: (v) =>
                          controller.formIsOffDuty.value = v,
                    )),
                const SizedBox(height: 14),

                // Remarks
                AppTextField(
                  label: 'Remarks',
                  hint: 'Optional notes...',
                  controller: remarksCtrl,
                  maxLines: 3,
                  onChanged: (v) => controller.formRemarks.value = v,
                ),
                const SizedBox(height: 28),

                // Error
                Obx(() {
                  if (controller.errorMessage.value.isEmpty) {
                    return const SizedBox.shrink();
                  }
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Text(
                      controller.errorMessage.value,
                      style: AppTextStyles.bodySmall
                          .copyWith(color: AppColors.error),
                    ),
                  );
                }),

                Obx(() => AppFullWidthButton(
                      label: _isEdit ? 'Update Record' : 'Save Record',
                      isLoading: controller.isLoading.value,
                      onPressed: () async {
                        if (formKey.currentState?.validate() ?? false) {
                          bool success;
                          if (_isEdit) {
                            success = await controller.updateRecord(
                                controller.selectedRecord.value!.id);
                          } else {
                            success = await controller.addRecord();
                          }
                          if (success) Get.back();
                        }
                      },
                    )),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TimePickerRow extends StatelessWidget {
  const _TimePickerRow({
    required this.label,
    required this.minutesObs,
  });

  final String label;
  final RxInt minutesObs;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(label, style: AppTextStyles.titleMedium),
        const Spacer(),
        Obx(() => GestureDetector(
              onTap: () => _pickTime(context),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(10),
                  border: const Border.fromBorderSide(
                      BorderSide(color: AppColors.outline)),
                ),
                child: Text(
                  DateTimeHelper.formatMinutes(minutesObs.value),
                  style: AppTextStyles.titleMedium,
                ),
              ),
            )),
      ],
    );
  }

  Future<void> _pickTime(BuildContext context) async {
    final hours = minutesObs.value ~/ 60;
    final minutes = minutesObs.value % 60;
    final initial = TimeOfDay(hour: hours, minute: minutes);
    final picked = await showTimePicker(
      context: context,
      initialTime: initial,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );
    if (picked != null) {
      minutesObs.value = picked.hour * 60 + picked.minute;
    }
  }
}
