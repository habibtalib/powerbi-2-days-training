# Hari 2 — Panduan Bengkel: DAX, Kepintaran Masa & Dashboard

Panduan langkah demi langkah untuk menyiapkan **Dashboard Aduan Alam Sekitar NRES**. Pada akhir bengkel ini (~6 jam), anda akan mempunyai dashboard interaktif penuh dengan sukatan DAX, analisis trend, peta, dan diterbitkan ke Power BI Service.

**Imbas kembali Hari 1:** Anda telah memuat empat fail CSV (`aduan`, `agensi`, `negeri`, `kategori`), membersihkan data dengan Power Query, membina **skema bintang** dengan tiga hubungan, dan menghasilkan beberapa visual asas. Hari ini kita beralih daripada *memaparkan data* kepada *mengira & menganalisis data* dengan **DAX**.

**Apa yang akan dibina:**
- Jadual **Kalendar** untuk analisis berasaskan masa
- **Lajur terkira** (Tahun, Tempoh Hari, Kumpulan Tempoh)
- 13 **sukatan (measures)** — kiraan, peratusan, kewangan (RM), dan kepintaran masa
- Visual lanjutan: **line chart** trend, **map**, dan **matrix**
- Dashboard interaktif dengan **slicer**
- Menerbitkan laporan ke **Power BI Service**

> **Buka semula** fail `.pbix` yang anda simpan pada Hari 1. Model dan hubungan sudah sedia — kita teruskan dari situ.

---

## Konsep: Sukatan vs Lajur Terkira

Sebelum mula, fahami dua jenis pengiraan DAX:

| | **Lajur Terkira** (Calculated Column) | **Sukatan** (Measure) |
|---|---|---|
| Bila dikira | Semasa data dimuat/refresh | Semasa anda berinteraksi dengan visual |
| Disimpan | Ya — mengambil ruang memori | Tidak — dikira atas permintaan |
| Konteks | Baris demi baris (row context) | Penapis visual (filter context) |
| Guna untuk | Mengkategori/menanda setiap baris | Agregat: jumlah, purata, peratus |
| Contoh | `Tahun`, `Kumpulan Tempoh` | `Jumlah Aduan`, `% Selesai` |

> **Petua emas:** Jika ragu, **guna sukatan**. Sukatan lebih cekap dan fleksibel. Guna lajur terkira hanya apabila anda perlu menapis/mengumpul mengikut nilai yang dikira.

### Konsep: Evaluation Context — Row vs Filter

Setiap pengiraan DAX dinilai dalam satu **konteks**. Memahami dua jenis ini menjelaskan kenapa measure & lajur terkira boleh beri jawapan berbeza:

| | **Row context** | **Filter context** |
|---|---|---|
| Maksud | "Nampak" satu **baris semasa** | Set baris yang **ditapis** oleh visual, slicer & hubungan |
| Default untuk | **Lajur terkira** (cth `tarikh_selesai − tarikh_terima` setiap aduan) | **Measure** dalam visual |
| Fungsi tipikal | Operasi baris demi baris | Agregat (SUM, COUNTROWS) |

> **Kunci faham:** **Measure tiada row context** — ia bermula daripada filter context visual. Sebab itu measure mesti guna fungsi agregat bila merujuk lajur (cth `SUM(aduan[amaun_kompaun])`, bukan `aduan[amaun_kompaun]` sahaja). `CALCULATE` ialah cara utama untuk **mengubah** filter context. *(Sumber: slaid "Evaluation context".)*

---

## Langkah 1: Cipta Jadual Kalendar

Untuk analisis masa (trend bulanan, YTD, bulan lepas), Power BI memerlukan satu **jadual tarikh** yang lengkap dan berterusan.

### Cipta jadual

Pada reben **Modeling**, klik **New table**. Tampal formula berikut dalam bar formula:

```dax
Kalendar =
ADDCOLUMNS(
    CALENDAR(DATE(2025, 1, 1), DATE(2026, 12, 31)),
    "Tahun", YEAR([Date]),
    "No Bulan", MONTH([Date]),
    "Nama Bulan", FORMAT([Date], "mmm"),
    "Tahun-Bulan", FORMAT([Date], "YYYY-MM"),
    "Suku Tahun", "S" & ROUNDUP(MONTH([Date]) / 3, 0)
)
```

Tekan **Enter**. Jadual `Kalendar` baharu muncul dalam anak tetingkap **Data**.

**Penerangan formula:**

