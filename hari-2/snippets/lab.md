# Lab Hari 2 — DAX, Kepintaran Masa & Dashboard

Lab ini menguji kemahiran DAX (sukatan & lajur terkira), kepintaran masa, visual lanjutan, dan menerbitkan ke Power BI Service.

## Fail dalam folder ini

| Fail | Kegunaan |
|------|----------|
| `measures.dax` | Sukatan DAX siap pakai (termasuk bahagian "Sukatan Tambahan") |
| `calculated-columns.dax` | Lajur terkira (termasuk `Urutan Status`) + jadual Kalendar |
| `../data/sasaran.csv` | Sasaran % Selesai setiap agensi — untuk conditional formatting (Latihan 8) |

## Persediaan

Teruskan menggunakan fail `.pbix` yang anda bina pada Hari 1 (model + hubungan sudah siap).

## Latihan

### Latihan 1 — Cipta jadual Kalendar
Modeling > **New table**, tampal formula `Kalendar` dari `calculated-columns.dax`. Kemudian buat hubungan `aduan[tarikh_terima]` → `Kalendar[Date]`.

### Latihan 2 — Tambah sukatan asas
Cipta sukatan ini (rujuk `measures.dax`):
- `Jumlah Aduan`
- `Aduan Selesai`
- `% Selesai`
- `Purata Tempoh Selesai`

Letak `% Selesai` dan `Purata Tempoh Selesai` ke dalam visual **Card**.

### Latihan 3 — Sukatan kewangan
Cipta `Jumlah Kompaun (RM)`, `Bilangan Kompaun`, dan `Purata Kompaun (RM)`. Paparkan **Jumlah Kompaun mengikut agensi** dalam bar chart.

### Latihan 4 — Kepintaran masa
Cipta `Aduan Bulan Lepas` dan `Perubahan Bulanan %`. Bina **line chart**: `Jumlah Aduan` mengikut `Kalendar[Tahun-Bulan]` untuk melihat trend.

### Latihan 5 — Dashboard interaktif
- Tambah **slicer**: `agensi`, `negeri`, dan julat `Kalendar[Tarikh]`.
- Tambah visual **Map**: `Jumlah Aduan` mengikut `negeri`.
- Tambah **Matrix**: baris = `agensi`, lajur = `status`, nilai = `Jumlah Aduan`.
- Susun semua visual menjadi satu halaman dashboard yang kemas.

### Latihan 6 — Quick measures & Sort by Column
- **Quick measure:** klik kanan `aduan` > **New quick measure** > *Running total* bagi `Jumlah Aduan` ikut `Kalendar[Date]`. Klik measure terhasil untuk kaji formula DAX-nya.
- **Sort by Column:** sort `Kalendar[Nama Bulan]` ikut `Kalendar[No Bulan]`. Cipta lajur `Urutan Status` (rujuk `calculated-columns.dax`) dan sort `aduan[status]` mengikutnya supaya carta ikut aliran proses (Baru → … → Ditutup).

### Latihan 7 — Conditional formatting & Top-N
1. Muat `../data/sasaran.csv` (Load). Cipta `Sasaran % Selesai` dan `Warna % Selesai` (rujuk `measures.dax`).
2. Matrix: Rows = `agensi[singkatan]`, Values = `% Selesai`. Format > Cell elements > Background color > **fx > Field value** = `Warna % Selesai` (hijau/merah ikut sasaran).
3. Bar chart `negeri` × `Jumlah Aduan` → Filters pane > **Top N** = Top 5 By value `Jumlah Aduan`.

### Latihan 8 — Polish & sedia publish
- **View > Themes:** pilih satu **Accessible theme**.
- **Filter scope:** tambah satu **report-level filter** (`Kalendar[Tahun]` = tahun semasa).
- **Senarai semak sebelum publish:** Mobile layout, Hide jadual/lajur pembantu (`Kalendar`, `Urutan Status`), Lock objects, dan uji slicer.

### Latihan 9 — Terbitkan (cabaran)
1. **Publish** laporan ke Power BI Service (perlu akaun kerja/sekolah).
2. Cipta **dashboard** dengan menyemat (pin) visual penting.
3. Tetapkan penapis dan terokai ciri **Q&A**.

> **Latihan Tambahan (use cases):** cuba kes DAX & visual (KPI visual, Pareto, purata bergerak 3 bulan, RANKX, peta per kapita) dalam bahagian **[Latihan Tambahan — Contoh Kes Penggunaan](../README.md#latihan-tambahan--contoh-kes-penggunaan-dax--visual)** README Hari 2.

## Semakan kendiri

- [ ] Jadual Kalendar wujud dan berkaitan dengan `aduan`
- [ ] Sekurang-kurangnya 8 sukatan dicipta dan berfungsi
- [ ] Memahami evaluation context (row vs filter) & mencuba satu Quick measure
- [ ] Line chart trend bulanan memaparkan corak musim (bulan disusun betul via Sort by Column)
- [ ] Conditional formatting (Field value `Warna % Selesai`) & Top-N berfungsi
- [ ] Report theme dipakai; report-level filter & senarai semak sebelum publish dilengkapkan
- [ ] Slicer, Map, dan Matrix berfungsi serentak
- [ ] Laporan berjaya diterbitkan ke Power BI Service
