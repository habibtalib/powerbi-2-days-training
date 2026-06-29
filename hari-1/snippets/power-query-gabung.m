// power-query-gabung.m
// Rujukan kod M (Power Query) untuk GABUNG & BENTUK data:
//   1) Append  — tambah BARIS (satukan fail bulanan)
//   2) Merge   — tambah LAJUR (bawa lookup pegawai)
//   3) Unpivot — bentuk semula ringkasan "wide" kepada "long"
//
// Setiap blok ialah satu Query berasingan. Tampal dalam
// Power Query Editor > Home > Advanced Editor (cipta Query baharu untuk setiap satu),
// ATAU ikut langkah GUI dalam README Hari 1 (Langkah 2B).
// Ganti laluan fail dengan lokasi sebenar folder data\ anda.

// ───────────────────────────────────────────────────────────────────────────
// 1) APPEND — tindan baris fail aduan bulanan menjadi satu jadual
//    (skema mesti sama: 9 lajur, nama tajuk sama)
// ───────────────────────────────────────────────────────────────────────────
let
    Julai = Table.PromoteHeaders(
        Csv.Document(File.Contents("C:\Kursus-PowerBI\data\aduan_2026_07.csv"),
            [Delimiter = ",", Encoding = 65001, QuoteStyle = QuoteStyle.Csv]),
        [PromoteAllScalars = true]),

    Ogos = Table.PromoteHeaders(
        Csv.Document(File.Contents("C:\Kursus-PowerBI\data\aduan_2026_08.csv"),
            [Delimiter = ",", Encoding = 65001, QuoteStyle = QuoteStyle.Csv]),
        [PromoteAllScalars = true]),

    // Table.Combine = Append (UNION baris). Tambah jadual lain dalam senarai
    // jika ada lebih banyak bulan, cth {Julai, Ogos, aduan}.
    Gabung = Table.Combine({Julai, Ogos})
in
    Gabung


// ───────────────────────────────────────────────────────────────────────────
// 2) MERGE — cantum pegawai ke dalam dimensi agensi ikut lajur "agensi"
//    (seperti SQL LEFT JOIN: kekalkan semua baris agensi)
// ───────────────────────────────────────────────────────────────────────────
let
    Agensi = Table.PromoteHeaders(
        Csv.Document(File.Contents("C:\Kursus-PowerBI\data\agensi.csv"),
            [Delimiter = ",", Encoding = 65001, QuoteStyle = QuoteStyle.Csv]),
        [PromoteAllScalars = true]),

    Pegawai = Table.PromoteHeaders(
        Csv.Document(File.Contents("C:\Kursus-PowerBI\data\pegawai.csv"),
            [Delimiter = ",", Encoding = 65001, QuoteStyle = QuoteStyle.Csv]),
        [PromoteAllScalars = true]),

    // NestedJoin = Merge; hasilnya satu lajur jadual bersarang bernama "Pegawai"
    Cantum = Table.NestedJoin(Agensi, {"agensi"}, Pegawai, {"agensi"}, "Pegawai", JoinKind.LeftOuter),

    // Expand = pilih lajur yang mahu dibawa keluar dari jadual bersarang
    Kembang = Table.ExpandTableColumn(Cantum, "Pegawai", {"pegawai", "emel"}, {"pegawai", "emel"})
in
    Kembang


// ───────────────────────────────────────────────────────────────────────────
// 3) UNPIVOT — tukar ringkasan tahunan "wide" (lajur = kategori) kepada "long"
//    Sumber: aduan_ringkasan.csv  →  Tahun | kategori | bilangan
// ───────────────────────────────────────────────────────────────────────────
let
    Source = Table.PromoteHeaders(
        Csv.Document(File.Contents("C:\Kursus-PowerBI\data\aduan_ringkasan.csv"),
            [Delimiter = ",", Encoding = 65001, QuoteStyle = QuoteStyle.Csv]),
        [PromoteAllScalars = true]),

    // Kunci lajur "Tahun"; unpivot SEMUA lajur lain (tahan walau kategori baharu masuk)
    Unpivot = Table.UnpivotOtherColumns(Source, {"Tahun"}, "kategori", "bilangan"),

    UbahJenis = Table.TransformColumnTypes(Unpivot, {
        {"Tahun", Int64.Type},
        {"kategori", type text},
        {"bilangan", Int64.Type}
    })
in
    UbahJenis
