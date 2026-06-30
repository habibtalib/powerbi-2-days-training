# Hari 1 — Panduan Bengkel: Dashboard Aduan Alam Sekitar NRES

Panduan langkah demi langkah untuk membina **Dashboard Aduan Alam Sekitar** menggunakan **Microsoft Power BI Desktop**. Pada akhir bengkel ini (~6 jam), anda akan mempunyai model data lengkap (skema bintang) dan laporan asas yang memaparkan aduan alam sekitar yang dikendalikan oleh pelbagai agensi di bawah **Kementerian Sumber Asli dan Kelestarian Alam (NRES)**.

**Apa yang akan dibina:**
- Sambungan ke 4 fail data CSV (`aduan`, `agensi`, `negeri`, `kategori`)
- Pembersihan data menggunakan **Power Query** (naik tajuk, ubah jenis, trim, lajur tersuai)
- Model **skema bintang** dengan 3 hubungan satu-ke-banyak
- 4 visual asas (Card, Bar chart, Donut, Column chart) + **Slicer** interaktif

> **Nota domain:** Data dalam kursus ini dijana untuk latihan sahaja dan **bukan** data rasmi NRES. Inspirasi: portal [nres.gov.my](https://www.nres.gov.my/ms-my/Pages/default.aspx) dan agensi di bawahnya — JAS, JPSM, PERHILITAN, JMG, dan JPS.

---

## Persediaan

### 1. Pasang Power BI Desktop

Power BI Desktop adalah **percuma** dan hanya untuk **Windows**. Pilih salah satu cara:

- **Microsoft Store** (disyorkan) — cari "Power BI Desktop", klik **Get/Install**. Kelebihan: kemas kini automatik.
- **Muat turun terus** — [powerbi.microsoft.com/desktop](https://powerbi.microsoft.com/desktop/), jalankan pemasang `.exe`.

> **Nota untuk pengguna macOS:** Power BI Desktop tidak tersedia untuk macOS. Anda perlu menjalankannya melalui mesin maya Windows (Parallels, VMware, atau UTM) atau perkhidmatan **Windows 365**.

Selepas dipasang, buka Power BI Desktop. Jika muncul skrin alu-aluan (splash), tutup sahaja untuk masuk ke kanvas kosong.

### 2. Salin Folder Data

Salin folder `data/` (mengandungi `aduan.csv`, `agensi.csv`, `negeri.csv`, `kategori.csv`) ke lokasi mudah, contohnya:

```
C:\Kursus-PowerBI\data\
```

> **Nota:** Elakkan laluan yang terlalu panjang atau folder OneDrive yang belum disegerak, kerana ia kadangkala menyukarkan Power BI mencari fail.

### 3. Kenali Antara Muka Power BI Desktop

Sebelum mula, kenali bahagian utama tetingkap Power BI Desktop:

| Bahagian | Fungsi |
|----------|--------|
| **Header** (paling atas) | Butang Save / Undo / Redo, nama fail (`.pbix`), Search, dan **Sign in** akaun Microsoft 365 |
| **Ribbon** (atas) | Tab kekal (File, Home, Help) + tab kontekstual (Modeling, View, Insert, Format, Table/Column/Measure tools) |
| **Formula Bar** | Tempat menulis **DAX** untuk measure, calculated column & calculated table (muncul ikut konteks) |
| **Kanvas** (tengah) | Tempat anda susun visual laporan |
| **Anak tetingkap Visualizations** (kanan) | Pilih jenis carta & seret medan ke dalam slot (Axis, Values, Legend) |
| **Anak tetingkap Data / Fields** (paling kanan) | Senarai semua jadual & lajur dalam model |
| **Footer** (bawah) | Bilangan halaman, kawalan zoom, dan statistik jadual/lajur |
| **Ikon paparan** (tepi kiri) | Tukar antara paparan **Report**, **Table**, dan **Model** |

**Tiga paparan utama** (ikon di tepi kiri tetingkap):

1. **Report view** (ikon carta) — bina dan susun visual.
2. **Table view** (ikon jadual) — lihat data dalam bentuk jadual.
3. **Model view** (ikon hubungan/gambarajah) — uruskan jadual dan hubungan.

> **Konsep penting:** Kita akan kerap bertukar antara tiga paparan ini sepanjang kursus. Ingat lokasi ikon di tepi kiri.

> **Nota:** Versi terkini Power BI Desktop menambah paparan ke-4, **DAX Query view**, untuk menjalankan kueri DAX secara langsung. Ia untuk pengguna lanjutan — **tidak digunakan** dalam bengkel ini.

---

## Pengenalan Power BI

**Power BI** ialah alat *business intelligence* (BI) daripada Microsoft untuk menukar data mentah menjadi laporan dan dashboard interaktif.

> **Konsep — Anatomi BI:** Mana-mana projek BI merangkumi lima konsep teras: **Domain** (bidang perniagaan — di sini, penguatkuasaan alam sekitar NRES), **Data** (punca data — fail CSV aduan), **Model** (model semantik: bersih, kategori & hubungkan), **Analysis** (agregat & KPI dengan DAX), dan **Visualization** (carta, laporan & dashboard). Hari 1 meliputi Domain → Data → Model → Visualization asas.

> **Konsep — Power BI ialah koleksi komponen,** bukan satu aplikasi tunggal: **Power Query** (transformasi data/ETL, bahasa M), **Power Pivot** (pemodelan + DAX → model semantik), **visual** (kanvas laporan), **Power BI Desktop** (tempat kerja kita), **Power BI Service** (awan untuk terbit & kongsi — kini sebahagian Microsoft Fabric), serta **Gateway** & **apl mudah alih**. Power BI Desktop **percuma**; ia menanam Power Query dan Power Pivot di dalamnya.

Aliran kerja Power BI sentiasa mengikut 5 peringkat ini:

```
  Get Data  →  Transform  →  Model  →  Visualize  →  Publish
  (sambung)    (Power Query)  (hubungan)  (carta)     (kongsi)
```

| Peringkat | Apa yang berlaku | Alat |
|-----------|------------------|------|
| **Get Data** | Sambung ke punca data (CSV, Excel, pangkalan data, web) | Get Data |
| **Transform** | Bersih & bentuk data | Power Query (bahasa M) |
| **Model** | Hubungkan jadual & cipta pengiraan | Model view + DAX |
| **Visualize** | Bina carta & dashboard | Report view |
| **Publish** | Terbit & kongsi dalam talian | Power BI Service |

Pada **Hari 1**, kita fokus pada **Get Data → Transform → Model → Visualize (asas)**. Pada **Hari 2**, kita dalami pengiraan **DAX**, visual lanjutan, dan **Publish**.

---

## Langkah 1: Muat Data (Get Data)

Kita akan import keempat-empat fail CSV.

### Import fail pertama (`aduan.csv`)

1. Pada **Ribbon > Home**, klik **Get data**.
2. Pilih **Text/CSV**, kemudian klik **Connect**.
3. Layari ke folder `data/`, pilih **`aduan.csv`**, klik **Open**.
4. Tetingkap pratonton (**Navigator**) akan muncul, menunjukkan data dalam jadual.

> **Konsep penting — "Load" vs "Transform Data":**
> - **Load** terus memuat data tanpa pembersihan.
> - **Transform Data** membuka **Power Query Editor** untuk bersihkan data dahulu.
>
> Untuk `aduan.csv`, kita mahu bersihkan dahulu — jadi klik **Transform Data** (kita akan teruskan di Langkah 2).

Buat masa ini, jika anda klik Transform Data, Power Query Editor akan terbuka. **Jangan tutup dulu** — teruskan ke Langkah 2.

### Import tiga fail dimensi

Ulang proses untuk `agensi.csv`, `negeri.csv`, dan `kategori.csv`. Fail dimensi ini lebih kecil dan bersih, jadi anda boleh terus klik **Load** (atau Transform Data jika mahu semak).

Selepas selesai, anda sepatutnya nampak **4 jadual** dalam anak tetingkap **Data** (sebelah kanan):

- `aduan`
- `agensi`
- `negeri`
- `kategori`

> **Nota:** Jika anda tutup Power Query secara tidak sengaja, anda boleh buka semula bila-bila masa melalui **Home > Transform data**.

---

## Langkah 2: Bersihkan Data dengan Power Query

**Power Query** ialah enjin transformasi data Power BI (sejenis alat **ETL** — Extract, Transform, Load).

> **Konsep — Query sebagai resipi:** Setiap query ialah satu senarai **Applied Steps** yang dirakam mengikut urutan (Power BI auto-jana langkah awal: *Source*, *Promoted Headers*, *Changed Type*). Klik mana-mana langkah untuk melihat keadaan data pada peringkat itu — anda boleh edit, susun semula, atau buang (X). Di sebalik tabir, setiap langkah ialah satu baris kod **M**. Apabila data baharu masuk, satu klik **Refresh** menjalankan semula **semua** langkah secara automatik — sebab itu kita bersihkan di sini, bukan dalam Excel.

Buka **Power Query Editor** (jika belum terbuka): **Home > Transform data**. Pilih query **`aduan`** di anak tetingkap **Queries** (kiri).

> **Konsep — gabung & bentuk data** (data utama kita sudah kemas, tetapi teknik ini penting untuk data dunia sebenar — **latihan amali penuh di [Langkah 2B](#langkah-2b-pilihan-gabung--bentuk-data--merge-append--unpivot)**):
> - **Merge** = cantum dua query ikut lajur sepadan (seperti SQL *JOIN*) → menambah **lajur**.
> - **Append** = tindan baris dua/lebih query → menambah **baris** (cth satukan fail aduan Jan + Feb + Mac menjadi satu jadual `aduan`).
> - **Unpivot Columns** = tukar data "wide" (satu lajur per kategori/bulan) kepada format panjang (lajur *Attribute* + *Value*) supaya mudah dijumlah & ditapis.
> - Query perantara boleh dimatikan **Enable load** supaya ia tidak menjadi jadual berasingan dalam model.

### 2.1 Naikkan tajuk (Promote Headers)

Jika baris pertama data masih dilabel `Column1`, `Column2`, ...:

- Klik **Home > Use First Row as Headers**.

Ini menjadikan baris pertama (`no_aduan`, `tarikh_terima`, dll.) sebagai nama lajur.

### 2.2 Tetapkan jenis data (Data Types)

Jenis data yang betul amat penting untuk pengiraan kemudian. Klik ikon jenis di sebelah kiri setiap nama lajur, kemudian pilih:

| Lajur | Jenis data |
|-------|------------|
| `no_aduan` | Text |
| `tarikh_terima` | **Date** |
| `tarikh_selesai` | **Date** |
| `kategori`, `agensi`, `negeri`, `status`, `tindakan` | Text |
| `amaun_kompaun` | **Currency** (Fixed decimal number) |

> **Konsep penting:** Jika `tarikh_terima` kekal sebagai *Text*, fungsi tarikh dan kepintaran masa (time intelligence) **tidak akan berfungsi** pada Hari 2. Pastikan ia bertukar menjadi ikon kalendar (Date).

### 2.3 Trim ruang berlebihan

Untuk mengelak nilai seperti `"Selangor "` dan `"Selangor"` dikira sebagai dua kategori berbeza:

1. Pilih lajur `kategori`, `agensi`, `negeri`, dan `status` (tahan **Ctrl** untuk pilih berbilang).
2. Klik **Transform > Format > Trim**.

### 2.4 Gantikan nilai kosong amaun kompaun

Lajur `amaun_kompaun` kosong untuk kes tanpa kompaun. Kita gantikan dengan 0 supaya mudah dijumlahkan:

1. Pilih lajur `amaun_kompaun`.
2. Klik **Transform > Replace Values**.
3. **Value To Find:** biarkan kosong (atau gunakan `null`) — sebenarnya cara paling selamat ialah klik kanan lajur > **Replace Values** dan ganti `null` dengan `0`.

> **Nota:** Dalam kod M, langkah ini ditulis sebagai `Table.ReplaceValue(..., null, 0, ...)`. Lihat fail rujukan `snippets/power-query.m`.

### 2.5 Tambah lajur tersuai (Custom Column): `tempoh_hari`

Kita kira berapa hari diambil untuk selesaikan setiap kes:

1. Klik **Add Column > Custom Column**.
2. **New column name:** `tempoh_hari`
3. **Custom column formula:**
   ```m
   if [tarikh_selesai] = null then null
   else Duration.Days([tarikh_selesai] - [tarikh_terima])
   ```
4. Klik **OK**.
5. Tukar jenis lajur baru `tempoh_hari` kepada **Whole Number**.

### 2.6 Semak kod M (Advanced Editor)

Semua langkah di atas menghasilkan kod **M**. Untuk melihat (atau menyalin terus) kod penuh, klik **Home > Advanced Editor**. Kod sepatutnya kelihatan seperti ini:

```m
let
    // 1) Punca data — baca fail CSV (UTF-8, pembatas koma)
    Source = Csv.Document(
        File.Contents("C:\Kursus-PowerBI\data\aduan.csv"),
        [Delimiter = ",", Columns = 9, Encoding = 65001, QuoteStyle = QuoteStyle.Csv]
    ),

    // 2) Naikkan baris pertama menjadi tajuk lajur
    NaikTajuk = Table.PromoteHeaders(Source, [PromoteAllScalars = true]),

    // 3) Tetapkan jenis data setiap lajur
    UbahJenis = Table.TransformColumnTypes(NaikTajuk, {
        {"no_aduan", type text},
        {"tarikh_terima", type date},
        {"tarikh_selesai", type date},
        {"kategori", type text},
        {"agensi", type text},
        {"negeri", type text},
        {"status", type text},
        {"tindakan", type text},
        {"amaun_kompaun", Currency.Type}
    }),

    // 4) Buang ruang berlebihan pada teks (kemas data)
    KemasTeks = Table.TransformColumns(UbahJenis, {
        {"kategori", Text.Trim, type text},
        {"agensi", Text.Trim, type text},
        {"negeri", Text.Trim, type text},
        {"status", Text.Trim, type text}
    }),

    // 5) Gantikan nilai kosong amaun kompaun dengan 0 (memudahkan pengiraan)
    GantiKosong = Table.ReplaceValue(KemasTeks, null, 0, Replacer.ReplaceValue, {"amaun_kompaun"}),

    // 6) Tambah lajur tersuai: tempoh hari untuk selesaikan aduan
    //    (kosong jika belum selesai)
    TambahTempoh = Table.AddColumn(GantiKosong, "tempoh_hari", each
        if [tarikh_selesai] = null then null
        else Duration.Days([tarikh_selesai] - [tarikh_terima]),
        Int64.Type
    )
in
    TambahTempoh
```

**Penerangan kod M:**

| Langkah | Fungsi |
|---------|--------|
| `Csv.Document` | Baca fail CSV mentah |
| `Table.PromoteHeaders` | Jadikan baris pertama sebagai tajuk lajur |
| `Table.TransformColumnTypes` | Tetapkan jenis data setiap lajur |
| `Table.TransformColumns` + `Text.Trim` | Buang ruang berlebihan pada teks |
| `Table.ReplaceValue` | Tukar `null` kepada `0` pada `amaun_kompaun` |
| `Table.AddColumn` + `Duration.Days` | Cipta lajur `tempoh_hari` |

> **Nota:** Setiap baris dalam senarai **Applied Steps** (sebelah kanan Power Query) sepadan dengan satu baris kod M. Anda boleh klik mana-mana langkah untuk melihat keadaan data pada peringkat itu.

### 2.7 Semak kualiti & profil data (Data Profiling)

Sebelum memuatkan data, gunakan **alat profil data** terbina Power Query untuk mengesahkan data anda bersih. Pada reben **View**, hidupkan tiga kotak semak:

| Pilihan (View) | Apa yang ditunjukkan |
|----------------|----------------------|
| **Column quality** | Peratus baris **Valid / Error / Empty** bagi setiap lajur (jalur kecil di bawah tajuk lajur) |
| **Column distribution** | Histogram taburan + bilangan nilai **distinct** dan **unique** |
| **Column profile** | Statistik penuh (min/max, kiraan kosong, ralat) untuk lajur terpilih di panel bawah |

Perkara untuk disemak:

- Lajur `amaun_kompaun` sepatutnya **0% Empty** selepas Langkah 2.4 (ganti `null` dengan 0).
- Lajur `negeri` sepatutnya menunjukkan **16 nilai distinct** — jika lebih, mungkin ada ruang berlebihan yang belum di-*trim* (Langkah 2.3).
- Lajur tarikh sepatutnya **0% Error** — jika ada Error, jenis data salah ditetapkan.

> **Nota:** Secara lalai, profil dikira berdasarkan **1,000 baris pertama** sahaja. Untuk dataset kecil seperti ini, klik status di bar bawah dan pilih **Column profiling based on entire data set** untuk profil penuh.

### 2.8 Close & Apply

Setelah selesai, klik **Home > Close & Apply** (sebelah kiri Ribbon). Power BI akan memuatkan data yang telah dibersihkan ke dalam model dan kembali ke Report view.

---

## Langkah 2B (Pilihan): Gabung & Bentuk Data — Merge, Append & Unpivot

> **Bila guna bahagian ini?** Data teras kursus (`aduan.csv` + 3 dimensi) sudah kemas, jadi bahagian ini **tidak wajib** untuk membina dashboard utama. Tetapi dalam dunia sebenar, data jarang sekemas itu — ia datang **berpecah** (fail bulanan berasingan), **berselerak** (perlu lookup dari fail lain), atau **sudah diringkaskan** (pivot table mengikut tahun/kategori). Tiga teknik dalam slaid menangani ketiga-tiga keadaan. Fail latihan disediakan dalam folder `data/`; kod M rujukan dalam [`snippets/power-query-gabung.m`](./snippets/power-query-gabung.m).

| Keadaan data sebenar | Teknik | Kesan |
|----------------------|--------|-------|
| Fail bulanan berasingan (Julai, Ogos, …) | **Append** | Tambah **baris** |
| Maklumat tambahan dalam fail lain (pegawai, sasaran) | **Merge** | Tambah **lajur** |
| Sudah diringkaskan: lajur = kategori, nilai = jumlah | **Unpivot** | Bentuk semula → **long** |

### 2B.1 Append — satukan fail aduan bulanan (tambah BARIS)

Bayangkan setiap bulan satu eksport baharu tiba: `aduan_2026_07.csv`, `aduan_2026_08.csv`. Skema sama (9 lajur), cuma baris berbeza. **Append** menindan baris menjadi satu jadual.

1. **Get Data > Text/CSV** → import `aduan_2026_07.csv` (klik **Transform Data**). Ulang untuk `aduan_2026_08.csv`. Naikkan tajuk jika perlu.
2. Pada **Home > Append Queries > Append Queries as New**.
3. Pilih **Three or more tables** jika ada banyak, atau dua jadual bulanan tadi, klik **OK**.
4. Hasilnya satu jadual bertindan. Namakan semula `aduan_gabung`.

> **Konsep:** Append = **UNION baris** (seperti menyusun kertas). Nama lajur mesti sepadan; lajur yang tiada padanan jadi `null`. **Petua pro:** guna penyambung **Folder** (Get Data > Folder) untuk auto-append **semua** fail dalam satu folder — sesuai untuk eksport bulanan berterusan tanpa edit query setiap bulan.

### 2B.2 Merge — bawa maklumat pegawai (tambah LAJUR)

Fail `pegawai.csv` menyenaraikan pegawai bertanggungjawab + emel bagi setiap agensi. Kita **Merge** ia ke dalam dimensi `agensi` (memperkaya jadual rujukan — seperti SQL **JOIN**).

1. **Get Data > Text/CSV** → import `pegawai.csv`.
2. Pilih query **`agensi`** di anak tetingkap Queries → **Home > Merge Queries**.
3. Pada jadual atas (`agensi`), klik tajuk lajur **`agensi`**. Pada jadual bawah, pilih **`pegawai`** dan klik lajur **`agensi`** juga.
4. **Join Kind: Left Outer** (kekalkan semua baris agensi). Klik **OK**.
5. Satu lajur baharu **`Pegawai`** (jadual bersarang) muncul. Klik ikon **Expand (⇔)** di tajuknya → tanda `pegawai` dan `emel` → **OK**.
6. Jadual `agensi` kini ada lajur `pegawai` & `emel`.

> **Konsep — 6 Join Kind:** *Left/Right/Full Outer*, *Inner*, *Left/Right Anti*. **Left Outer** paling biasa (kekal semua baris kiri, isi padanan kanan). **Inner** = baris yang ada di kedua-dua sahaja. **Anti** = cari baris yang **tiada** padanan (berguna semak data hilang).
>
> **Nota model:** Untuk hubungkan **fakta ↔ dimensi** (cth `aduan` ↔ `agensi`), kita guna **relationship** (Langkah 4), **bukan** Merge. Merge sesuai untuk **mencantum dua fail yang menerangkan entiti sama** (di sini: dua fail tentang agensi) menjadi satu dimensi yang lebih lengkap.

### 2B.3 Unpivot — bentuk semula data ringkasan "wide" kepada "long"

Selalunya data sampai dalam bentuk **pivot table** yang sudah diringkaskan — `aduan_ringkasan.csv` ialah kiraan aduan **mengikut tahun (baris) × kategori (lajur)**:

```
Tahun | Pencemaran Air | Pencemaran Udara | ... | Hakisan Pantai & Banjir
2022  | 38             | 61               | ... | 72
2023  | 44             | 70               | ... | 85
```

Power BI mahukan bentuk **panjang (long/tidy)** — satu baris per Tahun × kategori:

```
Tahun | kategori          | bilangan
2022  | Pencemaran Air    | 38
2022  | Pencemaran Udara  | 61
...
```

**Langkah:**

1. **Get Data > Text/CSV** → import `aduan_ringkasan.csv` (klik **Transform Data**). Naikkan tajuk.
2. Klik **satu kali** pada tajuk lajur **`Tahun`** untuk memilihnya.
3. **Klik kanan `Tahun` > Unpivot Other Columns.** *(Pilih "Other Columns", bukan "Unpivot Columns" — supaya kategori baharu tahun depan ikut serta automatik.)*
4. Namakan semula lajur baharu: `Attribute` → **`kategori`**, `Value` → **`bilangan`**.
5. Tetapkan jenis: `Tahun` Whole Number, `kategori` Text, `bilangan` Whole Number → **Close & Apply**.

> **⚠️ Penting — agregasi bersifat sehala (lossy):** Unpivot memulihkan bentuk **tidy long**, **bukan** baris transaksi asal. Apabila data sudah dijumlahkan (`38` aduan), anda **tidak boleh** memulihkan 38 rekod individu (tarikh, negeri, kompaun masing-masing sudah hilang). Untuk data peringkat transaksi sebenar, perlu kembali ke **sistem sumber**. Kerana `bilangan` ialah **jumlah terkumpul**, agregat dengan **Sum** (bukan Count) dalam visual.

> **Lanjutan — tajuk berbilang baris:** Eksport kerajaan kadangkala ada **tajuk bergabung 2 baris** (Tahun di atas Kategori). Sebelum unpivot: **Transpose** → **Fill Down** sel bergabung → **Merge Columns** dua baris tajuk → **Transpose** semula → barulah **Unpivot**.

### 2B.4 Enable Load — query perantara (staging)

Selepas Append/Merge, query sumber asal (cth jadual bulanan) selalunya tak perlu wujud sebagai jadual berasingan dalam model.

1. Klik kanan query perantara di anak tetingkap **Queries**.
2. **Nyahtanda Enable load** — query masih berjalan sebagai *staging* (sumber kepada `aduan_gabung`) tetapi tidak menjadi jadual dalam model semantik.
3. Pilihan **Include in report refresh** mengawal sama ada ia disegar semula.

> **Faedah:** model lebih kemas (hanya jadual yang benar-benar diperlukan), saiz lebih kecil, dan senarai Fields tidak berselerak.

---

## Langkah 3: Semak Data

Mari sahkan data dimuat dengan betul.

1. Klik ikon **Table view** (di tepi kiri).
2. Pilih jadual `aduan` di anak tetingkap Data.
3. Semak:
   - Lajur `tarikh_terima` & `tarikh_selesai` memaparkan tarikh (bukan teks).
   - Lajur `amaun_kompaun` memaparkan nilai mata wang (tiada `null`).
   - Lajur baru `tempoh_hari` wujud dan menunjukkan nombor untuk kes **Selesai**, dan kosong untuk kes lain.

> **Nota:** Di bahagian bawah Table view, Power BI memaparkan jumlah baris (cth. *480 rows*). Sahkan ia menghampiri 480.

---

## Langkah 4: Bina Model & Hubungan

Sekarang kita hubungkan jadual fakta dengan jadual dimensi — inilah **pemodelan data**.

### Konsep skema bintang

Klik ikon **Model view** (di tepi kiri). Anda akan nampak 4 kotak jadual.

```
   agensi (1) ──< (banyak) aduan (banyak) >── (1) negeri
                            │
                      (1) kategori
```

| Jenis jadual | Maksud | Contoh |
|--------------|--------|--------|
| **Jadual fakta** | Jadual besar yang merekod peristiwa/transaksi | `aduan` (≈480 baris) |
| **Jadual dimensi** | Jadual rujukan yang menerangkan fakta | `agensi`, `negeri`, `kategori` |

> **Konsep penting — Skema bintang:** Satu jadual fakta di tengah, dikelilingi jadual dimensi. Reka bentuk ini memudahkan penapisan, pengiraan, dan menjadikan model laju serta mudah difahami.

> **Istilah — Model semantik (semantic model):** Gabungan jadual, hubungan, dan pengiraan (DAX) yang anda bina di sini secara rasmi dipanggil **model semantik** (*semantic model*). Microsoft menamakan semula istilah lama *dataset* kepada **semantic model** pada 2023. Apabila anda menerbitkan `.pbix` ke Power BI Service nanti (Hari 2), model semantik inilah yang dimuat naik bersama laporan.

### Cipta hubungan

Power BI mungkin telah **auto-detect** sebahagian hubungan. Semak dan cipta yang berikut secara manual jika perlu.

**Cara cipta hubungan (seret dan lepas):**

1. Dalam Model view, seret medan `agensi` dari jadual **`aduan`** ke medan `agensi` dalam jadual **`agensi`**.
2. Satu garisan penghubung akan muncul.

Ulang untuk ketiga-tiga hubungan:

| Dari (jadual fakta) | Ke (jadual dimensi) | Jenis |
|---------------------|---------------------|-------|
| `aduan[agensi]` | `agensi[agensi]` | Many-to-one (*:1) |
| `aduan[negeri]` | `negeri[negeri]` | Many-to-one (*:1) |
| `aduan[kategori]` | `kategori[kategori]` | Many-to-one (*:1) |

**Untuk menyemak/mengedit hubungan:** klik dua kali pada garisan penghubung (atau **Home > Manage relationships**). Pastikan:

- **Cardinality:** *Many to one (\*:1)* — banyak aduan untuk satu agensi.
- **Cross-filter direction:** *Single* — penapis mengalir dari dimensi ke fakta.

> **Konsep penting — Cardinality & arah penapis:**
> - **Cardinality** ada 4 jenis: *One-to-one*, *One-to-many*, *Many-to-one (\*:1)*, dan *Many-to-many*. Garisan tunjuk **1** di sisi unik (dimensi) dan **\*** di sisi banyak (fakta). Skema bintang sentiasa guna One-to-many / Many-to-one.
> - **Many-to-one (\*:1)** bermakna banyak baris `aduan` boleh berkongsi satu `agensi`.
> - **Cross-filter direction:** *Single* (penapis mengalir satu arah, dimensi → fakta) atau *Both* (dua arah — guna berhati-hati). Untuk skema bintang, kekalkan **Single**.
> - Hanya **satu** hubungan boleh **active** (garisan pejal) antara dua jadual; yang lain *inactive* (garisan putus-putus). Cipta/edit melalui seret-lepas atau **Home > Manage relationships** (ada **Autodetect**).

---

## Langkah 5: Visual Pertama

Kembali ke **Report view**. Mari bina 4 visual.

### Cara umum membina visual

1. Pada anak tetingkap **Visualizations** (kanan), klik ikon jenis carta yang dikehendaki — satu visual kosong muncul di kanvas.
2. Daripada anak tetingkap **Data/Fields**, seret medan ke dalam slot yang sesuai (Axis, Values, Legend).

> **Konsep — anak tetingkap Visualizations ada 3 tab:**
> - **Build** — pilih jenis visual & seret medan ke slot (X-axis, Y-axis, Legend, Values). Tukar agregasi medan (Sum / Count / Average) guna anak panah turun pada medan.
> - **Format** — ubah rupa: Title, Data labels, font, warna (ada sub-tab *Visual* & *General*).
> - **Analytics** — tambah garisan analitik seperti *Average line* (untuk visual tertentu sahaja, cth column/line chart).
>
> Anda boleh **tukar jenis visual** bila-bila masa dengan klik ikon visual lain — medan kekal terpasang.

### 5.1 Card — Jumlah Aduan

1. Klik visual **Card** (ikon `123`).
2. Seret `aduan[no_aduan]` ke dalam slot **Fields**.
3. Klik anak panah di sebelah `no_aduan` dalam slot itu, pilih **Count**.

Card kini memaparkan jumlah aduan (≈480).

### 5.2 Bar chart — Aduan mengikut Agensi

1. Klik kawasan kosong kanvas, kemudian klik visual **Clustered bar chart**.
2. Seret `agensi[agensi]` ke **Y-axis**.
3. Seret `aduan[no_aduan]` ke **X-axis** (ia akan jadi Count secara automatik).

Anda kini nampak agensi mana menerima paling banyak aduan (JAS biasanya tertinggi).

### 5.3 Donut chart — Aduan mengikut Status

1. Klik visual **Donut chart**.
2. Seret `aduan[status]` ke **Legend**.
3. Seret `aduan[no_aduan]` ke **Values** (Count).

### 5.4 Column chart — Aduan mengikut Kategori

1. Klik visual **Clustered column chart**.
2. Seret `kategori[kategori]` ke **X-axis**.
3. Seret `aduan[no_aduan]` ke **Y-axis** (Count).

> **Nota:** Susun keempat-empat visual dengan kemas di kanvas. Anda boleh seret bucu visual untuk mengubah saiz.

---

## Langkah 6: Slicer & Interaksi

**Slicer** ialah penapis yang boleh diklik pengguna pada laporan.

### Tambah slicer Zon

1. Klik kawasan kosong kanvas, kemudian klik visual **Slicer**.
2. Seret `negeri[zon]` ke dalam slot **Field**.

Satu senarai zon (Utara, Tengah, Selatan, Timur, Borneo) muncul.

### Uji penapisan silang (cross-filtering)

Klik **"Borneo"** pada slicer. Perhatikan **semua visual lain** dikemas kini serentak — Card, Bar, Donut, dan Column hanya menunjukkan data untuk Sabah, Sarawak, dan WP Labuan.

> **Konsep penting — Penapisan silang:** Apabila slicer `zon` (dari jadual `negeri`) menapis, penapis itu mengalir melalui hubungan `aduan[negeri] → negeri[negeri]` dan menapis jadual fakta `aduan`. Inilah kuasa model yang betul.

Klik semula zon yang dipilih untuk membatalkan penapis.

---

## Latihan Tambahan — Contoh Kes Penggunaan (Use Cases)

Bahagian ini mengaitkan kemahiran Hari 1 dengan **soalan pengurusan sebenar** NRES. Kebanyakan kes hanya menggunakan alat Hari 1 — **Power Query**, **model**, **visual asas** (Card, Bar, Donut, Column, Scatter), **Slicer**, dan **Filters pane**. Beberapa kes ditanda **🔜 Pratonton Hari 2** kerana ia menggunakan teknik (Map, Matrix, conditional formatting, Top N, Sort by Column) yang kita dalami sepenuhnya pada Hari 2 — anda boleh cuba sekarang sebagai penambah selera.

> **Petua kerja:**
> - Untuk menapis **satu** visual tanpa slicer, seret medan ke **Filters on this visual** dalam anak tetingkap **Filters**.
> - Untuk menukar cara nombor dikira (**Count / Sum / Average**), klik anak panah turun pada medan di dalam slot visual.
> - Anda belum perlu menulis **measure DAX** di sini — semua pengiraan guna agregasi terbina pada medan. Sukatan DAX bermula Hari 2.

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
3. 🔜 *Pratonton Hari 2:* pada **Filters pane**, tukar Filter type `negeri` kepada **Top N** dan tetapkan **Top 5 By value = Count of no_aduan**.

**Hasil:** ranking negeri dengan aduan tertinggi — fokus untuk penguatkuasaan.

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

### Kes 6 — Taburan tindakan penguatkuasaan
**Soalan pengurusan:** *Berapa kerap setiap jenis tindakan diambil (Amaran / Kompaun / Pendakwaan / Tiada)?*

1. Bina **Donut chart** · **Legend:** `aduan[tindakan]` · **Values:** `aduan[no_aduan]` (Count).
2. (Pilihan) Tambah **Slicer** `agensi[agensi]` untuk bandingkan corak tindakan antara agensi.

**Hasil:** gambaran keseluruhan campuran tindakan penguatkuasaan, dan bagaimana ia berbeza ikut agensi.

### Kes 7 — Beban mengikut zon
**Soalan pengurusan:** *Wilayah/zon mana paling banyak aduan?*

1. Bina **Clustered column chart** · **X-axis:** `negeri[zon]` · **Y-axis:** `aduan[no_aduan]` (Count).
2. Tambah **Slicer** `kategori[kategori]` untuk lihat zon mana mendominasi setiap kategori kes.

**Hasil:** pandangan agregat peringkat zon (Utara, Tengah, Selatan, Timur, Borneo) — guna atribut dimensi `zon`, bukan negeri individu.

### Kes 8 — Aduan berbanding populasi negeri (Scatter)
**Soalan pengurusan:** *Negeri mana mencatat aduan tinggi **berbanding saiz populasinya**?*

1. Bina **Scatter chart**.
2. **X-axis:** `negeri[populasi]` (Sum) · **Y-axis:** `aduan[no_aduan]` (Count) · **Values/Details:** `negeri[negeri]`.
3. Setiap titik = satu negeri. Cari negeri yang **tinggi pada paksi-Y tetapi rendah pada paksi-X** — banyak aduan walaupun populasi kecil.

**Hasil:** analisis kadar relatif — menonjolkan negeri dengan beban aduan luar biasa berbanding populasi.

### Kes 9 — Heatmap aduan mengikut negeri (peta) &nbsp;🔜 *Pratonton Hari 2*
**Soalan pengurusan:** *Di mana tumpuan aduan secara geografi merentas Malaysia?*

1. **Tetapkan kategori data dahulu:** pilih jadual `negeri`, klik lajur `negeri`, kemudian **Column tools > Data category > State or Province**. Ini membantu Power BI memetakan nama negeri dengan betul.
2. Bina visual **Map** (peta gelembung) — **Location:** `negeri[negeri]` · **Bubble size:** `aduan[no_aduan]` (Count).
3. Untuk kesan "heatmap" sebenar, guna **Filled map (choropleth)**: Location = `negeri[negeri]`, kemudian warnakan melalui **Format > Fill colors > fx > Gradient** berdasarkan `aduan[no_aduan]` (Count) — negeri dengan lebih banyak aduan diwarnakan lebih gelap. *(Filled map tiada lagi well "color saturation"; warna kini guna conditional formatting.)*

> **Nota skop:** Visual **Map** & pewarnaan gradien (conditional formatting) diperkenalkan penuh pada **Hari 2**. Jika pemetaan kurang tepat (nama negeri samar), gunakan **Kes 3** (column chart disusun menurun) sebagai pandangan "hotspot" yang boleh dipercayai untuk Hari 1.

**Hasil:** peta tumpuan aduan — versi geografi bagi ranking negeri di Kes 3.

### Kes 10 — Heatmap agensi × kategori (matrix) &nbsp;🔜 *Pratonton Hari 2*
**Soalan pengurusan:** *Kombinasi agensi dan kategori mana paling kerap?*

1. Bina visual **Matrix** · **Rows:** `agensi[agensi]` · **Columns:** `kategori[kategori]` · **Values:** `aduan[no_aduan]` (Count).
2. Pada **Format > Cell elements**, hidupkan **Background color** untuk menjadikan setiap sel heat-map (nilai tinggi = warna lebih gelap).

> **Nota skop:** **Matrix** & **conditional formatting** diajar penuh pada Hari 2; di sini ia sekadar pratonton kuasa model bintang yang sama.

**Hasil:** jadual silang berwarna yang menyerlahkan sarang (hotspot) agensi-kategori serta-merta.

### Kes 11 — Papan KPI ringkas (Multi-row card)
**Soalan pengurusan:** *Boleh saya lihat 3 nombor utama dalam satu kotak?*

1. Bina visual **Multi-row card**.
2. Seret tiga medan: `aduan[no_aduan]` (Count), `aduan[amaun_kompaun]` (Sum), `aduan[tempoh_hari]` (Average).
3. Susun di **bahagian atas** halaman sebagai jalur ringkasan.

**Hasil:** tiga KPI teras (Jumlah Aduan · Jumlah Kompaun · Purata Tempoh) dalam satu visual — pendahulu kepada kad KPI berasaskan measure pada Hari 2.

> **🎯 Cabaran gabungan — mini dashboard NRES:** Letak **Kes 11** (jalur KPI) di atas, **Kes 1** dan **Kes 5** di tengah, serta **Kes 3** atau **Kes 9** di bawah pada **satu halaman laporan**. Tambah **Slicer** `negeri[zon]` dan `agensi[singkatan]`, kemudian klik beberapa pilihan untuk lihat semua visual menapis serentak. Inilah versi mini dashboard yang akan kita lengkapkan pada Hari 2.

---

## Cara Simpan Fail (.pbix)

Projek Power BI disimpan sebagai satu fail **`.pbix`** yang mengandungi data, model, dan laporan.

1. Klik **File > Save As**.
2. Beri nama, contoh: `Dashboard-Aduan-NRES.pbix`.
3. Simpan di lokasi mudah.

> **Penting:** Simpan fail `.pbix` ini dengan baik — anda akan **teruskan fail yang sama pada Hari 2** untuk menambah DAX, jadual Kalendar, dan dashboard penuh.

---

## Ringkasan Hari 1

Tahniah! Anda telah berjaya:

- [x] Memasang Power BI Desktop dan mengenali antara muka (Header, Ribbon, Formula Bar, Canvas, Panes) serta 3 paparan (Report, Table, Model)
- [x] Memahami **anatomi BI** (Domain → Data → Model → Analysis → Visualization) dan Power BI sebagai **koleksi komponen**
- [x] Memuat 4 fail CSV melalui **Get Data**
- [x] Membersihkan data `aduan` dengan **Power Query** (tajuk, jenis, trim, ganti null, lajur tersuai) dan memahami **Applied Steps**
- [x] Menyemak kualiti data dengan **alat profil data** (Column quality / distribution / profile)
- [x] Memahami dan menyemak kod **M**; sedar konsep **Merge / Append / Unpivot**
- [x] Membina model **skema bintang** dengan 3 hubungan satu-ke-banyak (cardinality & cross-filter direction)
- [x] Membina 4 visual asas (Card, Bar, Donut, Column)
- [x] Menambah **Slicer** dan memahami penapisan silang
- [x] Menyimpan projek sebagai fail `.pbix`

> **Lab:** Cuba latihan dalam [`snippets/lab.md`](./snippets/lab.md) untuk mengukuhkan kefahaman sebelum Hari 2.

---

## Apa Seterusnya?

Pada **[Hari 2](../hari-2/)**, kita akan:

- Cipta jadual **Kalendar** dengan **DAX** untuk membolehkan analisis masa
- Tulis **sukatan (measures)** DAX: `Jumlah Aduan`, `% Selesai`, `Purata Tempoh Selesai`, `Jumlah Kompaun (RM)`
- Guna **kepintaran masa** (time intelligence): trend bulanan & perbandingan bulan lepas
- Bina visual lanjutan: **line chart**, **Map**, dan **Matrix**
- Susun semuanya menjadi **dashboard interaktif** dan **terbitkan** ke Power BI Service

Pastikan fail `.pbix` Hari 1 anda disimpan — kita akan teruskan dari situ. Jumpa di Hari 2!
