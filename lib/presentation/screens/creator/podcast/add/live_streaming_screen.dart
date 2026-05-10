import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart';
import 'package:podcast/core/route/route_path.dart';
import 'package:podcast/core/route/routes.dart';
import 'package:podcast/helper/dialog/custom_dialog.dart';
import 'package:podcast/helper/toast_message/toast_message.dart';
import 'package:podcast/presentation/screens/creator/podcast/controller/podcast_audio_controller.dart';
import 'package:podcast/presentation/screens/profile/controller/profile_controller.dart';
import 'package:podcast/presentation/screens/streaming/streaming_screen.dart';
import 'package:podcast/presentation/widget/loading/loading_widget.dart';
import 'package:podcast/presentation/widget/text_field/custom_text_field.dart';
import 'package:podcast/utils/app_colors/app_colors.dart';
import '../model/live_records_model.dart';

const _kPurple = Color(0xFF6C47FF);
const _kPurpleLight = Color(0xFFF4F0FF);
const _kBg = Color(0xFFF7F8FA);
const _kCard = Colors.white;
const _kBorder = Color(0xFFEBEBEB);
const _kText = Color(0xFF111111);
const _kMuted = Color(0xFF999999);
const _kGreen = Color(0xFF0D7A45);
const _kGreenBg = Color(0xFFEDFAF4);
const _kRed = Color(0xFFE24B4A);
const _kRedBg = Color(0xFFFFF0F0);

class LiveStreamingScreen extends StatefulWidget {
  const LiveStreamingScreen({super.key});

  @override
  State<LiveStreamingScreen> createState() => _LiveStreamingScreenState();
}