| Bahagian | Fungsi |
|----------|--------|
| `CALENDAR(mula, tamat)` | Menjana satu lajur `Date` dari 1 Jan 2025 hingga 31 Dis 2026 |
| `ADDCOLUMNS(...)` | Menambah lajur tambahan pada jadual tersebut |
| `YEAR([Date])` | Tahun, cth: 2025 |
| `FORMAT([Date], "mmm")` | Nama bulan ringkas, cth: Jan, Feb |
| `FORMAT([Date], "YYYY-MM")` | Tahun-bulan untuk paksi carta, cth: 2025-03 |
| `ROUNDUP(MONTH([Date])/3, 0)` | Mengira suku tahun (1–4) |

### Hubungkan ke jadual fakta

Pergi ke paparan **Model**. Seret medan `aduan[tarikh_terima]` ke `Kalendar[Date]` untuk mencipta hubungan **satu-ke-banyak** (`Kalendar` 1 → ∞ `aduan`).

### Tandakan sebagai Jadual Tarikh

Klik jadual `Kalendar` > reben **Table tools** > **Mark as date table** > pilih lajur `Date`. Ini membolehkan fungsi kepintaran masa berfungsi dengan betul.

> **Nota:** Tanpa jadual Kalendar yang ditanda, fungsi seperti `TOTALYTD` dan `DATEADD` mungkin memberi keputusan yang salah.

---

## Langkah 2: Cipta Lajur Terkira

Lajur terkira dikira untuk **setiap baris** dalam jadual `aduan`.

### Tahun

Klik kanan jadual `aduan` > **New column**. Tampal:

```dax
Tahun = YEAR(aduan[tarikh_terima])
```

### Tempoh Hari

Berapa hari diambil untuk selesaikan satu kes? **New column**:

```dax
Tempoh Hari =
IF(
    ISBLANK(aduan[tarikh_selesai]),
    BLANK(),
    DATEDIFF(aduan[tarikh_terima], aduan[tarikh_selesai], DAY)
)
```

**Konsep penting:**
- `ISBLANK(...)` — menyemak jika kes belum selesai (tiada `tarikh_selesai`).
- `IF(syarat, benar, palsu)` — jika belum selesai, kembalikan `BLANK()`; jika tidak, kira tempoh.
- `DATEDIFF(mula, tamat, DAY)` — beza dua tarikh dalam unit hari.

### Kumpulan Tempoh

Kelaskan setiap kes mengikut kelajuan penyelesaian. **New column**:

```dax
Kumpulan Tempoh =
SWITCH(
    TRUE(),
    ISBLANK(aduan[Tempoh Hari]), "Belum Selesai",
    aduan[Tempoh Hari] <= 14, "≤ 2 minggu",
    aduan[Tempoh Hari] <= 30, "2–4 minggu",
    "> 1 bulan"
)
```

**Konsep penting:**
- `SWITCH(TRUE(), syarat1, hasil1, syarat2, hasil2, …, lalai)` — corak "if-else" yang kemas. DAX menyemak setiap syarat dari atas ke bawah dan mengembalikan hasil pertama yang benar.
- Nilai terakhir (`"> 1 bulan"`) ialah nilai **lalai** jika tiada syarat lain dipenuhi.

> **Nota:** `Kumpulan Tempoh` ialah contoh yang sah untuk lajur terkira (bukan sukatan) — kerana kita mahu **menapis dan mengumpul** visual mengikut kumpulan ini.

---

## Langkah 3: Cipta Sukatan Asas

Sekarang kita cipta **sukatan** untuk agregat. Klik kanan jadual `aduan` > **New measure** untuk setiap satu.

### Jumlah Aduan

```dax
Jumlah Aduan = COUNTROWS(aduan)
```

`COUNTROWS` mengira bilangan baris dalam jadual `aduan` mengikut konteks penapis semasa. Ini ialah sukatan **asas** yang akan digunakan oleh sukatan lain.

### Aduan mengikut status

```dax
Aduan Selesai = CALCULATE([Jumlah Aduan], aduan[status] = "Selesai")
```

```dax
Aduan Dalam Siasatan = CALCULATE([Jumlah Aduan], aduan[status] = "Dalam Siasatan")
```

```dax
Aduan Baru = CALCULATE([Jumlah Aduan], aduan[status] = "Baru")
```

**Konsep penting — `CALCULATE`:**
`CALCULATE(ungkapan, penapis…)` ialah fungsi **paling penting** dalam DAX. Ia menilai semula sesuatu ungkapan dengan konteks penapis yang **diubah**. Di sini, ia mengira `[Jumlah Aduan]` tetapi hanya untuk baris di mana `status = "Selesai"`.

### % Selesai

```dax
% Selesai = DIVIDE([Aduan Selesai], [Jumlah Aduan])
```

**Konsep penting — `DIVIDE`:**
Sentiasa guna `DIVIDE(pengangka, penyebut)` dan **bukan** operator `/`. `DIVIDE` mengendalikan pembahagian dengan sifar secara selamat (mengembalikan `BLANK` dan bukan ralat).

