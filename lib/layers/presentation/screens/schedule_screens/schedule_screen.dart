import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: AttachmentsPage(),
  ));
}

class Attachment {
  final String name;
  final String location;
  final String size;
  final String date;
  final IconData icon;
  final Color color;

  Attachment({
    required this.name,
    required this.location,
    required this.size,
    required this.date,
    required this.icon,
    required this.color,
  });
}

class AttachmentsPage extends StatelessWidget {
  const AttachmentsPage({super.key});

  static final List<Attachment> attachments = [
    Attachment(
      name: 'HVAC_Inspection_Report.pdf',
      location: 'HVAC Unit Block A',
      size: '2.4 MB',
      date: 'Today, 08:45',
      icon: Icons.picture_as_pdf_outlined,
      color: Colors.red,
    ),
    Attachment(
      name: 'Pump_Damage_Photo_01.jpg',
      location: 'Pump Station B1',
      size: '1.1 MB',
      date: 'Today, 11:10',
      icon: Icons.image_outlined,
      color: Colors.blue,
    ),
    Attachment(
      name: 'Generator_Monthly_Log.xlsx',
      location: 'Generator Utility',
      size: '540 KB',
      date: 'Yesterday',
      icon: Icons.table_chart_outlined,
      color: Colors.green,
    ),
    Attachment(
      name: 'Work_Order_WO-2024-089.docx',
      location: 'HVAC Unit Block A',
      size: '310 KB',
      date: 'May 29',
      icon: Icons.description_outlined,
      color: Colors.blueGrey,
    ),
    Attachment(
      name: 'Electrical_Panel_Check.jpg',
      location: 'Generator Utility',
      size: '870 KB',
      date: 'May 28',
      icon: Icons.image_outlined,
      color: Colors.blue,
    ),
    Attachment(
      name: 'Site_Docs_Bundle_May2024.zip',
      location: 'Pump Station B1',
      size: '8.2 MB',
      date: 'May 27',
      icon: Icons.inventory_2_outlined,
      color: Colors.orange,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _buildHeader(),
              const SizedBox(height: 16),
              _buildSearchField(),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "RECENT FILES",
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: ListView.separated(
                  itemCount: attachments.length,
                  separatorBuilder: (_, __) =>
                      const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    return AttachmentCard(
                      attachment: attachments[index],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        const Icon(
          Icons.attach_file_rounded,
          color: Color(0xFF2563EB),
        ),
        const SizedBox(width: 8),
        const Text(
          'Attachments',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w700,
          ),
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 5,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFF2563EB),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            attachments.length.toString(),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchField() {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Search attachments...',
        prefixIcon: const Icon(Icons.search),
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

class AttachmentCard extends StatelessWidget {
  final Attachment attachment;

  const AttachmentCard({
    super.key,
    required this.attachment,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: attachment.color.withOpacity(.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              attachment.icon,
              color: attachment.color,
              size: 28,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  attachment.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  attachment.location,
                  style: const TextStyle(
                    color: Color(0xFF2563EB),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '${attachment.size} • ${attachment.date}',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.more_vert,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}