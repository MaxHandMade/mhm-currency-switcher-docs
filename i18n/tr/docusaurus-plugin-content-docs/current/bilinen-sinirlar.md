---
sidebar_position: 14
title: Bilinen Sınırlar
slug: /bilinen-sinirlar
---

# Bilinen Sınırlar

Bunlar önbellek uyumluluğu modunun nasıl çalıştığının sonuçlarıdır, kusur değildir. Gözünüz açık karar verebilmeniz için burada listelenmiştir.

### Modu kapatmak, tam olarak 1.0.0 davranışını geri getirmez

Ayarın üstünde duran üç düzeltme, mod açık ya da kapalı olsun yerinde kalır: fiyatlar artık yönetim ekranlarında veya yönetici AJAX isteklerinde çevrilmez (eskiden bu, sipariş satırına çevrilmiş bir fiyat yazıyordu), `wc/v3` REST okumaları ana para birimine sabitlenir ve zamanlanmış görevler ile WP-CLI artık çevirmez. Modu kapatmak yalnızca 1.0.0'daki *görüntüleme* davranışını — fiyatların sunucuda çevrilmesini — geri getirir, başka hiçbir şeyi değil.

### Arama motorları ve tarayıcı robotları ana para biriminizdeki fiyatları görür

Mod açıkken bir tarayıcı robotunun getirdiği sayfa tarayıcıdan geçmemiştir; bu yüzden hem sayfa hem de içindeki makine tarafından okunabilir ürün verisi ana para biriminde fiyat taşır. Yapılandırılmış veri hakkındaki SSS sorusuna bakın; bu uyumsuzluk kasıtlıdır.

### Çevrilmiş fiyatlar, sayfa göründükten kısa bir süre sonra ana fiyatların yerini alır

Sayfa, ana para birimindeki fiyatlarla ekrana gelir — JavaScript'i bekleyen gizli bir şey yoktur — ve tarayıcı, isteği geri döner dönmez çevrilmiş fiyatları yerine koyar; her fiyat değişirken 200ms boyunca solar. Yavaş bir bağlantıda ana fiyat, değişimden önce daha uzun süre okunabilir kalır. Sisteminden azaltılmış hareket (reduced motion) isteyen ziyaretçiler, soldurma olmadan değişimi görür.

### JavaScript kapalıyken veya uç nokta erişilemezken ana fiyatlar kalır

Hiçbir şey bozulmaz ve ziyaretçiye hata gösterilmez — sayfa, render edildiği ana para birimindeki fiyatları korur ve nedeni tarayıcı konsoluna yazılır. Sepet ve ödeme (checkout) bundan etkilenmez, çünkü zaten hiçbir zaman tarayıcıya bağımlı değildi.

### Varyasyonlu ürünler bir ek istek yapar, bazı numune (swatch) eklentileri fiyatı kaybedebilir

Önbelleğe alınabilir bir sayfada eklenti, WooCommerce'i varyasyon fiyatlarını AJAX üzerinden çekmeye zorlar; çünkü WooCommerce'in normalde sayfaya gömdüğü varyasyon JSON'u, kendi betiklerinin doğrudan sayfaya yazdığı ana para birimindeki fiyatları taşır. Bunun bedeli, bir ziyaretçi bir varyasyon seçtiğinde yapılan tek bir istektir; ayrıca `data-product_variations` değeri `false` olur: fiyatları WooCommerce'e sormak yerine bu JSON'dan okuyan üçüncü taraf renk veya beden numunesi eklentileri fiyat göstermeyi bırakabilir. Böyle bir eklenti kullanıyorsanız, canlıya almadan önce varyasyonlu bir ürünü kontrol edin.

### Mini sepet, WooCommerce'in sepet parçalarına (cart fragments) bağımlıdır

Mini sepet her sayfada render edildiği için istek bazında sınıflandırılamaz. Ana para biriminde render edilir ve ardından WooCommerce'in kendi sepet parçası yenilemesiyle düzeltilir; bu da sunucu tarafında bir çevirme işlemidir. Sitenizde sepet parçaları devre dışıysa — bazı temalar ve optimizasyon eklentileri bunları kuyruktan çıkarır — önbelleğe alınmış mini sepet toplamı ana para biriminde kalırken sayfanın geri kalanı çevrilir. Eklenti bunu izler ve gerçekleştiğinde yönetim panelinde bildirir; hiç mini sepeti olmayan bir site bu konuda hiç uyarılmaz.

