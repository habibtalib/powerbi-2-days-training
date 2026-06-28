# Kursus Power BI 2 Hari — Dashboard Aduan Alam Sekitar NRES

Kursus latihan amali Microsoft Power BI untuk pemula, dengan nota dalam **Bahasa Melayu** dan istilah teknikal (DAX, Power Query, sukatan) dikekalkan dalam **Bahasa Inggeris**. Sepanjang 2 hari, peserta akan membina sebuah **Dashboard Aduan Alam Sekitar** untuk **Kementerian Sumber Asli dan Kelestarian Alam (NRES)** — meliputi aduan yang dikendalikan oleh pelbagai agensi di bawah NRES.

> Inspirasi domain: portal rasmi [nres.gov.my](https://www.nres.gov.my/ms-my/Pages/default.aspx) dan agensi di bawahnya — Jabatan Alam Sekitar (JAS), Jabatan Perhutanan (JPSM), PERHILITAN, Jabatan Mineral dan Geosains (JMG), dan Jabatan Pengairan dan Saliran (JPS).

## Projek: Dashboard Aduan Alam Sekitar NRES

Dashboard ini menjawab soalan seperti:

- **Berapa banyak** aduan diterima, dan berapa **% telah selesai**?
- Agensi mana menerima **beban kes** paling banyak?
- Kategori kes apa paling kerap (pencemaran, pembalakan haram, pemburuan, dll.)?
- **Trend bulanan** — adakah lonjakan pada musim tengkujuh / musim kering?
- **Jumlah kompaun (RM)** yang dikenakan mengikut agensi & negeri?
- Taburan kes mengikut **negeri & zon** pada peta Malaysia.

## Ringkasan Kursus

| Hari | Topik | Fokus | Hasil |
|------|-------|-------|-------|
| [**Hari 1**](./hari-1/) | Data, Power Query & Model | Power BI Desktop, Get Data, pembersihan Power Query, skema bintang, visual asas | Model data siap + laporan asas |
| [**Hari 2**](./hari-2/) | DAX, Kepintaran Masa & Dashboard | Sukatan & lajur terkira, jadual Kalendar, visual lanjutan, terbit ke Power BI Service | Dashboard interaktif penuh + diterbitkan |

## Keperluan Sistem

- Windows 10/11 (64-bit) — Power BI Desktop hanya untuk Windows
- Minimum 4GB RAM (8GB disyorkan)
- 1GB ruang cakera kosong
- Akaun kerja/sekolah (Microsoft 365) untuk menerbitkan ke Power BI Service *(pilihan, Hari 2)*

## Perisian yang Diperlukan

| Perisian | Tujuan | Pautan |
|----------|--------|--------|
| Power BI Desktop | Bina model, laporan & dashboard | [powerbi.microsoft.com/desktop](https://powerbi.microsoft.com/desktop/) |
| (Pilihan) Power BI Service | Terbit & kongsi dashboard dalam talian | [app.powerbi.com](https://app.powerbi.com/) |

> **Nota:** Pengguna macOS boleh jalankan Power BI Desktop melalui mesin maya Windows (Parallels/VMware) atau Windows 365.

## Konsep Utama yang Dipelajari

| Lapisan | Kemahiran |
|---------|-----------|
| Sambungan data | Get Data (Text/CSV), refresh |
| Transformasi | Power Query (M) — promote headers, ubah jenis, trim, custom column |
| Pemodelan | Skema bintang, hubungan satu-ke-banyak, jadual Kalendar |
| Pengiraan | DAX — sukatan, lajur terkira, `CALCULATE`, `DIVIDE`, time intelligence |
| Visualisasi | Card, bar/column, donut, line, map, matrix, slicer |
| Penerbitan | Power BI Service, dashboard, Q&A |

## Struktur Repositori

```
powerbi-2-days-training/
├── README.md                  # Fail ini
├── hari-1/                    # Hari 1 — Data, Power Query & Model
│   ├── README.md              # Nota lengkap Hari 1
│   ├── data/                  # Fail CSV punca data + kamus data
│   │   ├── aduan.csv          # Jadual fakta (≈480 kes)
│   │   ├── agensi.csv         # Dimensi agensi NRES
│   │   ├── negeri.csv         # Dimensi negeri + zon
│   │   ├── kategori.csv       # Dimensi kategori kes
│   │   └── README.md          # Kamus data
│   └── snippets/              # Lab: power-query.m, lab.md
├── hari-2/                    # Hari 2 — DAX, Kepintaran Masa & Dashboard
│   ├── README.md              # Nota lengkap Hari 2
│   ├── data/                  # Salinan data yang sama (standalone)
│   └── snippets/              # Lab: measures.dax, calculated-columns.dax, lab.md
└── slides/
    ├── README.md              # Panduan slaid
    ├── powerbi-training.html  # Deck reveal.js (buka dalam pelayar)
    └── vendor/reveal/         # reveal.js (vendored, berfungsi dari file://)
```

## Cara Menggunakan Repositori Ini

1. **Clone** repositori ini.
2. Pasang **Power BI Desktop**.
3. Salin folder `hari-1/data/` ke lokasi mudah di komputer anda.
4. Buka `hari-1/README.md` dan ikut nota langkah demi langkah untuk membina model & laporan.
5. Pada Hari 2, teruskan fail `.pbix` yang sama dan ikut `hari-2/README.md`.
6. Rujuk `snippets/` untuk kod Power Query (M) dan DAX yang boleh disalin, serta latihan `lab.md`.

## Model Data (Skema Bintang)

```
   agensi (1) ──< (banyak) aduan (banyak) >── (1) negeri
                            │   │
                  (1) kategori   tarikh_terima
                                       │
                                       v
                            Kalendar (dicipta dengan DAX pada Hari 2)
```

Lihat [`hari-1/data/README.md`](./hari-1/data/README.md) untuk kamus data penuh.

## Slaid Pembentangan

Deck slaid (reveal.js) untuk pengajar — buka terus dalam pelayar, tiada pelayan diperlukan:

```text
slides/powerbi-training.html
```

## Lab Setiap Hari

| Hari | Fail lab |
|------|----------|
| Hari 1 | `power-query.m`, `lab.md` |
| Hari 2 | `measures.dax`, `calculated-columns.dax`, `lab.md` |

## Komuniti & Sumber Tambahan

- [Dokumentasi Rasmi Power BI](https://learn.microsoft.com/power-bi/)
- [Rujukan Fungsi DAX](https://learn.microsoft.com/dax/)
- [Rujukan Bahasa Power Query M](https://learn.microsoft.com/powerquery-m/)
- [Portal Rasmi NRES](https://www.nres.gov.my/ms-my/Pages/default.aspx) — rujukan domain

## Penyumbang

Disediakan oleh **Habib** — [bespokesb.com](https://bespokesb.com)

## Lesen

Repositori ini dilesenkan di bawah [MIT License](LICENSE).
