import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool isLecturerRole = false; // Toggle to preview both interfaces dynamically

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC), // Slate 50 background
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isLecturerRole ? 'Lecturer Workspace' : 'Student Portal',
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            Text(
              isLecturerRole ? 'Dr. Emmanuel Kimeli' : 'Emmanuel Kimeli',
              style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
            ),
          ],
        ),
        actions: [
          // Dynamic Role Switcher for previewing both states
          Row(
            children: [
              Text(
                isLecturerRole ? 'Lecturer' : 'Student',
                style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              Switch(
                value: isLecturerRole,
                activeColor: const Color(0xFF0F172A),
                activeTrackColor: const Color(0xFFE2E8F0),
                onChanged: (value) {
                  setState(() {
                    isLecturerRole = value;
                  });
                },
              ),
            ],
          ),
          const SizedBox(width: 8),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            height: 1,
            color: const Color(0xFFE2E8F0),
          ),
        ),
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        child: isLecturerRole ? buildLecturerDashboard(theme) : buildStudentDashboard(theme),
      ),
      floatingActionButton: isLecturerRole
          ? FloatingActionButton.extended(
              onPressed: () {},
              backgroundColor: const Color(0xFF0F172A),
              foregroundColor: Colors.white,
              icon: const Icon(Icons.add),
              label: const Text('Create Session'),
            )
          : null,
    );
  }

  // --- STUDENT DASHBOARD VIEW ---
  Widget buildStudentDashboard(ThemeData theme) {
    return ListView(
      key: const ValueKey('StudentView'),
      padding: const EdgeInsets.all(20.0),
      children: [
        // Live Session Alert Card
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF1E3A8A), Color(0xFF3B82F6)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'LIVE NOW',
                        style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Advanced Network Engineering',
                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Room 4B • Broadcast Started 10m ago',
                      style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 13),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF1E3A8A),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                child: const Text('Join Stream', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 28),

        Text('Pending Tasks', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),

        // Assignment List Item 1
        buildTaskCard(
          title: 'Submit Data Science Proposal',
          subtitle: 'Distributed Systems & Analytics',
          dueDate: 'Today, 11:59 PM',
          icon: Icons.analytics_outlined,
          accentColor: Colors.amber[700]!,
        ),
        const SizedBox(height: 12),

        // Assignment List Item 2
        buildTaskCard(
          title: 'Complete Mobile Dev Lab 4',
          subtitle: 'Cross-Platform Frameworks',
          dueDate: 'Tomorrow, 4:00 PM',
          icon: Icons.phone_android_outlined,
          accentColor: const Color(0xFF3B82F6),
        ),
      ],
    );
  }

  // --- LECTURER DASHBOARD VIEW ---
  Widget buildLecturerDashboard(ThemeData theme) {
    return ListView(
      key: const ValueKey('LecturerView'),
      padding: const EdgeInsets.all(20.0),
      children: [
        // Quick Statistics Panel
        Row(
          children: [
            Expanded(child: buildStatCard('Active Units', '3', Icons.menu_book, Colors.indigo)),
            const SizedBox(width: 16),
            Expanded(child: buildStatCard('Total Students', '142', Icons.people_outline, Colors.teal)),
          ],
        ),
        const SizedBox(height: 28),

        Text('Your Scheduled Streams', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),

        // Broadcast Control Cards
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.video_camera_front, color: Color(0xFF0F172A)),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Network Automation Lab', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    Text('Scheduled for 2:00 PM', style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.play_circle_fill, color: Colors.green, size: 32),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ],
    );
  }

  // --- REUSABLE UI BUILDERS ---
  Widget buildTaskCard({
    required String title,
    required String subtitle,
    required String dueDate,
    required IconData icon,
    required Color accentColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: accentColor.withOpacity(0.1),
            child: Icon(icon, color: accentColor),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                Text(subtitle, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              dueDate,
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF475569)),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildStatCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 16),
          Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
          Text(label, style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
        ],
      ),
    );
  }
}