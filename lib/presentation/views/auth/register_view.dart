import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../domain/entities/user.dart';
import '../../controllers/auth_controller.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/common/app_button.dart';
import '../../widgets/common/app_text_field.dart';

/// Registration screen.
class RegisterView extends GetView<AuthController> {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    final nameCtrl = TextEditingController();
    final emailCtrl = TextEditingController();
    final passwordCtrl = TextEditingController();
    final confirmCtrl = TextEditingController();
    final employeeCtrl = TextEditingController();
    final airlineCtrl = TextEditingController();
    final airportCtrl = TextEditingController();
    final formKey = GlobalKey<FormState>();
    final obscure = true.obs;
    final obscureConfirm = true.obs;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Create Account'),
        backgroundColor: AppColors.background,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),
                Text('Join SkyCrew', style: AppTextStyles.headlineLarge),
                const SizedBox(height: 4),
                Text(
                  'Create your flight crew account',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 28),

                // Name
                AppTextField(
                  label: 'Full Name',
                  hint: 'Captain John Smith',
                  controller: nameCtrl,
                  textInputAction: TextInputAction.next,
                  prefixIcon: const Icon(Icons.person_outline, size: 18),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return 'Name is required.';
                    }
                    return null;
                  },
                  onChanged: (v) => controller.registerName.value = v,
                ),
                const SizedBox(height: 14),

                // Email
                AppTextField(
                  label: 'Email',
                  hint: 'you@airline.com',
                  controller: emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  prefixIcon: const Icon(Icons.email_outlined, size: 18),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Email is required.';
                    final regex = RegExp(
                      r'^[a-zA-Z0-9._%+\-]+@[a-zA-Z0-9.\-]+\.[a-zA-Z]{2,}$',
                    );
                    if (!regex.hasMatch(v.trim())) {
                      return 'Please enter a valid email address.';
                    }
                    return null;
                  },
                  onChanged: (v) => controller.registerEmail.value = v,
                ),
                const SizedBox(height: 14),

                // Password
                Obx(() => AppTextField(
                      label: 'Password',
                      hint: 'Min 8 characters',
                      controller: passwordCtrl,
                      obscureText: obscure.value,
                      textInputAction: TextInputAction.next,
                      prefixIcon:
                          const Icon(Icons.lock_outline, size: 18),
                      suffixIcon: IconButton(
                        icon: Icon(
                          obscure.value
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          size: 18,
                        ),
                        onPressed: () => obscure.value = !obscure.value,
                      ),
                      validator: (v) {
                        if (v == null || v.isEmpty) {
                          return 'Password is required.';
                        }
                        if (v.length < 8) {
                          return 'Password must be at least 8 characters.';
                        }
                        return null;
                      },
                      onChanged: (v) =>
                          controller.registerPassword.value = v,
                    )),
                const SizedBox(height: 14),

                // Confirm Password
                Obx(() => AppTextField(
                      label: 'Confirm Password',
                      controller: confirmCtrl,
                      obscureText: obscureConfirm.value,
                      textInputAction: TextInputAction.next,
                      prefixIcon:
                          const Icon(Icons.lock_outline, size: 18),
                      suffixIcon: IconButton(
                        icon: Icon(
                          obscureConfirm.value
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          size: 18,
                        ),
                        onPressed: () =>
                            obscureConfirm.value = !obscureConfirm.value,
                      ),
                      validator: (v) {
                        if (v != passwordCtrl.text) {
                          return 'Passwords do not match.';
                        }
                        return null;
                      },
                      onChanged: (v) =>
                          controller.registerConfirmPassword.value = v,
                    )),
                const SizedBox(height: 20),

                // Role selection
                Text('Your Role', style: AppTextStyles.titleMedium),
                const SizedBox(height: 10),
                Obx(() => Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: UserRole.values.map((role) {
                        final selected =
                            controller.registerRole.value == role;
                        return ChoiceChip(
                          label: Text(role.displayName),
                          selected: selected,
                          onSelected: (_) =>
                              controller.registerRole.value = role,
                          selectedColor: AppColors.primary,
                          labelStyle: TextStyle(
                            color: selected
                                ? Colors.white
                                : AppColors.textPrimary,
                          ),
                        );
                      }).toList(),
                    )),
                const SizedBox(height: 20),

                // Optional fields
                Text(
                  'Optional Details',
                  style: AppTextStyles.titleMedium,
                ),
                const SizedBox(height: 10),
                AppTextField(
                  label: 'Employee ID',
                  controller: employeeCtrl,
                  textInputAction: TextInputAction.next,
                  prefixIcon: const Icon(Icons.badge_outlined, size: 18),
                  onChanged: (v) =>
                      controller.registerEmployeeId.value = v,
                ),
                const SizedBox(height: 14),
                AppTextField(
                  label: 'Airline',
                  controller: airlineCtrl,
                  textInputAction: TextInputAction.next,
                  prefixIcon:
                      const Icon(Icons.business_outlined, size: 18),
                  onChanged: (v) => controller.registerAirline.value = v,
                ),
                const SizedBox(height: 14),
                AppTextField(
                  label: 'Base Airport (ICAO)',
                  hint: 'e.g. VVTS',
                  controller: airportCtrl,
                  textInputAction: TextInputAction.done,
                  prefixIcon:
                      const Icon(Icons.location_on_outlined, size: 18),
                  onChanged: (v) =>
                      controller.registerBaseAirport.value = v,
                ),
                const SizedBox(height: 24),

                // Error
                Obx(() {
                  if (controller.errorMessage.value.isEmpty) {
                    return const SizedBox.shrink();
                  }
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.error.withAlpha(20),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                            color: AppColors.error.withAlpha(80)),
                      ),
                      child: Text(
                        controller.errorMessage.value,
                        style: AppTextStyles.bodySmall
                            .copyWith(color: AppColors.error),
                      ),
                    ),
                  );
                }),

                Obx(() => AppFullWidthButton(
                      label: 'Create Account',
                      isLoading: controller.isLoading.value,
                      onPressed: () {
                        if (formKey.currentState?.validate() ?? false) {
                          controller.register();
                        }
                      },
                    )),
                const SizedBox(height: 20),
                Center(
                  child: TextButton(
                    onPressed: () => Get.back(),
                    child: RichText(
                      text: TextSpan(
                        style: AppTextStyles.bodyMedium,
                        children: [
                          TextSpan(
                            text: 'Already have an account? ',
                            style: TextStyle(
                                color: AppColors.textSecondary),
                          ),
                          TextSpan(
                            text: 'Sign In',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
