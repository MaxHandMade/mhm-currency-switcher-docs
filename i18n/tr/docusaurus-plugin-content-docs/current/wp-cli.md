---
sidebar_position: 8
title: WP-CLI Komutları
---

# WP-CLI Komutları

Sunucu terminalinden eklentiyi yönetmek için `wp mhm-cs <alt komut>` altında beş komut vardır.

### Kurları senkronize et

```bash
wp mhm-cs rates-sync
```

Ana para biriminiz için güncel kurları çeker ve yalnızca gerçekten değişen para birimlerine yazar.

```
Fetching rates for base currency: TRY...
Success: Synced 3 exchange rates successfully.
```

### Belirli bir kuru göster

```bash
wp mhm-cs rates-get EUR
```

Ham kuru ve komisyon uygulanmış efektif kuru gösterir. Kur tanımlı değilse hata verir.

```
Currency:       EUR
Raw rate:       0.0267
Effective rate: 0.0274
Success: Rate retrieved for EUR.
```

### Kur önbelleğini temizle

```bash
wp mhm-cs cache-flush
```

Ana para birimi için önbelleğe alınmış kurları siler. Sonraki senkronizasyon değerleri yeniden API'den çeker.

```
Success: Rate cache flushed for base currency: TRY.
```

### Para birimlerini listele

```bash
wp mhm-cs currencies-list
```

```
Base currency: TRY

+------+--------+---------+--------+
| Code | Rate   | Enabled | Symbol |
+------+--------+---------+--------+
| EUR  | 0.0267 | Yes     | €      |
| USD  | 0.0293 | Yes     | $      |
| GBP  | 0.0230 | Yes     | £      |
+------+--------+---------+--------+
```

Hiç para birimi eklenmemişse tablo yerine bir uyarı basar.

### Eklenti durumu

```bash
wp mhm-cs status
```

```
MHM Currency Switcher v1.2.0
Base currency:      TRY
Total currencies:   3
Enabled currencies: 3
Success: Status check complete.
```

Sürüm satırı her zaman kurulu eklenti sürümünüzü yansıtır — yukarıdaki `1.2.0` yalnızca örnek çıktıdır.

## Kaynak

Bu beş alt komut `src/CLI/Commands.php` dosyasındaki tek `Commands` sınıfının tamamıdır; eklenti bunların dışında başka bir `wp mhm-cs` alt komutu kaydetmez.
