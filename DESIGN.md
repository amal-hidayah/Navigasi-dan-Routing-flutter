# NusaTravel - Design Direction

Arah visual ini diturunkan dari brief produk: katalog paket wisata Nusantara untuk pengguna
domestik yang memesan lewat HP. Fokusnya fotourat destination, bukan dashboard.

## Identity

NusaTravel menjual pengalaman, bukan fitur. Keputusan desainnya:

- **Foto destination adalah protagonistsnya.** Setiap kartu paket dan header detail
  memberi area foto paling besar di layar. Teks hanya supporting.
- **Nada bicara:** lokal, lugas, tanpa jargon backpacker dan tanpa bahasa hard-selling.
  Bahasa Indonesia baku, kalimat pendek.
- **Motif:** garis horizon. Garis tipis dan laut sebagai aksen, muncul di satu tempat
  saja: strip koordinat di bawah judul pada halaman detail.

## Palette

| Peran | Nilai | Alasan |
|---|---|---|
| Core 1 - Laut Dalam | `#0F4C5C` | Warna brand. Terang di atas foto, gelap di atas pasir, selalu kontras minimal 4.5:1. |
| Core 2 - Pasir Hangat | `#F4EFE7` | Base netral seluruh app. Hangat, berbeda dari putih murni yang terasa generik. |
| Accent - Sunset | `#E2703A` | **Satu-satunya** warna aksen. Dipakai pada CTA utama dan harga saja. Tidak pernah di badge, ikon, atau garis. |
| Ink | `#16232B` | Teks utama. |
| Ink Muted | `#5A6B72` | Teks sekunder, kontras 5.6:1 di atas Pasir Hangat. |

Maksimal 2 core plus 1 accent. Tanpa gradient ungu-biru, tanpa glow, tanpa glassmorphism.

## Typography

| Peran | Typeface | Alasan |
|---|---|---|
| Display | Playfair Display (serif, 600/700) | Judul paket dan splash dibaca seperti judul majalah perjalanan. Serif editorial memberi karakter yang tidak dimiliki sans generik. |
| Body dan label | Source Sans 3 (400/600) | Humanist sans, tinggi x-height, nyaman untuk label form dan teks panjang di layar HP kecil. |

Alasan memilih dua keluarga: serif untuk "destination", sans untuk "transaksi". Pengguna
membrowse dengan mata, memesan dengan jari.

## Dials

**ENERGY 2 / RHYTHM 2 / MOTION 1**

- ENERGY 2: warna brand tegas di header, foto besar, sisanya tenang. Tidak gila.
- RHYTHM 2: Home memakai satu pola (kartu foto selebar layar). Detail memakai komposisi
  berbeda (hero foto, strip koordinat, blok form). Tidak ada pola kartu seragam yang
  diulang-ulang.
- MOTION 1: transisi singkat 150 sampai 250ms untuk navigasi dan perubahan state.
  Tidak ada loop, tidak ada pulse, tidak ada floating.

## Komponen

- **Radius:** 4 untuk input kecil, 8 untuk kartu, 16 untuk panel besar. Pill hanya untuk
  chip status nyata, tidak untuk tombol.
- **Shadow:** hanya pada satu elemen yang benar-benar mengambang di atas foto, yaitu tombol
  booking di halaman detail. Kartu lainnya rata dengan background, tanpa bayangan.
- **Tombol:** tinggi minimum 52px di atas target sentuh 44px, teks utama, tanpa ikon
  dekoratif, tanpa panah.
- **Icon:** hanya yang relevan isi, misalnya tag harga untuk nominal, kalender untuk tanggal,
  kompas untuk rute. Tidak ada sparkle, star, atau bolt sebagai ikon fitur.

## Data

Seluruh isi katalog adalah **data contoh** untuk demonstrasi navigation, bukan data
komersial riil. Nama peserta, tanggal, dan jumlah peserta di form dibiarkan kosong sampai
pengguna mengisinya. Tidak ada testimoni, rating, atau statistik turis yang dikarang.

## Anti-pattern yang dilarang di proyek ini

- Tombol berlabel generik seperti "Get Started", "Explore", atau "Discover"
- Badge capsule dekoratif di atas judul
- Emoji sebagai ornamen
- Stripe warna di tepi kiri kartu
- Angka turis, jumlah pengikut, atau testimoni rekaan
