import 'package:field_ops/core/constants/app_color.dart';
import 'package:field_ops/core/widgets/skeleton_bone_widget.dart';
import 'package:flutter/material.dart';
class ServiceRequestSkeleton extends StatefulWidget {
  const ServiceRequestSkeleton({super.key});

  @override
  State<ServiceRequestSkeleton> createState() =>
      ServiceRequestSkeletonState();
}

class ServiceRequestSkeletonState extends State<ServiceRequestSkeleton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (_, _) => Opacity(
        opacity: _animation.value,
        child: Container(
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: inputBorder),
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header skeleton ───────────────────────────────────
              Row(
                children: [
                  SkeletonBone(width: 16, height: 16, radius: 4),
                  const SizedBox(width: 8),
                  SkeletonBone(width: 120, height: 11),
                  const Spacer(),
                  SkeletonBone(width: 20, height: 11),
                ],
              ),
              const SizedBox(height: 16),
              // ── Item skeletons ────────────────────────────────────
              ...List.generate(3, (_) => ServiceRequestItemSkeleton()),
            ],
          ),
        ),
      ),
    );
  }
}

class ServiceRequestItemSkeleton extends StatelessWidget {
  const ServiceRequestItemSkeleton({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: inputBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SkeletonBone(width: 160, height: 13),
              const Spacer(),
              SkeletonBone(width: 70, height: 22, radius: 6),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              SkeletonBone(width: 100, height: 11),
              const Spacer(),
              SkeletonBone(width: 80, height: 11),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              SkeletonBone(width: 12, height: 12, radius: 4),
              const SizedBox(width: 4),
              SkeletonBone(width: 90, height: 11),
            ],
          ),
        ],
      ),
    );
  }
}