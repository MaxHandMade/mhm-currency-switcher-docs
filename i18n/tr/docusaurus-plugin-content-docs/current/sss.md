---
sidebar_position: 13
title: SSS
---

# Sık Sorulan Sorular

Bu sayfa, eklentinin `readme.txt` dosyasındaki sık sorulan sorularla bu kılavuzun kendi SSS bölümünü birleştirir; aynı soru iki kaynakta da varsa daha iyi anlatılan cevap kullanılmış, yalnızca birinde geçen sorular olduğu gibi taşınmıştır.

### Kaç para birimi ekleyebilirim?

Sınır yoktur — istediğiniz kadar para birimi ekleyebilirsiniz. Tek istisna ürün sayfasındaki fiyat bileşenidir: **Görüntüleme Seçenekleri** sekmesinden en fazla 5 para birimi seçip aynı anda gösterebilirsiniz.

### Döviz kurları nasıl ve ne sıklıkla güncellenir?

Kurlar ExchangeRate-API'den gerçek zamanlı çekilir ve kullanılan kaynak ücretsizdir, API anahtarı gerektirmez. Güncelleme sıklığını **Gelişmiş** sekmesinden siz belirlersiniz: saatlik, günde iki kez, günlük veya yalnızca elle. **Kurları Senkronize Et** düğmesiyle her zaman elle de güncelleyebilirsiniz. Çekilen kurlar 1 gün önbellekte tutulur.

### Kısa kodlar nelerdir, dönüştürücüyü sitemde nasıl gösteririm?

İki kısa kod vardır:

