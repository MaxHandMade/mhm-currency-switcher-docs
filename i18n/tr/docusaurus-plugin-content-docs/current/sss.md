---
sidebar_position: 13
title: SSS
slug: /faq
---

# Sık Sorulan Sorular

Bu sayfa, eklentinin `readme.txt` dosyasındaki sık sorulan sorularla bu kılavuzun kendi SSS bölümünü birleştirir; aynı soru iki kaynakta da varsa readme'nin cevabı kullanılmıştır — kaynak metin readme.txt'tir.

### Kaç para birimi ekleyebilirim?

Sınır yoktur — WooCommerce'in sunduğu her para birimini etkinleştirebilirsiniz, ücretli bir sürüm için hiçbir şey saklı tutulmaz. REST API, tek istekte 500'den fazla para birimi satırı taşınmasını reddeder; bu aşırı büyük yüklere karşı bir korumadır ve WooCommerce'in kendi sunduğu kod sayısının çok üzerindedir, yani panelden bu sınıra hiçbir zaman ulaşılmaz. Kullanıcının gördüğü tek sınır ürün sayfasındaki fiyat bileşenidir: **Görüntüleme Seçenekleri** sekmesinden en fazla 5 para birimi seçip aynı anda gösterebilirsiniz.

### Döviz kurları nasıl ve ne sıklıkla güncellenir?

Kurlar ExchangeRate-API'den gerçek zamanlı çekilir ve kullanılan kaynak ücretsizdir, API anahtarı gerektirmez. Bu kaynağa ulaşılamazsa eklenti tek bir yedeği — Avrupa Merkez Bankası'nın günlük referans kur akışını — dener; o da yanıt vermezse mevcut kurlarınız yerinde kalır. İkisi de kaynak ve koşullarıyla birlikte [Para Birimlerini Yönetme](/docs/managing-currencies) sayfasında listelidir; ağınız yedeği engelliyorsa `mhmcs_fallback_rates_url` filtresiyle başka bir adrese yönlendirebilirsiniz — 2.1.0'dan beri filtrenin kaynak argümanı her zaman `ecb`, çünkü zincirde tek yedek var. Güncelleme sıklığını **Gelişmiş** sekmesinden siz belirlersiniz: saatlik, günde iki kez, günlük veya yalnızca elle. **Kurları Senkronize Et** düğmesiyle her zaman elle de güncelleyebilirsiniz. Çekilen kurlar 1 gün önbellekte tutulur ve bu önbellek yalnızca fiyat ekranını besler — senkronizasyon her zaman API'ye gider.

### Kısa kodlar nelerdir, dönüştürücüyü sitemde nasıl gösteririm?

*2.0.0'da yeniden adlandırıldı.* Bu etiketler önceden `[mhm_currency_switcher]` ve `[mhm_currency_prices]` idi; eskileri takma ad olarak bırakılmadı, kaldırıldı. Hâlâ eski etiketi taşıyan bir sayfa dönüştürücü yerine ham metni gösterir — kullandığınız her yazıyı, sayfayı ve şablonu güncelleyin. Kayıtlı verileriniz değişmedi.

İki kısa kod vardır:

