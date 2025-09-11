import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart';
import 'package:podcast/core/route/routes.dart';
import 'package:podcast/helper/dialog/custom_dialog.dart';
import 'package:podcast/presentation/screens/creator/podcast/controller/podcast_audio_controller.dart';
import 'package:podcast/presentation/screens/profile/controller/profile_controller.dart';
import 'package:podcast/presentation/screens/streaming/streaming_screen.dart';
import 'package:podcast/presentation/widget/loading/loading_widget.dart';
import 'package:podcast/presentation/widget/text_field/custom_text_field.dart';
import 'package:podcast/utils/app_colors/app_colors.dart';
import 'package:url_launcher/url_launcher.dart';

import '../model/live_records_model.dart';

class LiveStreamingScreen extends StatefulWidget {
  const LiveStreamingScreen({super.key});

  @override
  State<LiveStreamingScreen> createState() => _LiveStreamingScreenState();
}

class _LiveStreamingScreenState extends State<LiveStreamingScreen> {
  final controller = Get.find<PodcastAudioController>();
  final _profileController = Get.find<ProfileController>();

  final pagingController = PagingController<int, LiveRecordItem>(firstPageKey: 1);
  final TextEditingController roomCodeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller.getLive();
    pagingController.addPageRequestListener((pageKey) {
      controller.getAllRecords(
        pageKey: pageKey,
        pagingController: pagingController,
      );
    });
  }

  @override
  void dispose() {
    roomCodeController.dispose();
    pagingController.dispose();
    super.dispose();
  }

  void _copyToClipboard(String text, String type) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$type copied to clipboard!'),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  void _joinAsAdmin() {
    final roomCodes = controller.liveData.value.data?.roomCodes;
    final adminCode = roomCodes?.firstWhere(
          (code) => code.role == 'admin',
      orElse: () => roomCodes.first,
    );

    if (adminCode?.code != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              StreamingScreen(
                authToken: "",
                roomCode: adminCode!.code!,
                userName: _profileController.profile.value.data?.name ?? "Admin",
                userID: _profileController.profile.value.data?.id ?? "4354534534534534535353",
              ),
        ),
      );
    }
  }

  void _joinAsHost() {
    if (roomCodeController.text
        .trim()
        .isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a room code'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            StreamingScreen(
              authToken: "",
              roomCode: roomCodeController.text.trim(),
              userName: _profileController.profile.value.data?.name ?? "Host",
              userID: _profileController.profile.value.data?.id ?? "43545454654444465476",
            ),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color color;
    IconData icon;

    switch (status.toLowerCase()) {
      case 'active':
      case 'live':
        color = Colors.green;
        icon = Icons.radio_button_checked;
        break;
      case 'ended':
        color = Colors.red;
        icon = Icons.stop_circle;
        break;
      case 'scheduled':
        color = Colors.orange;
        icon = Icons.schedule;
        break;
      default:
        color = Colors.grey;
        icon = Icons.help_outline;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 4),
          Text(
            status.toUpperCase(),
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecordChip(bool? status) {
    Color color;
    IconData icon;

    switch (status) {
      case true:
        color = Colors.green;
        icon = Icons.public;
        break;
      case false:
        color = Colors.red;
        icon = Icons.lock;
        break;
      default:
        color = Colors.grey;
        icon = Icons.help_outline;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 4),
          Text(
            (status ?? false) ? "Public" : "Private",
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoomCard() {
    final liveData = controller.liveData.value.data;
    final hostCode = liveData?.roomCodes?.firstWhere(
          (code) => code.role == 'host',
      orElse: () => liveData.roomCodes!.first,
    );

    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.blue.shade50,
            Colors.purple.shade50,
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.broadcast_on_personal,
                    color: Colors.blue.shade700,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Live Stream',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Make a room. Go live anytime.',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                _buildStatusChip(liveData?.status ?? 'Unknown'),
              ],
            ),
            const SizedBox(height: 20),

            // Room Details
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.7),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.meeting_room, color: Colors.grey.shade600, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Room ID: ${liveData?.roomId ?? 'N/A'}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade700,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (hostCode?.code != null) ...[
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.key, color: Colors.grey.shade600, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Host Code: ${hostCode!.code}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade700,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () => _copyToClipboard(hostCode.code!, 'Host code'),
                          icon: Icon(Icons.copy, color: Colors.blue.shade600, size: 20),
                          tooltip: 'Copy host code',
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _joinAsAdmin,
                    icon: const Icon(Icons.admin_panel_settings, size: 20),
                    label: const Text('Create Stream'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade600,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 2,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      if (liveData?.roomId != null &&
                          liveData!.roomId!.isNotEmpty &&
                          !controller.endLiveLoading.value) {
                        controller.endLive(id: liveData.roomId!);
                      }
                    },
                    icon: const Icon(Icons.stop, size: 20),
                    label: const Text('End Stream'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade600,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 2,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCreateRoomCard() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.blue.shade100,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.add_circle_outline,
              size: 48,
              color: Colors.blue.shade600,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'No Active Room',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Create a new live streaming room to get started',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => controller.createLive(),
              icon: const Icon(Icons.video_call, size: 20),
              label: const Text('Create Live Room'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade600,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 2,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJoinAsHostSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.person_add, color: Colors.orange.shade600),
              const SizedBox(width: 8),
              Text(
                'Join as Host',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Enter the room code to join as a host',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: roomCodeController,
            decoration: InputDecoration(
              hintText: 'Enter room code (e.g., abc-def-ghi)',
              prefixIcon: Icon(Icons.meeting_room, color: Colors.grey.shade400),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.orange.shade400, width: 2),
              ),
              filled: true,
              fillColor: Colors.grey.shade50,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _joinAsHost,
              icon: const Icon(Icons.login, size: 20),
              label: const Text('Join Room'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange.shade600,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 2,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecordingCard({
    required LiveRecordItem item,
    required VoidCallback onDelete,
    required VoidCallback onToggle,
    required VoidCallback onInfo,
  }) {
    return Container(
      margin: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.blue.shade50,
            Colors.purple.shade50,
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// Room + Status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Row(
                    children: [
                      Icon(Icons.meeting_room, color: Colors.grey.shade600, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Room ID: ${item.roomId ?? 'N/A'}',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade700,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                _buildStatusChip(item.status?.toUpperCase() ?? 'UNKNOWN'),
              ],
            ),
            const SizedBox(height: 12),

            /// Record Link
            GestureDetector(
              onTap: () => openBrowser(url: item.recordingPresignedUrl ?? ""),
              child: Row(
                children: [
                  Icon(Icons.link, color: Colors.grey.shade600, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      item.recordingPresignedUrl ?? "No Recording Link",
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.blue.shade700,
                        fontWeight: FontWeight.w500,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () =>
                        _copyToClipboard(item.recordingPresignedUrl ?? "", 'Record Link'),
                    icon: Icon(Icons.copy, color: Colors.blue.shade600, size: 20),
                    tooltip: 'Copy Record Link',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),

            /// Date
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.date_range, color: Colors.grey.shade600, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      DateFormat("MMMM dd, yyyy").format(item.sessionStartedAt ?? DateTime.now()),
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                _buildRecordChip(item.isPublic ?? false),
              ],
            ),
            const SizedBox(height: 20),

            Row(
              spacing: 4,
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      final canToggle = (item.name?.isNotEmpty ?? false) &&
                          (item.description?.isNotEmpty ?? false) &&
                          (item.coverImage?.isNotEmpty ?? false);

                      if (canToggle) {
                        onToggle();
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
                                  foregroundColor: Colors.white,
                                ),
                                child: const Text("Back"),
                              ),
                            ),
                            const Gap(30),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  onInfo();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  foregroundColor: Colors.white,
                                ),
                                child: const Text("Add Info"),
                              ),
                            ),
                          ],
                        );
                      }
                    },
                    icon: Icon(
                      item.isPublic == true ? Icons.public : Icons.lock,
                      size: 20,
                    ),
                    label: Text(item.isPublic == true ? 'Public' : 'Private'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: item.isPublic == true ? Colors.green : Colors.black,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: Colors.grey.shade400,
                      disabledForegroundColor: Colors.white,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: onDelete,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade600,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 2,
                  ),
                  child: const Icon(Icons.delete_outline, size: 20),
                ),
                ElevatedButton(
                  onPressed: onInfo,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade600,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 2,
                  ),
                  child: const Icon(Icons.info_outline, size: 20),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> openBrowser({required String url}) async {
    final Uri recordUri = Uri.parse(url);

    try {
      if (await canLaunchUrl(recordUri)) {
        await launchUrl(recordUri, mode: LaunchMode.externalApplication);
      } else {
        if (await canLaunchUrl(recordUri)) {
          await launchUrl(recordUri, mode: LaunchMode.platformDefault);
        }
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text(
          'Live Streaming',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          controller.getLive();
          pagingController.refresh();
        },
        child: CustomScrollView(
          slivers: [
            Obx(() {
              if (controller.createLiveLoading.value || controller.getLiveLoading.value) {
                return const SliverFillRemaining(child: LoadingWidget(color: AppColors.blackColor));
              }

              return SliverToBoxAdapter(
                child: Column(
                  children: [
                    const SizedBox(height: 8),
                    if (controller.liveData.value.data != null)
                      _buildRoomCard()
                    else
                      _buildCreateRoomCard(),
                    const SizedBox(height: 16),
                    _buildJoinAsHostSection(),
                  ],
                ),
              );
            }),
            PagedSliverList<int, LiveRecordItem>(
              pagingController: pagingController,
              builderDelegate:
              PagedChildBuilderDelegate<LiveRecordItem>(itemBuilder: (context, item, index) {
                return _buildRecordingCard(
                  item: item,
                  onDelete: () {
                    controller.endRecord(id: item.id ?? "", pagingController: pagingController);
                  },
                  onToggle: () {
                    controller.toggleRecord(id: item.id ?? "", pagingController: pagingController);
                  },
                  onInfo: () => showLiveInfoBottomSheet(context, item),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  void showLiveInfoBottomSheet(BuildContext context, LiveRecordItem item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return LiveInfoSheetInfo(
          item: item,
          controller: controller,
          pagingController: pagingController,
        );
      },
    );
  }
}

class LiveInfoSheetInfo extends StatefulWidget {
  const LiveInfoSheetInfo({
    super.key,
    required this.item,
    required this.controller,
    required this.pagingController,
  });

  final LiveRecordItem item;
  final PodcastAudioController controller;
  final PagingController<int, LiveRecordItem> pagingController;

  @override
  State<LiveInfoSheetInfo> createState() => _LiveInfoSheetInfoState();
}

class _LiveInfoSheetInfoState extends State<LiveInfoSheetInfo> {
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  final ValueNotifier<String> selectedImage = ValueNotifier<String>("");

  @override
  void initState() {
    nameController = TextEditingController(text: widget.item.name);
    descriptionController = TextEditingController(text: widget.item.description);

    super.initState();
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
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery
            .of(context)
            .viewInsets
            .bottom + 20,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag handle
            Container(
              width: 40,
              height: 5,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.grey.shade400,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            Text(
              "Live Information",
              style: Theme
                  .of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Image Picker
            ValueListenableBuilder<String>(
              valueListenable: selectedImage,
              builder: (context, path, _) {
                return GestureDetector(
                  onTap: () async {
                    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
                    if (pickedFile != null) {
                      selectedImage.value = pickedFile.path;
                    }
                  },
                  child: Container(
                    height: 150,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade400),
                      image: path.isNotEmpty
                          ? DecorationImage(image: FileImage(File(path)), fit: BoxFit.cover)
                          : null,
                    ),
                    child: path.isEmpty
                        ? const Center(
                        child: Icon(Icons.add_a_photo, size: 40, color: Colors.black))
                        : null,
                  ),
                );
              },
            ),
            const SizedBox(height: 16),

            // Name
            CustomTextField(
              controller: nameController,
              hintText: "Title",
            ),
            const SizedBox(height: 12),

            // Description
            CustomTextField(
              controller: descriptionController,
              maxLines: 3,
              hintText: "Description",
            ),
            const SizedBox(height: 20),

            // Save button
            SizedBox(
              width: double.infinity,
              child: Obx(() {
                if(widget.controller.addInfoLoading.value){
                  return const LoadingWidget();
                }
                return ElevatedButton.icon(
                  onPressed: () async {
                    try{
                      if (nameController.text.isNotEmpty &&
                          descriptionController.text.isNotEmpty &&
                          selectedImage.value.isNotEmpty &&
                          widget.item.id != null) {
                        final payload = {
                          "data": jsonEncode({
                            "name": nameController.text,
                            "description": descriptionController.text,
                          }),
                        };

                        await widget.controller.addRecordInfo(
                          id: widget.item.id ?? "",
                          body: payload,
                          file: selectedImage.value,
                          pagingController: widget.pagingController,
                        );
                        if(context.mounted &&Navigator.canPop(context)){
                          AppRouter.route.pop();
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("All fields and image are required")),
                        );
                      }
                    }catch(_){

                    }
                  },
                  icon: const Icon(Icons.save),
                  label: const Text("Save"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
