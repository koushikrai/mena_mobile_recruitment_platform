import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mena_recruitment/core/theme/app_colors.dart';
import 'package:mena_recruitment/features/jobs/providers/job_filter_provider.dart';

class JobFilterBottomSheet extends ConsumerStatefulWidget {
  const JobFilterBottomSheet({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => const JobFilterBottomSheet(),
    );
  }

  @override
  ConsumerState<JobFilterBottomSheet> createState() => _JobFilterBottomSheetState();
}

class _JobFilterBottomSheetState extends ConsumerState<JobFilterBottomSheet> {
  late List<String> _selectedCountries;
  bool _visaSponsored = false;
  bool _transferableIqama = false;
  bool _housingIncluded = false;
  String _selectedSector = 'All';

  final List<Map<String, String>> _countryOptions = [
    {'code': 'sau', 'label': '🇸🇦 Saudi Arabia'},
    {'code': 'uae', 'label': '🇦🇪 United Arab Emirates'},
    {'code': 'qat', 'label': '🇶🇦 Qatar'},
    {'code': 'kwt', 'label': '🇰🇼 Kuwait'},
    {'code': 'omn', 'label': '🇴🇲 Oman'},
    {'code': 'bhr', 'label': '🇧🇭 Bahrain'},
  ];

  final List<String> _sectors = [
    'All',
    'Oil & Gas',
    'Facility Mgmt',
    'Healthcare',
    'Hospitality',
    'Construction',
    'Maritime & Port',
  ];

  @override
  void initState() {
    super.initState();
    final currentFilter = ref.read(jobFilterProvider);
    _selectedCountries = List<String>.from(currentFilter.selectedCountries);
    _visaSponsored = currentFilter.visaSponsored == true;
    _transferableIqama = currentFilter.transferableIqama == true;
    _housingIncluded = currentFilter.housingIncluded == true;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.tune_rounded, color: AppColors.primary, size: 22),
                    const SizedBox(width: 8),
                    const Text(
                      'Filter Opportunities',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.onSurface),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _selectedCountries.clear();
                      _visaSponsored = false;
                      _transferableIqama = false;
                      _housingIncluded = false;
                      _selectedSector = 'All';
                    });
                  },
                  child: const Text('Reset All', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFE4DADB)),

          // Scrollable Filter Sections
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // GCC Countries
                  const Text('GCC Destination Countries', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.onSurface)),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _countryOptions.map((country) {
                      final isSelected = _selectedCountries.contains(country['code']);
                      return FilterChip(
                        selected: isSelected,
                        label: Text(country['label']!),
                        labelStyle: TextStyle(
                          fontSize: 12,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                          color: isSelected ? Colors.white : AppColors.onSurface,
                        ),
                        selectedColor: AppColors.primary,
                        backgroundColor: const Color(0xFFF1F5F9),
                        checkmarkColor: Colors.white,
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              _selectedCountries.add(country['code']!);
                            } else {
                              _selectedCountries.remove(country['code']!);
                            }
                          });
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),

                  // Industry Sector
                  const Text('Industry Sector', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.onSurface)),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _sectors.map((sector) {
                      final isSelected = _selectedSector == sector;
                      return ChoiceChip(
                        selected: isSelected,
                        label: Text(sector),
                        labelStyle: TextStyle(
                          fontSize: 12,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                          color: isSelected ? Colors.white : AppColors.onSurface,
                        ),
                        selectedColor: AppColors.primary,
                        backgroundColor: const Color(0xFFF1F5F9),
                        onSelected: (selected) {
                          if (selected) {
                            setState(() => _selectedSector = sector);
                          }
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),

                  // Benefits & Visa Status
                  const Text('Visa & Relocation Benefits', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.onSurface)),
                  const SizedBox(height: 8),
                  CheckboxListTile(
                    value: _visaSponsored,
                    activeColor: AppColors.primary,
                    contentPadding: EdgeInsets.zero,
                    title: const Text('100% Visa Sponsorship Provided', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                    subtitle: const Text('Employer covers entry visa, medical & flights', style: TextStyle(fontSize: 11, color: Colors.grey)),
                    onChanged: (val) => setState(() => _visaSponsored = val ?? false),
                  ),
                  CheckboxListTile(
                    value: _transferableIqama,
                    activeColor: AppColors.primary,
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Transferable Iqama Accepted (In-Country)', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                    subtitle: const Text('For candidates currently residing in KSA/UAE', style: TextStyle(fontSize: 11, color: Colors.grey)),
                    onChanged: (val) => setState(() => _transferableIqama = val ?? false),
                  ),
                  CheckboxListTile(
                    value: _housingIncluded,
                    activeColor: AppColors.primary,
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Free Food & Housing / Suite Included', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                    subtitle: const Text('Camp lodging, private suite, or monthly allowance', style: TextStyle(fontSize: 11, color: Colors.grey)),
                    onChanged: (val) => setState(() => _housingIncluded = val ?? false),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),

          // Bottom Action
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Color(0xFFE4DADB))),
            ),
            child: SafeArea(
              child: ElevatedButton(
                onPressed: () {
                  final notifier = ref.read(jobFilterProvider.notifier);
                  notifier.clearFilters();
                  for (final c in _selectedCountries) {
                    notifier.toggleCountry(c);
                  }
                  if (_visaSponsored) notifier.toggleVisaSponsored();
                  if (_transferableIqama) notifier.toggleIqama();
                  if (_housingIncluded) notifier.toggleHousing();
                  if (_selectedSector != 'All') {
                    notifier.setSearchQuery(_selectedSector);
                  }
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(48),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Apply Filters', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
