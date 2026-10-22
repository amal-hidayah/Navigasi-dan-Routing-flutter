import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/tour_package.dart';
import '../theme.dart';

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

  /// Total harga dalam format rupiah.
  String get totalLabel => 'Rp ${_groupDigits(total.round())}';

  static const List<String> _bulan = [
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

  static String _formatDate(DateTime value) {
    return '${value.day} ${_bulan[value.month - 1]} ${value.year}';
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

/// Form pemesanan paket wisata.
///
/// Memakai `PopScope` supaya pengguna mengonfirmasi dulu sebelum meninggalkan
/// form, dan mengembalikan [BookingResult] ke pemanggil lewat `Navigator.pop`.
class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key, this.package});

  /// Paket yang dipesan. Null berarti pengguna masuk tanpa memilih paket.
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

  /// Diaktifkan sesaat sebelum halaman ditutup supaya `PopScope` melepas
  /// kendali atas proses pop.
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
          child: _package == null
              ? _buildEmptyState(context)
              : _buildForm(context),
        ),
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
    final textTheme = Theme.of(context).textTheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('PAKET YANG DIPESAN', style: textTheme.labelMedium),
            const SizedBox(height: 6),
            Text(_package!.title, style: textTheme.titleLarge),
            const SizedBox(height: 24),
            TextFormField(
              controller: _nameController,
              textCapitalization: TextCapitalization.words,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(labelText: 'Nama lengkap'),
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
              decoration: const InputDecoration(labelText: 'Jumlah peserta'),
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
                suffixIcon: Icon(Icons.calendar_today_outlined),
              ),
              validator: (value) => _departureDate == null
                  ? 'Pilih tanggal keberangkatan'
                  : null,
            ),
            const SizedBox(height: 26),
            _buildSummary(),
            const SizedBox(height: 26),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _submit,
                child: const Text('Konfirmasi pemesanan'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummary() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
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
              padding: EdgeInsets.symmetric(vertical: 14),
              child: Divider(),
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
