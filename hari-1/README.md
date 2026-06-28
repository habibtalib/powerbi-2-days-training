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
| **Ribbon** (atas) | Menu arahan: Home, Insert, Modeling, View, dll. |
| **Kanvas** (tengah) | Tempat anda susun visual laporan |
| **Anak tetingkap Visualizations** (kanan) | Pilih jenis carta & seret medan ke dalam slot (Axis, Values, Legend) |
| **Anak tetingkap Data / Fields** (paling kanan) | Senarai semua jadual & lajur dalam model |
| **3 ikon paparan** (tepi kiri) | Tukar antara paparan **Report**, **Table**, dan **Model** |

**Tiga paparan utama** (ikon di tepi kiri tetingkap):

1. **Report view** (ikon carta) — bina dan susun visual.
2. **Table view** (ikon jadual) — lihat data dalam bentuk jadual.
3. **Model view** (ikon hubungan/gambarajah) — uruskan jadual dan hubungan.

> **Konsep penting:** Kita akan kerap bertukar antara tiga paparan ini sepanjang kursus. Ingat lokasi ketiga-tiga ikon di tepi kiri.

---

## Pengenalan Power BI

**Power BI** ialah alat *business intelligence* daripada Microsoft untuk menukar data mentah menjadi laporan dan dashboard interaktif.

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

**Power Query** ialah enjin transformasi data Power BI. Setiap perubahan yang anda buat direkod sebagai satu **langkah (Applied Step)**, jadi proses pembersihan boleh diulang secara automatik setiap kali data dimuat semula.

Buka **Power Query Editor** (jika belum terbuka): **Home > Transform data**. Pilih query **`aduan`** di anak tetingkap **Queries** (kiri).

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
> - **Many-to-one (\*:1)** bermakna banyak baris `aduan` boleh berkongsi satu `agensi`.
> - **Cross-filter Single** bermakna apabila anda pilih satu agensi, ia menapis jadual `aduan` — tetapi tidak sebaliknya. Inilah tingkah laku biasa untuk skema bintang.

---

## Langkah 5: Visual Pertama

Kembali ke **Report view**. Mari bina 4 visual.

### Cara umum membina visual

1. Pada anak tetingkap **Visualizations** (kanan), klik ikon jenis carta yang dikehendaki — satu visual kosong muncul di kanvas.
2. Daripada anak tetingkap **Data/Fields**, seret medan ke dalam slot yang sesuai (Axis, Values, Legend).

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

## Cara Simpan Fail (.pbix)

Projek Power BI disimpan sebagai satu fail **`.pbix`** yang mengandungi data, model, dan laporan.

1. Klik **File > Save As**.
2. Beri nama, contoh: `Dashboard-Aduan-NRES.pbix`.
3. Simpan di lokasi mudah.

> **Penting:** Simpan fail `.pbix` ini dengan baik — anda akan **teruskan fail yang sama pada Hari 2** untuk menambah DAX, jadual Kalendar, dan dashboard penuh.

---

## Ringkasan Hari 1

Tahniah! Anda telah berjaya:

- [x] Memasang Power BI Desktop dan mengenali 3 paparan (Report, Table, Model)
- [x] Memuat 4 fail CSV melalui **Get Data**
- [x] Membersihkan data `aduan` dengan **Power Query** (tajuk, jenis, trim, ganti null, lajur tersuai)
- [x] Menyemak kualiti data dengan **alat profil data** (Column quality / distribution / profile)
- [x] Memahami dan menyemak kod **M**
- [x] Membina model **skema bintang** dengan 3 hubungan satu-ke-banyak
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
