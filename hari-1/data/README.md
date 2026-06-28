# Data Contoh — Dashboard Aduan Alam Sekitar NRES

Empat fail CSV ini ialah punca data untuk dashboard yang anda bina sepanjang kursus. Strukturnya ialah **skema bintang (star schema)**: satu jadual fakta (`aduan`) dikelilingi jadual dimensi (`agensi`, `negeri`, `kategori`).

Data meliputi aduan alam sekitar yang dikendalikan oleh pelbagai agensi di bawah **Kementerian Sumber Asli dan Kelestarian Alam (NRES)**.

## `aduan.csv` — Jadual Fakta (≈480 baris)

Setiap baris ialah satu aduan/kes alam sekitar.

| Lajur | Jenis | Penerangan |
|-------|-------|------------|
| `no_aduan` | Teks | Nombor rujukan unik, cth: `NRES-2025-0001` |
| `tarikh_terima` | Tarikh | Tarikh aduan diterima |
| `tarikh_selesai` | Tarikh | Tarikh kes diselesaikan (kosong jika belum) |
| `kategori` | Teks | Jenis kes alam sekitar (lihat `kategori.csv`) |
| `agensi` | Teks | Agensi NRES yang mengendalikan kes (lihat `agensi.csv`) |
| `negeri` | Teks | Negeri lokasi kes (lihat `negeri.csv`) |
| `status` | Teks | Baru / Dalam Siasatan / Selesai / Ditutup |
| `tindakan` | Teks | Tindakan diambil: Amaran / Kompaun / Pendakwaan / Tiada |
| `amaun_kompaun` | Nombor (RM) | Amaun kompaun dikenakan (0 jika tiada) |

## `agensi.csv` — Jadual Dimensi (5 baris)

| Lajur | Jenis | Penerangan |
|-------|-------|------------|
| `agensi` | Teks | Nama penuh agensi (kunci hubungan) |
| `singkatan` | Teks | Singkatan, cth: JAS, JPSM, PERHILITAN, JMG, JPS |
| `fokus` | Teks | Bidang tanggungjawab agensi |

## `negeri.csv` — Jadual Dimensi (16 baris)

| Lajur | Jenis | Penerangan |
|-------|-------|------------|
| `negeri` | Teks | Nama negeri (kunci hubungan) |
| `zon` | Teks | Zon wilayah: Utara, Tengah, Selatan, Timur, Borneo |
| `populasi` | Nombor | Anggaran penduduk (untuk kiraan per kapita) |

## `kategori.csv` — Jadual Dimensi (8 baris)

| Lajur | Jenis | Penerangan |
|-------|-------|------------|
| `kategori` | Teks | Nama kategori kes (kunci hubungan) |
| `agensi` | Teks | Agensi yang bertanggungjawab bagi kategori tersebut |
| `keterangan` | Teks | Penerangan ringkas kategori |

## Hubungan dalam model

```
   agensi (1) ──< (banyak) aduan (banyak) >── (1) negeri
                            │   │
                  (1) kategori   tarikh_terima
                                       │
                                       v
                            Kalendar (dicipta dengan DAX pada Hari 2)
```

> **Nota:** Data ini dijana untuk tujuan latihan sahaja dan **bukan** data rasmi NRES. Inspirasi domain: portal rasmi [nres.gov.my](https://www.nres.gov.my/ms-my/Pages/default.aspx).
