import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/language_provider.dart';
import '../../providers/hospital_provider.dart';
import '../../providers/appointment_provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/medical_card.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/language_selector_widget.dart';
import '../../core/services/emergency_service.dart';
import '../../data/models/hospital_model.dart';
import '../../data/models/doctor_model.dart';

class HospitalFinderScreen extends StatefulWidget {
  final bool isEmbedded;

  const HospitalFinderScreen({super.key, this.isEmbedded = false});

  @override
  State<HospitalFinderScreen> createState() => _HospitalFinderScreenState();
}

class _HospitalFinderScreenState extends State<HospitalFinderScreen> {
  final TextEditingController _searchController = TextEditingController();

  void _showBookDoctorDialog(DoctorModel doctor) {
    DateTime selectedDate = DateTime.now().add(const Duration(days: 1));
    String selectedSlot = doctor.timeSlots.first;
    final symptomsController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            left: 20,
            right: 20,
            top: 20,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Book Appointment with ${doctor.name}',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                ),
                Text(
                  '${doctor.specialty} • ${doctor.hospitalName}',
                  style: const TextStyle(fontSize: 13, color: AppColors.textMuted),
                ),
                const SizedBox(height: 16),

                // Select Time Slot
                const Text('Available Time Slot', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: doctor.timeSlots.map((slot) {
                    final isSel = selectedSlot == slot;
                    return ChoiceChip(
                      label: Text(slot),
                      selected: isSel,
                      onSelected: (val) => setModalState(() => selectedSlot = slot),
                      selectedColor: AppColors.primaryUltraLight,
                      labelStyle: TextStyle(
                        color: isSel ? AppColors.primary : AppColors.textDark,
                        fontWeight: isSel ? FontWeight.w700 : FontWeight.normal,
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),

                // Symptoms / Reason
                const Text('Describe Health Issue / Symptoms', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                const SizedBox(height: 6),
                TextField(
                  controller: symptomsController,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    hintText: 'e.g. Mild fever, diabetes follow up, or knee pain',
                  ),
                ),
                const SizedBox(height: 20),

                // Confirm Booking Button
                CustomButton(
                  text: 'Confirm Booking (Token Generation)',
                  icon: Icons.check_circle_rounded,
                  onPressed: () async {
                    final auth = context.read<AuthProvider>();
                    final aptProvider = context.read<AppointmentProvider>();
                    final user = auth.currentUser;

                    final apt = await aptProvider.bookAppointment(
                      patientId: user?.id ?? 'user_patient_01',
                      patientName: user?.name ?? 'Gurpreet Singh',
                      patientPhone: user?.phone ?? '+91 98765 43210',
                      doctor: doctor,
                      date: selectedDate,
                      timeSlot: selectedSlot,
                      symptoms: symptomsController.text.trim(),
                    );

                    if (context.mounted) {
                      Navigator.pop(ctx);
                      _showConfirmationDialog(apt.tokenNumber, doctor.name, selectedSlot);
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showConfirmationDialog(String token, String docName, String slot) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.check_circle_rounded, color: AppColors.success, size: 28),
            SizedBox(width: 10),
            Text('Booking Confirmed!'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Appointment booked with $docName at $slot.'),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primaryUltraLight,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.primaryLight),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Your Token Number:', style: TextStyle(fontWeight: FontWeight.w600)),
                  Text(
                    token,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();
    final hospProvider = context.watch<HospitalProvider>();

    final hospitals = hospProvider.filteredHospitals;
    final doctors = hospProvider.doctors;

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: widget.isEmbedded
          ? null
          : AppBar(
              title: Text(
                lang.tr('hospitalFinderTitle'),
                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 17),
              ),
              actions: const [
                Padding(
                  padding: EdgeInsets.only(right: 12),
                  child: LanguageSelectorWidget(isCompact: true),
                ),
              ],
            ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            TextField(
              controller: _searchController,
              onChanged: (val) => hospProvider.setSearchQuery(val),
              decoration: InputDecoration(
                hintText: 'Search Punjab hospitals, PHCs, or specialties...',
                prefixIcon: const Icon(Icons.search_rounded, color: AppColors.textMuted),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded),
                        onPressed: () {
                          _searchController.clear();
                          hospProvider.setSearchQuery('');
                        },
                      )
                    : null,
              ),
            ),
            const SizedBox(height: 12),

            // Filter Chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterChip('all', 'All Punjab Centres', hospProvider),
                  _buildFilterChip('emergency', '24/7 Emergency', hospProvider),
                  _buildFilterChip('phc', 'Rural PHC / CHC', hospProvider),
                  _buildFilterChip('govt', 'Govt Hospitals', hospProvider),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Available Doctors in Punjab Strip
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Telemedicine Doctors in Punjab',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
                Text(
                  '${doctors.length} Doctors Available',
                  style: const TextStyle(fontSize: 12, color: AppColors.primary, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: 10),

            SizedBox(
              height: 180,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: doctors.length,
                itemBuilder: (context, idx) {
                  final doc = doctors[idx];
                  return Container(
                    width: 250,
                    margin: const EdgeInsets.only(right: 12),
                    child: MedicalCard(
                      margin: EdgeInsets.zero,
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.network(
                                  doc.avatarUrl,
                                  width: 44,
                                  height: 44,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => CircleAvatar(
                                    radius: 22,
                                    backgroundColor: AppColors.primaryUltraLight,
                                    child: Text(
                                      doc.name.split(' ').length > 1 ? doc.name.split(' ')[1][0] : 'D',
                                      style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      doc.name,
                                      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      doc.specialty,
                                      style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const Icon(Icons.star_rounded, size: 14, color: Colors.amber),
                              Text(' ${doc.rating} (${doc.reviewsCount})', style: const TextStyle(fontSize: 11)),
                              const Spacer(),
                              Text(
                                doc.fee == 0.0 ? 'Free (Govt)' : '₹${doc.fee.toInt()}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primary,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 6),
                                minimumSize: Size.zero,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                              onPressed: () => _showBookDoctorDialog(doc),
                              child: const Text('Book Appointment', style: TextStyle(fontSize: 12)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            // Hospitals List Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Hospitals & Health Centres (${hospitals.length})',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Hospitals List
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: hospitals.length,
              itemBuilder: (context, idx) {
                final hosp = hospitals[idx];
                return _buildHospitalCard(hosp, lang);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String key, String label, HospitalProvider provider) {
    final isSelected = provider.selectedCategory == key;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (val) => provider.setCategoryFilter(key),
        selectedColor: AppColors.primaryUltraLight,
        labelStyle: TextStyle(
          color: isSelected ? AppColors.primary : AppColors.textDark,
          fontWeight: isSelected ? FontWeight.w700 : FontWeight.normal,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildHospitalCard(HospitalModel hosp, LanguageProvider lang) {
    return MedicalCard(
      margin: const EdgeInsets.only(bottom: 14),
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Image.network(
              hosp.imageUrl,
              height: 125,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const SizedBox.shrink(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            hosp.name,
                            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${hosp.category} • ${hosp.district}, Punjab',
                            style: const TextStyle(fontSize: 12, color: AppColors.primary, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primaryUltraLight,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${hosp.distanceKm} km',
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
          const SizedBox(height: 8),

          Row(
            children: [
              const Icon(Icons.location_on_outlined, size: 14, color: AppColors.textMuted),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  hosp.address,
                  style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Badges: Emergency 24/7, Beds, Ayushman
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: [
              if (hosp.is24x7Emergency)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.emergencyLight,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.flash_on_rounded, color: AppColors.emergency, size: 12),
                      SizedBox(width: 2),
                      Text('24/7 Emergency', style: TextStyle(fontSize: 11, color: AppColors.emergency, fontWeight: FontWeight.w700)),
                    ],
                  ),
                ),
              if (hosp.isAyushmanEmpanelled)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.successLight,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text('Ayushman PM-JAY', style: TextStyle(fontSize: 11, color: AppColors.success, fontWeight: FontWeight.w700)),
                ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.lightBackground,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: AppColors.border),
                ),
                child: Text(
                  '${hosp.availableBeds} / ${hosp.totalBeds} Beds Avail.',
                  style: const TextStyle(fontSize: 11, color: AppColors.textDark, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Action Buttons: Call & Directions
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  icon: const Icon(Icons.call_rounded, size: 16),
                  label: Text(lang.tr('callHospital')),
                  onPressed: () => EmergencyService.dialEmergencyNumber(hosp.phone),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  icon: const Icon(Icons.directions_rounded, size: 16),
                  label: Text(lang.tr('directions')),
                  onPressed: () => EmergencyService.openMapDirections(
                    latitude: hosp.latitude,
                    longitude: hosp.longitude,
                    destinationName: hosp.name,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  ],
),
);
}
}
