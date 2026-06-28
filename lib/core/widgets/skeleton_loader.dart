import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class SkeletonBox extends StatefulWidget {
  final double width;
  final double height;
  final double borderRadius;

  const SkeletonBox({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = 8,
  });

  @override
  State<SkeletonBox> createState() => _SkeletonBoxState();
}

class _SkeletonBoxState extends State<SkeletonBox>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..repeat(reverse: true);
    _anim = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) => Opacity(
        opacity: _anim.value,
        child: Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            color: AppColors.border,
            borderRadius: BorderRadius.circular(widget.borderRadius),
          ),
        ),
      ),
    );
  }
}

class HomeSkeleton extends StatelessWidget {
  const HomeSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SkeletonBox(width: 160, height: 22),
          const SizedBox(height: 8),
          const SkeletonBox(width: 240, height: 14),
          const SizedBox(height: 28),
          Row(
            children: [
              Expanded(child: _card()),
              const SizedBox(width: 12),
              Expanded(child: _card()),
            ],
          ),
          const SizedBox(height: 12),
          _card(height: 100),
          const SizedBox(height: 28),
          const SkeletonBox(width: 140, height: 16),
          const SizedBox(height: 12),
          ...List.generate(
            2,
            (_) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: const [
                  SkeletonBox(width: 40, height: 40, borderRadius: 10),
                  SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SkeletonBox(width: 180, height: 14),
                      SizedBox(height: 6),
                      SkeletonBox(width: 100, height: 11),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _card({double height = 110}) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          SkeletonBox(width: 40, height: 40, borderRadius: 10),
          SizedBox(height: 12),
          SkeletonBox(width: 60, height: 10),
          SizedBox(height: 6),
          SkeletonBox(width: 40, height: 20),
        ],
      ),
    );
  }
}