// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get appTitle => 'Story App';

  @override
  String get loginTitle => 'Selamat datang kembali';

  @override
  String get loginSubtitle =>
      'Masuk untuk membagikan momen belajarmu di Dicoding';

  @override
  String get registerTitle => 'Buat akun';

  @override
  String get registerSubtitle => 'Daftar untuk mulai membagikan ceritamu';

  @override
  String get name => 'Nama';

  @override
  String get email => 'Email';

  @override
  String get password => 'Kata sandi';

  @override
  String get signIn => 'Masuk';

  @override
  String get register => 'Daftar';

  @override
  String get noAccountYet => 'Belum punya akun? Daftar';

  @override
  String get haveAccount => 'Sudah punya akun? Masuk';

  @override
  String get registerSuccess => 'Pendaftaran berhasil. Silakan masuk.';

  @override
  String get nameRequired => 'Nama wajib diisi';

  @override
  String get emailRequired => 'Email wajib diisi';

  @override
  String get emailInvalid => 'Masukkan alamat email yang valid';

  @override
  String get passwordRequired => 'Kata sandi wajib diisi';

  @override
  String get passwordMinLength => 'Kata sandi minimal 8 karakter';

  @override
  String get showPassword => 'Tampilkan kata sandi';

  @override
  String get hidePassword => 'Sembunyikan kata sandi';

  @override
  String get storiesTitle => 'Cerita';

  @override
  String get storyDetailTitle => 'Detail Cerita';

  @override
  String get addStoryTitle => 'Cerita Baru';

  @override
  String get camera => 'Kamera';

  @override
  String get gallery => 'Galeri';

  @override
  String get description => 'Deskripsi';

  @override
  String get descriptionRequired => 'Deskripsi wajib diisi';

  @override
  String get upload => 'Unggah';

  @override
  String get imageRequired => 'Pilih foto terlebih dahulu';

  @override
  String get imageTooLarge => 'Ukuran foto maksimal 1 MB';

  @override
  String get imagePickFailed => 'Tidak dapat membuka kamera atau galeri';

  @override
  String get uploadSuccess => 'Cerita berhasil diunggah';

  @override
  String get logout => 'Keluar';

  @override
  String get language => 'Bahasa';

  @override
  String get retry => 'Coba lagi';

  @override
  String get refresh => 'Muat ulang';

  @override
  String get emptyStories => 'Belum ada cerita. Jadilah yang pertama berbagi!';

  @override
  String get errorGeneric =>
      'Terjadi kesalahan. Periksa koneksi internet dan coba lagi.';

  @override
  String get storyLocation => 'Lokasi cerita';

  @override
  String get locationSectionTitle => 'Lokasi';

  @override
  String get addLocation => 'Tambah lokasi';

  @override
  String get changeLocation => 'Ketuk untuk mengubah';

  @override
  String get removeLocation => 'Hapus lokasi';

  @override
  String get locationLockedTitle =>
      'Menambahkan lokasi adalah fitur versi Paid';

  @override
  String get locationLockedSubtitle =>
      'Gunakan versi Paid untuk menyertakan lokasi pada ceritamu';

  @override
  String get pickLocationTitle => 'Pilih lokasi';

  @override
  String get pickLocationHint => 'Ketuk peta untuk menaruh marker';

  @override
  String get useThisLocation => 'Gunakan lokasi ini';

  @override
  String get myLocation => 'Lokasi saya';

  @override
  String get locationUnavailable =>
      'Tidak dapat mengambil lokasi. Periksa izin dan GPS.';

  @override
  String get addressLoading => 'Mencari alamat...';

  @override
  String get addressUnavailable => 'Alamat tidak tersedia';

  @override
  String get selectedLocation => 'Lokasi terpilih';

  @override
  String get loadMoreFailed => 'Gagal memuat cerita berikutnya';
}
