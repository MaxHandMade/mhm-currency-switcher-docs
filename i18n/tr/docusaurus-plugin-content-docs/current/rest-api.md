---
sidebar_position: 12
title: REST API Referansı
---

# REST API Referansı

**Ad alanı (namespace):** `mhmcs/v1`
**Temel URL:** `/wp-json/mhmcs/v1/`

## Herkese Açık Uç Noktalar

### GET `/rates`

Kimlik doğrulaması gerektirmez. Ana para birimini ve etkin para birimlerinin efektif (komisyon dahil) kurlarını döndürür.

```bash
curl https://siteadiniz.com/wp-json/mhmcs/v1/rates
```

```json
{
    "base": "TRY",
    "rates": {
        "EUR": 0.0274,
        "USD": 0.0293,
        "GBP": 0.0250
    }
}
```

### POST `/convert`

*Sürüm 1.1.0'dan beri.* Kılavuzun eski sürümü bu uç noktadan hiç bahsetmiyordu; [önbellek uyumluluğu modu](/docs/gelismis) açıkken tarayıcının, önbelleklenmiş bir sayfadaki işaretlenmiş fiyatları ziyaretçinin gerçek para biriminde almak için çağırdığı uç nokta budur. Kimlik doğrulaması gerektirmez.

**Parametreler:**

| Parametre | Tür | Zorunlu mu | Açıklama |
|-----------|-----|------------|----------|
| `currency` | `string` veya `null` | Hayır | Fiyatlanacak ISO 4217 kodu. Boş bırakılır veya `null` gönderilirse sunucu ziyaretçinin para birimini [algılama zincirinden](/docs/algilama) (çerez yazmadan) kendisi bulur. |
| `product_ids` | tamsayı dizisi | Evet | Fiyatlanacak ürün veya varyasyon ID'leri. Sunucu bu diziyi en fazla **50** öğeyle sınırlar — istemci de isteklerini 50'lik gruplara böler, ama asıl sınır sunucu tarafında uygulanır; istemcinin gönderdiği sayı önemli değildir. |

**Örnek istek:**

```bash
curl -X POST https://siteadiniz.com/wp-json/mhmcs/v1/convert \
  -H "Content-Type: application/json" \
  -d '{"currency": "EUR", "product_ids": [101, 102]}'
```

**Örnek yanıt:**

```json
{
    "currency": "EUR",
    "detected": false,
    "prices": {
        "101": "<span class=\"woocommerce-Price-amount amount\">€13,68</span>",
        "102": "<span class=\"woocommerce-Price-amount amount\">€27,36</span>"
    }
}
```

`detected` alanı, para biriminin **sunucu tarafından algılandığını** bildirir — istek açıkça bir `currency` göndermişse, ya da algılama sonuçsuz kalmışsa `false` döner. İstemci tarafındaki dönüştürücü, çerezini yalnızca `detected: true` olduğunda yazar.

**Bu uç nokta neden kimlik doğrulaması istemiyor?**

Bu uç noktanın hizmet ettiği sayfalar önbelleğe alınmış sayfalardır; okuyucuları tanım gereği oturum açmamıştır ve önbelleklemeden sağ çıkabilecek bir nonce taşımazlar (oturum açmış bir ziyaretçi bu yolu hiç kullanmaz — fiyatları zaten sunucu tarafında dönüştürülür). Bu yüzden uç nokta bilerek herkese açıktır; asıl iş neyin açık olabileceğini sınırlamaya harcanmıştır:

- Yalnızca **`price_html`** döner, ve yalnızca zaten herkese açık okunabilir ürünler için — aynı anonim çağıranın mağaza sayfalarından zaten okuyabileceği aynı metinler, mağazanın kur yayınladığı bir para biriminde.
- Yayınlanmamış, parola korumalı veya ürün olmayan ID'ler **sessizce atlanır**. ID'yi anan bir hata, o ID'nin var olduğunu ve gizlendiğini doğrulamış olurdu — bunu sitenin kendisi bile söylemez.
- Mağazanın sunmadığı bir para birimi hata vermez, ana para birimine döner; bu yüzden hiçbir durum kodu ikisini birbirinden ayırmaz. Yanıttaki `currency` alanı yine de hangi kodun kullanıldığını söyler, böylece çağıran sunulan bir para birimini reddedilenden ayırt edebilir — zaten `GET /rates` etkin para birimi listesini anonim çağıranlara yayınlıyor.
- Toplu istek **sunucu tarafında** sınırlıdır, istemcinin gönderdiği sayı üzerinden değil.
- Hiçbir şey **yazılmaz**: çerez yok, seçenek (option) yok, post meta yok.

**Hız sınırı:** Bir adres, varsayılan olarak dakikada en fazla **120** istek yapabilir (60 saniyelik pencerede). Sıradan bir gezinme bunun çok altındadır — bir sayfa tek bir istek yapar. Sınır aşılırsa yanıt:

```
HTTP/1.1 429 Too Many Requests
Retry-After: 60
```
```json
{
    "code": "mhmcs_rate_limited",
    "message": "Too many currency conversion requests. Please try again shortly."
}
```

Mağazanız bir ters proxy veya CDN arkasındaysa ve her ziyaretçi aynı adresten geliyormuş gibi görünüyorsa, `mhmcs_convert_rate_limit` filtresiyle sınırı yükseltebilir veya kapatabilirsiniz.

**Yalnızca başarılı dönüştürme yanıtı** `Cache-Control: no-store` başlığıyla döner — içerik ziyaretçinin çerezine bağlı olduğu için bir paylaşımlı önbellek tarafından saklanmamalıdır. Yukarıdaki 429 (hız sınırı) yanıtında bu başlık **yoktur**, yalnızca `Retry-After` bulunur. Bu fark mağazanız bir paylaşımlı proxy veya CDN arkasındaysa önemlidir: `no-store` taşımayan bir 429, aynı adresten gelen (ör. aynı NAT arkasındaki) başka ziyaretçilere de önbellekten sunulabilir — o ziyaretçiler fiyatların neden dönüştürülmediğine dair sayfada hiçbir açıklama görmeden, süresiz biçimde ana para biriminde takılı kalabilir.

## Yönetici Uç Noktaları

> Aşağıdaki uç noktaların tamamı `manage_woocommerce` yetkisi gerektirir. Yönetim panelinin kendisi de bu uç noktaları kullanır.

| Yöntem | Uç Nokta | Açıklama |
|--------|----------|----------|
| GET | `/settings` | Eklenti ayarlarını getirir |
| POST | `/settings` | Eklenti ayarlarını kaydeder |
| GET | `/currencies` | Ana para birimini ve yapılandırılmış para birimlerini getirir |
| POST | `/currencies` | Para birimlerini kaydeder |
| POST | `/rates/sync` | Kurları kaynaktan çekip günceller |
| GET | `/rates/preview` | Her para birimi için ham ve efektif kuru döndürür |

## WooCommerce Ürün API'sinde Para Birimi

WooCommerce'in kendi ürün uç noktalarına `currency` parametresi ekleyerek fiyatları çevrilmiş olarak alabilirsiniz:

```bash
curl https://siteadiniz.com/wp-json/wc/v3/products?currency=EUR
```

Yanıttaki `price`, `regular_price` ve `sale_price` alanları çevrilir ve yanıta `currency_code` alanı eklenir. Parametre yalnızca mağazanızda etkin olan bir para birimi kodu içeriyorsa dikkate alınır; hiç gönderilmezse veya geçersizse yanıt her zaman ana para biriminize sabitlenir — yani sonuç, çağıranın çerezine değil yalnızca isteğin kendisine bağlıdır.
