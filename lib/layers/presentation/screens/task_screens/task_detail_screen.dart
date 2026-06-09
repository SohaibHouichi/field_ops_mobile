import 'package:field_ops/core/constants/app_color.dart';
import 'package:flutter/material.dart';

// ── Mock data ─────────────────────────────────────────────────────────────────
class _MockTask {
  static const reference = 'REQ-0041';
  static const title = 'HVAC Unit Full Inspection';
  static const subtitle = 'Preventive maintenance';
  static const customerName = 'Amine Haddad';
  static const customerInitials = 'AH';
  static const technicianName = 'Ahmed Bouzid';
  static const technicianInitials = 'AB';
  static const location = 'Msila Plant';
  static const scheduled = '14 May 2026';
  static const dueDate = '18 May 2026';
  static const createdAt = 'Created 10 May 2026 · Updated 28 May 2026';
  static const priority = 'High';
  static const lat = 35.7049;
  static const lng = 4.5417;
}

// ── Status enum ───────────────────────────────────────────────────────────────
enum TaskStatus {
  inProgress,
  accepted,
  onHold,
  resume,
  cancel,
  complete;

  String get label {
    switch (this) {
      case TaskStatus.inProgress:
        return 'In Progress';
      case TaskStatus.accepted:
        return 'Accepted';
      case TaskStatus.onHold:
        return 'On Hold';
      case TaskStatus.resume:
        return 'Resume';
      case TaskStatus.cancel:
        return 'Cancel';
      case TaskStatus.complete:
        return 'Complete';
    }
  }

  Color get color {
    switch (this) {
      case TaskStatus.inProgress:
        return const Color(0xFF3B82F6);
      case TaskStatus.accepted:
        return const Color(0xFF10B981);
      case TaskStatus.onHold:
        return const Color(0xFFF59E0B);
      case TaskStatus.resume:
        return const Color(0xFF8B5CF6);
      case TaskStatus.cancel:
        return const Color(0xFFEF4444);
      case TaskStatus.complete:
        return const Color(0xFF059669);
    }
  }

  Color get bgColor {
    return color.withOpacity(0.12);
  }

  IconData get icon {
    switch (this) {
      case TaskStatus.inProgress:
        return Icons.autorenew_rounded;
      case TaskStatus.accepted:
        return Icons.check_circle_outline_rounded;
      case TaskStatus.onHold:
        return Icons.pause_circle_outline_rounded;
      case TaskStatus.resume:
        return Icons.play_circle_outline_rounded;
      case TaskStatus.cancel:
        return Icons.cancel_outlined;
      case TaskStatus.complete:
        return Icons.task_alt_rounded;
    }
  }
}

// ── Progress steps ────────────────────────────────────────────────────────────
const _steps = ['New', 'Scheduled', 'Accepted', 'In progress'];

// ── Screen ────────────────────────────────────────────────────────────────────
class TaskDetailScreen extends StatefulWidget {
  const TaskDetailScreen({super.key});

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  TaskStatus _status = TaskStatus.inProgress;