Selepas mencipta sukatan ini, pilihnya dalam anak tetingkap **Data**, kemudian pada reben **Measure tools**, tetapkan **Format** kepada **Percentage** dengan 1 tempat perpuluhan.

### Purata Tempoh Selesai

```dax
Purata Tempoh Selesai =
AVERAGEX(
    FILTER(aduan, NOT ISBLANK(aduan[tarikh_selesai])),
    DATEDIFF(aduan[tarikh_terima], aduan[tarikh_selesai], DAY)
)
```

**Konsep penting:**
- `FILTER(jadual, syarat)` — menghasilkan subset jadual; di sini hanya kes yang **sudah selesai**.
- `AVERAGEX(jadual, ungkapan)` — fungsi *iterator*: untuk setiap baris dalam jadual yang ditapis, ia mengira `DATEDIFF`, kemudian mengambil purata semua nilai tersebut.

### Letak ke dalam Card

Daripada anak tetingkap **Visualizations**, tambah dua visual **Card**:
- Card 1 → `% Selesai`
- Card 2 → `Purata Tempoh Selesai` (tukar tajuk kepada "Purata Hari Selesai")

### Quick measures — DAX tanpa menulis DAX (mesra pemula)

Belum yakin menulis DAX? Klik kanan jadual `aduan` > **New quick measure**. Pilih satu pengiraan biasa, seret medan, dan Power BI **menjana formula DAX automatik**.

1. **New quick measure** > Calculation = **Running total**.
2. Base value = `Jumlah Aduan`, Field = `Kalendar[Date]`.
3. Klik **OK** — measure baharu terhasil. **Klik measure itu** untuk lihat & belajar formula DAX yang dijana (boleh diubah kemudian).

> **Petua:** Quick measures sangat membantu ketika mula belajar DAX — cuba *Running total* aduan ikut bulan atau *% of total* ikut agensi, kemudian kaji formulanya. *(Sumber: slaid "Quick measures".)*

---

## Langkah 4: Sukatan Kewangan (RM)

NRES mengenakan **kompaun** sebagai tindakan penguatkuasaan. Mari kita ukur nilainya.

### Jumlah & bilangan kompaun

```dax
Jumlah Kompaun (RM) = SUM(aduan[amaun_kompaun])
```

```dax
Bilangan Kompaun = CALCULATE([Jumlah Aduan], aduan[tindakan] = "Kompaun")
```

### Purata kompaun

```dax
Purata Kompaun (RM) =
DIVIDE([Jumlah Kompaun (RM)], [Bilangan Kompaun])
```

### Format sebagai mata wang

Untuk `Jumlah Kompaun (RM)` dan `Purata Kompaun (RM)`: pilih sukatan > **Measure tools** > **Format** = **Currency**, dan tukar simbol kepada **RM** (Currency format > English (Malaysia), atau set Decimal places = 0).

### Visual: kompaun mengikut agensi

Tambah **Bar chart**:
- **Y-axis:** `agensi[singkatan]`
- **X-axis:** `Jumlah Kompaun (RM)`

Anda akan nampak agensi mana mengutip kompaun paling tinggi.

> **Nota:** Oleh kerana kita menggantikan nilai kosong `amaun_kompaun` dengan 0 pada Hari 1, `SUM` berfungsi tanpa ralat dan kes bukan-kompaun menyumbang RM 0.

---

## Langkah 5: Kepintaran Masa (Time Intelligence)

Inilah kuasa sebenar jadual Kalendar — analisis merentas masa.

### Aduan terkumpul tahun semasa (YTD)

```dax
Aduan YTD = TOTALYTD([Jumlah Aduan], 'Kalendar'[Date])
```

`TOTALYTD` menjumlahkan `[Jumlah Aduan]` dari 1 Januari sehingga tarikh dalam konteks semasa.

### Bandingkan dengan bulan lepas

```dax
Aduan Bulan Lepas =
CALCULATE([Jumlah Aduan], DATEADD('Kalendar'[Date], -1, MONTH))
```

```dax
Perubahan Bulanan % =
DIVIDE([Jumlah Aduan] - [Aduan Bulan Lepas], [Aduan Bulan Lepas])
```

**Konsep penting:**
- `DATEADD(lajur_tarikh, -1, MONTH)` — mengalih konteks tarikh ke belakang satu bulan.
- `Perubahan Bulanan %` membandingkan bulan semasa dengan bulan sebelumnya — berguna untuk melihat lonjakan.

### Visual: trend bulanan

Tambah **Line chart**:
- **X-axis:** `Kalendar[Tahun-Bulan]`
- **Y-axis:** `Jumlah Aduan`