- `[mhmcs_currency_switcher]` — para birimi açılır listesini gösterir. Tek isteğe bağlı özelliği `size`'dır (`small`, `medium` veya `large`); belirtilmezse Görüntüleme Seçenekleri'nde kayıtlı boyut kullanılır.
- `[mhmcs_currency_prices]` — aynı ürün fiyatını birden çok para biriminde gösterir. Tüm özellikleri isteğe bağlıdır: `currencies` (virgülle ayrılmış kodlar, ör. `currencies="USD,EUR"`; belirtilmezse Görüntüleme Seçenekleri'ndeki para birimleri kullanılır — yapılandırmadığınız kodlar yok sayılır), `product_id` (görüntülenen ürün yerine belirli bir ürünü fiyatlandırır), `price` (bir ürün yerine belirli bir tutarı fiyatlandırır), `show_flags` (kayıtlı bayrak ayarını `true`/`false` ile geçersiz kılar).

Her ikisi de Elementor widget'ı olarak kullanılabilir. Dönüştürücüyü header'a eklemenin dört yolu vardır:

1. **Navigasyon menüsü (önerilen):** Görünüm > Menüler'den **Para Birimi Dönüştürücü** öğesini menünüze ekleyin.
2. **Widget alanı:** Temanızın header widget alanına bir "Kısa Kod" widget'ı ekleyip `[mhmcs_currency_switcher]` yazın.
3. **Elementor:** Header şablonunuza **Currency Switcher** widget'ını sürükleyin.
4. **PHP:** Temanızın şablon dosyasına `<?php echo do_shortcode( '[mhmcs_currency_switcher]' ); ?>` ekleyin.

### Belirli bir ürüne sabit fiyat verebilir miyim?

Evet. Ürün düzenleme ekranındaki **Para Birimi Fiyatları** sekmesini kullanın — ayrıntılar için [Ürün Bazında Sabit Fiyatlar](/docs/fixed-prices) bölümüne bakın. Şunu bilerek kullanın: sabit fiyat ürün ve para birimi başına saklanır, fiyat türüne göre değil — yani aynı tutar hem normal fiyat hem de indirimli fiyat için kullanılır. Ana para biriminizde indirimde olan bir ürün, sabit fiyat verdiğiniz bir para biriminde indirimde değilmiş gibi görünür. İndirimin o para birimine de yansımasını istiyorsanız, o para birimini sabitlemek yerine döviz kuruna bırakın.

### WooCommerce HPOS (Yüksek Performanslı Sipariş Depolama) ile uyumlu mu?

Evet. Eklenti, WooCommerce'in Yüksek Performanslı Sipariş Depolama (HPOS / Custom Order Tables) özelliğini tam olarak desteklediğini bildirir.

### Siparişler hangi para biriminde kaydedilir?

Müşterinin sipariş sırasında kullandığı para biriminde. Siparişe para birimi kodu, uygulanan kur ve mağazanın o andaki ana para birimi birlikte kaydedilir. Bu kayıt sayesinde, WooCommerce Analytics farklı para birimlerindeki siparişleri birbirine ekleyip yanlış toplamlar üretse bile, siparişleri kendi kurlarıyla dışa aktarıp doğru şekilde yeniden hesaplayabilirsiniz.

### Bir para birimini kaldırmak (listeden çıkarmak) verileri siler mi?

Hayır. Para birimini listeden çıkarmak yalnızca yapılandırmadan kaldırır. O para biriminde alınmış siparişler ve onlara kaydedilmiş kur bilgisi etkilenmez.

### Dönüştürme uç noktasının (endpoint) çağrılma sıklığında bir sınır var mı?

Evet. Önbellek uyumluluğu modu açıkken, önbelleğe alınmış sayfalardaki fiyatlar herkese açık bir REST uç noktası üzerinden çevrilir ve bir adres varsayılan olarak dakikada 120 kez bu uç noktayı çağırabilir. Sıradan bir gezinme bu sınırın çok altındadır — bir sayfa tek bir istek yapar. Mağazanız bir ters proxy veya her ziyaretçiyi aynı adresmiş gibi gösteren bir CDN arkasındaysa, sınırı `mhmcs_convert_rate_limit` filtresiyle yükseltin veya kapatın. Adres, WooCommerce'in güvendiği proxy başlıklarından okunur ve bu başlıklar sahtelenebilir; dolayısıyla bu sınır kararlı bir saldırgana karşı değil, kazara aşırı yüklemeye karşı koruma sağlar.

### "Önbellek uyumluluğu uygulanmıyor" uyarısını görüyorum, bu ne demek?

Bazı temalar ve eklentiler, header'da bir sepet toplamı göstermek için WooCommerce'in sepet sabitini her sayfada tanımlar. Bu olduğunda eklenti her sayfayı bir ödeme (checkout) sayfası gibi ele alır — çünkü müşterinin parası söz konusudur — ve fiyatları sunucuda çevirir; bu da önbellek uyumluluğu modunun tam olarak önlemeye çalıştığı şeydir. Sitede görünürde yanlış bir şey yoktur: sayfayı ilk yükleyen kişi için fiyatlar doğrudur, ardından bir sayfa önbelleği o kişinin para birimini herkese sunabilir. Görünür bir belirti olmadığı için eklenti bunu yönetim panelinde bildirir.

**Hangi sayfayı gösterir.** Uyarı, sorunun ilk görüldüğü sayfayı adıyla söyler (yalnız yol; sorgu dizesi olmadan) ve sorun sürdükçe başka sayfalarda da aynı sorun görülse bile o sayfayı göstermeye devam eder. Gerçek sepet ya da ödeme sayfasına yapılan bir ziyaret iki yönde de sayılmaz: sabit orada zaten meşru olarak tanımlıdır.

**Ne zaman kalkar.** Aynı sayfa yeniden normal şekilde işlendiğinde, o sayfa artık yoksa (sayfaya yapılan istek "bulunamadı" döndüğünde) ya da önbellek uyumluluğunu kapatıp kaydettiğiniz anda. Sayfa önbelleğinizden sunulan bir kopya eklentinin sunucudaki denetimine hiç ulaşmaz; bu yüzden temayı düzelttikten sonra önbelleği temizleyin.

**Kim görür, nerede görünür.** Yalnızca WooCommerce'i yönetebilen kullanıcılara ve yalnızca üç ekranda gösterilir: bu eklentinin ayarlar sayfası, **WooCommerce > Ayarlar** ve **WooCommerce > Durum**.

**Ertelemek.** **Bu değişene kadar ertele** düğmesi uyarıyı yalnızca sizin için gizler — WooCommerce'i yönetebilen diğer kullanıcılar görmeye devam eder — ve uyarı kalkana kadar geçerlidir. Sorun bundan sonra yeniden ortaya çıkarsa uyarı, aynı sayfa için bile yeniden gösterilir.

### "Mini sepet ana para biriminde takılı kaldı" uyarısını görüyorum, bu ne demek?

Önbelleğe alınan bir sayfada mini sepet önce ana para biriminizde basılır, ardından WooCommerce'in `wc-cart-fragments` betiği onu yeniler. Bu yenileme sunucudan geçer; çeviri de orada yapılır. Temalar ve optimizasyon eklentileri hız için bu betiği sık sık kaldırır. Kaldırdıklarında sayfadaki diğer tüm fiyatlar tarayıcıda çevrilir, ama mini sepet toplamı ana para biriminde kalır.

Uyarı yalnızca dört koşulun hepsi birden sağlandığında görünür: önbellek uyumluluğu açık, sayfa önbelleğe alınan türden (oturum açmamış bir ziyaretçi; sepet, ödeme ya da hesap sayfası olmayan bir sayfa), gerçekten bir mini sepet basılmış ve WordPress betiği o sayfaya basmamış. Mini sepeti olmayan bir mağaza, betik kaldırılmış olsa bile bu uyarıyı hiç görmez. Düzeltmek için betiğin yeniden yüklenmesine izin verin ya da mini sepeti önbelleğe alınan sayfalardan kaldırın.

Bir sayfayı adıyla söyler; yukarıdaki önbellek uyumluluğu uyarısıyla aynı kişilere, aynı ekranlarda gösterilir ve aynı şekilde ertelenir. Aynı sayfa, oturum açmamış bir ziyaretçi için betik yüklenmiş olarak işlendiğinde — ya da mini sepeti kaldırdıysanız, sepetinde ürün bulunan oturum açmamış bir ziyaretçi için işlendiğinde — ya da önbellek uyumluluğunu kapatıp kaydettiğiniz anda kendiliğinden kalkar. Kendi mağazanızı oturum açıkken gezmeniz onu hiçbir zaman kaldırmaz, çünkü o görüntüleme önbelleğin sakladığı görüntüleme değildir; sepet sabitinin tanımlı olduğu her sayfada da — yukarıdaki uyarının bildirdiği sorun — hiçbir işleme önbelleğe alınabilir sayılmaz, bu yüzden önce onu düzeltin. Öteki uyarıda olduğu gibi, düzelttikten sonra sayfa önbelleğinizi temizleyin.

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

Anahtara bağlı: [Gelişmiş Ayarlar](/docs/advanced-settings) sekmesindeki **Eklenti kaldırıldığında tüm verileri sil** anahtarı varsayılan olarak **kapalıdır**. Kapalı kaldığı sürece, eklentiyi WordPress üzerinden sildiğinizde bile ayarlarınız, para birimi yapılandırmanız ve her siparişe kaydedilmiş para birimi ile uygulanan döviz kuru yerinde kalır — yalnızca önbelleğe alınmış kurlar, zamanlanmış görevler ve artık var olmayan ayarların sakladığı gizli bilgiler gibi hiçbir zaman kalmaması gereken şeyler temizlenir.

Bu anahtarı silmeden önce açarsanız eklenti her şeyi kaldırır: ayarları, para birimi yapılandırmasını ve siparişlere kaydedilmiş para birimi kodu ile döviz kurunu — hem klasik gönderi meta verisinde hem de HPOS kullanan mağazaların sipariş tablosunda. Çok para birimli satış geçmişinizi korumak istiyorsanız (ör. WooCommerce Analytics'in birbirine eklediği tutarları her siparişe kaydedilmiş kurla doğru şekilde yeniden hesaplamak için), anahtarı açtıysanız eklentiyi silmeden önce sipariş verilerini dışa aktarın. Yalnızca devre dışı bırakmak hiçbir veriyi silmez.
