# Mula di sini — Panduan GitHub untuk pemula

Repository ialah **folder projek di GitHub** yang menyimpan dokumen, kod, gambar dan sejarah perubahan. Fail `README.md` ialah halaman utama yang GitHub paparkan secara automatik.

## Apa yang sudah disusun?

- `README.md` — ringkasan profesional projek dalam English.
- `docs/` — bab laporan ditukar kepada Markdown supaya boleh dibaca terus di GitHub.
- `assets/` — rajah architecture berdasarkan laporan.
- Laporan Word asal disimpan offline dan belum dikongsi kerana repository sekarang **public**.
- `scripts/` — skrip diagnostik *read-only* contoh (disediakan baru, bukan bukti sudah diuji).
- `configs/examples/` — contoh fragmen konfigurasi, bukan konfigurasi sebenar daripada VM.

## Repository awak sudah dicipta

Project sekarang berada di **[saciey/SOC-Home-Lab-with-Ai](https://github.com/saciey/SOC-Home-Lab-with-Ai)**. GitHub menyimpan fail sebagai `commit` dan memperlihatkan `README.md` secara automatik.

Untuk tambah gambar atau screenshot sendiri: buka folder tujuan di GitHub → **Add file** → **Upload files** → pilih fail yang telah disunting → **Commit changes**. Jangan upload password, API keys, log mentah atau file VM.

Untuk buat perubahan tulisan: buka fail `.md`, tekan ikon pensel **Edit this file**, kemas kini teks dan pilih **Commit changes**.

## Terma GitHub yang perlu tahu

| Perkataan | Maksud mudah |
|---|---|
| Repository / repo | Folder projek di GitHub |
| README | Muka utama untuk menerangkan projek |
| Commit | Rekod perubahan dengan nama/masa dan mesej |
| Branch | Laluan kerja lain selain versi utama (`main`) |
| Push | Hantar perubahan dari laptop ke GitHub |
| Clone | Salin repository dari GitHub ke laptop |
| Private | Hanya pemilik/individu diberi akses boleh lihat |
| Public | Orang ramai boleh lihat repository |

## Apa langkah seterusnya untuk projek SOC?

1. Semak status sebenar `wazuh-manager`; sejarah 24 Oktober menunjukkan masalah yang **belum terbukti selesai**.
2. Masukkan screenshot sebenar yang telah disunting pada folder evidence dan kemas kini evidence register.
3. Jalankan semula ujian Windows → Wazuh → Indexer → Grafana.
4. Kemaskini checklist keputusannya; jangan tandakan ujian sebagai PASS tanpa bukti.
5. Rancang pembangunan AI selepas lapisan SOC stabil; bahagian AI masih **future work**.

> Perhatian: Jangan upload password, API token, SSH private key, sijil peribadi, log pengguna tanpa tapisan, atau konfigurasi yang mengandungi rahsia.

[← Kembali ke README](README.md)