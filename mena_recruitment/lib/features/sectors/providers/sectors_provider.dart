import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mena_recruitment/features/sectors/data/mock_sectors_data.dart';
import 'package:mena_recruitment/features/sectors/domain/sector_entity.dart';

final sectorsProvider = Provider<List<SectorEntity>>((ref) {
  return MockSectorsData.sectors;
});

final sectorByIdProvider = Provider.family<SectorEntity?, String>((ref, id) {
  return MockSectorsData.getById(id);
});

final selectedSectorProvider = StateProvider<String?>((ref) => null);
