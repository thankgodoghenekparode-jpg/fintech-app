import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

const _referenceScreenIds = <String>[
  'S-AGT-001',
  'S-AGT-002',
  'S-AGT-003',
  'S-AGT-004',
  'S-AGT-005',
  'S-AGT-006',
  'S-AGT-007',
  'S-AGT-010',
  'S-AGT-011',
  'S-AGT-012',
  'S-AGT-013',
  'S-AJO-001',
  'S-AJO-002',
  'S-AJO-003',
  'S-AJO-004',
  'S-AJO-005',
  'S-AJO-006',
  'S-AJO-007',
  'S-AJO-008',
  'S-AJO-009',
  'S-AJO-010',
  'S-AJO-011',
  'S-AJO-012',
  'S-AJO-013',
  'S-AJO-014',
  'S-COOP-001',
  'S-COOP-002',
  'S-COOP-003',
  'S-COOP-004',
  'S-COOP-005',
  'S-COOP-006',
  'S-COOP-007',
  'S-COOP-008',
  'S-COOP-009',
  'S-COOP-010',
  'S-COOP-011',
  'S-COOP-012',
  'S-COOP-013',
  'S-COOP-014',
  'S-COOP-015',
  'S-COOP-016',
  'S-COOP-017',
  'S-REV-001',
  'S-REV-002',
  'S-REV-003',
  'S-REV-004',
  'S-REV-005',
  'S-REV-006',
  'S-REV-007',
  'S-REV-008',
  'S-REV-009',
  'S-REV-010',
  'S-TGT-001',
  'S-TGT-002',
  'S-TGT-003',
  'S-TGT-004',
  'S-TGT-005',
  'S-TGT-006',
  'S-TGT-007',
  'S-TGT-008',
  'S-TGT-009',
];

class ReferenceDemoGalleryScreen extends StatelessWidget {
  const ReferenceDemoGalleryScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Design previews')),
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const Card(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      'Interactive demos using supplied sample content. Changes stay local; there is no live account data or transaction processing.',
                    ),
                  ),
                ),
                for (final screenId in _referenceScreenIds)
                  ListTile(
                    leading: const Icon(Icons.phone_android_outlined),
                    title: Text(screenId),
                    subtitle: const Text('Open interactive demo screen'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => context.push('/design-preview/$screenId'),
                  ),
              ],
            ),
          ),
        ),
      );
}
