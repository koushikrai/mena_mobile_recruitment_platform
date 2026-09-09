import 'package:flutter/material.dart';

class SectorEntity {
  final String id;
  final String name;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final Color gradientStart;
  final Color gradientEnd;
  final int jobCount;
  final String avgSalaryRange;
  final String currency;
  final bool isTrending;
  final bool isHot;
  final List<String> topCountries; // country codes
  final List<String> topCertifications;
  final List<String> topSkills;
  final List<String> topCompanies;
  final String demandTrend; // e.g. '↑ 34%'
  final String demandLabel; // e.g. 'more jobs this month'
  final String description;

  const SectorEntity({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.gradientStart,
    required this.gradientEnd,
    required this.jobCount,
    required this.avgSalaryRange,
    required this.currency,
    this.isTrending = false,
    this.isHot = false,
    required this.topCountries,
    required this.topCertifications,
    required this.topSkills,
    required this.topCompanies,
    required this.demandTrend,
    required this.demandLabel,
    required this.description,
  });
}
