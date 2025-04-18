import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_1/domain/entities/chat_message.dart';
import 'package:flutter_application_1/presentation/providers/auth_provider.dart';
import 'package:flutter_application_1/presentation/providers/chatbot_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_application_1/core/utils/responsive_util.dart';

class ChatbotPage extends ConsumerStatefulWidget {
  const ChatbotPage({super.key});

  @override
  _ChatbotPageState createState() => _ChatbotPageState();
}

class _ChatbotPageState extends ConsumerState<ChatbotPage> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(chatbotProvider.notifier).initialize();
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final message = _messageController.text.trim();
    if (message.isEmpty) return;

    ref.read(chatbotProvider.notifier).sendMessage(message);
    _messageController.clear();

    // Scroll to bottom after sending message
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final chatbotState = ref.watch(chatbotProvider);
    final messages = chatbotState.messages;
    final isLoading = chatbotState.isLoading;

    final isMobile = ResponsiveUtil.isMobile(context);
    final isTablet = ResponsiveUtil.isTablet(context);

    // Auto-scroll when new messages come in
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // We won't actually navigate back, as this is the main page after auth
          },
          color: Colors.black,
        ),
        title: Text(
          'Welcome, ${authState.user?.name ?? 'User'}',
          style: GoogleFonts.poppins(
            fontSize: ResponsiveUtil.getResponsiveFontSize(context, baseFontSize: 18),
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black),
            onPressed: () {
              // Could implement message search here
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout_rounded, color: Colors.black),
            tooltip: 'Logout',
            onPressed: () => _showLogoutConfirmation(context),
          ),
        ],
      ),
      body: OrientationBuilder(
        builder: (context, orientation) {
          // For larger screens in landscape, we can show a different layout
          if (!isMobile && orientation == Orientation.landscape) {
            return Row(
              children: [
                // Left side - user info and settings (optional)
                Expanded(
                  flex: 1,
                  child: Container(
                    padding: EdgeInsets.all(ResponsiveUtil.horizontalPadding(context)),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // User profile section
                        Center(
                          child: Column(
                            children: [
                              const CircleAvatar(
                                radius: 40,
                                backgroundColor: Color(0xFF5BBCD6),
                                child: Icon(Icons.person, color: Colors.white, size: 40),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                authState.user?.name ?? 'User',
                                style: GoogleFonts.poppins(
                                  fontSize: ResponsiveUtil.getResponsiveFontSize(context, baseFontSize: 20),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                authState.user?.email ?? 'user@example.com',
                                style: GoogleFonts.poppins(
                                  fontSize: ResponsiveUtil.getResponsiveFontSize(context, baseFontSize: 14),
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 40),
                        // Settings options
                        _buildSettingsItem(context, Icons.color_lens, 'Theme'),
                        _buildSettingsItem(context, Icons.notifications, 'Notifications'),
                        _buildSettingsItem(context, Icons.privacy_tip, 'Privacy'),
                        _buildSettingsItem(context, Icons.help, 'Help & Support'),
                        const Spacer(),
                        // Logout button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () => _showLogoutConfirmation(context),
                            icon: const Icon(Icons.logout_rounded),
                            label: Text(
                              'Logout',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red[400],
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Right side - chat section
                Expanded(
                  flex: 2,
                  child: _buildChatSection(context, messages, isLoading),
                ),
              ],
            );
          }
          // Default layout for mobile and portrait
          return _buildChatSection(context, messages, isLoading);
        },
      ),
    );
  }

  Widget _buildSettingsItem(BuildContext context, IconData icon, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: InkWell(
        onTap: () {
          // Handle settings item tap
        },
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Icon(icon, color: const Color(0xFF5BBCD6)),
              const SizedBox(width: 12),
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: ResponsiveUtil.getResponsiveFontSize(context, baseFontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChatSection(BuildContext context, List<ChatMessage> messages, bool isLoading) {
    return Column(
      children: [
        // Chat messages
        Expanded(
          child: messages.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.chat_bubble_outline,
                        size: ResponsiveUtil.isMobile(context) ? 80 : 100,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Start a conversation',
                        style: GoogleFonts.poppins(
                          fontSize: ResponsiveUtil.getResponsiveFontSize(context, baseFontSize: 18),
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  controller: _scrollController,
                  padding: EdgeInsets.all(ResponsiveUtil.isMobile(context) ? 16 : 24),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    return _ChatBubble(
                      message: message,
                      isTabletOrLarger: !ResponsiveUtil.isMobile(context),
                    );
                  },
                ),
        ),
        // Message input
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: ResponsiveUtil.isMobile(context) ? 8 : 16,
            vertical: 12,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(0, -1),
              ),
            ],
          ),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.mic, color: Color(0xFF5BBCD6)),
                onPressed: () {
                  // Could implement voice input here
                },
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      hintStyle: GoogleFonts.poppins(
                        fontSize: ResponsiveUtil.getResponsiveFontSize(context, baseFontSize: 14),
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    textInputAction: TextInputAction.send,
                    onSubmitted: (_) => _sendMessage(),
                    style: GoogleFonts.poppins(
                      fontSize: ResponsiveUtil.getResponsiveFontSize(context, baseFontSize: 14),
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.send,
                  color: Color(0xFF5BBCD6),
                ),
                onPressed: _sendMessage,
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showLogoutConfirmation(BuildContext context) {
    final isMobile = ResponsiveUtil.isMobile(context);

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        backgroundColor: Colors.white,
        elevation: 5,
        child: Padding(
          padding: EdgeInsets.all(isMobile ? 24.0 : 32.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: isMobile ? 70 : 90,
                height: isMobile ? 70 : 90,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFFFE8E8),
                ),
                child: Icon(
                  Icons.logout_rounded,
                  color: const Color(0xFFFF5C5C),
                  size: isMobile ? 32 : 40,
                ),
              ),
              SizedBox(height: isMobile ? 20 : 24),
              Text(
                'Logout',
                style: GoogleFonts.poppins(
                  fontSize: ResponsiveUtil.getResponsiveFontSize(context, baseFontSize: 20),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Are you sure you want to logout?',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  color: Colors.grey[600],
                  fontSize: ResponsiveUtil.getResponsiveFontSize(context, baseFontSize: 16),
                ),
              ),
              SizedBox(height: isMobile ? 24 : 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        side: const BorderSide(color: Color(0xFF5BBCD6)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        'Cancel',
                        style: GoogleFonts.poppins(
                          color: const Color(0xFF5BBCD6),
                          fontWeight: FontWeight.w600,
                          fontSize: ResponsiveUtil.getResponsiveFontSize(context, baseFontSize: 14),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF5C5C),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        elevation: 0,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        ref.read(authProvider.notifier).logout();
                        context.go('/login');
                      },
                      child: Text(
                        'Logout',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: ResponsiveUtil.getResponsiveFontSize(context, baseFontSize: 14),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChatBubble extends StatelessWidget {
  final ChatMessage message;
  final bool isTabletOrLarger;

  const _ChatBubble({
    required this.message,
    this.isTabletOrLarger = false,
  });

  @override
  Widget build(BuildContext context) {
    final isUser = message.type == MessageType.user;
    final bubblePadding = isTabletOrLarger
        ? const EdgeInsets.symmetric(horizontal: 20, vertical: 16)
        : const EdgeInsets.symmetric(horizontal: 16, vertical: 12);

    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 8.0,
        horizontal: isTabletOrLarger ? 8.0 : 0.0,
      ),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isUser) ...[
            CircleAvatar(
              radius: isTabletOrLarger ? 20 : 16,
              backgroundColor: const Color(0xFF5BBCD6),
              child: Text(
                'AI',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: isTabletOrLarger ? 12 : 10,
                ),
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: bubblePadding,
              decoration: BoxDecoration(
                color: isUser ? const Color(0xFF5BBCD6) : Colors.grey.shade200,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: isUser ? const Radius.circular(16) : Radius.zero,
                  bottomRight: isUser ? Radius.zero : const Radius.circular(16),
                ),
              ),
              child: Text(
                message.text,
                style: GoogleFonts.poppins(
                  color: isUser ? Colors.white : Colors.black,
                  fontSize: ResponsiveUtil.getResponsiveFontSize(
                    context,
                    baseFontSize: isTabletOrLarger ? 15 : 14,
                  ),
                ),
              ),
            ),
          ),
          if (isUser) ...[
            const SizedBox(width: 8),
            CircleAvatar(
              radius: isTabletOrLarger ? 20 : 16,
              backgroundColor: const Color(0xFFE0E0E0),
              child: Icon(
                Icons.person,
                color: Colors.white,
                size: isTabletOrLarger ? 20 : 16,
              ),
            ),
          ],
        ],
      ),
    );
  }
}