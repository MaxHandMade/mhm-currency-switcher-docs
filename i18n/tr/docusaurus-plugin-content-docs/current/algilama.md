---
sidebar_position: 9
title: Para Birimi Algılama Mekanizması
---

# Para Birimi Algılama Mekanizması

Eklenti, ziyaretçinin hangi para birimini göreceğini şu sırayla belirler:

```
1. Çerez                 ← En yüksek öncelik
2. URL parametresi
3. Konum algılama        ← Yalnızca Gelişmiş sekmesinden açıksa
4. Ana para birimi       ← Varsayılan
```

Hangi adımdan gelirse gelsin, bulunan kod **ana para birimi** veya **etkin bir para birimi** değilse yok sayılır ve sıradaki adıma geçilir. Bu sıra ve bu geçerlilik kuralı tek bir yerde uygulanır (`DetectionService::detect_currency()`) ve her fiyat yüzeyi — sayfa render'ı, sepet, dönüştürme uç noktası — aynı sıradan geçer; ikinci bir kopya yoktur.

## 1. Çerez

Ziyaretçi dönüştürücüden bir para birimi seçtiğinde çerez yazılır.

| Özellik | Değer |
|---------|-------|
| Ad | `mhmcs_currency` |
| Süre | 30 gün |
| Yol | `/` (tüm site) |
| Güvenli | HTTPS sitelerinde evet |
| SameSite | Lax |
| HttpOnly | Hayır |

## 2. URL Parametresi

Bağlantıya `?currency=EUR` ekleyerek para birimini belirleyebilirsiniz:

```
https://siteadiniz.com/urun-sayfasi/?currency=EUR
https://siteadiniz.com/magaza/?currency=USD
```

Kampanya bağlantıları ve dış yönlendirmeler için kullanışlıdır. Bu parametre yalnızca o sayfa görüntülemesi sırasında geçerlidir — **kasıtlı olarak hiçbir çerez yazmaz**. Ziyaretçide zaten bir çerez varsa çerez öncelikli olduğu için parametre etkisiz kalır; ziyaretçi açtığı bir sonraki sayfada tekrar ana para birimine döner (dönüştürücüyü kullanmadığı sürece). Bu bir eksiklik değil, bilinçli bir tercihtir: bir bağlantının sessizce kalıcı bir çerez bırakması, katalogda bir para birimi gösterilirken çerezi okuyan sepetin başka bir para birimi tahsil etmesine yol açabilirdi.

## 3. Konum Algılama

**Gelişmiş** sekmesinden açıldıysa devreye girer. Kaynaklar (CloudFlare / WooCommerce MaxMind), sıralama ve algılamanın hangi durumlarda çalıştığına dair ayrıntılar için [Gelişmiş Ayarlar](/docs/gelismis) sayfasına bakın.

## 4. Ana Para Birimi

Yukarıdakilerin hiçbiri sonuç vermezse WooCommerce'te tanımlı ana para birimi kullanılır.

## Önbellek uyumluluğu modunda bir istisna

Önbellek uyumluluğu modu açıkken tarayıcının çağırdığı dönüştürme uç noktası (`POST /wp-json/mhmcs/v1/convert` — bkz. [REST API Referansı](/docs/rest-api)) da aynı dört adımlı zinciri kullanır, ama iki farkla: çerez **yazmaz** (önbellek modunda çerez tarayıcıya aittir) ve bu istek sırasında konum algılama çalışmaz. Bu, zincirin kendisini değiştirmez — yalnızca bu tek uç noktanın zincirin yan etkilerini (çerez yazma, coğrafi konum sorgusu) bilerek devre dışı bırakmasıdır.
