import 'package:get/get.dart';

/// GetX i18n translations.
///
/// Keys use `snake_case` and are accessed with the `.tr` extension in widgets.
/// Default locale is English; Indonesian is the secondary locale.
class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': _en,
        'id_ID': _id,
      };

  // ──────────────────────────────────────────────────────────────────────────
  // ENGLISH
  // ──────────────────────────────────────────────────────────────────────────
  static const Map<String, String> _en = {
    // ── App
    'app_name': 'SkyCrew',
    'app_tagline': 'Professional Flight Crew Management',

    // ── Auth
    'welcome_back': 'Welcome back',
    'sign_in_subtitle': 'Sign in to your account',
    'email': 'Email',
    'email_hint': 'you@airline.com',
    'password': 'Password',
    'sign_in': 'Sign In',
    'no_account': "Don't have an account?",
    'register': 'Register',
    'create_account': 'Create your account',
    'full_name': 'Full Name',
    'full_name_hint': 'John Doe',
    'confirm_password': 'Confirm Password',
    'role': 'Role',
    'employee_id': 'Employee ID',
    'airline': 'Airline',
    'base_airport': 'Base Airport',
    'optional_details': 'Optional Details',
    'already_have_account': 'Already have an account?',
    'sign_in_instead': 'Sign In',

    // ── Navigation
    'nav_home': 'Home',
    'nav_logbook': 'Logbook',
    'nav_licenses': 'Licenses',
    'nav_wellness': 'Wellness',
    'nav_profile': 'Profile',

    // ── Home / Dashboard
    'good_morning': 'Good morning',
    'good_afternoon': 'Good afternoon',
    'good_evening': 'Good evening',
    'crew_member': 'Crew Member',
    'quick_actions': 'Quick Actions',
    'recent_flights': 'Recent Flights',
    'view_all': 'View all',
    'no_recent_flights': 'No recent flights',
    'upcoming_expirations': 'Upcoming Expirations',
    'no_expirations': 'No expiring licenses',
    'wellness_summary': 'Wellness Summary',
    'flight_stats': 'Flight Statistics',
    'total_hours': 'Total Hours',
    'this_month': 'This Month',
    'this_year': 'This Year',

    // ── Logbook
    'logbook_title': 'Logbook',
    'logbook_empty': 'No flight records yet',
    'logbook_empty_hint': 'Tap + to log your first flight',
    'logbook_summary': 'Logbook Summary',
    'total_flights': 'Total Flights',
    'total_block': 'Total Block',
    'landings': 'Landings',
    'add_flight': 'Log Flight',
    'edit_flight': 'Edit Flight',
    'flight_number': 'Flight Number',
    'flight_number_hint': 'e.g. GA123',
    'departure': 'Departure',
    'departure_hint': 'e.g. CGK',
    'arrival': 'Arrival',
    'arrival_hint': 'e.g. DPS',
    'aircraft_type': 'Aircraft Type',
    'aircraft_registration': 'Registration',
    'block_time': 'Block Time',
    'duty_time': 'Duty Time',
    'night_time': 'Night Time',
    'role_label': 'Role',
    'landings_label': 'Landings',
    'off_duty': 'Off Duty Day',
    'remarks': 'Remarks',
    'remarks_hint': 'Optional notes',
    'date': 'Date',
    'export': 'Export',
    'export_csv': 'Export CSV',
    'export_pdf': 'Export PDF',
    'monthly_compliant': 'Monthly limit OK',
    'monthly_exceeded': 'Monthly limit exceeded',
    'yearly_compliant': 'Yearly limit OK',
    'yearly_exceeded': 'Yearly limit exceeded',

    // ── Licenses
    'licenses_title': 'Licenses & Currency',
    'licenses_empty': 'No licenses added',
    'licenses_empty_hint': 'Tap + to add your first license',
    'add_license': 'Add License',
    'edit_license': 'Edit License',
    'license_type': 'License Type',
    'license_number': 'License Number',
    'issuing_authority': 'Issuing Authority',
    'issue_date': 'Issue Date',
    'expiry_date': 'Expiry Date',
    'valid': 'Valid',
    'expired': 'Expired',
    'expiring_soon': 'Expiring Soon',
    'expires_in': 'Expires in @days days',

    // ── Wellness / Fatigue
    'wellness_title': 'Wellness & Fatigue',
    'log_wellness': 'Log Wellness',
    'fatigue_level': 'Fatigue Level',
    'fatigue_scale': '1 = Fully Rested  |  10 = Extremely Fatigued',
    'sleep_hours': 'Sleep Hours',
    'wellness_score': 'Wellness Score',
    'stress_level': 'Stress Level',
    'timezone': 'Timezone',
    'notes': 'Notes',
    'notes_hint': 'Optional notes',
    'avg_fatigue': 'Avg Fatigue',
    'avg_sleep': 'Avg Sleep',
    'high_fatigue': 'High Fatigue',
    'fatigue_trend': 'Fatigue Trend (Last 14 days)',
    'wellness_history': 'Wellness History',
    'no_wellness_entries': 'No wellness entries yet',
    'no_wellness_hint': 'Tap + to log today\'s wellness',

    // ── Profile
    'profile_title': 'Profile',
    'account_details': 'Account Details',
    'app_settings': 'App Settings',
    'theme': 'Theme',
    'language': 'Language',
    'notifications': 'Notifications',
    'about': 'About SkyCrew',
    'sign_out': 'Sign Out',
    'sign_out_confirm': 'Are you sure you want to sign out?',

    // ── Theme picker
    'theme_system': 'System default',
    'theme_light': 'Light',
    'theme_dark': 'Dark',

    // ── Language picker
    'lang_english': 'English',
    'lang_indonesian': 'Bahasa Indonesia',

    // ── Common actions
    'save': 'Save',
    'cancel': 'Cancel',
    'delete': 'Delete',
    'edit': 'Edit',
    'add': 'Add',
    'confirm': 'Confirm',
    'ok': 'OK',
    'yes': 'Yes',
    'no': 'No',
    'close': 'Close',
    'loading': 'Loading…',
    'error': 'Error',
    'success': 'Saved',

    // ── Confirmations
    'delete_confirm_title': 'Delete',
    'delete_confirm_message': 'This action cannot be undone.',

    // ── Errors
    'error_required': '@field is required.',
    'error_invalid_email': 'Enter a valid email address.',
    'error_short_password': 'Password must be at least 6 characters.',
    'error_passwords_mismatch': 'Passwords do not match.',
    'error_unexpected': 'An unexpected error occurred. Please try again.',
  };

  // ──────────────────────────────────────────────────────────────────────────
  // INDONESIAN
  // ──────────────────────────────────────────────────────────────────────────
  static const Map<String, String> _id = {
    // ── App
    'app_name': 'SkyCrew',
    'app_tagline': 'Manajemen Awak Penerbangan Profesional',

    // ── Auth
    'welcome_back': 'Selamat datang kembali',
    'sign_in_subtitle': 'Masuk ke akun Anda',
    'email': 'Email',
    'email_hint': 'anda@maskapai.com',
    'password': 'Kata Sandi',
    'sign_in': 'Masuk',
    'no_account': 'Belum punya akun?',
    'register': 'Daftar',
    'create_account': 'Buat akun Anda',
    'full_name': 'Nama Lengkap',
    'full_name_hint': 'Budi Santoso',
    'confirm_password': 'Konfirmasi Kata Sandi',
    'role': 'Peran',
    'employee_id': 'ID Karyawan',
    'airline': 'Maskapai',
    'base_airport': 'Bandara Asal',
    'optional_details': 'Detail Opsional',
    'already_have_account': 'Sudah punya akun?',
    'sign_in_instead': 'Masuk',

    // ── Navigation
    'nav_home': 'Beranda',
    'nav_logbook': 'Buku Log',
    'nav_licenses': 'Lisensi',
    'nav_wellness': 'Kesehatan',
    'nav_profile': 'Profil',

    // ── Home / Dashboard
    'good_morning': 'Selamat pagi',
    'good_afternoon': 'Selamat siang',
    'good_evening': 'Selamat malam',
    'crew_member': 'Awak Kabin',
    'quick_actions': 'Aksi Cepat',
    'recent_flights': 'Penerbangan Terakhir',
    'view_all': 'Lihat semua',
    'no_recent_flights': 'Belum ada penerbangan',
    'upcoming_expirations': 'Lisensi Akan Kedaluwarsa',
    'no_expirations': 'Tidak ada lisensi yang akan kedaluwarsa',
    'wellness_summary': 'Ringkasan Kesehatan',
    'flight_stats': 'Statistik Penerbangan',
    'total_hours': 'Total Jam',
    'this_month': 'Bulan Ini',
    'this_year': 'Tahun Ini',

    // ── Logbook
    'logbook_title': 'Buku Log',
    'logbook_empty': 'Belum ada catatan penerbangan',
    'logbook_empty_hint': 'Ketuk + untuk mencatat penerbangan pertama',
    'logbook_summary': 'Ringkasan Buku Log',
    'total_flights': 'Total Penerbangan',
    'total_block': 'Total Blok',
    'landings': 'Pendaratan',
    'add_flight': 'Catat Penerbangan',
    'edit_flight': 'Edit Penerbangan',
    'flight_number': 'Nomor Penerbangan',
    'flight_number_hint': 'mis. GA123',
    'departure': 'Keberangkatan',
    'departure_hint': 'mis. CGK',
    'arrival': 'Kedatangan',
    'arrival_hint': 'mis. DPS',
    'aircraft_type': 'Tipe Pesawat',
    'aircraft_registration': 'Registrasi',
    'block_time': 'Waktu Blok',
    'duty_time': 'Waktu Dinas',
    'night_time': 'Waktu Malam',
    'role_label': 'Peran',
    'landings_label': 'Pendaratan',
    'off_duty': 'Hari Libur Dinas',
    'remarks': 'Catatan',
    'remarks_hint': 'Catatan opsional',
    'date': 'Tanggal',
    'export': 'Ekspor',
    'export_csv': 'Ekspor CSV',
    'export_pdf': 'Ekspor PDF',
    'monthly_compliant': 'Batas bulanan OK',
    'monthly_exceeded': 'Batas bulanan terlampaui',
    'yearly_compliant': 'Batas tahunan OK',
    'yearly_exceeded': 'Batas tahunan terlampaui',

    // ── Licenses
    'licenses_title': 'Lisensi & Valuta',
    'licenses_empty': 'Belum ada lisensi',
    'licenses_empty_hint': 'Ketuk + untuk menambah lisensi pertama',
    'add_license': 'Tambah Lisensi',
    'edit_license': 'Edit Lisensi',
    'license_type': 'Jenis Lisensi',
    'license_number': 'Nomor Lisensi',
    'issuing_authority': 'Otoritas Penerbit',
    'issue_date': 'Tanggal Terbit',
    'expiry_date': 'Tanggal Kedaluwarsa',
    'valid': 'Berlaku',
    'expired': 'Kedaluwarsa',
    'expiring_soon': 'Segera Kedaluwarsa',
    'expires_in': 'Kedaluwarsa dalam @days hari',

    // ── Wellness / Fatigue
    'wellness_title': 'Kesehatan & Kelelahan',
    'log_wellness': 'Catat Kesehatan',
    'fatigue_level': 'Tingkat Kelelahan',
    'fatigue_scale': '1 = Sangat Segar  |  10 = Sangat Lelah',
    'sleep_hours': 'Jam Tidur',
    'wellness_score': 'Skor Kesehatan',
    'stress_level': 'Tingkat Stres',
    'timezone': 'Zona Waktu',
    'notes': 'Catatan',
    'notes_hint': 'Catatan opsional',
    'avg_fatigue': 'Rata-rata Kelelahan',
    'avg_sleep': 'Rata-rata Tidur',
    'high_fatigue': 'Kelelahan Tinggi',
    'fatigue_trend': 'Tren Kelelahan (14 hari terakhir)',
    'wellness_history': 'Riwayat Kesehatan',
    'no_wellness_entries': 'Belum ada catatan kesehatan',
    'no_wellness_hint': 'Ketuk + untuk mencatat hari ini',

    // ── Profile
    'profile_title': 'Profil',
    'account_details': 'Detail Akun',
    'app_settings': 'Pengaturan Aplikasi',
    'theme': 'Tema',
    'language': 'Bahasa',
    'notifications': 'Notifikasi',
    'about': 'Tentang SkyCrew',
    'sign_out': 'Keluar',
    'sign_out_confirm': 'Apakah Anda yakin ingin keluar?',

    // ── Theme picker
    'theme_system': 'Ikuti sistem',
    'theme_light': 'Terang',
    'theme_dark': 'Gelap',

    // ── Language picker
    'lang_english': 'English',
    'lang_indonesian': 'Bahasa Indonesia',

    // ── Common actions
    'save': 'Simpan',
    'cancel': 'Batal',
    'delete': 'Hapus',
    'edit': 'Edit',
    'add': 'Tambah',
    'confirm': 'Konfirmasi',
    'ok': 'OK',
    'yes': 'Ya',
    'no': 'Tidak',
    'close': 'Tutup',
    'loading': 'Memuat…',
    'error': 'Kesalahan',
    'success': 'Tersimpan',

    // ── Confirmations
    'delete_confirm_title': 'Hapus',
    'delete_confirm_message': 'Tindakan ini tidak dapat dibatalkan.',

    // ── Errors
    'error_required': '@field wajib diisi.',
    'error_invalid_email': 'Masukkan alamat email yang valid.',
    'error_short_password': 'Kata sandi minimal 6 karakter.',
    'error_passwords_mismatch': 'Kata sandi tidak cocok.',
    'error_unexpected': 'Terjadi kesalahan tak terduga. Silakan coba lagi.',
  };
}
