# SISTEM MANAJEMEN PERUSAHAAN (SMP)

**Aplikasi HRIS + Payroll + Approval + Aset + Performance — All-in-One**

Dibangun dengan **Flutter** (Frontend) + **Firebase** (Backend/Infra), support **Android, iOS, dan Web (PWA)**.

---

## 📱 Platform

| Platform | Install |
|---|---|
| Android | PWA (via browser) atau APK (Play Store) |
| iOS | PWA (via Safari) atau IPA (App Store) |
| Web | PWA — install ke home screen |

---

## 🚀 Fitur Lengkap

| Modul | Fitur |
|---|---|
| **Perusahaan** | Profil, struktur organisasi, jabatan, level/grade |
| **Rekrutmen** | Lowongan, kandidat, interview, offering |
| **Karyawan** | Data pribadi, dokumen, keluarga, kontrak, mutasi, resign, sanksi |
| **Absensi** | Check-in GPS+foto, izin, dinas, WFH, rekap |
| **Cuti** | Tahunan, sakit, melahirkan, besar, sisa kuota |
| **Lembur** | Pengajuan, hitung otomatis |
| **Payroll** | Gaji, PPh 21, BPJS, THR, pinjaman, slip PDF |
| **Approval** | Multi-level workflow, notifikasi WA/Email/Push |
| **Aset** | Daftar aset, peminjaman, maintenance |
| **Performance** | KPI/OKR, penilaian periodik, 360 feedback |
| **Helpdesk** | Tiket IT/HR/GA, SLA, FAQ |
| **Dokumen** | Upload, kategori, search, expired reminder |
| **Laporan** | Dashboard direksi, export Excel/PDF |
| **Notifikasi** | In-app, push, WhatsApp, email |

---

## 🧱 Tech Stack

| Lapisan | Teknologi |
|---|---|
| **Frontend** | Flutter 3.22+ (Dart) |
| **Backend** | Firebase (Auth, Firestore, Functions, Storage, FCM, Hosting) |
| **Database** | Cloud Firestore (NoSQL) |
| **Storage** | Firebase Storage |
| **Auth** | Firebase Auth (Email/Password + Custom Claims) |
| **Notification** | Firebase Cloud Messaging |
| **CI/CD** | GitHub Actions |
| **Hosting** | Firebase Hosting + GitHub Pages |

---

## 🔧 Setup Firebase (WAJIB)

1. **Buat project** di [console.firebase.google.com](https://console.firebase.google.com)
2. **Aktifkan layanan:**
   - Authentication (Email/Password)
   - Cloud Firestore
   - Storage
   - Cloud Functions (upgrade ke Blaze plan — free tier cukup)
   - Cloud Messaging
   - Hosting
3. **Download file config:**
   - Android: `google-services.json` → `frontend/android/app/`
   - iOS: `GoogleService-Info.plist` → `frontend/ios/`
   - Web: Firebase config → copy ke `frontend/lib/firebase_options.dart`
4. **Generate token deploy:**
   ```bash
   firebase login:ci
   # Copy token → set sebagai GitHub secret: FIREBASE_TOKEN
   ```
5. **Ganti `.firebaserc`** → isi dengan project ID Firebase kamu:
   ```json
   { "projects": { "default": "nama-project-kamu" } }
   ```
6. **Firestore Indexes:** deploy index:
   ```bash
   firebase deploy --only firestore:indexes
   ```

---

## 🖥️ Install & Run Lokal

### Prerequisites

- Flutter SDK 3.22.x
- Node.js 20+
- Firebase CLI

### Frontend

```bash
cd frontend
flutter pub get
flutter run -d chrome   # Web
flutter run -d android  # Android
flutter run -d ios      # iOS
```

### Build Web Production

```bash
flutter build web --release --base-href /
```

### Backend Functions

```bash
cd functions
npm install
npm run serve  # Local emulator
```

### Deploy

```bash
# Build & deploy ke Firebase
flutter build web --release --base-href /
firebase deploy
```

---

## 📁 Struktur Project

```
sistem-manajemen-perusahaan/
├── frontend/                  # Flutter App
│   ├── lib/
│   │   ├── main.dart          # Entry point
│   │   ├── app.dart           # Router
│   │   ├── core/              # Theme, constants, utils
│   │   ├── data/              # Models, repositories, datasources
│   │   ├── domain/            # Entities, usecases
│   │   └── presentation/      # Pages, widgets, providers
│   ├── android/
│   ├── ios/
│   └── web/
├── functions/                 # Firebase Cloud Functions
│   └── src/
│       └── index.ts           # All functions
├── database/                  # Firestore rules & indexes
│   ├── firestore.rules
│   ├── firestore.indexes.json
│   └── storage.rules
├── firebase.json
├── .firebaserc
└── .github/workflows/
    └── deploy.yml             # CI/CD
```

---

## 👥 Role & Akses

| Role | Akses |
|---|---|
| **Super Admin** | Full — semua modul + pengaturan sistem |
| **Direktur** | Dashboard, laporan, approval level akhir |
| **Manager** | Karyawan (bawahan), approval level menengah |
| **HR** | Karyawan, payroll, absensi, kontrak, rekrutmen |
| **Finance** | Payroll, BPJS, pinjaman, laporan keuangan |
| **Staff** | Profile, absen, cuti, izin, slip gaji |

---

## 📊 API Endpoints (via Firebase)

Semua akses data via **Firebase SDK langsung dari Flutter** — tidak perlu REST API terpisah.

Untuk backend logic berat (payroll, approval, notifikasi) menggunakan **Firebase Cloud Functions**.

---

## 🔐 Keamanan

- ✅ Firebase Auth (Email/Password)
- ✅ Firestore Security Rules (RBAC)
- ✅ Validasi input di client + server
- ✅ Audit log untuk setiap perubahan
- ✅ Enkripsi data at rest (Firebase)
- ✅ Rate limiting
- ✅ CORS protection

---

## 📞 Kontak

Dibuat oleh [KoRifCan](https://github.com/KoRifCan)

---

## 📄 Lisensi

MIT License — bebas digunakan dan dikembangkan.
