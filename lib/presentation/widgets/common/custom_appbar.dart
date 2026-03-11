import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

/// Custom app bar following SkyCrew design system.
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.actions,
    this.showBack = true,
    this.bottom,
  });

  final String title;
  final String? subtitle;
  final Widget? leading;
  final List<Widget>? actions;
  final bool showBack;
  final PreferredSizeWidget? bottom;

  @override
  Size get preferredSize => Size.fromHeight(
        kToolbarHeight + (bottom?.preferredSize.height ?? 0),
      );

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: showBack,
      leading: leading,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(title),
          if (subtitle != null)
            Text(
              subtitle!,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
        ],
      ),
      actions: actions,
      bottom: bottom,
    );
  }
}
