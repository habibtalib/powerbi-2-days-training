# Lab Hari 1 — Data, Power Query & Model

Lab ini mengukuhkan kemahiran memuat data, membersihkan data dengan Power Query, dan membina model bintang.

## Fail dalam folder ini

| Fail | Kegunaan |
|------|----------|
| `power-query.m` | Rujukan kod M untuk transformasi jadual `aduan` |
| `power-query-gabung.m` | Rujukan kod M untuk **Append**, **Merge** & **Unpivot** (Latihan 6–8) |

Fail data tambahan dalam folder `data/` untuk Latihan 6–8:

| Fail | Kegunaan |
|------|----------|
| `aduan_2026_07.csv`, `aduan_2026_08.csv` | Eksport bulanan untuk latihan **Append** (tambah baris) |
| `pegawai.csv` | Lookup pegawai/emel per agensi untuk latihan **Merge** (tambah lajur) |
| `aduan_ringkasan.csv` | Ringkasan tahunan "wide" (lajur = kategori) untuk latihan **Unpivot** |

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

### Latihan 6 — Append (satukan fail bulanan)
Import `aduan_2026_07.csv` dan `aduan_2026_08.csv` (Get Data > Text/CSV). Guna **Home > Append Queries as New** untuk tindan kedua-duanya menjadi satu jadual `aduan_gabung`. Sahkan jumlah baris = 8 + 8 = **16**. Rujuk `power-query-gabung.m` (blok 1).
> *Renungan:* nama lajur kedua-dua fail mesti sama supaya append kemas. Penyambung **Folder** boleh auto-append semua fail dalam satu folder.

### Latihan 7 — Merge (bawa lajur pegawai)
Import `pegawai.csv`. Pilih query `agensi` → **Home > Merge Queries**, padan ikut lajur `agensi`, **Join Kind = Left Outer**. **Expand** lajur `pegawai` dan `emel`. Sahkan jadual `agensi` kini ada 5 baris dengan pegawai & emel. Rujuk `power-query-gabung.m` (blok 2).
> *Cuba:* tukar Join Kind kepada **Inner** dan **Left Anti** — perhatikan perbezaan baris yang terhasil.

### Latihan 8 — Unpivot (data ringkasan → long)
Import `aduan_ringkasan.csv` (format "wide": lajur = kategori, nilai = jumlah). Pilih lajur `Tahun` → klik kanan → **Unpivot Other Columns**. Namakan `Attribute` → `kategori`, `Value` → `bilangan`. Sahkan hasil = 3 tahun × 8 kategori = **24 baris**. Rujuk `power-query-gabung.m` (blok 3).
> *Faham:* Unpivot memberi bentuk **long** yang kemas, **bukan** baris transaksi asal — jumlah yang sudah diringkas tidak boleh dipecahkan semula. Kerana `bilangan` ialah jumlah, agregat dengan **Sum** dalam visual.

## Semakan kendiri

- [ ] Boleh kenal pasti antara muka & bertukar antara 3 paparan (Report / Table / Model)
- [ ] Keempat-empat jadual dimuat dan jenis data betul
- [ ] Alat profil data disemak (amaun_kompaun 0% Empty, negeri 16 distinct, tarikh 0% Error)
- [ ] Applied Steps difahami (klik langkah berbeza; kod M dilihat dalam Advanced Editor)
- [ ] Lajur `tempoh_hari` wujud dan menunjukkan nilai untuk kes selesai
- [ ] Tiga hubungan dicipta dengan Cardinality \*:1 dan Cross-filter Single
- [ ] Visual berfungsi dan menapis melalui slicer
- [ ] **Append** menghasilkan `aduan_gabung` (16 baris) daripada dua fail bulanan
- [ ] **Merge** membawa lajur `pegawai` & `emel` ke dalam `agensi` (Left Outer + Expand)
- [ ] **Unpivot** menukar `aduan_ringkasan` "wide" kepada 24 baris `Tahun`/`kategori`/`bilangan`

---

## Latihan Tambahan — Contoh Kes Penggunaan (Use Cases)

Untuk latihan lanjutan berasaskan **soalan pengurusan sebenar** NRES (beban agensi, kes tertunggak, negeri hotspot, purata tempoh, jumlah kompaun, scatter populasi, heatmap peta & matrix, papan KPI, dan cabaran mini dashboard), rujuk bahagian **[Latihan Tambahan — Contoh Kes Penggunaan](../README.md#latihan-tambahan--contoh-kes-penggunaan-use-cases)** dalam README Hari 1. Cuba sekurang-kurangnya tiga kes sebelum Hari 2.

### Lanjutan Power Query (cuba sendiri)
Dua transformasi Power Query yang berguna dan sering dipakai dalam kes di atas:

- **Conditional Column — `kumpulan_tempoh`:** **Add Column > Conditional Column** → jika `tempoh_hari` ≤ 7 → `"Cepat"`, ≤ 30 → `"Sederhana"`, else `"Lambat"`. Kemudian bina **Donut** mengikut `kumpulan_tempoh` untuk lihat taburan kelajuan penyelesaian.
- **Lajur bulan — `Nama Bulan`:** pilih `tarikh_terima` → **Add Column > Date > Month > Name of Month**, untuk membolehkan analisis bulanan. *(Susunan ikut abjad buat masa ini — dibetulkan dengan **Sort by Column** pada Hari 2.)*
