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

### Latihan 3 — Bina hubungan
Dalam paparan **Model**, cipta hubungan:
- `aduan[agensi]` → `agensi[agensi]`
- `aduan[negeri]` → `negeri[negeri]`
- `aduan[kategori]` → `kategori[kategori]`

Pastikan semua **satu-ke-banyak** (1 → *).

### Latihan 4 — Visual pertama
Bina visual pada kanvas laporan:
- **Card**: bilangan aduan (Count of `no_aduan`)
- **Bar chart**: aduan mengikut `agensi`
- **Donut**: aduan mengikut `status`
- **Column chart**: aduan mengikut `kategori`

### Latihan 5 — Cabaran
Tambah **Slicer** untuk `zon` (dari jadual `negeri`) dan perhatikan semua visual menapis serentak apabila anda pilih satu zon.

## Semakan kendiri

- [ ] Keempat-empat jadual dimuat dan jenis data betul
- [ ] Alat profil data disemak (amaun_kompaun 0% Empty, negeri 16 distinct, tarikh 0% Error)
- [ ] Lajur `tempoh_hari` wujud dan menunjukkan nilai untuk kes selesai
- [ ] Tiga hubungan dicipta dalam paparan Model (skema bintang)
- [ ] Visual berfungsi dan menapis melalui slicer