### WooCommerce'in bilmediği bir sayfadaki sepet veya ödeme, önbelleğinizden hariç tutulmalıdır

Sayfa önbellekleri, WooCommerce'in atadığı sayfaları tanıdıkları için sepet ve ödeme sayfalarını otomatik olarak hariç tutar. Sepet veya ödeme kısa kodunu ya da bloğunu başka bir sayfaya koyduysanız, o sayfayı kendiniz hariç tutun. Aksi halde iki şey ters gider: çevirme kararı render'ın ortasında "çevir"e döner, bu yüzden sayfanın geri kalanı zaten çevrilmiş ve tarayıcının aradığı işaretler olmadan basılır; blok tabanlı sepet ve ödeme de tutarlarını render sırasında sayfaya JSON olarak gömer. Her iki durumda da önbellek, ilk ziyaretçinin para birimini herkese sunar. Sepet içeriği zaten kişiseldir; böyle bir sayfa önbelleğe alınmamalıdır.

### `?currency=` parametresi önbellek girdilerinizi çoğaltır

Bir para birimi URL üzerinden istenebilir ve bir önbellek her farklı URL'yi ayrı bir girdi olarak ele alır; bu yüzden `?currency=EUR` ve `?currency=GBP`'ye bağlantı vermek aynı sayfayı birden fazla kez saklar. Dönüştürücünün kendisi bu URL'leri üretmez — bir çerez yazar ve, **yalnızca istemci tarafı çevirme açıkken**, sayfayı yeniden yüklemeden yerinde çevirir. Sepet sayfasında, oturum açmış bir ziyaretçi için veya önbellek uyumluluğu kapalıyken dönüştürücü bunun yerine sayfayı yeniden yükler — bu durumların hiçbirinde sayfada dinleyecek bir dönüştürme betiği yoktur, çünkü sayfa zaten sunucuda, ziyaretçiye özel çevrilmiştir.

`?currency=` bağlantısı yalnızca o sayfa görüntülemesi için geçerlidir: kasıtlı olarak hiçbir çerez ayarlamaz, bu yüzden ziyaretçinin açacağı bir sonraki sayfa, dönüştürücüyü kullanmadıkça yeniden ana para biriminizde olur. Bu bir eksiklik değildir — sessizce bir para birimini sabitleyen bir bağlantı, kataloğu bir para biriminde gösterirken çerezi okuyan sepetin başka bir para birimde tahsilat yapmasına yol açabilirdi. Kalıcı olan bir kampanya bağlantısı istiyorsanız, ziyaretçileri parametreye güvenmek yerine dönüştürücüyü taşıyan bir sayfaya gönderin.

### WooCommerce Analytics, farklı para birimlerini birbirine ekler

Bir sipariş, müşterinin ödediği para biriminde saklanır ve WooCommerce Analytics her siparişin rakamlarını, onları geri çevirmeden mağaza para biriminizde raporlar. 4,38 USD'lik bir sipariş, ana para biriminizde 4,38 olarak sayılır; yani birden fazla para biriminde sipariş almaya başladığınızda Analytics'teki gelir rakamları ve sipariş ekranındaki müşteri panelindeki toplamlar, birbirine benzemeyen tutarların toplamı haline gelir. Siparişlerin kendisi doğrudur — her biri kendi para birimini, toplamını ve verildiği andaki döviz kurunu korur, bu eklenti de o kuru siparişe kaydeder. Doğru okunamayan, toplu raporlardır. Bu eklenti bunu dışarıdan düzeltemez; doğru çok para birimli raporlama gerekiyorsa siparişleri dışa aktarıp her birine kaydedilmiş kuru kullanarak kendiniz çevirin.

### Oturum açmış ziyaretçiler sunucuda çevrilir

Oturum açmış ziyaretçiler sunucu tarafı yolu izler; bu, önbelleğiniz neredeyse hepsinin yaptığı gibi davranıp oturum açmış kullanıcılara asla önbelleğe alınmış sayfa sunmadığı sürece doğrudur. Çerezlere bakmadan önbelleğe alan bir kenar (edge) önbelleği veya CDN bir istisnadır ve orada oturum açmış bir ziyaretçinin çevrilmiş sayfası saklanıp başkalarına sunulabilir. Kenarda önbelleğe alıyorsanız, oturum çerezine göre farklılaştığını (vary) doğrulayın.