class _LiveStreamingScreenState extends State<LiveStreamingScreen> {
  final controller = Get.find<PodcastAudioController>();
  final _profileController = Get.find<ProfileController>();
  final pagingController =
      PagingController<int, LiveRecordItem>(firstPageKey: 1);
  final TextEditingController roomCodeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller.getLive();
    pagingController.addPageRequestListener((pageKey) {
      controller.getAllRecords(
          pageKey: pageKey, pagingController: pagingController);
    });
  }

  @override
  void dispose() {
    roomCodeController.dispose();
    pagingController.dispose();
    super.dispose();
  }

  void _copyToClipboard(String text, String label) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$label copied'),
        backgroundColor: _kGreen,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _joinAsAdmin() {
    final roomCodes = controller.liveData.value.data?.roomCodes ?? [];
    if (roomCodes.isEmpty) {
      toastMessage(message: "No room codes available.");
      return;
    }
    final adminCode = roomCodes.firstWhere(
      (c) => c.role == 'host',
      orElse: () => roomCodes.firstWhere(
        (c) => c.role == 'admin',
        orElse: () => roomCodes.first,
      ),
    );
    if (adminCode.code != null) {
      Navigator.push(context, MaterialPageRoute(builder: (_) {
        final name = _profileController.profile.value.data?.name;
        final id = _profileController.profile.value.data?.id;
        return StreamingScreen(
          roomCode: adminCode.code!.trim(),
          userName: (name != null && name.isNotEmpty) ? name : "Admin",
          userID: (id != null && id.isNotEmpty) ? id : null,
        );
      }));
    } else {
      toastMessage(message: "Admin code not found.");
    }
  }

  void _joinAsHost() {
    if (roomCodeController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please enter a room code'),
          backgroundColor: Colors.orange.shade700,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
      return;
    }
    Navigator.push(context, MaterialPageRoute(builder: (_) {
      final name = _profileController.profile.value.data?.name;
      final id = _profileController.profile.value.data?.id;
      return StreamingScreen(
        roomCode: roomCodeController.text.trim(),
        userName: (name != null && name.isNotEmpty) ? name : "Host",
        userID: (id != null && id.isNotEmpty) ? id : null,
      );
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kBg,
      appBar: AppBar(
        title: const Text(
          'Live Streaming',
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.w700, color: _kText),
        ),
        backgroundColor: _kCard,
        elevation: 0,
        centerTitle: true,
        surfaceTintColor: _kCard,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(0.5),
          child: Container(height: 0.5, color: _kBorder),
        ),
      ),
      body: RefreshIndicator(
        color: _kPurple,
        onRefresh: () async {
          controller.getLive();
          pagingController.refresh();
        },
        child: CustomScrollView(
          slivers: [
            Obx(() {
              if (controller.createLiveLoading.value ||
                  controller.getLiveLoading.value) {
                return const SliverFillRemaining(
                  child:
                      Center(child: LoadingWidget(color: AppColors.blackColor)),
                );
              }
              return SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      controller.liveData.value.data != null
                          ? _buildStudioCard()
                          : _buildCreateCard(),
                      const SizedBox(height: 12),
                      _buildJoinCard(),
                      const SizedBox(height: 20),
                      _buildSectionLabel('Recordings'),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              );
            }),
            PagedSliverList<int, LiveRecordItem>(
              pagingController: pagingController,
              builderDelegate: PagedChildBuilderDelegate<LiveRecordItem>(
                itemBuilder: (context, item, index) => Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
                  child: _buildRecordCard(item),
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionLabel(String label) {
    return Text(
      label.toUpperCase(),
      style: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        color: _kMuted,
        letterSpacing: 0.8,
      ),
    );
  }

  // ─── Studio / Active Room Card ─────────────────────────────────────
  Widget _buildStudioCard() {
    final liveData = controller.liveData.value.data;
    final hostCode = liveData?.roomCodes?.firstWhere(
      (c) => c.role == 'host',
      orElse: () => liveData.roomCodes!.first,
    );
    final isLive = ['active', 'live'].contains(liveData?.status?.toLowerCase());

    return Container(
      decoration: BoxDecoration(
        color: _kPurple,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            _liveIndicator(isLive),
            const Spacer(),
            Text(
              liveData?.status ?? 'Unknown',
              style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.6),
                  fontSize: 12,
                  fontWeight: FontWeight.w500),
            ),
          ]),
          const SizedBox(height: 14),
          const Text('Your Studio',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w800)),
          const SizedBox(height: 4),
          Text(
            isLive
                ? 'Room is active · Ready to broadcast'
                : 'Room is ${liveData?.status ?? 'unknown'}',
            style: TextStyle(
                color: Colors.white.withValues(alpha: 0.65), fontSize: 13),
          ),
          if (hostCode?.code != null) ...[
            const SizedBox(height: 16),
            _buildCodeChip(
              icon: Icons.vpn_key_rounded,
              label: 'Host Code',
              value: hostCode!.code!,
              onCopy: () => _copyToClipboard(hostCode.code!, 'Host code'),
            ),
          ],
          const SizedBox(height: 16),
          Row(children: [
            Expanded(
              child: _heroBtn(
                label: 'Start',
                icon: Icons.play_arrow_rounded,
                bg: Colors.white,
                fg: _kPurple,
                onTap: _joinAsAdmin,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _heroBtn(
                label: 'End Stream',
                icon: Icons.stop_rounded,
                bg: Colors.white.withValues(alpha: 0.15),
                fg: Colors.white,
                border: Colors.white.withValues(alpha: 0.3),
                onTap: () {
                  if (liveData?.roomId != null &&
                      liveData!.roomId!.isNotEmpty &&
                      !controller.endLiveLoading.value) {
                    controller.endLive(id: liveData.roomId!);
                  }
                },
              ),
            ),
          ]),
        ],
      ),
    );
  }

  Widget _liveIndicator(bool isLive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Container(
          width: 7,
          height: 7,
          decoration: BoxDecoration(
            color: isLive ? const Color(0xFFFF4D4D) : Colors.white60,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          isLive ? 'LIVE' : 'OFFLINE',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
      ]),
    );
  }

  Widget _buildCodeChip({
    required IconData icon,
    required String label,
    required String value,
    required VoidCallback onCopy,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.13),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(children: [
        Icon(icon, color: Colors.white70, size: 18),
        const SizedBox(width: 10),
        Expanded(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(label,
                style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.6),
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5)),
            const SizedBox(height: 2),
            Text(value,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'monospace')),
          ]),
        ),
        GestureDetector(
          onTap: onCopy,
          child: Icon(Icons.copy_rounded,
              color: Colors.white.withValues(alpha: 0.7), size: 18),
        ),
      ]),
    );
  }

  Widget _heroBtn({
    required String label,
    required IconData icon,
    required Color bg,
    required Color fg,
    Color? border,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 13),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(13),
          border: border != null ? Border.all(color: border) : null,
        ),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(icon, color: fg, size: 18),
          const SizedBox(width: 6),
          Text(label,
              style: TextStyle(
                  color: fg, fontSize: 13, fontWeight: FontWeight.w700)),
        ]),
      ),
    );
  }

  // ─── Create Room Card ──────────────────────────────────────────────
  Widget _buildCreateCard() {
    return Container(
      decoration: BoxDecoration(
        color: _kCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _kBorder),
      ),
      padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 24),
      child: Column(children: [
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
              color: _kPurpleLight, borderRadius: BorderRadius.circular(20)),
          child:
              const Icon(Icons.video_call_rounded, color: _kPurple, size: 36),
        ),
        const SizedBox(height: 16),
        const Text('No active room',
            style: TextStyle(
                fontSize: 17, fontWeight: FontWeight.w700, color: _kText)),
        const SizedBox(height: 6),
        const Text(
          'Create a room to start broadcasting',
          style: TextStyle(fontSize: 13, color: _kMuted),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        GestureDetector(
          onTap: () => controller.createLive(),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
                color: _kPurple, borderRadius: BorderRadius.circular(13)),
            child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_rounded, color: Colors.white, size: 20),
                  SizedBox(width: 7),
                  Text('Create Live Room',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w700)),
                ]),
          ),
        ),
      ]),
    );
  }

  // ─── Join as Host Card ─────────────────────────────────────────────
  Widget _buildJoinCard() {
    return Container(
      decoration: BoxDecoration(
        color: _kCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _kBorder),
      ),
      padding: const EdgeInsets.all(18),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
                color: _kPurpleLight, borderRadius: BorderRadius.circular(10)),
            child: const Icon(Icons.login_rounded, color: _kPurple, size: 18),
          ),
          const SizedBox(width: 10),
          const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Join as Host',
                style: TextStyle(
                    fontSize: 14, fontWeight: FontWeight.w700, color: _kText)),
            Text('Enter code shared with you',
                style: TextStyle(fontSize: 11, color: _kMuted)),
          ]),
        ]),
        const SizedBox(height: 14),
        TextField(
          controller: roomCodeController,
          style: const TextStyle(fontSize: 14, color: _kText),
          decoration: InputDecoration(
            hintText: 'e.g. abc-def-ghi',
            hintStyle: const TextStyle(fontSize: 13, color: _kMuted),
            filled: true,
            fillColor: _kBg,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 13, horizontal: 14),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: _kBorder)),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: _kBorder)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: _kPurple, width: 1.5),),
          ),
        ),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: _joinAsHost,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 13),
            decoration: BoxDecoration(
                color: _kText, borderRadius: BorderRadius.circular(13)),
            child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Join Room',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w700)),
                  SizedBox(width: 6),
                  Icon(Icons.arrow_forward_rounded,
                      color: Colors.white, size: 16),
                ]),
          ),
        ),
      ]),
    );
  }

  // ─── Recording Card ────────────────────────────────────────────────
  Widget _buildRecordCard(LiveRecordItem item) {
    final isPublic = item.isPublic ?? false;

    return Container(
      decoration: BoxDecoration(
        color: _kCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _kBorder),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Expanded(
            child: Text(
              item.roomId ?? 'Unknown Room',
              style: const TextStyle(
                  fontSize: 13, fontWeight: FontWeight.w700, color: _kText),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          _statusPill(item.status ?? 'unknown'),
        ]),
        const SizedBox(height: 12),
        Container(height: 0.5, color: _kBorder),
        const SizedBox(height: 12),

        // Recording link
        GestureDetector(
          onTap: () {
            if (item.recordingPresignedUrl != null) {
              AppRouter.route.pushNamed(RoutePath.recordPlayScreen,
                  extra: {"url": item.recordingPresignedUrl ?? ""});
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
                color: _kPurpleLight, borderRadius: BorderRadius.circular(10)),
            child: Row(children: [
              const Icon(Icons.play_circle_outline_rounded,
                  color: _kPurple, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  item.recordingPresignedUrl ?? 'No recording link',
                  style: TextStyle(
                    fontSize: 12,
                    color:
                        item.recordingPresignedUrl != null ? _kPurple : _kMuted,
                    fontWeight: FontWeight.w500,
                    decoration: item.recordingPresignedUrl != null
                        ? TextDecoration.underline
                        : null,
                    decorationColor: _kPurple,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (item.recordingPresignedUrl != null) ...[
                const SizedBox(width: 6),
                GestureDetector(
                  onTap: () =>
                      _copyToClipboard(item.recordingPresignedUrl!, 'Link'),
                  child:
                      const Icon(Icons.copy_rounded, color: _kPurple, size: 15),
                ),
              ],
            ]),
          ),
        ),

        const SizedBox(height: 12),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Row(children: [
            const Icon(Icons.calendar_today_rounded, size: 13, color: _kMuted),
            const SizedBox(width: 5),
            Text(
              DateFormat("MMM dd, yyyy")
                  .format(item.sessionStartedAt ?? DateTime.now()),
              style: const TextStyle(fontSize: 12, color: _kMuted),
            ),
          ]),
          _visibilityPill(isPublic),
        ]),

        const SizedBox(height: 14),

        Row(children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                final canToggle = (item.name?.isNotEmpty ?? false) &&
                    (item.description?.isNotEmpty ?? false) &&
                    (item.coverImage?.isNotEmpty ?? false);
                if (canToggle) {
                  controller.toggleRecord(
                      id: item.id ?? "", pagingController: pagingController);
                } else {
                  showCustomAnimatedDialog(
                    context: context,
                    title: "Warning",
                    subtitle: "Please add name, description, and cover image first.",
                    actionButton: [
                      Expanded(
                        child: TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              foregroundColor: Colors.white),
                          child: const Text("Back"),
                        ),
                      ),
                      const Gap(30),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            _showInfoSheet(item);
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: _kPurple,
                              foregroundColor: Colors.white),
                          child: const Text("Add Info"),
                        ),
                      ),
                    ],
                  );
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 11),
                decoration: BoxDecoration(
                  color: isPublic ? _kGreen : _kText,
                  borderRadius: BorderRadius.circular(10),
                ),
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Icon(isPublic ? Icons.public_rounded : Icons.lock_rounded,
                      color: Colors.white, size: 14),
                  const SizedBox(width: 5),
                  Text(
                    isPublic ? 'Public' : 'Make Public',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w700),
                  ),
                ]),
              ),
            ),
          ),
          const SizedBox(width: 8),
          _iconBtn(
              icon: Icons.info_outline_rounded,
              bg: _kPurpleLight,
              fg: _kPurple,
              onTap: () => _showInfoSheet(item)),
          const SizedBox(width: 8),
          _iconBtn(
            icon: Icons.delete_outline_rounded,
            bg: _kRedBg,
            fg: _kRed,
            onTap: () => controller.endRecord(
                id: item.id ?? "", pagingController: pagingController),
          ),
        ]),
      ]),
    );
  }

  Widget _statusPill(String status) {
    Color bg, fg;
    switch (status.toLowerCase()) {
      case 'active':
      case 'live':
        bg = _kGreenBg;
        fg = _kGreen;
        break;
      default:
        bg = const Color(0xFFF2F2F2);
        fg = _kMuted;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration:
          BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20)),
      child: Text(status.toUpperCase(),
          style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: fg,
              letterSpacing: 0.4)),
    );
  }

  Widget _visibilityPill(bool isPublic) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isPublic ? _kGreenBg : _kPurpleLight,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(isPublic ? Icons.public_rounded : Icons.lock_rounded,
            size: 11, color: isPublic ? _kGreen : _kPurple),
        const SizedBox(width: 4),
        Text(
          isPublic ? 'Public' : 'Private',
          style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: isPublic ? _kGreen : _kPurple),
        ),
      ]),
    );
  }

  Widget _iconBtn(
      {required IconData icon,
      required Color bg,
      required Color fg,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38,
        height: 38,
        decoration:
            BoxDecoration(color: bg, borderRadius: BorderRadius.circular(10)),
        child: Icon(icon, color: fg, size: 18),
      ),
    );
  }

  void _showInfoSheet(LiveRecordItem item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => LiveInfoSheetInfo(
          item: item,
          controller: controller,
          pagingController: pagingController),
    );
  }
}

