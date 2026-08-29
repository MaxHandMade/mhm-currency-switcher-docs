---
sidebar_position: 10
title: Döviz Kuru Dönüştürme Mantığı
slug: /donusturme
---

# Döviz Kuru Dönüştürme Mantığı

## Temel Formül

```
Çevrilmiş Fiyat = Ana Fiyat × Efektif Kur   → (varsa) yuvarlama
```

**Efektif kur:**

| Komisyon Türü | Formül |
|---------------|--------|
| Yok | Efektif Kur = Ham Kur |
| Yüzde | Efektif Kur = Ham Kur × (1 + Komisyon / 100) |
| Sabit | Efektif Kur = Ham Kur + Sabit Komisyon |

**Yuvarlama** — kur ve komisyon uygulandıktan sonra devreye girer:

| Tür | Formül |
|-----|--------|
| En Yakına | (Fiyat ÷ Adım) en yakına yuvarlanır × Adım − Çıkar |
| Yukarı Yuvarla | (Fiyat ÷ Adım) yukarı yuvarlanır × Adım − Çıkar |
| Aşağı Yuvarla | (Fiyat ÷ Adım) aşağı yuvarlanır × Adım − Çıkar |

> **Düzeltme:** Kılavuzun eski sürümü yuvarlamanın "yalnızca ürün fiyatlarına uygulandığını" söylüyordu. 1.1.0'dan beri doğru değil: aynı yuvarlama kuralı kargo ücretine, sepet ek ücretlerine (fees) ve sabit tutarlı kupon indirimlerine de uygulanır — aşağıdaki "Dönüştürülen Fiyatlar" tablosuna bakın.

### Pratik Örnek

Ana para birimi TRY, ürün fiyatı 500 TRY:

| Para Birimi | Ham Kur | Komisyon | Efektif Kur | Çevrilmiş Fiyat |
|------------|---------|----------|-------------|-----------------|
| EUR | 0.0267 | %2.5 | 0.0274 | 13,68 € |
| USD | 0.0293 | Yok | 0.0293 | 14,65 $ |
| GBP | 0.0230 | 0.002 sabit | 0.0250 | 12,50 £ |

Kur 0 ise veya para birimi bulunamıyorsa fiyat çevrilmeden olduğu gibi bırakılır.

### Fiyat Biçimlendirme

Her para birimi kendi biçimlendirme ayarlarıyla gösterilir. Bu değerler para birimi eklenirken WooCommerce ayarlarınızdan otomatik doldurulur.

| Ayar | Açıklama | Örnek |
|------|----------|-------|
| Simge | Para birimi simgesi | €, $, ₺, £ |
| Ondalık basamak | Kaç hane gösterileceği | 2 |
| Ondalık ayracı | Ondalık işareti | `,` veya `.` |
| Binler ayracı | Binlik işareti | `.` veya `,` |
| Simge konumu | Simgenin yeri | sol, sağ, sol boşluklu, sağ boşluklu |

**Konum örnekleri:**

| Konum | Görünüm |
|-------|---------|
| `left` | €50,00 |
| `left_space` | € 50,00 |
| `right` | 50,00€ |
| `right_space` | 50,00 € |

## Dönüştürülen Fiyatlar

Ziyaretçi ana para birimi dışında bir para birimi seçtiğinde şunlar çevrilir:

| Alan | Durum |
|------|-------|
| Ürün fiyatı (normal ve indirimli) | Çevrilir, yuvarlama uygulanır |
| Varyasyon fiyatları ve fiyat aralıkları | Çevrilir, yuvarlama uygulanır |
| Sepet ve sipariş toplamları | Çevrilmiş kalemler (ürün, ek ücret, kargo) üzerinden hesaplanır |
| Sepet ek ücretleri (fees) | Çevrilir, yuvarlama uygulanır |
| Kargo ücretleri | Çevrilir, yuvarlama uygulanır |
| Kargo satırındaki vergi | Çevrilir, **yuvarlama uygulanmaz** — kargo ücretiyle birlikte taşınır |
| Sabit tutarlı kuponlar | Çevrilir, yuvarlama uygulanır |
| Kuponun asgari/azami harcama sınırı | Çevrilir, **yuvarlama uygulanmaz** |

**Çevrilmeyenler:**

- **Yüzde indirimli kuponlar** — oran para biriminden bağımsız olduğu için olduğu gibi uygulanır.

> **Düzeltme:** Kılavuzun eski sürümü "vergi tutarları kargo satırında ayrıca çevrilmez" diyordu. 1.1.0'dan beri bu doğru değil — kargo vergisi artık kargo ücretiyle birlikte çevrilir; aksi halde sepet bir para biriminde fiyatlanırken vergi ana para biriminde kalırdı.

**Neden bazı tutarlar yuvarlanmıyor?** Kargo vergisi ve kuponun asgari/azami harcama sınırı kasıtlı olarak yuvarlama dışı bırakılmıştır. Yuvarlama kuralının amacı müşteriden tahsil edilen tutarı düzgün bir rakama oturtmaktır; oysa bu iki değer müşterinin ödediği bir tutar değildir — vergi, kargo ücretinden türetilen bir yan hesaptır, kuponun asgari/azami sınırı ise indirimin ne zaman devreye gireceğini belirleyen bir eşiktir. Bu eşiği yuvarlamak, satıcının belirlediği kuralı (örneğin "123 üzeri alışverişte" şartını) kendiliğinden değiştirmiş olurdu.

### Siparişler

Sipariş oluşturulurken müşterinin kullandığı para birimi, o anki kur ve ana para birimi siparişe kaydedilir. Sipariş yönetiminde ve sipariş e-postalarında tutarlar müşterinin ödediği para birimiyle gösterilir. Eklenti daha önce oluşturulmuş siparişlerin kayıtlı tutarlarını değiştirmez; eklenti kurulmadan önce alınan siparişler olduğu gibi kalır.
