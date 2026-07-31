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

Çerezin **üç** ayrı yazma yolu vardır — kılavuzun eski sürümü yalnızca birini (dönüştürücüden seçim) anıyordu; bir ziyaretçi yanlış para biriminde görünüyorsa üçünün de kontrol edilmesi gerekir:

1. **Dönüştürücüden seçim.** Ziyaretçi açılır listeden bir para birimi seçtiğinde çerezi tarayıcı (`switcher.js`) doğrudan kendisi yazar.
2. **Konum algılama — sunucu tarafında.** `DetectionService::detect_from_geolocation()` bulduğu para birimini bekletir; `template_redirect` kancasının en başında (öncelik 0) çalışan `prime_currency_cookie()` bunu çereze yazar — **ama yalnızca render bir sayfa önbelleği tarafından saklanacak türden değilse.** Render önbelleklenebilir ise (önbellek uyumluluğu modu açık, ziyaretçi oturum açmamış, sayfa mağaza/kategori/ürün sayfası) bu yazma bilerek atlanır: aksi halde bir ziyaretçinin coğrafi konumdan bulunan para birimi önbelleğe giren HTML'e gömülür ve o sayfayı sonra açan herkese aynı para birimi sunulurdu.
3. **Konum algılama — tarayıcı tarafında.** Tam olarak 2. adımın atlandığı önbelleklenebilir render'larda, tarayıcı önbellek uyumluluğu modunun [dönüştürme uç noktasını](/docs/rest-api) çağırır; yanıt `detected: true` dönerse çerezi bu kez `price-converter.js` kendisi yazar. 2. ve 3. yol birbirini tamamlar, çakışmaz: bir render önbelleklenebilirse yalnızca tarayıcı yazar, önbelleklenemezse yalnızca sunucu yazar.

Üçü de aynı öznitelik setini kullanır (30 gün, `path=/`, `SameSite=Lax`, yalnızca HTTPS'te `Secure`) — kod bunu bilerek tekrarlar, çünkü tek bir özniteliğin üçünde de aynı olmaması, ziyaretçinin tercihinin bir modda sessizce kalıcı olmaktan çıkması demektir.

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
