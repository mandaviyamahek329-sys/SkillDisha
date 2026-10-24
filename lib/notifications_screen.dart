import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  static const Color darkBlue = Color(0xFF075273);

  @override
  Widget build(BuildContext context) {
    final List<NotificationItem> notifications = [
      const NotificationItem(
        title: 'Flutter Test Scheduled',
        message: 'Your Flutter Basics Test is scheduled for 08 Sep 2026.',
        time: '10 minutes ago',
        type: NotificationType.exam,
        isUnread: true,
      ),
      const NotificationItem(
        title: 'New Study Material',
        message: 'New Flutter state management notes are now available.',
        time: '1 hour ago',
        type: NotificationType.study,
        isUnread: true,
      ),
      const NotificationItem(
        title: 'Assignment Reminder',
        message: 'Flutter Login UI assignment is due on 05 Sep 2026.',
        time: '3 hours ago',
        type: NotificationType.assignment,
        isUnread: true,
      ),
      const NotificationItem(
        title: 'Fee Payment Reminder',
        message: 'Your next fee installment is due soon.',
        time: 'Yesterday',
        type: NotificationType.fees,
        isUnread: false,
      ),
      const NotificationItem(
        title: 'Certificate Issued',
        message: 'Your Flutter App Development certificate is available.',
        time: '2 days ago',
        type: NotificationType.certificate,
        isUnread: false,
      ),
      const NotificationItem(
        title: 'Placement Opportunity',
        message: 'A new Flutter Developer Intern opportunity is available.',
        time: '3 days ago',
        type: NotificationType.placement,
        isUnread: false,
      ),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        foregroundColor: darkBlue,
        title: const Text(
          'Notifications',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'All notifications will be marked as read after database setup',
                  ),
                ),
              );
            },
            child: const Text(
              'Mark all read',
              style: TextStyle(
                color: darkBlue,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          16,
          16,
          16,
          24,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Expanded(
                  child: NotificationSummaryCard(
                    title: 'Total',
                    value: '6',
                    icon: Icons.notifications_outlined,
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: NotificationSummaryCard(
                    title: 'Unread',
                    value: '3',
                    icon: Icons.mark_email_unread_outlined,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              'Recent Notifications',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1F2937),
              ),
            ),
            const SizedBox(height: 12),
            ...notifications.map(
                  (notification) => NotificationCard(
                notification: notification,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NotificationSummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const NotificationSummaryCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
  });

  static const Color darkBlue = Color(0xFF075273);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 15,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFFE5E7EB),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFFEAF4F7),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: darkBlue,
              size: 23,
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: darkBlue,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 11,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class NotificationCard extends StatelessWidget {
  final NotificationItem notification;

  const NotificationCard({
    super.key,
    required this.notification,
  });

  static const Color darkBlue = Color(0xFF075273);

  @override
  Widget build(BuildContext context) {
    final NotificationStyle style = getNotificationStyle(
      notification.type,
    );

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () {
          showNotificationDetails(
            context,
            notification,
          );
        },
        child: Container(
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 11),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: notification.isUnread
                ? const Color(0xFFF1F8FA)
                : Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: notification.isUnread
                  ? const Color(0xFFBFDDE2)
                  : const Color(0xFFE5E7EB),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: style.color.withValues(
                    alpha: 0.12,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  style.icon,
                  color: style.color,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            notification.title,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1F2937),
                            ),
                          ),
                        ),
                        if (notification.isUnread)
                          Container(
                            width: 8,
                            height: 8,
                            margin: const EdgeInsets.only(
                              top: 4,
                              left: 8,
                            ),
                            decoration: const BoxDecoration(
                              color: darkBlue,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Text(
                      notification.message,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        height: 1.4,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          Icons.access_time,
                          size: 14,
                          color: Colors.black38,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          notification.time,
                          style: const TextStyle(
                            fontSize: 10.5,
                            color: Colors.black45,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  NotificationStyle getNotificationStyle(
      NotificationType type,
      ) {
    switch (type) {
      case NotificationType.exam:
        return const NotificationStyle(
          icon: Icons.quiz_outlined,
          color: Colors.deepPurple,
        );

      case NotificationType.study:
        return const NotificationStyle(
          icon: Icons.folder_outlined,
          color: Colors.blue,
        );

      case NotificationType.assignment:
        return const NotificationStyle(
          icon: Icons.assignment_outlined,
          color: Colors.orange,
        );

      case NotificationType.fees:
        return const NotificationStyle(
          icon: Icons.currency_rupee,
          color: Colors.green,
        );

      case NotificationType.certificate:
        return const NotificationStyle(
          icon: Icons.workspace_premium_outlined,
          color: Colors.amber,
        );

      case NotificationType.placement:
        return const NotificationStyle(
          icon: Icons.work_outline,
          color: Colors.teal,
        );
    }
  }

  void showNotificationDetails(
      BuildContext context,
      NotificationItem notification,
      ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(22),
        ),
      ),
      builder: (context) {
        final NotificationStyle style = getNotificationStyle(
          notification.type,
        );

        return Padding(
          padding: const EdgeInsets.fromLTRB(
            20,
            8,
            20,
            30,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: style.color.withValues(
                        alpha: 0.12,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      style.icon,
                      color: style.color,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      notification.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: darkBlue,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Text(
                notification.message,
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.5,
                  color: Color(0xFF374151),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Icon(
                    Icons.access_time,
                    size: 17,
                    color: Colors.black45,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    notification.time,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class NotificationItem {
  final String title;
  final String message;
  final String time;
  final NotificationType type;
  final bool isUnread;

  const NotificationItem({
    required this.title,
    required this.message,
    required this.time,
    required this.type,
    required this.isUnread,
  });
}

class NotificationStyle {
  final IconData icon;
  final Color color;

  const NotificationStyle({
    required this.icon,
    required this.color,
  });
}

enum NotificationType {
  exam,
  study,
  assignment,
  fees,
  certificate,
  placement,
}