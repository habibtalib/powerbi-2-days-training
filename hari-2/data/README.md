# Data Hari 2 — Sasaran Prestasi

Hari 2 **menyambung** fail `.pbix` yang anda bina pada Hari 1 — jadi jadual teras (`aduan`, `agensi`, `negeri`, `kategori`) **sudah dimuat** dalam model dan tidak perlu diimport semula. Kamus data penuh untuk keempat-empat jadual itu ada dalam [`../../hari-1/data/README.md`](../../hari-1/data/README.md).

Folder ini hanya mengandungi **satu fail baharu** yang diperkenalkan pada Hari 2.

## `sasaran.csv` — Jadual Sasaran (5 baris)

Sasaran prestasi setiap agensi — digunakan untuk **conditional formatting** (heat-map matrix) & kes "prestasi vs sasaran".

| Lajur | Jenis | Penerangan |
|-------|-------|------------|
| `agensi` | Teks | Nama penuh agensi (kunci padanan) |
| `sasaran_selesai` | Nombor (0–1) | Sasaran peratus kes selesai, cth `0.70` = 70% |

> **Nota:** Dimuat sebagai jadual **disconnected** (tiada hubungan dalam model). Sukatan `Sasaran % Selesai` mencapainya dengan `LOOKUPVALUE`. Lihat README Hari 2, Langkah 6 › Conditional formatting.

## Jadual `Kalendar` — dicipta dengan DAX (bukan CSV)

Hari 2 juga menambah jadual **`Kalendar`**, tetapi ia **tidak datang daripada CSV** — ia dijana dengan DAX `CALENDAR()` (rujuk `../snippets/calculated-columns.dax`) dan dihubungkan `aduan[tarikh_terima]` → `Kalendar[Date]`.

## Model selepas Hari 2

```
   agensi (1) ──< (banyak) aduan (banyak) >── (1) negeri
                            │   │
                  (1) kategori   tarikh_terima
                                       │
                                       v
                            Kalendar (DAX, Hari 2)

   sasaran  ·  jadual disconnected (LOOKUPVALUE, tiada hubungan)
```

> **Nota:** Data ini dijana untuk tujuan latihan sahaja dan **bukan** data rasmi NRES. Inspirasi domain: portal rasmi [nres.gov.my](https://www.nres.gov.my/ms-my/Pages/default.aspx).
