import 'package:flutter/material.dart';
import 'admin_panel.dart'; // Imports the secure lecturer provisioning engine

class DashboardScreen extends StatelessWidget {
  final String userRole; 

  const DashboardScreen({super.key, required this.userRole});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    String headerTitle = 'Student Portal';
    String statusLabel = 'Student Account';
    Color chipBgColor = const Color(0xFFE0F2FE);
    Color chipTextColor = const Color(0xFF0369A1);

    if (userRole == 'admin') {
      headerTitle = 'Centralized Admin Panel';
      statusLabel = 'System Administrator';
      chipBgColor = const Color(0xFFFEE2E2);
      chipTextColor = const Color(0xFF991B1B);
    } else if (userRole == 'lecturer') {
      headerTitle = 'Lecturer Workspace';
      statusLabel = 'Faculty Member';
      chipBgColor = const Color(0xFFF1F5F9);
      chipTextColor = const Color(0xFF0F172A);
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              headerTitle,
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            Text(
              'Emmanuel Kimeli',
              style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: chipBgColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              statusLabel,
              style: TextStyle(
                color: chipTextColor,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1.0),
          child: Divider(
            color: Color(0xFFE2E8F0),
            height: 1.0,
            thickness: 1.0,
          ),
        ),
      ),
      body: SafeArea(child: _resolveDashboardView(context, theme)), // Added context parameter pass
      floatingActionButton: userRole == 'lecturer'
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

  Widget _resolveDashboardView(BuildContext context, ThemeData theme) {
    switch (userRole) {
      case 'admin':
        return buildAdminDashboard(context, theme); // Passed context through mapping
      case 'lecturer':
        return buildLecturerDashboard(theme);
      case 'student':
      default:
        return buildStudentDashboard(theme);
    }
  }

  Widget buildAdminDashboard(BuildContext context, ThemeData theme) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        Text('Administrative Quick Tasks', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        
        // Dynamic Quick Portal Trigger Button
        InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const AdminPanelScreen()),
            );
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E3A8A), // High contrast premium brand blue
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(color: const Color(0xFF1E3A8A).withOpacity(0.2), blurRadius: 8, offset: const Offset(0, 4))
              ]
            ),
            child: Row(
              children: [
                const Icon(Icons.person_add_alt_1, color: Colors.white, size: 24),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Register New Faculty Lecturer', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white)),
                      Text('Provision official university accounts and Firestore roles instantly.', style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 12)),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
              ],
            ),
          ),
        ),
        
        const SizedBox(height: 24),
        Text('System Core Overview', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        LayoutBuilder(
          builder: (context, constraints) {
            final cardWidth = (constraints.maxWidth - 16) / 2;
            return Wrap(
              spacing: 16,
              runSpacing: 12,
              children: [
                SizedBox(width: cardWidth, child: buildStatCard('Global Attendance', '94.2%', Icons.analytics, Colors.purple)),
                SizedBox(width: cardWidth, child: buildStatCard('Active Classes', '18', Icons.online_prediction, Colors.green)),
                Container(
                  width: constraints.maxWidth,
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: buildStatCard('Total Registered System Users Across Tracks', '2,450 Verified', Icons.shield, Colors.blue),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 24),
        Text('Departmental Progress Trackers', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        buildAdminTrackingCard(
          department: 'School of Information Technology',
          lecturerCount: '12 Faculty Active',
          completionRate: '89% Syllabus Covered',
          progressValue: 0.89,
          indicatorColor: Colors.blue,
        ),
        const SizedBox(height: 12),
        buildAdminTrackingCard(
          department: 'Mechanical Engineering Complex',
          lecturerCount: '8 Faculty Active',
          completionRate: '72% Syllabus Covered',
          progressValue: 0.72,
          indicatorColor: Colors.amber,
        ),
        const SizedBox(height: 24),
        Text('System Log Alerts', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Row(
            children: [
              const Icon(Icons.warning_amber_rounded, color: Colors.orange),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Database Storage Load Warning', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    Text('S3 Asset Stream caches are currently reaching 84% usage thresholds.', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget buildStudentDashboard(ThemeData theme) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF1E3A8A), Color(0xFF3B82F6)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(8),
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
                style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 12),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF1E3A8A),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('Join Live Stream Class', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Text('Pending Tasks', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        buildTaskCard(
          title: 'Submit Data Science Proposal',
          subtitle: 'Distributed Systems & Analytics',
          dueDate: 'Today, 11:59 PM',
          icon: Icons.analytics_outlined,
          accentColor: Colors.amber[700]!,
        ),
        const SizedBox(height: 12),
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

  Widget buildLecturerDashboard(ThemeData theme) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            final cardWidth = (constraints.maxWidth - 16) / 2;
            return Wrap(
              spacing: 16,
              runSpacing: 12,
              children: [
                SizedBox(width: cardWidth, child: buildStatCard('Active Units', '3', Icons.menu_book, Colors.indigo)),
                SizedBox(width: cardWidth, child: buildStatCard('Total Students', '142', Icons.people_outline, Colors.teal)),
              ],
            );
          },
        ),
        const SizedBox(height: 24),
        Text('Your Scheduled Streams', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
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
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Network Automation Lab', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    Text('Scheduled for 2:00 PM', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.play_circle_fill, color: Colors.green, size: 28),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildAdminTrackingCard({
    required String department,
    required String lecturerCount,
    required String completionRate,
    required double progressValue,
    required Color indicatorColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: Text(department, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14), maxLines: 1, overflow: TextOverflow.ellipsis)),
              const Icon(Icons.settings_outlined, size: 18, color: Colors.grey),
            ],
          ),
          const SizedBox(height: 4),
          Text(lecturerCount, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Overall Term Metric:', style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
              Text(completionRate, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: indicatorColor)),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: progressValue,
            backgroundColor: const Color(0xFFF1F5F9),
            color: indicatorColor,
            minHeight: 6,
            borderRadius: BorderRadius.circular(4),
          )
        ],
      ),
    );
  }

  Widget buildTaskCard({
    required String title,
    required String subtitle,
    required String dueDate,
    required IconData icon,
    required Color accentColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: accentColor.withOpacity(0.1),
            child: Icon(icon, color: accentColor, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13), maxLines: 1, overflow: TextOverflow.ellipsis),
                Text(subtitle, style: TextStyle(color: Colors.grey[600], fontSize: 11), maxLines: 1, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
          const SizedBox(width: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              dueDate,
              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Color(0xFF475569)),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildStatCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)), maxLines: 1, overflow: TextOverflow.ellipsis),
          Text(label, style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)), maxLines: 1, overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }
}