Perhatikan corak — **lonjakan kes banjir** pada musim tengkujuh (Nov–Feb) dan **pencemaran udara** pada musim kering (Jun–Sep). Tambah `Aduan Bulan Lepas` sebagai garisan kedua untuk perbandingan.

### Sort by Column — susun teks ikut nombor

**Masalah biasa:** lajur teks seperti **Nama Bulan** atau **status** disusun ikut **abjad** (April, August, December…) — bukan urutan sebenar, jadi carta nampak kacau.

**Selesai:**
1. Pilih lajur teks (cth `Kalendar[Nama Bulan]`) di paparan **Data**.
2. Reben **Column tools** > **Sort by column** > pilih lajur nombor padanan (`Kalendar[No Bulan]`).
3. Carta kini susun Jan→Dis dengan betul. (`Tahun-Bulan` dalam format `YYYY-MM` pula sudah susun kronologi secara abjad.)

Ulang untuk `aduan[status]` — cipta lajur terkira `Urutan Status`, kemudian sort `status` mengikutnya supaya carta ikut **aliran proses**, bukan A–Z:

```dax
Urutan Status =
SWITCH(aduan[status],
    "Baru", 1, "Dalam Siasatan", 2, "Selesai", 3, "Ditutup", 4, 99)
```

> **Syarat:** setiap nilai teks mesti petakan ke **satu** nombor konsisten. *(Sumber: slaid "Sort by Column".)*

> **Tabiat kualiti — semak & troubleshoot sukatan:** Selepas mencipta measure, sahkan ia munasabah: **(1)** sort hasil (% tertinggi/terendah) & siasat nilai ekstrem; **(2)** tambah slicer (bulan/kategori) & periksa nilai pada data ditapis; **(3)** letak ikut kumpulan (zon/agensi) & pastikan baris **Total** betul. Sentiasa guna `DIVIDE` (bukan `/`) supaya bahagi-sifar pulang BLANK. Awas baris Total — ia dinilai dalam *context* tersendiri. *(Sumber: slaid "Checking & troubleshooting calculations".)*

---

## Langkah 6: Visual Lanjutan

### Peta taburan negeri

Tambah visual **Map** (atau **Filled map**):
- **Location:** `negeri[negeri]`
- **Bubble size / Saturation:** `Jumlah Aduan`

Power BI akan meletakkan setiap negeri Malaysia di atas peta. Negeri dengan lebih banyak kes akan kelihatan lebih besar/gelap.

### Sukatan per kapita

```dax
Aduan per 100k Penduduk =
DIVIDE([Jumlah Aduan], SUM(negeri[populasi])) * 100000
```

Sukatan ini menormalkan kes mengikut saiz penduduk — berguna untuk membandingkan negeri besar dengan negeri kecil secara adil.

### Scatter chart — aduan vs populasi

Carta serakan (**Scatter chart**) memetakan dua nilai numerik pada satu titik — sesuai untuk mencari negeri yang **banyak aduan walaupun populasi kecil**.

Tambah visual **Scatter chart**:
- **X-axis:** `negeri[populasi]` (set ke **Sum**)
- **Y-axis:** `Jumlah Aduan` (sukatan — rujuk Langkah 3)
- **Values / Details:** `negeri[negeri]`

Setiap titik = satu negeri. Cari titik yang **tinggi pada paksi-Y** (banyak aduan) tetapi **kiri pada paksi-X** (populasi kecil) — itulah negeri dengan beban aduan luar biasa berbanding populasinya.

> **⚠️ Gotcha biasa:** Jangan seret `aduan[no_aduan]` terus ke **Y-axis**. Ia kolum **teks**, jadi paksi scatter (yang perlukan nilai numerik beragregat) akan tersekat atau dikunci sebagai *Don't summarize*. Gunakan **sukatan** `Jumlah Aduan` (`COUNTROWS(aduan)`) — lebih tepat (bilang baris, bukan teks unik) dan boleh diguna semula. *(Kalau betul-betul mahu tanpa sukatan: seret `no_aduan`, klik ▼ pada medan dalam well Y-axis → pilih **Count**.)*

### Small multiples — bandingkan kategori dalam setiap agensi

Kadang kita mahu **satu bar stacked bagi setiap kategori**, tetapi **dikumpulkan ikut agensi** — cth. JAS (3 kategori) vs JPSM (2) vs agensi lain (1). Power BI **tiada** visual "clustered + stacked" serentak, jadi cara paling kemas dan native ialah **Small multiples**: satu stacked bar chart dipecahkan jadi panel kecil per agensi.

1. Tambah **Stacked bar chart**:
   - **Y-axis:** `kategori[kategori]`
   - **Legend:** `aduan[status]`  ← bahagian *stacked* (warna)
   - **X-axis (Values):** `Jumlah Aduan`
