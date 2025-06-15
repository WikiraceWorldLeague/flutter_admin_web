import 'package:flutter/material.dart';

class GradeIcon extends StatelessWidget {
  final String? grade;
  final double size;

  const GradeIcon({super.key, required this.grade, this.size = 16});

  @override
  Widget build(BuildContext context) {
    if (grade == null) return const SizedBox.shrink();

    final gradeInfo = _getGradeInfo(grade!.toLowerCase());

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(gradeInfo.icon, color: gradeInfo.color, size: size),
        const SizedBox(width: 4),
        Text(
          gradeInfo.displayName,
          style: TextStyle(
            color: gradeInfo.color,
            fontSize: size * 0.75,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  _GradeInfo _getGradeInfo(String grade) {
    switch (grade) {
      case 'bronze':
        return _GradeInfo(
          displayName: 'Bronze',
          color: const Color(0xFFCD7F32),
          icon: Icons.workspace_premium,
        );
      case 'silver':
        return _GradeInfo(
          displayName: 'Silver',
          color: const Color(0xFFC0C0C0),
          icon: Icons.workspace_premium,
        );
      case 'gold':
        return _GradeInfo(
          displayName: 'Gold',
          color: const Color(0xFFFFD700),
          icon: Icons.workspace_premium,
        );
      case 'platinum':
        return _GradeInfo(
          displayName: 'Platinum',
          color: const Color(0xFFE5E4E2),
          icon: Icons.diamond,
        );
      case 'diamond':
        return _GradeInfo(
          displayName: 'Diamond',
          color: const Color(0xFFB9F2FF),
          icon: Icons.diamond,
        );
      default:
        return _GradeInfo(
          displayName: grade.toUpperCase(),
          color: const Color(0xFF6C757D),
          icon: Icons.star,
        );
    }
  }
}

class _GradeInfo {
  final String displayName;
  final Color color;
  final IconData icon;

  const _GradeInfo({
    required this.displayName,
    required this.color,
    required this.icon,
  });
}