- `[mhm_currency_switcher]` — para birimi açılır listesini gösterir. Tek isteğe bağlı özelliği `size`'dır (`small`, `medium` veya `large`); belirtilmezse Görüntüleme Seçenekleri'nde kayıtlı boyut kullanılır.
- `[mhm_currency_prices]` — aynı ürün fiyatını birden çok para biriminde gösterir. Tüm özellikleri isteğe bağlıdır: `currencies` (virgülle ayrılmış kodlar, ör. `currencies="USD,EUR"`; belirtilmezse Görüntüleme Seçenekleri'ndeki para birimleri kullanılır — yapılandırmadığınız kodlar yok sayılır), `product_id` (görüntülenen ürün yerine belirli bir ürünü fiyatlandırır), `price` (bir ürün yerine belirli bir tutarı fiyatlandırır), `show_flags` (kayıtlı bayrak ayarını `true`/`false` ile geçersiz kılar).

Her ikisi de Elementor widget'ı olarak kullanılabilir. Dönüştürücüyü header'a eklemenin dört yolu vardır:

1. **Navigasyon menüsü (önerilen):** Görünüm > Menüler'den **Para Birimi Dönüştürücü** öğesini menünüze ekleyin.
2. **Widget alanı:** Temanızın header widget alanına bir "Kısa Kod" widget'ı ekleyip `[mhm_currency_switcher]` yazın.
3. **Elementor:** Header şablonunuza **Currency Switcher** widget'ını sürükleyin.
4. **PHP:** Temanızın şablon dosyasına `<?php echo do_shortcode( '[mhm_currency_switcher]' ); ?>` ekleyin.

### Belirli bir ürüne sabit fiyat verebilir miyim?

Evet. Ürün düzenleme ekranındaki **Para Birimi Fiyatları** sekmesini kullanın — ayrıntılar için [Ürün Bazında Sabit Fiyatlar](/docs/sabit-fiyat) bölümüne bakın. Şunu bilerek kullanın: sabit fiyat ürün ve para birimi başına saklanır, fiyat türüne göre değil — yani aynı tutar hem normal fiyat hem de indirimli fiyat için kullanılır. Ana para biriminizde indirimde olan bir ürün, sabit fiyat verdiğiniz bir para biriminde indirimde değilmiş gibi görünür. İndirimin o para birimine de yansımasını istiyorsanız, o para birimini sabitlemek yerine döviz kuruna bırakın.

### WooCommerce HPOS (Yüksek Performanslı Sipariş Depolama) ile uyumlu mu?

Evet. Eklenti, WooCommerce'in Yüksek Performanslı Sipariş Depolama (HPOS / Custom Order Tables) özelliğini tam olarak desteklediğini bildirir.

### Siparişler hangi para biriminde kaydedilir?

Müşterinin sipariş sırasında kullandığı para biriminde. Siparişe para birimi kodu, uygulanan kur ve mağazanın o andaki ana para birimi birlikte kaydedilir. Bu kayıt sayesinde, WooCommerce Analytics farklı para birimlerindeki siparişleri birbirine ekleyip yanlış toplamlar üretse bile, siparişleri kendi kurlarıyla dışa aktarıp doğru şekilde yeniden hesaplayabilirsiniz.

### Bir para birimini kaldırmak (listeden çıkarmak) verileri siler mi?

Hayır. Para birimini listeden çıkarmak yalnızca yapılandırmadan kaldırır. O para biriminde alınmış siparişler ve onlara kaydedilmiş kur bilgisi etkilenmez.

### Dönüştürme uç noktasının (endpoint) çağrılma sıklığında bir sınır var mı?

Evet. Önbellek uyumluluğu modu açıkken, önbelleğe alınmış sayfalardaki fiyatlar herkese açık bir REST uç noktası üzerinden çevrilir ve bir adres varsayılan olarak dakikada 120 kez bu uç noktayı çağırabilir. Sıradan bir gezinme bu sınırın çok altındadır — bir sayfa tek bir istek yapar. Mağazanız bir ters proxy veya her ziyaretçiyi aynı adresmiş gibi gösteren bir CDN arkasındaysa, sınırı `mhmcs_convert_rate_limit` filtresiyle yükseltin veya kapatın. Adres, WooCommerce'in güvendiği proxy başlıklarından okunur ve bu başlıklar sahtelenebilir; dolayısıyla bu sınır kararlı bir saldırgana karşı değil, kazara aşırı yüklemeye karşı koruma sağlar.

### "Önbellek uyumluluğu uygulanmıyor" uyarısını görüyorum, bu ne demek?

Bazı temalar ve eklentiler, header'da bir sepet toplamı göstermek için WooCommerce'in sepet sabitini her sayfada tanımlar. Bu olduğunda eklenti her sayfayı bir ödeme (checkout) sayfası gibi ele alır — çünkü müşterinin parası söz konusudur — ve fiyatları sunucuda çevirir; bu da önbellek uyumluluğu modunun tam olarak önlemeye çalıştığı şeydir. Sitede görünürde yanlış bir şey yoktur: sayfayı ilk yükleyen kişi için fiyatlar doğrudur, ardından bir sayfa önbelleği o kişinin para birimini herkese sunabilir. Görünür bir belirti olmadığı için eklenti bunu yönetim panelinde bildirir. Bildirim, bir ön yüz sayfası normal şekilde render edilir edilmez kendiliğinden temizlenir.

### Yapılandırılmış veri (structured data) neden sayfadaki fiyattan farklı bir para birimi gösteriyor?

Önbellek uyumluluğu açıkken sayfa ana para biriminizde üretilir ve fiyatları tarayıcı sonradan çevirir; bu yüzden bir tarayıcı robotunun okuduğu makine tarafından okunabilir ürün verisi ana para biriminde kalır. Bu kasıtlıdır ve düzeltilmez: tersini sabitlemek, verinin sayfayla anlaştığı tek durumda — önbellek uyumluluğu kapalıyken, hem sayfa hem yapılandırılmış veri sunucuda çevrildiğinde — ikisini birbirinden ayırırdı.

### WooCommerce REST API'si çevrilmiş fiyatlar döndürür mü?

Yalnızca istek bir para birimi belirtiyorsa: bir `wc/v3` ürün isteğinde `?currency=EUR` parametresi `price`, `regular_price` ve `sale_price` alanlarını çevirir ve bir `currency_code` alanı ekler. Parametre yoksa yanıt ana para biriminize sabitlenir; yani cevap, isteği yapanın çerezlerine hiçbir zaman bağlı değildir. Burada da ürün bazında sabit fiyat, tıpkı mağaza sayfasında olduğu gibi, döviz kurunun önüne geçer.

Bilinen bir sınır: `price_html` alanı aynı şekilde sabitlenmez. Normal bir `wc/v3` istemcisi bu durumda ona erişemez — yalnızca sayfa render'ı sırasında dahili bir REST isteği gönderen kod erişebilir — dolayısıyla hiçbir entegrasyon onu görmez, ama diğer üç sayısal alanla tutarlı değildir ve bu nedenle burada kayıt altına alınmıştır.

### Fiyatlar değişmiyor, ne kontrol etmeliyim?

1. Para biriminin **Etkin** olduğundan emin olun.
2. Kurun sıfır olmadığını doğrulayın — sıfır kurda fiyat çevrilmeden bırakılır.
3. **Kurları Senkronize Et** düğmesiyle güncel kuru çekin.
4. Tarayıcı önbelleğini temizleyin (Ctrl+Shift+R).
5. Sayfa önbellekleme eklentiniz varsa önbelleği boşaltın — seçilen para birimi çerezde tutulduğu için önbelleğe alınmış sayfalar eski para birimini gösterebilir.

### Eklentiyi silersem verilerim ne olur?

Eklentiyi WordPress üzerinden **sildiğinizde** ayarları, para birimi yapılandırmasını, zamanlanmış görevleri, önbelleğe alınmış kurları ve ürünlere girilmiş sabit fiyatları temizler. **Ayrıca siparişlere kaydedilmiş para birimi kodu ve o siparişte uygulanan döviz kuru da silinir** — hem klasik gönderi meta verisinde hem de HPOS kullanan mağazaların sipariş tablosunda. Çok para birimli satış geçmişinizi korumak istiyorsanız (ör. WooCommerce Analytics'in birbirine eklediği tutarları her siparişe kaydedilmiş kurla doğru şekilde yeniden hesaplamak için), eklentiyi silmeden önce sipariş verilerini dışa aktarın. Yalnızca devre dışı bırakmak hiçbir veriyi silmez.