2. Seret **`agensi[singkatan]`** ke telaga **Small multiples**.

Hasil: grid panel — panel **JAS** tunjuk **3 bar stacked**, **JPSM** 2 bar, agensi lain 1 bar. Setiap panel = satu agensi, setiap bar = satu kategori, warna = status.

> **Alternatif:**
> - **Axis hierarchy** (satu carta, tanpa Small multiples): letak `agensi[singkatan]` **kemudian** `kategori[kategori]` pada **Y-axis** stacked bar chart, Legend = `status`, kemudian klik **Expand all** (↧). Bar stacked tersusun berkelompok di bawah setiap agensi.
> - **Custom visual** untuk *clustered-stacked* sebenar (bar bersebelahan **dan** stacked): **⋯ → Get more visuals** (AppSource) → cari "Clustered stacked column/bar chart". Ada had lesen & perlu internet — kurang sesuai untuk kelas pemula.

### Matriks agensi × status

Tambah visual **Matrix**:
- **Rows:** `agensi[singkatan]`
- **Columns:** `aduan[status]`
- **Values:** `Jumlah Aduan`

Ini memberi jadual silang yang menunjukkan beban kerja setiap agensi mengikut status.

### Pemformatan asas

Untuk setiap visual, buka anak tetingkap **Format** (ikon berus):
- Hidupkan **Title** yang jelas (cth: "Kes Mengikut Agensi").
- Hidupkan **Data labels** untuk carta bar/line.
- Selaraskan **warna** mengikut tema (cth: hijau untuk tema alam sekitar).

> **Konsep penting:** Visual yang baik mempunyai **tajuk jelas**, **label data**, dan **warna konsisten**. Elakkan terlalu banyak warna yang mengelirukan.

### Conditional formatting — heat-map matrix (prestasi vs sasaran)

Gunakan fail **`sasaran.csv`** (sasaran % Selesai setiap agensi) untuk mewarnakan prestasi secara automatik.

1. **Get Data > Text/CSV** → import `sasaran.csv` (**Load** sahaja — tiada hubungan diperlukan; kita guna `LOOKUPVALUE` supaya ia jadi jadual *disconnected*).
2. Cipta dua measure (rujuk `measures.dax`):
   ```dax
   Sasaran % Selesai =
   LOOKUPVALUE(sasaran[sasaran_selesai], sasaran[agensi], SELECTEDVALUE(aduan[agensi]), 0.70)

   Warna % Selesai =
   IF([% Selesai] >= [Sasaran % Selesai], "#1a7f4b", "#b42318")
   ```
3. Pada matrix (Rows = `agensi[singkatan]`, Values = `% Selesai`), buka **Format > Cell elements > Background color > fx**.
4. **Format style = Field value**, *Based on field* = **`Warna % Selesai`**. Sel jadi **hijau** jika capai sasaran, **merah** jika tidak.

> **Tiga gaya conditional formatting:** **Gradient** (skala min–max), **Rules** (julat nilai), dan **Field value** (warna terus daripada measure — paling berkuasa). Anda juga boleh gunakan **Data bars** atau **Icons**. *(Sumber: slaid "Conditional formatting".)*

### Top-N filtering — fokus pemain utama

1. Bina bar chart: `negeri[negeri]` × `Jumlah Aduan`.
2. Pada **Filters pane**, di medan `negeri`, tukar **Filter type = Top N**.
3. Pilih **Top**, masukkan **5**, seret `Jumlah Aduan` ke **By value** → **Apply filter**.
4. Visual kini papar hanya 5 negeri teratas. Salin visual & tukar Top→Bottom untuk lihat 5 terendah.

> NRES: "Top 5 negeri ikut Jumlah Aduan" atau "Top 3 kategori ikut Jumlah Kompaun (RM)". *(Sumber: slaid "Top-N filtering".)*

---

## Langkah 7: Susun Dashboard

Sekarang gabungkan semua visual menjadi **satu halaman dashboard** yang kemas.

### Susun atur cadangan

```
┌──────────────────────────────────────────────────────┐
│  [Card: Jumlah]  [Card: % Selesai]  [Card: Kompaun]  │
├───────────────┬──────────────────────────────────────┤
│  Slicer:      │   Line chart — Trend bulanan          │
│  - Agensi     ├──────────────────────────────────────┤
│  - Negeri     │   Bar: Agensi   │   Map: Negeri       │
│  - Tarikh     ├─────────────────┴──────────────────── │
│               │   Matrix: Agensi × Status             │
└───────────────┴──────────────────────────────────────┘
```

### Tambah slicer

Daripada **Visualizations**, tambah tiga **Slicer**:
- `agensi[singkatan]`
- `negeri[zon]` atau `negeri[negeri]`
- `Kalendar[Date]` (tetapkan jenis slicer kepada **Between** untuk julat tarikh)

