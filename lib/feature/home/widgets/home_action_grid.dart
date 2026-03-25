import 'package:flutter/material.dart';
import 'package:brownyplus/res/colors/app_colors.dart';
import 'package:brownyplus/res/icons/assets.gen.dart';
import 'package:brownyplus/res/dims/app_dims.dart';
import 'package:go_router/go_router.dart';

class HomeActionGrid extends StatelessWidget {
  const HomeActionGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final actions = <_Action>[
      _Action(imagePath: Assets.images.homeMenu.createOrder.path, onTap: () {}),
      _Action(
        imagePath: Assets.images.homeMenu.task.path,
        onTap: () => context.push('/service_page?tab=management'),
      ),
      _Action(imagePath: Assets.images.homeMenu.review.path, onTap: () {}),
      _Action(imagePath: Assets.images.homeMenu.promotion.path, onTap: () {}),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppDims.vericalPadding_10,
        LayoutBuilder(
          builder: (context, constraints) {
            final itemWidth = (constraints.maxWidth - AppDims.size_10) / 2;
            return Wrap(
              spacing: AppDims.size_10,
              runSpacing: AppDims.size_10,
              children: [
                for (final a in actions)
                  SizedBox(
                    width: itemWidth,
                    child: _ActionTile(action: a),
                  ),
              ],
            );
          },
        ),
        AppDims.vericalPadding_20,
      ],
    );
  }
}

class _ActionTile extends StatelessWidget {
  final _Action action;

  const _ActionTile({required this.action});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.transparent,
      borderRadius: BorderRadius.circular(AppDims.size_18),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppDims.size_18),
        onTap: action.onTap,

        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppDims.size_18),
          child: Image.asset(action.imagePath, fit: BoxFit.cover),
        ),
      ),
    );
  }
}

class _Action {
  final String imagePath;
  final VoidCallback? onTap;

  const _Action({required this.imagePath, this.onTap});
}
