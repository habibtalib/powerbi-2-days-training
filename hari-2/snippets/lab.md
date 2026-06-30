# Lab Hari 2 — DAX, Kepintaran Masa & Dashboard

Lab ini menguji kemahiran DAX (sukatan & lajur terkira), kepintaran masa, visual lanjutan, dan menerbitkan ke Power BI Service. **Latihan 1–9** ialah teras; **Latihan Bonus** meneroka galeri visual penuh; **Latihan Lanjutan 10–16** mengisi separuh hari kedua dengan interaktiviti & tadbir urus (drill-through, bookmarks, tooltip, what-if, drill-down, RLS, capstone).

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

### 🎁 Latihan Bonus — Galeri visual penuh

Teroka visual teras lain Power BI yang belum disentuh dalam Latihan 1–9. Setiap satu hanya guna `Jumlah Aduan` dan medan model sedia ada — tiada DAX baharu diperlukan. Cuba **mana-mana tiga** dan perhatikan soalan yang setiap visual paling sesuai jawab. *(Rujuk Langkah 6: "Galeri visual lain" dalam README untuk butiran.)*

**B1 — Funnel (aliran status):** Category = `aduan[status]`, Values = `Jumlah Aduan`. Pastikan `aduan[status]` sudah **Sort by Column** ikut `Urutan Status` (Latihan 6) supaya corong ikut Baru → Dalam Siasatan → Selesai → Ditutup. Perhati peratus penyusutan antara aras.

**B2 — Treemap (bahagian-keseluruhan):** Category = `kategori[kategori]`, Values = `Jumlah Aduan`, Details = `aduan[status]`. Banding blok terbesar dengan donut status Hari 1 — mana lebih mudah dibaca?

**B3 — Ribbon chart (ranking ikut masa):** X-axis = `Kalendar[Tahun-Bulan]`, Legend = `agensi[singkatan]`, Y-axis = `Jumlah Aduan`. Cari **silang reben** — bulan di mana satu agensi memintas agensi lain dari segi beban aduan.

**B4 — Decomposition tree (drill AI):** Analyze = `Jumlah Aduan`; Explain by = `agensi[singkatan]`, `negeri[zon]`, `kategori[kategori]`. Klik **+** > **High value** beberapa kali — apakah laluan pemacu jumlah terbesar?

**B5 — Smart narrative (teks AI):** Klik kanan kanvas > **Summarize** (atau tambah visual **Smart narrative**). Letak ia di atas dashboard; klik slicer agensi/negeri dan perhati ayat ringkasan **berubah dinamik**.

**B6 (cabaran) — Small multiples:** Stacked bar chart (Y = `kategori[kategori]`, Legend = `aduan[status]`, Values = `Jumlah Aduan`) + seret `agensi[singkatan]` ke telaga **Small multiples**. JAS dapat 3 panel bar, JPSM 2, lain-lain 1.

---

## Latihan Lanjutan — Separuh Hari Kedua (interaktiviti & tadbir urus)

Anda sudah siap dashboard teras (Langkah 1–7). Gunakan baki masa untuk **menjadikan laporan benar-benar interaktif dan sedia-pengeluaran** — ciri yang membezakan laporan "pelajar" daripada laporan "dashboard kerajaan sebenar". Setiap latihan berdiri sendiri; ikut turutan, atau pilih ikut minat. Anggaran masa diberi supaya muat ~3 jam.

> **Petua:** Simpan (`Ctrl+S`) selepas setiap latihan, dan tambah **halaman laporan baharu** (tab `+` di bawah kanvas) untuk latihan yang perlukan halaman berasingan supaya dashboard utama anda kekal kemas.

### Latihan 10 — Drill-through: halaman butiran agensi *(±30 min)*

Benarkan pengguna **klik kanan satu agensi → terjun ke halaman butiran penuh**.

1. Cipta halaman baharu, namakan **"Butiran Agensi"**.
2. Pada anak tetingkap **Visualizations > Build > Add drill-through fields here**, seret `agensi[singkatan]`. Power BI auto-tambah **butang Back** (←).
3. Pada halaman ini, bina visual khusus agensi: **Table** (`no_aduan`, `kategori`, `status`, `tempoh_hari`), **Card** `% Selesai`, **line chart** trend bulanan.
4. Kembali ke halaman dashboard → **klik kanan** mana-mana bar agensi → **Drill through > Butiran Agensi**. Semua visual halaman butiran ditapis kepada agensi itu.

> **Hasil:** corak "ringkasan → butiran" — pengguna mula daripada gambaran besar, terjun ke satu agensi tanpa membina 5 halaman berasingan.

### Latihan 11 — Bookmarks & butang navigasi *(±30 min)*

Cipta "pandangan tersimpan" yang boleh ditogol dengan butang.

1. Buka **View > Bookmarks** dan **View > Selection**.
2. Tetapkan satu pandangan (cth slicer = "Selesai" sahaja, susunan tertentu) → **Bookmarks > Add**. Namakan **"Fokus Selesai"**.
3. Tetapkan pandangan kedua (cth status "Baru") → Add → **"Fokus Baru"**.
4. **Insert > Buttons > Blank** (atau **Navigator > Bookmark navigator**). Pada butang, **Format > Action > Type = Bookmark**, pilih bookmark. **Ctrl+klik** untuk menguji.
5. (Cabaran) Guna **Selection pane** + bookmark untuk **show/hide** satu panel "info" (butang ❔ buka, ✕ tutup).

> **Hasil:** dashboard bercerita — pengguna menukar konteks dengan satu klik, bukan menyeret slicer.

### Latihan 12 — Report page tooltip (tooltip tersuai) *(±20 min)*

Ganti tooltip lalai dengan **mini-carta** apabila hover.

