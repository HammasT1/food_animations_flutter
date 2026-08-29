import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';

class TimeLineWidget extends StatefulWidget {
  final List<String> steps;
  final List<bool> isCheckedList;

  const TimeLineWidget({
    super.key,
    required this.steps,
    required this.isCheckedList,
  });

  @override
  State<TimeLineWidget> createState() => _TimeLineWidgetState();
}

class _TimeLineWidgetState extends State<TimeLineWidget> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 110),
      itemCount: widget.steps.length,
      itemBuilder: (context, index) {
        final stagger = (130 * index).ms;
        return GestureDetector(
          onTap: () {
            setState(() {
              widget.isCheckedList[index] = !widget.isCheckedList[index];
            });
          },
          child: _buildStep(index, stagger),
        )
            .animate()
            .fadeIn(delay: stagger, duration: 420.ms, curve: Curves.easeOut)
            .slideX(begin: 0.25, end: 0, delay: stagger, curve: Curves.easeOutCubic);
      },
    );
  }

  Widget _buildStep(int index, Duration stagger) {
    final bool isChecked = widget.isCheckedList[index];
    final bool isLast = index == widget.steps.length - 1;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 280),
              curve: Curves.easeOutBack,
              width: 25,
              height: 25,
              decoration: BoxDecoration(
                color: isChecked ? AppColors.timeLineColor : Colors.transparent,
                border: Border.all(color: AppColors.timeLineColor, width: 2),
                shape: BoxShape.circle,
                boxShadow: isChecked
                    ? [
                        BoxShadow(
                          color: AppColors.timeLineColor.withValues(alpha: 0.6),
                          blurRadius: 12,
                          spreadRadius: 1,
                        )
                      ]
                    : null,
              ),
              child: isChecked
                  ? const Icon(Icons.check, size: 15, color: Colors.black)
                      .animate()
                      .scaleXY(begin: 0, end: 1, curve: Curves.easeOutBack)
                  : null,
            )
                .animate()
                .scaleXY(
                    begin: 0,
                    end: 1,
                    delay: stagger,
                    duration: 380.ms,
                    curve: Curves.elasticOut),
            if (!isLast)
              Container(
                width: 2,
                height: 60,
                margin: const EdgeInsets.symmetric(vertical: 2),
                color: AppColors.timeLineColor,
              )
                  .animate()
                  .scaleY(
                      begin: 0,
                      end: 1,
                      alignment: Alignment.topCenter,
                      delay: stagger + 150.ms,
                      duration: 320.ms,
                      curve: Curves.easeOut),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Step ${index + 1}",
                    style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                Text(widget.steps[index],
                    style: Theme.of(context).textTheme.bodySmall),
              ],
            )
                .animate()
                .fadeIn(delay: stagger + 100.ms, duration: 400.ms)
                .slideY(begin: 0.3, end: 0, curve: Curves.easeOutCubic)
                .blurX(begin: 6, end: 0),
          ),
        ),
      ],
    );
  }
}
