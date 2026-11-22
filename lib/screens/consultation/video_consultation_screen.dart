import 'dart:async';
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/services/emergency_service.dart';
import '../../data/models/appointment_model.dart';

class VideoConsultationScreen extends StatefulWidget {
  final AppointmentModel appointment;
  final bool isDoctorView;

  const VideoConsultationScreen({
    super.key,
    required this.appointment,
    this.isDoctorView = false,
  });

  @override
  State<VideoConsultationScreen> createState() => _VideoConsultationScreenState();
}

class _VideoConsultationScreenState extends State<VideoConsultationScreen> {
  bool _isMicMuted = false;
  bool _isVideoOff = false;
  int _callDurationSeconds = 0;
  Timer? _callTimer;
  final TextEditingController _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _callTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) setState(() => _callDurationSeconds++);
    });
  }

  @override
  void dispose() {
    _callTimer?.cancel();
    _notesController.dispose();
    super.dispose();
  }

  String _formatCallDuration(int totalSeconds) {
    final minutes = (totalSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (totalSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final apt = widget.appointment;

    return Scaffold(
      backgroundColor: const Color(0xFF111827),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1F2937),
        iconTheme: const IconThemeData(color: Colors.white),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.isDoctorView ? 'Consulting: ${apt.patientName}' : 'Consultation: ${apt.doctorName}',
              style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700),
            ),
            Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Colors.greenAccent,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  'Connected • ${_formatCallDuration(_callDurationSeconds)}',
                  style: const TextStyle(color: Colors.white70, fontSize: 11),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.open_in_new_rounded, color: Colors.white70),
            tooltip: 'Launch Jitsi Meet Room Externally',
            onPressed: () => EmergencyService.launchJitsiRoom(apt.jitsiRoomId),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Video Preview Stage
            Expanded(
              flex: 5,
              child: Stack(
                children: [
                  // Primary Video Feed (Remote Participant)
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    color: const Color(0xFF1F2937),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 44,
                            backgroundColor: AppColors.primaryLight.withValues(alpha: 0.3),
                            child: Icon(
                              widget.isDoctorView ? Icons.person_rounded : Icons.medical_services_rounded,
                              size: 46,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            widget.isDoctorView ? apt.patientName : apt.doctorName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'HD WebRTC Encrypted Video Stream',
                            style: TextStyle(color: Colors.white60, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Picture-in-Picture Self Feed
                  Positioned(
                    right: 16,
                    bottom: 16,
                    child: Container(
                      width: 100,
                      height: 140,
                      decoration: BoxDecoration(
                        color: const Color(0xFF374151),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: Colors.white24, width: 1.5),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.3),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: Center(
                        child: _isVideoOff
                            ? const Icon(Icons.videocam_off_rounded, color: Colors.white60)
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.face_rounded, color: Colors.white, size: 30),
                                  const SizedBox(height: 4),
                                  Text(
                                    widget.isDoctorView ? 'You (Doc)' : 'You',
                                    style: const TextStyle(color: Colors.white70, fontSize: 10),
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ),

                  // Room ID Badge
                  Positioned(
                    left: 16,
                    top: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.lock_rounded, color: Colors.greenAccent, size: 12),
                          const SizedBox(width: 4),
                          Text(
                            apt.jitsiRoomId,
                            style: const TextStyle(color: Colors.white70, fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Consultation Details & Clinical Notes Pane
            Expanded(
              flex: 4,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.isDoctorView ? 'Patient Clinical Notes' : 'Consultation Guidance',
                            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.primaryUltraLight,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'Token: ${apt.tokenNumber}',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      if (widget.isDoctorView) ...[
                        Text(
                          'Chief Complaint: ${apt.symptoms.isNotEmpty ? apt.symptoms : "Routine chronic checkup."}',
                          style: const TextStyle(fontSize: 13, color: AppColors.textDark),
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          controller: _notesController,
                          maxLines: 3,
                          decoration: const InputDecoration(
                            hintText: 'Enter clinical observations, prescribed medicines, and follow-up...',
                            contentPadding: EdgeInsets.all(12),
                          ),
                        ),
                      ] else ...[
                        Text(
                          'Hospital: ${apt.hospitalName}',
                          style: const TextStyle(fontSize: 13, color: AppColors.textDark),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Instructions: Speak clearly into the microphone. Keep your recent prescription or lab reports ready to show the doctor on camera.',
                          style: TextStyle(fontSize: 12, color: AppColors.textMuted, height: 1.4),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),

            // Call Controls Toolbar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              color: const Color(0xFF1F2937),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Microphone Mute Toggle
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: _isMicMuted ? Colors.red : Colors.white24,
                    child: IconButton(
                      icon: Icon(
                        _isMicMuted ? Icons.mic_off_rounded : Icons.mic_rounded,
                        color: Colors.white,
                      ),
                      onPressed: () => setState(() => _isMicMuted = !_isMicMuted),
                    ),
                  ),

                  // End Call Button
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: AppColors.emergency,
                    child: IconButton(
                      icon: const Icon(Icons.call_end_rounded, color: Colors.white, size: 28),
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Video consultation ended.')),
                        );
                      },
                    ),
                  ),

                  // Camera Off Toggle
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: _isVideoOff ? Colors.red : Colors.white24,
                    child: IconButton(
                      icon: Icon(
                        _isVideoOff ? Icons.videocam_off_rounded : Icons.videocam_rounded,
                        color: Colors.white,
                      ),
                      onPressed: () => setState(() => _isVideoOff = !_isVideoOff),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
