import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/tour_package.dart';
import '../theme.dart';
import '../widgets/destination_photo.dart';

/// Hasil pemesanan yang dikirim balik ke halaman detail.
///
/// Dikembalikan lewat `Navigator.pop` ketika pemesanan berhasil.
class BookingResult {
  const BookingResult({
    required this.name,
    required this.participants,
    required this.date,
    required this.total,
  });

  final String name;
  final int participants;
  final DateTime date;
  final double total;

  /// Tanggal keberangkatan dalam format Indonesia, contoh: `12 Mei 2026`.
  String get dateLabel => _formatDate(date);

  /// Total biaya dalam format rupiah, contoh: `Rp 2.500.000`.
  String get totalLabel => 'Rp ${_groupDigits(total.round())}';

  static String _formatDate(DateTime d) {
    const months = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];
    return '${d.day} ${months[d.month - 1]} ${d.year}';
  }

  static String _groupDigits(int value) {
    final digits = value.toString();
    final buffer = StringBuffer();
    for (var i = 0; i < digits.length; i++) {
      if (i > 0 && (digits.length - i) % 3 == 0) {
        buffer.write('.');
      }
      buffer.write(digits[i]);
    }
    return buffer.toString();
  }
}

/// Form pemesanan dengan validasi, pemilih tanggal, dan konfirmasi saat keluar.
///
/// Memanfaatkan [PopScope] agar pengguna tidak sengaja kehilangan data saat
/// menekan tombol back di perangkat Android atau gesture back.
class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key, this.package});

  /// Paket yang sedang dipesan. Bisa null jika route dibuka langsung tanpa
  /// arguments, dalam hal ini layar menampilkan pesan kosong.
  final TourPackage? package;

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _participantsController = TextEditingController();
  final _dateController = TextEditingController();

  DateTime? _departureDate;

  /// Penanda apakah `Navigator.pop` sedang diizinkan lewat.
  ///
  /// Saat `false`, tombol back di perangkat Android atau AppBar akan dicegat
  /// oleh [PopScope] lalu menampilkan dialog konfirmasi.
  bool _allowPop = false;

  @override
  void initState() {
    super.initState();
    _participantsController.addListener(_onParticipantsChanged);
  }

  @override
  void dispose() {
    _participantsController.removeListener(_onParticipantsChanged);
    _nameController.dispose();
    _participantsController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  void _onParticipantsChanged() {
    setState(() {});
  }

  TourPackage? get _package => widget.package;

  int get _participants => int.tryParse(_participantsController.text.trim()) ?? 0;

  double get _total => (_package?.price ?? 0) * _participants;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _allowPop,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          return;
        }
        _confirmLeave();
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Pemesanan')),
        body: SafeArea(
          bottom: false,
          child: _package == null
              ? _buildEmptyState(context)
              : _buildForm(context),
        ),
        bottomNavigationBar:
            _package == null ? null : _buildBottomBar(context),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 40, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.map_outlined,
            size: 32,
            color: NusaTheme.inkMuted,
          ),
          const SizedBox(height: 16),
          Text('Belum ada paket dipilih', style: textTheme.headlineSmall),
          const SizedBox(height: 10),
          Text(
            'Form pemesanan butuh paket wisata yang sudah dipilih. Kembali ke '
            'daftar paket lalu pilih salah satu untuk melanjutkan.',
            style: textTheme.bodyMedium,
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: _pop,
              child: const Text('Kembali ke daftar paket'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPackageHeader(context),
            const SizedBox(height: 22),
            TextFormField(
              controller: _nameController,
              textCapitalization: TextCapitalization.words,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'Nama lengkap',
                prefixIcon: Icon(Icons.person_outline),
              ),
              validator: (value) {
                final name = value?.trim() ?? '';
                if (name.isEmpty) {
                  return 'Isi nama lengkap pemesan';
                }
                if (name.length < 3) {
                  return 'Nama minimal 3 huruf';
                }
                return null;
              },
            ),
            const SizedBox(height: 18),
            TextFormField(
              controller: _participantsController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(
                labelText: 'Jumlah peserta',
                prefixIcon: Icon(Icons.group_outlined),
                suffixText: 'orang',
              ),
              validator: (value) {
                final count = int.tryParse(value?.trim() ?? '');
                if (count == null) {
                  return 'Isi jumlah peserta';
                }
                if (count < 1) {
                  return 'Minimal 1 peserta';
                }
                return null;
              },
            ),
            const SizedBox(height: 18),
            TextFormField(
              controller: _dateController,
              readOnly: true,
              onTap: _pickDate,
              decoration: const InputDecoration(
                labelText: 'Tanggal keberangkatan',
                prefixIcon: Icon(Icons.calendar_today_outlined),
              ),
              validator: (value) => _departureDate == null
                  ? 'Pilih tanggal keberangkatan'
                  : null,
            ),
            const SizedBox(height: 24),
            _buildSummary(),
          ],
        ),
      ),
    );
  }

  Widget _buildPackageHeader(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final package = _package!;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(NusaTheme.radiusKartu),
        border: Border.all(color: NusaTheme.garis),
      ),
      child: Row(
        children: [
          DestinationPhoto(
            imageUrl: package.imageUrl,
            label: package.title,
            width: 74,
            height: 74,
            borderRadius: BorderRadius.circular(NusaTheme.radiusKecil),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'PAKET YANG DIPESAN',
                  style: textTheme.labelSmall?.copyWith(
                    color: NusaTheme.sunsetTua,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  package.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${package.priceLabel} / peserta',
                  style: textTheme.bodySmall?.copyWith(
                    color: NusaTheme.inkMuted,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummary() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(NusaTheme.radiusKartu),
        border: Border.all(color: NusaTheme.garis),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.receipt_long_outlined,
                size: 20,
                color: NusaTheme.lautDalam,
              ),
              const SizedBox(width: 8),
              Text(
                'Rincian Pemesanan',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: NusaTheme.lautDalam,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          _SummaryRow(
            label: 'Harga per peserta',
            value: _package!.priceLabel,
          ),
          const SizedBox(height: 10),
          _SummaryRow(
            label: 'Jumlah peserta',
            value: '$_participants',
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(color: NusaTheme.garis),
          ),
          _SummaryRow(
            label: 'Total',
            value: BookingResult(
              name: '',
              participants: _participants,
              date: _departureDate ?? DateTime.now(),
              total: _total,
            ).totalLabel,
            emphasize: true,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: NusaTheme.pasirHangat,
        border: Border(top: BorderSide(color: NusaTheme.garis)),
        boxShadow: [
          BoxShadow(
            color: Color(0x0A000000),
            offset: Offset(0, -2),
            blurRadius: 6,
          ),
        ],
      ),
      child: SafeArea(
        minimum: const EdgeInsets.fromLTRB(20, 12, 20, 14),
        child: SizedBox(
          width: double.infinity,
          height: NusaTheme.tinggiTombol,
          child: FilledButton.icon(
            onPressed: _submit,
            icon: const Icon(Icons.check_circle_outline, size: 20),
            label: const Text('Konfirmasi pemesanan'),
          ),
        ),
      ),
    );
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _departureDate ?? now.add(const Duration(days: 7)),
      firstDate: now,
      lastDate: DateTime(now.year + 1, 12, 31),
      helpText: 'Pilih tanggal keberangkatan',
    );

    if (picked == null || !mounted) {
      return;
    }

    setState(() {
      _departureDate = picked;
      _dateController.text = BookingResult(
        name: '',
        participants: _participants,
        date: picked,
        total: _total,
      ).dateLabel;
    });
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    _pop(
      BookingResult(
        name: _nameController.text.trim(),
        participants: _participants,
        date: _departureDate!,
        total: _total,
      ),
    );
  }

  /// Mengonfirmasi meninggalkan form sebelum data dibuang.
  Future<void> _confirmLeave() async {
    final leave = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Keluar dari form pemesanan?'),
        content: const Text(
          'Data yang sudah kamu isi tidak akan tersimpan.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Lanjut mengisi'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Keluar'),
          ),
        ],
      ),
    );

    if (leave == true && mounted) {
      _pop();
    }
  }

  /// Menutup halaman dan mengembalikan [result] ke pemanggil.
  void _pop([BookingResult? result]) {
    setState(() => _allowPop = true);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        Navigator.of(context).pop(result);
      }
    });
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
    this.emphasize = false,
  });

  final String label;
  final String value;
  final bool emphasize;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        Text(label, style: textTheme.bodyMedium),
        const Spacer(),
        Text(
          value,
          style: emphasize
              ? textTheme.titleMedium?.copyWith(color: NusaTheme.sunsetTua)
              : textTheme.titleMedium,
        ),
      ],
    );
  }
}