1. Cipta halaman baharu **"Tooltip Trend"**. **Format > Page information > Allow use as tooltip = On**; **Page size > Type = Tooltip**.
2. Pada halaman kecil itu, bina **line chart** trend `Jumlah Aduan` ikut `Kalendar[Tahun-Bulan]` + satu Card.
3. Kembali ke bar chart agensi → **Format > Tooltips > Type = Report page > Page = Tooltip Trend**.
4. Hover pada mana-mana bar — mini trend agensi itu muncul.

> **Hasil:** maklumat kaya tanpa memenuhkan kanvas.

### Latihan 13 — What-if parameter: sasaran boleh laras *(±25 min)*

Biar pengguna **laras ambang sasaran** dengan slider dan lihat kesan serta-merta.

1. **Modeling > New parameter > Numeric range**. Nama **"Sasaran Pelarasan"**, Min `0`, Max `1`, Increment `0.05`, Default `0.7`. Centang "Add slicer to this page". *(Power BI auto-cipta jadual + measure `Sasaran Pelarasan Value` yang memulangkan nilai slider semasa.)*
2. Cipta measure:
   ```dax
   Capai Sasaran Laras =
   IF([% Selesai] >= [Sasaran Pelarasan Value], "✅", "❌")
   ```
3. Bina **Table**: `agensi[singkatan]`, `% Selesai`, `Capai Sasaran Laras`. Geser slider — lajur status bertukar dinamik.

> **Hasil:** analisis "bagaimana-jika" — pengurus uji sasaran 65% vs 75% tanpa edit data.

### Latihan 14 — Drill-down hierarki *(±15 min)*

1. Pada **column chart** `Jumlah Aduan`, letak **dua** medan pada Axis: `negeri[zon]` kemudian `negeri[negeri]`.
2. Hidupkan **mod drill** (ikon anak panah ↓ di sudut visual).
3. Klik satu zon untuk **drill down** ke negeri dalam zon itu; guna ikon **drill up** (↑) untuk kembali. Cuba juga **Expand all** (↧) untuk lihat kedua-dua aras serentak.

> **Hasil:** satu visual, banyak aras — pengguna terokai sendiri dari zon ke negeri.

### Latihan 15 — Row-Level Security (RLS) *(±30 min)*

Hadkan data ikut peranan — cth pegawai JAS hanya nampak kes JAS.

1. **Modeling > Manage roles > Create**. Nama peranan **"JAS sahaja"**.
2. Pada jadual `agensi`, tetapkan penapis DAX:
   ```dax
   [singkatan] = "JAS"
   ```
3. (Dinamik, cabaran) Buat peranan **"Ikut pengguna"** dengan jadual pemetaan e-mel→agensi dan penapis `USERPRINCIPALNAME()`.
4. **Modeling > View as > pilih "JAS sahaja"** — seluruh laporan kini hanya papar data JAS. Klik **Stop viewing** untuk keluar.

> **Hasil:** satu laporan, banyak penonton — selepas publish, tetapkan ahli peranan dalam Power BI Service (**Datasets > Security**).

### Latihan 16 (Capstone) — Halaman "Ringkasan Eksekutif" *(±40 min)*

Gabungkan semua yang dipelajari menjadi **satu halaman bos-boleh-baca-5-saat**:

1. Halaman baharu **"Ringkasan Eksekutif"**.
2. Jalur atas: 3–4 **Card/KPI** (Jumlah Aduan, % Selesai, Jumlah Kompaun RM, Purata Tempoh).
3. Tengah: **Smart narrative** + **line chart** trend dengan **Average line** (tab Analytics).
4. Bawah: **Filled map** (gradient) + **matrix** heat-map sasaran (Latihan 7).
5. Tambah **slicer** `Kalendar[Tahun]` + butang **bookmark "Reset"**, dan satu **report-level filter** tahun semasa.
6. Lengkapkan **senarai semak sebelum publish** (Langkah 7B) → **Publish** (Latihan 9) → kongsi pautan.

> **Hasil:** satu halaman ringkasan yang kemas, ditapis, dan boleh diterbit — produk akhir kursus.

## Semakan kendiri

- [ ] Jadual Kalendar wujud dan berkaitan dengan `aduan`
- [ ] Sekurang-kurangnya 8 sukatan dicipta dan berfungsi
- [ ] Memahami evaluation context (row vs filter) & mencuba satu Quick measure
- [ ] Line chart trend bulanan memaparkan corak musim (bulan disusun betul via Sort by Column)
- [ ] Conditional formatting (Field value `Warna % Selesai`) & Top-N berfungsi
- [ ] Report theme dipakai; report-level filter & senarai semak sebelum publish dilengkapkan
- [ ] Slicer, Map, dan Matrix berfungsi serentak
- [ ] Laporan berjaya diterbitkan ke Power BI Service
- [ ] 🎁 Bonus: mencuba sekurang-kurangnya **tiga** visual galeri (funnel / treemap / ribbon / decomposition tree / smart narrative / small multiples)

### Separuh hari kedua (Latihan Lanjutan 10–16)

- [ ] **Drill-through** ke halaman "Butiran Agensi" berfungsi (klik kanan → Drill through)
- [ ] **Bookmarks** + butang navigasi menukar pandangan dengan satu klik
- [ ] **Report page tooltip** memaparkan mini-trend bila hover
- [ ] **What-if parameter** melaras sasaran & measure bertindak balas
- [ ] **Drill-down** zon → negeri berfungsi (mod drill)
- [ ] **Row-Level Security** diuji dengan **View as** (peranan "JAS sahaja")
- [ ] **Capstone**: halaman "Ringkasan Eksekutif" siap, ditapis & diterbitkan
