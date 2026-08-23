---
sidebar_position: 5
title: Gelişmiş Ayarlar
---

# Gelişmiş Ayarlar

**WooCommerce > MHM Para Birimi > Gelişmiş** sekmesi

Bu sekmede dört ayar bulunur.

## Konum Algılama

| Ayar | Açıklama |
|------|----------|
| **Konuma dayalı para birimi algılamayı etkinleştir** | Ziyaretçinin ülkesini tespit edip eşleşen para birimini gösterir |

Ülke tespiti iki kaynaktan kademeli olarak yapılır:

1. **CloudFlare (birincil):** Siteniz CloudFlare arkasındaysa ülke kodu `CF-IPCountry` başlığından okunur. Ek yapılandırma gerektirmez ve çok hızlıdır. Bilinmeyen ülke ve Tor çıkış düğümü kodları yok sayılır.
2. **WooCommerce MaxMind (yedek):** CloudFlare başlığı yoksa WooCommerce'in yerleşik MaxMind GeoIP veritabanı sorgulanır. Bunun için **WooCommerce > Ayarlar > Entegrasyon > MaxMind Geolocation** bölümünden lisans anahtarı girilmiş olmalıdır.

**Nasıl çalışır:**

1. Ziyaretçide henüz para birimi çerezi yoksa konum algılama devreye girer
2. Bulunan ülke koduna karşılık gelen para birimi belirlenir
3. Bu para birimi mağazanızda **etkin** değilse algılama sonuçsuz sayılır ve ana para birimi kullanılır
4. Başarılı algılamada çerez yazılır — böylece sonraki sayfalarda tespit yeniden çalışmaz
5. Ziyaretçi dönüştürücüden başka bir para birimi seçerse tercihi çereze kaydedilir ve konum algılamanın önüne geçer

## Otomatik Kur Güncelleme

Kurlar WordPress'in zamanlanmış görev (WP Cron) altyapısıyla otomatik güncellenebilir.

| Seçenek | Etki |
|---------|------|
| **Yalnızca manuel** | Otomatik güncelleme yapılmaz; zamanlanmış görev kaldırılır |
| **Saatlik** | Saatte bir güncellenir |
| **Günde iki kez** | Günde iki kez güncellenir |
| **Günlük** | Günde bir kez güncellenir |

Aralığı değiştirdiğinizde mevcut zamanlanmış görev temizlenir ve yeni aralıkla yeniden kurulur. Eklentiyi devre dışı bıraktığınızda görev tamamen kaldırılır.

> **Not:** WP Cron gerçek bir sistem cron'u değildir — siteye gelen trafikle tetiklenir. Düşük trafikli sitelerde güncellemelerin düzenli çalışması için sunucunuzun crontab'ına `wp-cron.php` çağrısı eklemeniz önerilir.

> Kur kaynakları API anahtarı istemediği için bu sekmede sağlayıcı seçimi veya anahtar alanı bulunmaz.

## Önbellek Uyumluluğu Modu

*Sürüm 1.1.0'dan beri.*

Bir sayfa önbelleği (page cache), sunucunuzun ürettiği HTML'i ilk isteyen ziyaretçi için saklar ve sonraki ziyaretçilere aynı HTML'i sunar. Fiyatlar sunucuda dönüştürülüyorsa bu, ilk ziyaretçinin para biriminin herkese gösterilmesi anlamına gelir.

**Önbellek uyumluluğu modu**, varsayılan olarak **açık** gelir ve bu sorunu şöyle çözer: oturum açmamış ziyaretçiler için mağaza, kategori ve ürün sayfaları her zaman **ana para biriminizde** oluşturulur, böylece önbellekteki aynı sayfa herkes için doğrudur. Tarayıcı, sayfa yüklendikten sonra bu eklentiye yaptığı bir REST isteğiyle görünen fiyatları ziyaretçinin seçtiği para birimine dönüştürür.

Ayrım kasıtlıdır: yalnızca **görüntülenen** fiyatlar tarayıcıda dönüştürülür. Sepet, ödeme, sipariş toplamları, sipariş e-postaları ve WooCommerce REST API'si her zaman sunucuda, ziyaretçinin gerçekten seçtiği para biriminde hesaplanır — yani tahsil edilen tutar tarayıcıdan değiştirilemez.

| Ayar | Açıklama |
|------|----------|
| **Sayfaları ana para biriminde önbellekle** | Kapatıldığında fiyatlar eskisi gibi (1.1.0 öncesi gibi) sunucuda dönüştürülür; bu, sayfa önbellekleme eklentileriyle iyi çalışmaz. Sepet, ödeme ve sipariş toplamları her iki durumda da her zaman sunucuda dönüştürülür. |

Modu kapatmak 1.0.0 davranışını birebir geri getirmez: yönetim ekranları, REST API ve zamanlanmış görevlerle ilgili düzeltmeler her iki modda da etkin kalır.

## Eklenti Kaldırılınca Ne Olur

*1.3.0 ile geldi.*

| Ayar | Açıklama |
|------|----------|
| **Eklenti kaldırıldığında tüm verileri sil** | Varsayılan olarak **kapalı**. Kapalı bırakıldığında, eklenti silinse bile ayarlarınız ve her siparişe kaydedilmiş para birimi ile kur yerinde kalır. |

Sipariş başına tutulan bu kayıtlar, çok para birimli satış geçmişinizin tek dayanağıdır ve
sonradan yeniden üretilemez. Yıkıcı olan seçeneğin bilerek yapılması gereken seçenek olmasının
sebebi budur — kendiliğinden olan değil.

Eklentiyi **devre dışı bırakmak** hiçbir veriyi silmez; yalnız zamanlanmış kur güncelleme görevi
temizlenir. Silme yalnız eklenti **kaldırıldığında** ve yalnız bu anahtar açıkken olur.

Çok siteli (multisite) bir ağda anahtar, eklentinin kaldırıldığı siteyi temizler.
