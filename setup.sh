#!/bin/bash

echo "=========================================="
echo "  SISTEM MANAJEMEN PERUSAHAAN - SETUP"
echo "=========================================="
echo ""

# Check prerequisites
echo "[1/6] Memeriksa prerequisites..."

check_command() {
    if ! command -v $1 &> /dev/null; then
        echo "  ❌ $1 tidak ditemukan. Install dulu: $2"
        missing=true
    else
        echo "  ✅ $1 tersedia"
    fi
}

missing=false
check_command "flutter" "https://flutter.dev/docs/get-started/install"
check_command "dart" "(bundled with Flutter)"
check_command "node" "https://nodejs.org (v20+)"
check_command "npm" "(bundled with Node.js)"
check_command "firebase" "npm install -g firebase-tools"
check_command "git" "https://git-scm.com"

if [ "$missing" = true ]; then
    echo ""
    echo "⚠️  Install prerequisite di atas dulu, lalu jalankan ulang script ini."
    exit 1
fi

echo ""

# Create platform files
echo "[2/6] Membuat platform files..."
cd frontend
flutter create --platforms android,ios,web . 2>/dev/null || echo "  ⚠️  Platform files sudah ada, dilewati"
cd ..
echo "  ✅ Platform files siap"

echo ""

# Install Flutter dependencies
echo "[3/6] Install Flutter dependencies..."
cd frontend
flutter pub get
cd ..
echo "  ✅ Flutter dependencies installed"

echo ""

# Install Functions dependencies
echo "[4/6] Install Firebase Functions dependencies..."
cd functions
npm install
cd ..
echo "  ✅ Functions dependencies installed"

echo ""

# Setup Firebase
echo "[5/6] Setup Firebase..."
echo ""
echo "  🔑 Sebelum lanjut, pastikan kamu sudah:"
echo "     1. Buka https://console.firebase.google.com"
echo "     2. Buat project baru (atau pake yang existing)"
echo "     3. Aktifkan:"
echo "        - Authentication (Email/Password)"
echo "        - Cloud Firestore"
echo "        - Storage"
echo "        - Cloud Functions (upgrade ke Blaze - masih gratis)"
echo "        - Cloud Messaging"
echo "        - Hosting"
echo "     4. Download:"
echo "        - google-services.json → taruh di frontend/android/app/"
echo "        - GoogleService-Info.plist → taruh di frontend/ios/Runner/"
echo "     5. Copy Firebase Web config → paste ke frontend/lib/firebase_options.dart"
echo ""

read -p "  Udah selesai? (y/n): " firebase_done

if [ "$firebase_done" = "y" ]; then
    echo ""
    echo "  🔗 Login Firebase..."
    firebase login --no-localhost
    echo ""
    read -p "  Masukkan Firebase Project ID: " project_id
    if [ -n "$project_id" ]; then
        firebase use --add "$project_id"
        echo ""
        echo "  📦 Deploy Firestore rules & indexes..."
        firebase deploy --only firestore:rules,firestore:indexes
        echo "  📦 Deploy Storage rules..."
        firebase deploy --only storage:rules
        echo ""
        echo "  🔨 Build & deploy Functions..."
        cd functions
        npm run build
        cd ..
        firebase deploy --only functions
    fi
    echo "  ✅ Firebase setup selesai"
else
    echo "  ⏸️  Firebase setup dilewati. Jalankan manual nanti."
fi

echo ""

# Build
echo "[6/6] Build Flutter Web..."
cd frontend
flutter build web --release --base-href /
cd ..
echo "  ✅ Build selesai"

echo ""
echo "=========================================="
echo "  ✅ SETUP SELESAI!"
echo "=========================================="
echo ""
echo "  Jalankan:"
echo "    cd frontend"
echo "    flutter run -d chrome   # Web"
echo "    flutter run -d android  # Android"
echo "    flutter run -d ios      # iOS"
echo ""
echo "  Deploy ke Firebase:"
echo "    firebase deploy"
echo ""
echo "  Atau deploy ulang setelah perubahan:"
echo "    cd frontend && flutter build web --release && cd .. && firebase deploy"
echo ""