// ─── Bottom Sheet ──────────────────────────────────────────────────────────
class LiveInfoSheetInfo extends StatefulWidget {
  const LiveInfoSheetInfo(
      {super.key,
      required this.item,
      required this.controller,
      required this.pagingController});

  final LiveRecordItem item;
  final PodcastAudioController controller;
  final PagingController<int, LiveRecordItem> pagingController;

  @override
  State<LiveInfoSheetInfo> createState() => _LiveInfoSheetInfoState();
}

class _LiveInfoSheetInfoState extends State<LiveInfoSheetInfo> {
  late TextEditingController nameController;
  late TextEditingController descriptionController;
  final ValueNotifier<String> selectedImage = ValueNotifier("");

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.item.name);
    descriptionController =
        TextEditingController(text: widget.item.description);
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    selectedImage.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(
          20, 20, 20, MediaQuery.of(context).viewInsets.bottom + 24),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                    color: const Color(0xFFDDDDDD),
                    borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const Text('Recording Info',
                style: TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w800, color: _kText)),
            const SizedBox(height: 4),
            const Text('Add details to publish this recording',
                style: TextStyle(fontSize: 12, color: _kMuted)),
            const SizedBox(height: 20),

            // Cover image
            ValueListenableBuilder<String>(
              valueListenable: selectedImage,
              builder: (_, path, __) => GestureDetector(
                onTap: () async {
                  final f = await ImagePicker()
                      .pickImage(source: ImageSource.gallery);
                  if (f != null) selectedImage.value = f.path;
                },
                child: Container(
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: _kBg,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                        color: path.isNotEmpty ? _kPurple : _kBorder,
                        width: path.isNotEmpty ? 1.5 : 1),
                    image: path.isNotEmpty
                        ? DecorationImage(
                            image: FileImage(File(path)), fit: BoxFit.cover)
                        : null,
                  ),
                  child: path.isEmpty
                      ? const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                              Icon(Icons.add_photo_alternate_outlined,
                                  size: 32, color: _kMuted),
                              SizedBox(height: 8),
                              Text('Tap to upload cover',
                                  style:
                                      TextStyle(fontSize: 12, color: _kMuted)),
                            ])
                      : null,
                ),
              ),
            ),

            const SizedBox(height: 16),
            const Text('Title',
                style: TextStyle(
                    fontSize: 12, fontWeight: FontWeight.w700, color: _kText)),
            const SizedBox(height: 6),
            CustomTextField(
                controller: nameController, hintText: "Recording title"),

            const SizedBox(height: 14),
            const Text('Description',
                style: TextStyle(
                    fontSize: 12, fontWeight: FontWeight.w700, color: _kText)),
            const SizedBox(height: 6),
            CustomTextField(
                controller: descriptionController,
                maxLines: 3,
                hintText: "Short description..."),

            const SizedBox(height: 22),

            Obx(() {
              if (widget.controller.addInfoLoading.value) {
                return const Center(child: LoadingWidget());
              }
              return GestureDetector(
                onTap: () async {
                  try {
                    if (nameController.text.isNotEmpty &&
                        descriptionController.text.isNotEmpty &&
                        selectedImage.value.isNotEmpty &&
                        widget.item.id != null) {
                      await widget.controller.addRecordInfo(
                        id: widget.item.id ?? "",
                        body: {
                          "data": jsonEncode({
                            "name": nameController.text,
                            "description": descriptionController.text,
                          }),
                        },
                        file: selectedImage.value,
                        pagingController: widget.pagingController,
                      );
                      if (context.mounted && Navigator.canPop(context)) {
                        AppRouter.route.pop();
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text("All fields and image are  ")),
                      );
                    }
                  } catch (_) {}
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  decoration: BoxDecoration(
                      color: _kPurple, borderRadius: BorderRadius.circular(13)),
                  child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.check_rounded,
                            color: Colors.white, size: 18),
                        SizedBox(width: 8),
                        Text(
                          'Save Recording',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w700),
                        ),
                      ]),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