Apabila pengguna memilih satu agensi atau julat tarikh, **semua visual menapis serentak**.

### Edit interactions

Pilih satu visual, kemudian pada reben **Format** > **Edit interactions**. Anda boleh tetapkan sama ada satu visual **menapis (filter)**, **menyerlah (highlight)**, atau **tidak terjejas (none)** apabila visual lain dipilih. Ini memberi kawalan halus terhadap cara dashboard bertindak balas.

> **Nota:** Beri ruang dan jajaran yang kemas. Guna **Gridlines** dan **Snap to grid** (View > Gridlines) untuk meletakkan visual dengan rapi.

### Tema laporan (Report theme) — warna konsisten

**View > Themes** — pilih theme terbina atau **Accessible themes** (mesra colorblind). Satu set warna + saiz font dikenakan ke **seluruh laporan** sekali gus. Untuk branding rasmi, import fail **JSON** (dataColors, background, foreground, fontSize) via **Browse for themes** (boleh dijana daripada logo guna penjana seperti themes.powerbi.tips).

> NRES: pilih **Accessible theme** + warna korporat supaya agensi (JAS/JPSM/…) mudah dibeza. *(Sumber: slaid "Report theme".)*

### Skop penapis: visual, page, report

Anak tetingkap **Filters** ada **tiga skop**:
- **Filters on this visual** — kesan satu visual sahaja.
- **Filters on this page** — kesan semua visual pada halaman itu.
- **Filters on all pages** — ditetapkan sekali, kesan **semua halaman**.

> **Slicer vs Filters pane:** slicer = kawalan di atas kanvas untuk **pengguna**; Filters pane = **penulis** tetapkan skop. NRES: gunakan report-level filter untuk papar hanya aduan tahun semasa merentas semua halaman. *(Sumber: slaid "Filter scope".)*

---

## Langkah 7B: Senarai Semak Sebelum Publish

Sebelum menerbitkan, lalui senarai semak ini supaya laporan kemas & profesional:

- [ ] **Mobile layout** — **View > Mobile layout**, susun semula visual untuk telefon (boleh skrol; tidak mengubah susunan desktop). Berguna untuk pegawai di lapangan.
- [ ] **Hide** item pembantu — sorok jadual/lajur/measure pembantu (cth jadual `Kalendar`, lajur `No Bulan`, `Urutan Status`) dengan **Hide in report view**, serta halaman pembantu.
- [ ] **Lock objects** — **View > Lock objects**; matikan Gridlines/Snap selepas susun atur siap.
- [ ] **Uji seperti pengguna** — klik slicer, drill, dan **Reset** sebelum publish.
- [ ] **Format measure** betul — `%` sebagai Percentage, `RM` sebagai Currency.

> *(Sumber: slaid "Pre-publish checklist".)*

---

## Langkah 8: Terbitkan ke Power BI Service

Untuk berkongsi dashboard dalam talian, terbitkan ke **Power BI Service**.

### Sediakan akaun (jika belum ada)

Power BI Service kini sebahagian daripada portal bersepadu **Microsoft Fabric**. Untuk menerbitkan, anda perlukan akaun kerja/sekolah dan lesen Power BI:

