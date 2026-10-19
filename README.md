# 📱 Story App - Dicoding Submission Project

[![Flutter Version](https://shields.io)](https://flutter.dev)
[![Dart Version](https://shields.io)](https://dart.dev)
[![Architecture](https://shields.io)](#-arsitektur-proyek)
[![License](https://shields.io)](LICENSE)

**Story App** adalah aplikasi berbagi momen dan cerita menarik selama belajar di Dicoding. Aplikasi ini dibangun menggunakan **Flutter** dengan menerapkan prinsip **Clean Architecture (Layered Architecture)**, manajemen state menggunakan **Provider**, navigasi deklaratif tingkat lanjut memakai **GoRouter**, serta dukungan multi-bahasa (**Localization**). Aplikasi ini terintegrasi penuh dengan Dicoding Story API resmi.

---

## 🚀 Fitur Utama Application

### 🔐 1. Halaman Autentikasi (Authentication)

- **Register & Login:** Pendaftaran akun baru dan masuk menggunakan enkripsi token JWT resmi dari Dicoding Story API.
- **Keamanan Input:** Penyembunyian karakter password menggunakan fitur toggle visibilitas (`obscureText`).
- **Session Management:** Menyimpan session token secara aman di penyimpanan lokal menggunakan `shared_preferences`.
- **Auth Guard Router:** Pengalihan otomatis halaman (_auto-redirect_). Jika token terdeteksi, pengguna langsung diarahkan ke Halaman Utama. Jika tidak, pengguna diarahkan ke halaman Login.
- **Secure Logout:** Fitur keluar akun yang menghapus seluruh data sesi dan token, kemudian meredireksi pengguna ke halaman Login tanpa menyisakan _back-stack_ navigasi.

### 📜 2. Halaman Cerita (Story Flow)

- **Daftar Cerita (Story List):** Menampilkan momen-momen yang diunggah pengguna lain lengkap dengan nama dan foto dari API menggunakan komponen `CachedNetworkImage` yang efisien.
- **Detail Cerita (Detail Story):** Menampilkan informasi menyeluruh (Nama, Foto resolusi penuh, waktu pembuatan, dan deskripsi lengkap) saat salah satu item cerita ditekan.
- **Pull-to-Refresh:** Memperbarui daftar cerita secara interaktif.

### 📸 3. Tambah Cerita (Add New Story)

- **Pick Image:** Mengambil foto baru langsung dari Kamera atau memilih gambar dari Galeri menggunakan library `image_picker`.
- **Kompresi Otomatis:** Membatasi ukuran file maksimal **1MB** dengan penyesuaian resolusi lebar (`1280px`) dan kualitas kompresi (`70%`) untuk menghemat bandwidth.
- **Multipart Upload:** Mengunggah cerita baru ke endpoint API menggunakan format request `multipart/form-data`.
- **Auto-Refresh on Success:** Setelah berhasil mengunggah, halaman otomatis menutup diri (`context.pop`), kembali ke halaman utama, dan melakukan penyegaran data agar cerita terbaru langsung muncul di paling atas.

### 🌐 4. Aksesibilitas & UI Terstandar

- **Localization (Multi-Bahasa):** Mendukung penuh alih bahasa antara **Bahasa Indonesia (ID)** dan **Bahasa Inggris (EN)** menggunakan `flutter_localizations` dan file `.arb`.
- **Responsive Layout:** Menerapkan struktur UI anti-overlapping menggunakan `SingleChildScrollView` dan `ConstrainedBox` agar komponen tetap rapi saat keyboard perangkat terbuka.
- **State UI Handling:** Penanganan status aplikasi yang adaptif dengan indikator loading, penanganan _error state_ (tombol coba lagi), dan _empty state_ saat tidak ada data tersedia.

---

## 🏗️ Arsitektur Proyek

Proyek ini dirancang menggunakan arsitektur berlapis (**Clean/Layered Architecture**) untuk memisahkan tanggung jawab kode (_Separation of Concerns_), mempermudah pengujian, serta menjaga skalabilitas aplikasi.

```text
lib/
├── main.dart                  # Dependency Injection manual & Inisialisasi awal app
├── app.dart                   # Konfigurasi MaterialApp.router, Tema, & Localization
├── core/                      # Komponen utilitas global & infrastruktur dasar
│   ├── constants/             # Menyimpan teks konstan seperti API Endpoint URL
│   ├── error/                 # Penanganan exception & pemetaan pesan error custom
│   ├── network/               # HTTP client core (`ApiClient`) untuk JSON & Multipart
│   ├── router/                # Konfigurasi GoRouter deklaratif beserta alur redirect (Auth Guard)
│   └── utils/                 # Validasi input text form & enum ViewState UI
├── domain/                    # Layer Inti Bisnis (Tidak bergantung pada framework/library luar)
│   ├── entities/              # Objek data mentah aplikasi (Story, UserSession)
│   └── repositories/          # Kontrak/Abstraksi interface untuk Data Source
├── data/                      # Layer Implementasi Data & Integrasi Eksternal
│   ├── models/                # Model data hasil serialisasi JSON dari/ke API
│   ├── datasources/           # Sumber data utama (Remote API & Local SharedPreferences)
│   └── repositories/          # Implementasi konkret dari kontrak layer Domain
└── presentation/              # Layer Antarmuka Pengguna (UI & State Management)
    ├── providers/             # Pengelola state aplikasi menggunakan Provider (Business Logic)
    ├── pages/                 # Halaman layar utama aplikasi (Login, Register, List, Detail, Add)
    └── widgets/               # Komponen UI modular yang dapat digunakan kembali (Reusable Card/Button)
```

---

## 🛠️ Langkah Pemasangan Lokalan (Installation)

Ikuti instruksi berikut untuk menjalankan proyek ini di mesin lokal Anda:

### 1. Prasyarat

- Pastikan **Flutter SDK** versi minimum `3.13.5` atau yang terbaru telah terinstal di komputer Anda.
- Gunakan IDE seperti **Visual Studio Code** atau **Android Studio**.

### 2. Kloning Repositori

```bash
git clone https://github.com/putraharifin/story-app.git 
cd story_app
```

### 3. Konfigurasi Dependensi & Generator Bahasa

Buka terminal proyek Anda, lalu jalankan perintah berikut untuk mengunduh semua library pendukung dan men-generate otomatis kode translasi bahasa lokal:

```bash
flutter pub get
flutter gen-l10n
```

### 4. Menjalankan Analisis Kode

Pastikan kode bersih dari sisa peringatan gaya penulisan (_linter warning_) Dart terbaru dengan menjalankan perintah:

```bash
flutter analyze
```

### 5. Jalankan Aplikasi

Hubungkan perangkat HP fisik Anda atau aktifkan simulator/emulator, kemudian ketik perintah di bawah ini:

```bash
flutter run
```

---

## 📡 Spesifikasi Integrasi API

Aplikasi ini sepenuhnya berkomunikasi dengan **Dicoding Story API** pada endpoint root `https://dicoding.dev` dengan cakupan endpoint operasional sebagai berikut:

| Fungsi                     | Method | Endpoint       | Kebutuhan Header / Auth                               |
| :------------------------- | :----- | :------------- | :---------------------------------------------------- |
| **Daftar Akun**            | `POST` | `/register`    | _None_ (Public)                                       |
| **Masuk Akun**             | `POST` | `/login`       | _None_ (Public)                                       |
| **Ambil Semua Cerita**     | `GET`  | `/stories`     | `Authorization: Bearer <token>`                       |
| **Detail Cerita Spesifik** | `GET`  | `/stories/:id` | `Authorization: Bearer <token>`                       |
| **Unggah Cerita Baru**     | `POST` | `/stories`     | `Content-Type: multipart/form-data`, `Bearer <token>` |

---

## 🔒 Konfigurasi Izin Akses Perangkat (Permissions)

Untuk memastikan fitur penarikan data internet dan pengunggahan gambar dari hardware berjalan dengan baik di perangkat target, konfigurasi berikut telah diterapkan:

### 🤖 Android (`android/app/src/main/AndroidManifest.xml`)

Hak akses koneksi jaringan internet global ditambahkan sebelum tag `<application>`:

```xml
<uses-permission android:name="android.permission.INTERNET"/>
```

### 🍏 iOS (`ios/Runner/Info.plist`)

Deskripsi permohonan izin interaksi perangkat ditambahkan di dalam tag blok `<dict>` utama:

```xml
<key>NSCameraUsageDescription</key>
<string>Aplikasi ini memerlukan akses kamera untuk mengambil foto cerita Anda.</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>Aplikasi ini memerlukan akses galeri untuk memilih foto cerita Anda.</string>
```

---

## ⚙️ Dependencies Terpakai

Daftar _packages_ utama yang tercatat di dalam file `pubspec.yaml` untuk menyokong aplikasi ini:

- **`provider`**: Manajemen state terpusat yang memisahkan antara UI dengan logika bisnis.
- **`go_router`**: Solusi navigasi deklaratif (Router API) yang menangani pembatasan rute (_auth routing guard_).
- **`shared_preferences`**: Menyimpan persistent local data untuk token autentikasi pengguna.
- **`http`**: Klien HTTP untuk interaksi REST API yang andal.
- **`image_picker`**: Antarmuka bawaan perangkat untuk mengakses Kamera dan Galeri foto.
- **`cached_network_image`**: Memuat gambar web secara asinkron disertai manajemen caching memori lokal yang rapi.
- **`flutter_localizations` & `intl`**: Mesin penerjemah teks komponen bawaan dari Flutter SDK.

---

_Proyek ini diajukan sebagai pemenuhan syarat kelulusan Tugas Akhir Kelas Flutter Developer di Dicoding Indonesia._
