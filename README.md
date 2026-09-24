# Ditonton - Movie & TV Series App

[![CI](https://github.com/AanSumanto/ditonton/actions/workflows/ci.yml/badge.svg)](https://github.com/AanSumanto/ditonton/actions/workflows/ci.yml)

Aplikasi katalog Film dan TV Series yang dibangun menggunakan Flutter dengan arsitektur multi-module (modularization), state management BLoC, keamanan SSL Pinning, pemantauan Firebase Crashlytics & Analytics, serta Continuous Integration (CI). Proyek ini merupakan submission akhir kelas **Menjadi Flutter Developer Expert** di Dicoding Indonesia.

---

## Fitur Utama

- **Movies**: Now Playing, Popular, Top Rated, Detail Movie, Rekomendasi, Watchlist Movies.
- **TV Series**: On The Air / Now Playing, Popular, Top Rated, Detail TV Series, Daftar Musim & Episode (Seasons & Episodes), Rekomendasi, Watchlist TV Series.
- **Search**: Pencarian interaktif dengan debounce untuk Movies dan TV Series.
- **State Management**: Seluruh fitur menggunakan **BLoC (Business Logic Component)** dengan event-state architecture dan stream transformer debounce.
- **Keamanan Jaringan (SSL Pinning)**: Koneksi aman TMDB API (`api.themoviedb.org`) menggunakan Custom SecurityContext dan sertifikat SSL valid (`assets/certificates.pem`), dilengkapi unit test valid cert vs invalid/expired cert.
- **Monitoring & Analytics**: Integrasi **Firebase Crashlytics** untuk penanganan fatal exception dan **Firebase Analytics** untuk user engagement tracking.
- **Modular Multi-Package Architecture**: Proyek terbagi menjadi beberapa package independen untuk modularitas tinggi, decoupling, dan build scalability.

---

## Arsitektur Modular

```text
ditonton/
├── core/       # Komponen bersama (styles, utils, routes, exceptions, db helper, entities)
├── movie/      # Fitur Movie (presentation/bloc, pages, domain usecases, data sources, repos)
├── tv/         # Fitur TV Series + Seasons/Episodes (presentation/bloc, pages, domain, data)
├── search/     # Fitur Pencarian Movie & TV Series (BLoCs, search UI)
├── about/      # Halaman About
└── lib/        # Root container, main.dart, injection.dart, Firebase initialization
```

---

## Continuous Integration (CI)

Proyek ini telah dikonfigurasi dengan **GitHub Actions** (`.github/workflows/ci.yml`) yang berjalan otomatis setiap kali ada `push` atau `pull request` ke branch `main`/`master`.

CI menjalankan serangkaian tahapan otomatis:
1. `flutter analyze` pada root dan seluruh sub-package (`core`, `movie`, `tv`, `search`, `about`).
2. Menjalankan seluruh pengujian unit & widget test melalui `test.sh`.
3. Memastikan 100% test passing dan mengumpulkan laporan code coverage (`coverage/test.info`).

Status build dapat dilihat langsung pada badge di bagian atas berkas ini.

---

## Menjalankan Unit & Widget Test dengan Coverage

Proyek dilengkapi dengan skrip pengujian modular `test.sh` yang menjalankan seluruh test suite dan menggabungkan hasilnya ke dalam laporan coverage LCOV.

### Menjalankan di Linux / macOS
```bash
chmod +x test.sh
./test.sh
```

### Menjalankan di Windows
Gunakan Git Bash:
```bash
./test.sh
```

### Hasil Pengujian & Code Coverage
- **Total Pengujian**: 350+ tests (Unit Test, Widget Test, BLoC Test)
- **Status Pengujian**: 100% Passed
- **Code Coverage**: **> 95.0%** di seluruh sub-package