1. Daftar/log masuk dengan akaun **Microsoft 365** (akaun organisasi — bukan Gmail/Hotmail).
2. Layari [`powerbi.com`](https://powerbi.com), masukkan e-mel Microsoft 365 anda, dan ikut gesaan untuk mengaktifkan **percubaan percuma Microsoft Fabric** (Fabric trial). Ini memberi anda ruang kerja untuk menerbitkan.

> **Nota:** Jika organisasi anda sudah memberi lesen **Power BI Pro** atau **Premium Per User (PPU)**, anda boleh terus ke langkah Terbitkan tanpa percubaan Fabric.

### Terbitkan

1. Pada reben **Home**, klik **Publish**.
2. Log masuk dengan **akaun kerja/sekolah** (Microsoft 365).
3. Pilih ruang kerja (cth: *My workspace*).
4. Selepas siap, klik pautan **"Open in Power BI"**.

> **Apa yang berlaku semasa Publish?** Power BI memuat naik **dua item** ke ruang kerja: satu **model semantik (semantic model)** — data + hubungan + sukatan DAX anda — dan satu **laporan** yang dipautkan kepadanya. (Istilah *semantic model* ialah nama baharu untuk apa yang dahulu dipanggil *dataset*.)

### Cipta dashboard

Dalam Power BI Service, terdapat **tiga** jenis item utama:
- **Model semantik (semantic model)** — lapisan data: jadual, hubungan, dan sukatan DAX. Satu model boleh dikongsi oleh banyak laporan.
- **Laporan (report)** — berbilang halaman, interaktif penuh; mengambil data daripada model semantik.
- **Dashboard** — satu kanvas yang menyemat (pin) visual penting daripada satu atau lebih laporan.

Buka laporan anda, hover pada satu visual, klik ikon **Pin** (📌), dan cipta dashboard baharu. Ulang untuk visual KPI utama.

### Q&A — tanya dalam bahasa biasa

Pada dashboard, gunakan kotak **"Ask a question about your data"**. Cuba taip:
- *"Jumlah Aduan by agensi"*
- *"Jumlah Kompaun by negeri"*

Power BI akan menjana visual secara automatik.

### Kongsi & refresh

- **Share** — klik **Share** untuk memberi akses kepada rakan sekerja (dalam organisasi yang sama).
- **Scheduled refresh** — untuk data sebenar (bukan CSV statik), anda boleh sediakan **gateway** dan jadual segar semula automatik supaya dashboard sentiasa terkini.

---

## Cara Menjalankan Aplikasi

Tiada pelayan untuk dijalankan — Power BI Desktop ialah aplikasi desktop. Untuk meneruskan:

1. Buka fail `.pbix` Hari 1 dalam **Power BI Desktop**.
2. Ikut Langkah 1–7 untuk menambah Kalendar, sukatan, dan visual.
3. **Save** kerap (`Ctrl+S`).
4. **Refresh** data jika anda mengubah fail CSV: reben **Home** > **Refresh**.
5. Untuk Langkah 8, anda memerlukan akaun kerja/sekolah dan sambungan internet.

Rujuk `snippets/measures.dax` dan `snippets/calculated-columns.dax` untuk semua kod DAX yang boleh disalin, dan `snippets/lab.md` untuk latihan.

---

## Latihan Tambahan — Contoh Kes Penggunaan (DAX & Visual)

Kes ini melanjutkan kemahiran Hari 2 dengan **soalan pengurusan sebenar** NRES. Sukatan tambahan disediakan dalam `snippets/measures.dax` (bahagian "Sukatan Tambahan"); fail `data/sasaran.csv` diperlukan untuk kes berkaitan sasaran. Cuba sekurang-kurangnya tiga.

### Kes 1 — KPI visual: bulan ini vs bulan lepas
**Soalan:** *Adakah kemasukan aduan bulan ini naik atau turun?*

1. Bina visual **KPI**.
2. **Value:** `Jumlah Aduan` · **Trend axis:** `Kalendar[Tahun-Bulan]` · **Target:** `Aduan Bulan Lepas`.
3. KPI menunjukkan nilai semasa, garis trend, dan warna (capai/tak capai sasaran) — tanpa data tambahan.

### Kes 2 — Prestasi agensi vs sasaran (gauge / heat-map)
**Soalan:** *Agensi mana mencapai sasaran % Selesai?*

1. Muat `sasaran.csv` dan cipta `Sasaran % Selesai` + `Warna % Selesai` (lihat Langkah 6 › Conditional formatting).
2. **Pilihan A — Gauge:** Value = `% Selesai`, Target = `Sasaran % Selesai`, satu gauge per agensi (guna slicer).
3. **Pilihan B — Matrix heat-map:** Rows = `agensi`, Values = `% Selesai`, background = Field value `Warna % Selesai` (hijau/merah).

### Kes 3 — Analisis Pareto (80/20) dengan Quick measure
**Soalan:** *Berapa kategori menyumbang majoriti nilai kompaun?*

1. **New quick measure > Running total** bagi `Jumlah Kompaun (RM)` mengikut `kategori`.
2. Tambah satu lagi quick measure **% of total** bagi `Jumlah Kompaun (RM)`.
3. Bina **Line and clustered column chart**: lajur = kompaun per kategori (susun menurun), garis = running total % — lihat di mana ia cecah ~80%.

### Kes 4 — Purata bergerak 3 bulan (smoothing trend)
**Soalan:** *Apakah trend sebenar tanpa "bunyi" bulanan?*

1. Guna measure `Aduan Purata 3 Bulan` (rujuk `measures.dax`).
2. Pada **line chart** trend, tambah ia sebagai garisan kedua di sebelah `Jumlah Aduan`. Garis purata bergerak melicinkan turun-naik.

### Kes 5 — Ranking negeri dengan RANKX
**Soalan:** *Apakah kedudukan setiap negeri mengikut jumlah aduan?*

1. Guna measure `Pangkat Negeri` (rujuk `measures.dax`).
2. Bina **Table**: `negeri[negeri]`, `Jumlah Aduan`, `Pangkat Negeri`. Susun ikut pangkat.
3. Gabungkan dengan **Top-N filter** (Langkah 6) untuk fokus 5 teratas.

### Kes 6 — Peta per kapita (perbandingan adil)
**Soalan:** *Negeri mana tinggi aduan **berbanding populasi**?*

1. Guna measure `Aduan per 100k Penduduk`.
2. Bina **Filled map**: Location = `negeri[negeri]`, Saturation = `Aduan per 100k Penduduk`. Bandingkan dengan peta Jumlah Aduan mentah — negeri kecil mungkin "naik" selepas dinormalkan.

### Kes 7 — Kategori dalam setiap agensi (small multiples)
**Soalan:** *Bagaimana taburan status berbeza antara kategori dalam setiap agensi?*

1. Bina **Stacked bar chart**: Y-axis = `kategori[kategori]`, Legend = `aduan[status]`, Values = `Jumlah Aduan`.
2. Seret `agensi[singkatan]` ke telaga **Small multiples** (rujuk Langkah 6).
3. Perhatikan panel **JAS** (3 kategori) vs **JPSM** (2) vs agensi lain (1) — banding corak status setiap kategori secara adil dalam satu pandangan.

> NRES: "Agensi mana ada kategori dengan kes 'Baru' menumpuk?" — small multiples mendedahkan corak per-kategori yang tersembunyi dalam jumlah agensi agregat.

> **🎯 Cabaran gabungan — dashboard eksekutif NRES:** Satukan **KPI (Kes 1)** + **matrix heat-map sasaran (Kes 2)** + **peta Top-5 (Kes 5/6)** + **line chart dengan purata 3 bulan (Kes 4)** pada satu halaman. Pakai satu **Report theme** (Accessible), tetapkan **report-level filter** tahun semasa, dan lengkapkan **senarai semak sebelum publish** (Langkah 7B) sebelum menerbitkan.

---

## Ringkasan Hari 2

Anda telah berjaya:

- [x] Mencipta jadual **Kalendar** dengan DAX dan menandanya sebagai jadual tarikh
- [x] Menambah **lajur terkira**: `Tahun`, `Tempoh Hari`, `Kumpulan Tempoh`
- [x] Mencipta **13 sukatan** — kiraan, peratus, kewangan (RM), dan kepintaran masa
- [x] Memahami `CALCULATE`, `DIVIDE`, `AVERAGEX`, `FILTER`, `TOTALYTD`, `DATEADD`
- [x] Memahami **evaluation context** (row vs filter) dan mencuba **Quick measures**
- [x] Membina visual **line, map, matrix** dengan pemformatan kemas
- [x] Membetulkan susunan dengan **Sort by Column** & menyemak/troubleshoot sukatan
- [x] Menggunakan **conditional formatting** (sasaran), **Top-N filtering**, dan **report theme**
- [x] Memahami **skop penapis** (visual/page/report) dan **senarai semak sebelum publish**
- [x] Menyusun **dashboard interaktif** dengan slicer dan edit interactions
- [x] **Menerbitkan** ke Power BI Service (model semantik + laporan) dan mencipta dashboard + Q&A

---

## Penutup Kursus

Tahniah! 🎉 Dalam masa **2 hari**, anda telah membina sebuah **Dashboard Aduan Alam Sekitar NRES** yang lengkap — daripada fail CSV mentah kepada dashboard interaktif yang diterbitkan dalam talian.

Anda kini boleh:
- **Memuat & membersihkan** data dengan Power Query
- **Memodel** data menggunakan skema bintang dan hubungan
- **Mengira** dengan DAX (sukatan, lajur terkira, kepintaran masa)
- **Memvisualkan** dengan carta, peta, dan matriks
- **Menerbitkan & berkongsi** melalui Power BI Service

### Langkah seterusnya untuk belajar

| Topik | Penerangan |
|-------|------------|
| **Row-Level Security (RLS)** | Hadkan data yang dilihat pengguna mengikut peranan (cth: pegawai negeri hanya nampak negerinya) |
| **Drillthrough** | Klik satu negeri untuk pergi ke halaman butiran khusus negeri itu |
| **Bookmarks & Buttons** | Cipta navigasi tersuai dan "cerita" data yang interaktif |
| **DAX lanjutan** | `VAR`, `RANKX`, `CALCULATETABLE`, fungsi konteks penapis |
| **Gateway & refresh** | Sambung ke pangkalan data sebenar dengan segar semula automatik |
| **Power BI Service** | Apps, ruang kerja berkongsi, dan tadbir urus data |

Teruskan berlatih dengan data anda sendiri — itulah cara terbaik untuk mahir Power BI!

> **Sumber:** [Dokumentasi Power BI](https://learn.microsoft.com/power-bi/) · [Rujukan DAX](https://learn.microsoft.com/dax/) · [Portal NRES](https://www.nres.gov.my/ms-my/Pages/default.aspx)