  void _showStatusSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => _StatusSheet(
        current: _status,
        onSelected: (s) {
          setState(() => _status = s);
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: Column(
        children: [
          // ── Map header ──────────────────────────────────────────────
          _MapHeader(onBack: () => Navigator.pop(context)),

          // ── Content ─────────────────────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Progress stepper ──────────────────────────────
                  _Stepper(currentStep: 3),
                  const SizedBox(height: 20),

                  // ── Reference + status badge ──────────────────────
                  Row(
                    children: [
                      Text(
                        '# ${_MockTask.reference}',
                        style: const TextStyle(
                          color: secondaryText,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.3,
                        ),
                      ),
                      const Spacer(),
                      // ── Status dropdown button ─────────────────
                      GestureDetector(
                        onTap: _showStatusSheet,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: _status.bgColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                _status.icon,
                                size: 13,
                                color: _status.color,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                _status.label,
                                style: TextStyle(
                                  color: _status.color,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Icon(
                                Icons.keyboard_arrow_down_rounded,
                                size: 14,
                                color: _status.color,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // ── Title + subtitle ──────────────────────────────
                  Text(
                    _MockTask.title,
                    style: const TextStyle(
                      color: primaryText,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.4,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _MockTask.subtitle,
                    style: const TextStyle(
                      color: secondaryText,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // ── Info rows ─────────────────────────────────────
                  _InfoCard(
                    rows: [
                      _InfoRow(
                        icon: Icons.flag_outlined,
                        label: 'Priority',
                        trailing: _PriorityBadge(priority: _MockTask.priority),
                      ),
                      _InfoRow(
                        icon: Icons.person_outline_rounded,
                        label: 'Customer',
                        trailing: _Avatar(
                          initials: _MockTask.customerInitials,
                          name: _MockTask.customerName,
                          color: const Color(0xFF6366F1),
                        ),
                      ),
                      _InfoRow(
                        icon: Icons.build_outlined,
                        label: 'Technician',
                        trailing: _Avatar(
                          initials: _MockTask.technicianInitials,
                          name: _MockTask.technicianName,
                          color: const Color(0xFF0EA5E9),
                        ),
                      ),
                      _InfoRow(
                        icon: Icons.location_on_outlined,
                        label: 'Location',
                        trailing: Text(
                          _MockTask.location,
                          style: const TextStyle(
                            color: primaryText,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      _InfoRow(
                        icon: Icons.calendar_today_outlined,
                        label: 'Scheduled',
                        trailing: Text(
                          _MockTask.scheduled,
                          style: const TextStyle(
                            color: primaryText,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      _InfoRow(
                        icon: Icons.event_outlined,
                        label: 'Due date',
                        trailing: Text(
                          _MockTask.dueDate,
                          style: const TextStyle(
                            color: primaryText,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        isLast: true,
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // ── Timestamp ─────────────────────────────────────
                  Center(
                    child: Text(
                      _MockTask.createdAt,
                      style: const TextStyle(
                        color: secondaryText,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Map header (static placeholder) ──────────────────────────────────────────
class _MapHeader extends StatelessWidget {
  final VoidCallback onBack;
  const _MapHeader({required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Map placeholder
        Container(
          height: 180,
          color: const Color(0xFFD1D5DB),
          child: Stack(
            children: [
              // Fake map lines
              CustomPaint(
                size: const Size(double.infinity, 180),
                painter: _FakeMapPainter(),
              ),
              // Pin
              const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.location_on_rounded,
                      color: Color(0xFFEF4444),
                      size: 36,
                    ),
                    SizedBox(height: 2),
                    _PlantLabel(),
                  ],
                ),
              ),
              // Zoom button
              Positioned(
                right: 12,
                bottom: 12,
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.12),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: const Icon(Icons.add, size: 18, color: primaryText),
                ),
              ),
            ],
          ),
        ),
        // Back button
        Positioned(
          top: MediaQuery.of(context).padding.top + 8,
          left: 12,
          child: GestureDetector(
            onTap: onBack,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 6,
                  ),
                ],
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.chevron_left_rounded,
                    size: 16,
                    color: primaryText,
                  ),
                  SizedBox(width: 4),
                  Text(
                    'Service request details',
                    style: TextStyle(
                      color: primaryText,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _PlantLabel extends StatelessWidget {
  const _PlantLabel();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
          ),
        ],
      ),
      child: const Text(
        'Msila Plant',
        style: TextStyle(
          color: primaryText,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

// ── Fake map painter ──────────────────────────────────────────────────────────
class _FakeMapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFE5E7EB)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    // Horizontal roads
    for (double y = 20; y < size.height; y += 35) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
    // Vertical roads
    for (double x = 30; x < size.width; x += 50) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    // Zone label area
    final blockPaint = Paint()
      ..color = const Color(0xFFF3F4F6)
      ..style = PaintingStyle.fill;
    canvas.drawRect(
      Rect.fromLTWH(10, 30, size.width * 0.35, size.height * 0.5),
      blockPaint,
    );
  }

  @override
  bool shouldRepaint(_) => false;
}

// ── Progress stepper ──────────────────────────────────────────────────────────
class _Stepper extends StatelessWidget {
  final int currentStep;
  const _Stepper({required this.currentStep});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(_steps.length, (i) {
        final isDone = i < currentStep;
        final isCurrent = i == currentStep;
        final color = isDone || isCurrent ? primaryBlue : inputBorder;

        return Expanded(
          child: Row(
            children: [
              Column(
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isDone
                          ? primaryBlue
                          : isCurrent
                          ? Colors.white
                          : const Color(0xFFE5E7EB),
                      border: Border.all(
                        color: color,
                        width: isCurrent ? 2.5 : 0,
                      ),
                    ),
                    child: isDone
                        ? const Icon(
                            Icons.check_rounded,
                            size: 14,
                            color: Colors.white,
                          )
                        : isCurrent
                        ? Center(
                            child: Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: primaryBlue,
                              ),
                            ),
                          )
                        : null,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _steps[i],
                    style: TextStyle(
                      color: isDone || isCurrent ? primaryBlue : secondaryText,
                      fontSize: 10,
                      fontWeight: isCurrent
                          ? FontWeight.w600
                          : FontWeight.w400,
                    ),
                  ),
                ],
              ),
              if (i < _steps.length - 1)
                Expanded(
                  child: Container(
                    height: 2,
                    margin: const EdgeInsets.only(bottom: 16),
                    color: isDone ? primaryBlue : const Color(0xFFE5E7EB),
                  ),
                ),
            ],
          ),
        );
      }),
    );
  }
}

// ── Info card ─────────────────────────────────────────────────────────────────
class _InfoCard extends StatelessWidget {
  final List<_InfoRow> rows;
  const _InfoCard({required this.rows});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: inputBorder),
      ),
      child: Column(children: rows),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final Widget trailing;
  final bool isLast;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.trailing,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
          child: Row(
            children: [
              Icon(icon, size: 16, color: secondaryText),
              const SizedBox(width: 10),
              Text(
                label,
                style: const TextStyle(color: secondaryText, fontSize: 13),
              ),
              const Spacer(),
              trailing,
            ],
          ),
        ),
        if (!isLast)
          Divider(
            color: inputBorder,
            height: 1,
            indent: 16,
            endIndent: 16,
          ),
      ],
    );
  }
}

// ── Priority badge ────────────────────────────────────────────────────────────
class _PriorityBadge extends StatelessWidget {
  final String priority;
  const _PriorityBadge({required this.priority});

  Color get _color {
    switch (priority.toLowerCase()) {
      case 'high':
        return const Color(0xFFEF4444);
      case 'medium':
        return const Color(0xFFF59E0B);
      default:
        return const Color(0xFF10B981);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: _color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        priority,
        style: TextStyle(
          color: _color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

// ── Avatar with name ──────────────────────────────────────────────────────────
class _Avatar extends StatelessWidget {
  final String initials;
  final String name;
  final Color color;

  const _Avatar({
    required this.initials,
    required this.name,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 26,
          height: 26,
          decoration: BoxDecoration(
            color: color.withOpacity(0.15),
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Text(
            initials,
            style: TextStyle(
              color: color,
              fontSize: 10,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(width: 7),
        Text(
          name,
          style: const TextStyle(
            color: primaryText,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

// ── Status bottom sheet ───────────────────────────────────────────────────────
class _StatusSheet extends StatelessWidget {
  final TaskStatus current;
  final ValueChanged<TaskStatus> onSelected;

  const _StatusSheet({required this.current, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.85,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: ListView(
            controller: scrollController,
            padding: EdgeInsets.fromLTRB(20, 12, 20, bottomPadding + 24),
            children: [
              // Handle
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
              const Text(
                'Update Status',
                style: TextStyle(
                  color: primaryText,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 16),
              ...TaskStatus.values.map(
                (s) => _StatusTile(
                  status: s,
                  isSelected: s == current,
                  onTap: () => onSelected(s),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _StatusTile extends StatelessWidget {
  final TaskStatus status;
  final bool isSelected;
  final VoidCallback onTap;

  const _StatusTile({
    required this.status,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
        decoration: BoxDecoration(
          color: isSelected ? status.bgColor : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? status.color.withOpacity(0.3) : inputBorder,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: status.bgColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(status.icon, size: 18, color: status.color),
            ),
            const SizedBox(width: 12),
            Text(
              status.label,
              style: TextStyle(
                color: isSelected ? status.color : primaryText,
                fontSize: 14,
                fontWeight:
                    isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
            const Spacer(),
            if (isSelected)
              Icon(Icons.check_rounded, size: 18, color: status.color),
          ],
        ),
      ),
    );
  }
}