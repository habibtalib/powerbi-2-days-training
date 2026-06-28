# Lab Hari 2 — DAX, Kepintaran Masa & Dashboard

Lab ini menguji kemahiran DAX (sukatan & lajur terkira), kepintaran masa, visual lanjutan, dan menerbitkan ke Power BI Service.

## Fail dalam folder ini

| Fail | Kegunaan |
|------|----------|
| `measures.dax` | Sukatan DAX siap pakai untuk dashboard |
| `calculated-columns.dax` | Lajur terkira + jadual Kalendar |

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

### Latihan 6 — Terbitkan (cabaran)
1. **Publish** laporan ke Power BI Service (perlu akaun kerja/sekolah).
2. Cipta **dashboard** dengan menyemat (pin) visual penting.
3. Tetapkan penapis dan terokai ciri **Q&A**.

## Semakan kendiri

- [ ] Jadual Kalendar wujud dan berkaitan dengan `aduan`
- [ ] Sekurang-kurangnya 8 sukatan dicipta dan berfungsi
- [ ] Line chart trend bulanan memaparkan corak musim
- [ ] Slicer, Map, dan Matrix berfungsi serentak
- [ ] Laporan berjaya diterbitkan ke Power BI Service
