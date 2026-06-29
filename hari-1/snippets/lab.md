# Lab Hari 1 — Data, Power Query & Model

Lab ini mengukuhkan kemahiran memuat data, membersihkan data dengan Power Query, dan membina model bintang.

## Fail dalam folder ini

| Fail | Kegunaan |
|------|----------|
| `power-query.m` | Rujukan kod M untuk transformasi jadual `aduan` |

## Persediaan

1. Pasang **Power BI Desktop** (percuma dari Microsoft Store atau [powerbi.microsoft.com](https://powerbi.microsoft.com/desktop/)).
2. Salin folder `data/` ke lokasi mudah, contoh `C:\Kursus-PowerBI\data\`.

## Latihan

### Latihan 0 — Orientasi antara muka
Sebelum muat data, kenal pasti bahagian utama: **Header** (Save, nama fail), **Ribbon**, **Formula Bar**, **Kanvas**, anak tetingkap **Visualizations** & **Data**, dan **3 ikon paparan** (Report / Table / Model) di tepi kiri. Tukar antara ketiga-tiga paparan sekali untuk biasakan diri.

### Latihan 1 — Muat keempat-empat fail
Guna **Get Data > Text/CSV** untuk import `aduan.csv`, `agensi.csv`, `negeri.csv`, dan `kategori.csv`. Sahkan kesemuanya muncul dalam anak tetingkap **Data**.

### Latihan 2 — Bersihkan data `aduan`
Dalam **Transform data** (Power Query):
- Naikkan tajuk (Promote Headers) jika perlu.
- Tetapkan jenis: `tarikh_terima` & `tarikh_selesai` sebagai **Date**, `amaun_kompaun` sebagai **Currency**.
- Trim ruang berlebihan pada `kategori`, `agensi`, `negeri`, `status`.
- Gantikan nilai kosong `amaun_kompaun` dengan 0.
- Tambah lajur tersuai `tempoh_hari` (rujuk `power-query.m`).
- Hidupkan **Data Profiling** (View > Column quality, Column distribution, Column profile) dan sahkan: `amaun_kompaun` 0% Empty, `negeri` 16 nilai distinct, lajur tarikh 0% Error.
- Lihat senarai **Applied Steps** (kanan): klik langkah berbeza untuk lihat data berubah, kemudian buka **Advanced Editor** untuk tengok kod **M**.

### Latihan 3 — Bina hubungan
Dalam paparan **Model**, cipta hubungan:
- `aduan[agensi]` → `agensi[agensi]`
- `aduan[negeri]` → `negeri[negeri]`
- `aduan[kategori]` → `kategori[kategori]`

Pastikan semua **satu-ke-banyak** (1 → *). Buka **Manage relationships** (atau klik dua kali garisan) dan sahkan **Cardinality = Many to one (\*:1)** dan **Cross-filter direction = Single**.

### Latihan 4 — Visual pertama
Bina visual pada kanvas laporan:
- **Card**: bilangan aduan (Count of `no_aduan`)
- **Bar chart**: aduan mengikut `agensi`
- **Donut**: aduan mengikut `status`
- **Column chart**: aduan mengikut `kategori`

Cuba ketiga-tiga tab anak tetingkap **Visualizations**: **Build** (seret medan), **Format** (hidupkan Title & Data labels), dan **Analytics** (tambah *Average line* pada column chart).

### Latihan 5 — Cabaran
Tambah **Slicer** untuk `zon` (dari jadual `negeri`) dan perhatikan semua visual menapis serentak apabila anda pilih satu zon.

## Semakan kendiri

- [ ] Boleh kenal pasti antara muka & bertukar antara 3 paparan (Report / Table / Model)
- [ ] Keempat-empat jadual dimuat dan jenis data betul
- [ ] Alat profil data disemak (amaun_kompaun 0% Empty, negeri 16 distinct, tarikh 0% Error)
- [ ] Applied Steps difahami (klik langkah berbeza; kod M dilihat dalam Advanced Editor)
- [ ] Lajur `tempoh_hari` wujud dan menunjukkan nilai untuk kes selesai
- [ ] Tiga hubungan dicipta dengan Cardinality \*:1 dan Cross-filter Single
- [ ] Visual berfungsi dan menapis melalui slicer

---

## Latihan Tambahan — Contoh Kes Penggunaan (Use Cases)

Latihan tambahan ini mengaitkan kemahiran Hari 1 dengan **soalan pengurusan sebenar** NRES. Setiap kes hanya menggunakan alat Hari 1 — **Power Query**, **model**, **visual asas**, **slicer**, dan **Filters pane** (belum perlu menulis measure DAX; itu Hari 2). Cuba sekurang-kurangnya tiga.

> **Petua:** Untuk menapis satu visual tanpa slicer, seret medan ke bahagian **Filters on this visual** dalam anak tetingkap **Filters**. Untuk menukar cara nombor dikira (Count / Sum / Average), klik anak panah turun pada medan dalam slot visual.

### Kes 1 — Beban kerja & status setiap agensi
**Soalan pengurusan:** *Agensi mana paling banyak aduan, dan berapa banyak yang masih belum selesai?*

1. Bina **Stacked bar chart**.
2. **Y-axis:** `agensi[agensi]` · **X-axis:** `aduan[no_aduan]` (Count) · **Legend:** `aduan[status]`.
3. Perhatikan komposisi status (Baru / Dalam Siasatan / Selesai / Ditutup) bagi setiap agensi.

**Hasil:** satu carta menunjukkan beban kerja **dan** kemajuan setiap agensi sekali pandang.

### Kes 2 — Kes tertunggak (backlog)
**Soalan pengurusan:** *Berapa banyak aduan yang masih belum selesai sekarang?*

1. Bina visual **Card** · seret `aduan[no_aduan]` (Count).
2. Pada **Filters on this visual**, seret `aduan[status]` dan pilih **Baru** dan **Dalam Siasatan** sahaja.
3. (Pilihan) Tambah **Card** kedua untuk kes **Selesai** sebagai perbandingan.

**Hasil:** KPI ringkas bilangan kes tertunggak — sesuai diletak di bahagian atas dashboard.

### Kes 3 — Negeri "hotspot"
**Soalan pengurusan:** *Negeri mana mencatat aduan paling tinggi?*

1. Bina **Clustered column chart** · **X-axis:** `negeri[negeri]` · **Y-axis:** `aduan[no_aduan]` (Count).
2. Klik **... (More options) > Sort axis** dan susun menurun (descending).
3. (Pilihan) Pada **Filters pane**, tukar Filter type `negeri` kepada **Top N** dan tetapkan **Top 5 By value = Count of no_aduan**.

**Hasil:** 5 negeri dengan aduan tertinggi — fokus untuk penguatkuasaan.

### Kes 4 — Purata tempoh penyelesaian
**Soalan pengurusan:** *Agensi mana paling pantas/lambat menyelesaikan kes?*

1. Bina **Clustered bar chart** · **Y-axis:** `agensi[agensi]` · **X-axis:** `aduan[tempoh_hari]`.
2. Klik anak panah turun pada `tempoh_hari` dalam slot dan tukar agregasi kepada **Average**.
3. Pada tab **Analytics** (anak tetingkap Visualizations), tambah **Average line** sebagai penanda purata keseluruhan.

**Hasil:** perbandingan purata hari penyelesaian antara agensi (kes belum selesai diabaikan kerana `tempoh_hari` kosong).

### Kes 5 — Jumlah kompaun mengikut kategori
**Soalan pengurusan:** *Kategori kes mana menyumbang nilai kompaun (RM) tertinggi?*

1. Bina **Clustered column chart** · **X-axis:** `kategori[kategori]` · **Y-axis:** `aduan[amaun_kompaun]`.
2. Pastikan agregasi `amaun_kompaun` ialah **Sum**.
3. Pada **Format > Data labels**, hidupkan label; format medan sebagai **Currency (RM)** dalam Column tools jika perlu.

**Hasil:** carta nilai kompaun terkumpul setiap kategori — asas analisis penguatkuasaan Hari 2.

### Kes 6 — Kumpulan tempoh (Conditional Column dalam Power Query)
**Soalan pengurusan:** *Berapa peratus kes diselesaikan dengan cepat berbanding lambat?*

1. Buka **Home > Transform data**, pilih query `aduan`.
2. **Add Column > Conditional Column**, namakan `kumpulan_tempoh`:
   - Jika `tempoh_hari` **≤ 7** → `"Cepat"`
   - Jika `tempoh_hari` **≤ 30** → `"Sederhana"`
   - Else → `"Lambat"`
3. **Close & Apply**, kemudian bina **Donut chart**: **Legend:** `kumpulan_tempoh` · **Values:** `no_aduan` (Count).

**Hasil:** taburan kelajuan penyelesaian — satu lajur kategori baharu yang anda cipta sendiri dalam Power Query.

### Kes 7 — Aduan mengikut bulan terima (lajur tarikh Power Query)
**Soalan pengurusan:** *Bulan mana kemasukan aduan paling tinggi?*

1. Dalam Power Query, pilih `aduan`, klik lajur `tarikh_terima`.
2. **Add Column > Date > Month > Name of Month** (cipta `Nama Bulan`).
3. **Close & Apply**, bina **Column chart**: **X-axis:** `Nama Bulan` · **Y-axis:** `no_aduan` (Count).

**Hasil:** corak musiman kemasukan aduan. *(Susunan bulan ikut abjad buat masa ini — kita betulkan dengan **Sort by Column** pada Hari 2.)*

> **Cabaran gabungan:** Letak Kes 1, 2, 3 dan 5 pada **satu halaman laporan**, tambah **Slicer** `negeri[zon]` dan `agensi[singkatan]`, kemudian klik beberapa pilihan untuk lihat semua visual menapis serentak — versi mini dashboard NRES sebelum kita lengkapkannya pada Hari 2.
