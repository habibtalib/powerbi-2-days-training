// power-query.m
// Rujukan transformasi Power Query (bahasa M) untuk jadual fakta "aduan".
// Anda boleh tampal kod ini dalam Power Query Editor > Home > Advanced Editor,
// ATAU lakukan setiap langkah melalui antara muka (GUI) seperti dalam nota README.
//
// Ganti laluan fail dengan lokasi sebenar data/aduan.csv di komputer anda.

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
