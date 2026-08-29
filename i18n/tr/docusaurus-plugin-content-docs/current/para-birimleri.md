---
sidebar_position: 3
title: Para Birimlerini Yönet
slug: /para-birimleri
---

# Para Birimlerini Yönet

**WooCommerce > MHM Para Birimi > Para Birimlerini Yönet** sekmesi

Mağazanızda kullanılacak para birimlerini burada yapılandırırsınız.

## Para Birimi Tablosu

| Sütun | Açıklama |
|-------|----------|
| **Etkin** | Para birimini açıp kapatır. Kapalı birimler dönüştürücüde görünmez. |
| **Kod** | ISO 4217 kodu, bayrak simgesi ve para biriminin tam adı |
| **Kur** | Kur türü (Otomatik / Manuel) ve kur değeri |
| **Komisyon** | Kura uygulanacak ek komisyon (Yok / Yüzde / Sabit) |
| **Yuvarlama** | Çevrilen fiyata uygulanacak yuvarlama kuralı |
| **Sıra** | Yukarı/aşağı okları ile listedeki sırayı değiştirir |
| **İşlemler** | Para birimini listeden kaldırır |

Sıralama, dönüştürücü açılır menüsündeki görüntülenme sırasını belirler. Ana para birimi bu
tabloda bir **satır değildir** — tablonun üstünde yazar ve **WooCommerce > Ayarlar > Genel**
bölümünden gelir. Vitrindeki dönüştürücüde ise her zaman ilk sırada yer alır.

## Müşteri Ne Görecek

*1.3.0 ile geldi.*

Her satırın altında bir önizleme satırı vardır: `Müşteri şunu görür: 100,00 <ana> → …`. Bu değer
tarayıcıda tahmin edilmez, **sunucuda mağazanın kendi fiyat biçimlendiricisiyle** hesaplanır;
yani vitrinin uygulayacağı kuru, komisyonu, yuvarlamayı ve sayı biçimini birebir uygular —
**henüz kaydetmediğiniz değişiklikler dahil**. Kuru fiyat üretemeyen satırda tire görünür.

## Para Birimi Başına Sayı Biçimi

*1.3.0 ile geldi.*

Bir satırdaki **Biçimi düzenle** bağlantısı, yalnız o para birimi için beş alan açar:

| Alan | Açıklama |
|-------|----------|
| **Sembol** | Tutarla birlikte gösterilen sembol |
| **Konum** | Sol, Sağ, Sol (boşluklu) veya Sağ (boşluklu) |
| **Ondalık basamak** | Kaç ondalık basamak, 0 ile 4 arası |
| **Ondalık ayırıcı** | Tek karakter |
| **Binlik ayırıcı** | Tek karakter |

WooCommerce bunların yalnız **bir** takımını tutar, çünkü mağazanın tek para birimi olduğunu
varsayar. Buradaki değerler para birimi başınadır ve yalnız o para birimi için geçerlidir.

Girdiler sessizce kabul edilmez, **düzeltilir**: birden uzun ayraç, 0–4 dışında ondalık sayısı,
ya da ondalık ayracıyla aynı olan binlik ayracı. Bir düzeltme yapıldığında ekran bunu söyler —
girdinizi haber vermeden değiştirmez.

## Kur Güncel mi?

*1.3.0 ile geldi.*

Her satırda bir durum satırı, sekme başlığında ise bir özet rozeti bulunur:

| Satır | Anlamı |
|-------|----------|
| **elle girildi** | Kur **Manuel** bir değerdir; onu bir senkron üretmedi |
| **Henüz kur yok — bu para birimi mağazada gösterilmiyor** | Kur 0 ya da eksik; vitrin bu para birimini listelemez |
| **kur kaydedildi, senkron kaydı yok** | Kur var ama bu satır için bir senkron zaman damgası yok |
| **Kur N önce güncellendi** | Bu değeri bir senkron üretti, N önce |

"Henüz senkron kaydı yok" tam olarak bunu söyler: **kayıt yok**. Bir senkronun hiç koşmadığını
iddia etmez — zaman damgası tutmayan bir sürümden yükselen mağazada doğru olan da budur.

## Yeni Para Birimi Ekleme

1. **+ Yeni Para Birimi** düğmesine tıklayın
2. Açılır listeden istediğiniz para birimini seçin (ana para birimi ve zaten ekli olanlar listede çıkmaz)
3. **Ekle** düğmesine tıklayın
4. Kur, komisyon ve yuvarlama ayarlarını yapın
5. **Değişiklikleri Kaydet** düğmesine tıklayın

Yeni eklenen para birimi şu değerlerle gelir: etkin, kur türü **Otomatik**, komisyon **Yok**, yuvarlama **Yok**.

## Kur Türleri

- **Otomatik:** Kur alanı düzenlenemez; değer kur senkronizasyonundan gelir.
- **Manuel:** Kuru kendiniz yazarsınız. Alan 6 ondalık basamağa kadar değer kabul eder.

> **Dikkat:** Kur senkronizasyonu, kur türü ayrımı yapmadan API'den dönen tüm para birimlerinin kurunu günceller. Elle girdiğiniz bir kurun korunmasını istiyorsanız senkronizasyondan sonra değeri kontrol edin.

## Komisyon Türleri

Döviz kuruna ek komisyon uygulamak için üç seçenek vardır:

| Tür | Etki | Örnek (kur 0.92) |
|-----|------|------------------|
| **Yok** | Komisyon uygulanmaz | Efektif kur 0.92 |
| **Yüzde** | Kur, yüzde oranında artırılır | %2.5 → 0.92 × 1.025 = 0.943 |
| **Sabit** | Kura sabit bir değer eklenir | 0.03 → 0.92 + 0.03 = 0.95 |

Komisyon türünü **Yok** yaptığınızda önceden girilmiş komisyon değeri de sıfırlanır.

## Yuvarlama

Çevrilen tutarı düzgün bir rakama oturtmak için kullanılır. Yuvarlama, kur ve komisyon uygulandıktan **sonra** devreye girer ve yalnızca ürün fiyatlarıyla sınırlı değildir — kargo, ek ücretler (fees) ve kupon indirimleri de aynı kuralla yuvarlanır.

| Tür | Etki |
|-----|------|
| **Yok** | Yuvarlama uygulanmaz |
| **En Yakına** | Tutarı belirttiğiniz adımın en yakın katına yuvarlar |
| **Yukarı Yuvarla** | Belirttiğiniz adımın bir üst katına yuvarlar |
| **Aşağı Yuvarla** | Belirttiğiniz adımın bir alt katına yuvarlar |

Yuvarlamayı **Yok** dışında bir değere ayarladığınızda iki alan açılır:

- **Adım değeri:** Neye göre yuvarlanacağı (örneğin `1`, `5`, `0.5`)
- **Çıkar:** Yuvarlamadan sonra düşülecek miktar — psikolojik fiyatlama için kullanışlıdır

**Örnek:** Çevrilen fiyat 47,30 · Tür: Yukarı Yuvarla · Adım: 1 · Çıkar: 0,01 → sonuç **47,99**.

> Adım değeri `0` bırakılırsa yuvarlama uygulanmaz.

## Kurları Senkronize Etme

**Kurları Senkronize Et** düğmesi güncel kurları anında çeker ve tabloya yazar. Senkronizasyon çevrimdışı çalışmaz — sunucunuzun dışarıya HTTP isteği yapabilmesi gerekir.

Kurlar sırayla şu kaynaklardan gelir:

1. **ExchangeRate-API** (birincil) — `api.exchangerate-api.com`
2. **Currency API** (yedek) — `latest.currency-api.pages.dev`
3. **Frankfurter** (ikinci yedek) — `api.frankfurter.dev`

Üçü de ücretsizdir ve API anahtarı istemez. Eklenti sırayla dener ve ilk yanıt
vereni kullanır; hiçbiri yanıt vermezse mevcut kurların yerinde kalır. Çekilen
kurlar 1 gün önbelleklenir, ama bu önbellek yalnızca alıcıya gösterilen fiyat
ekranını besler. **Kurları Senkronize Et** — ister düğmeye tıklayın, ister
`wp mhm-cs rates-sync` çalıştırın, ister zamanlanmış görev tetiklensin — her
durumda önbelleği atlar ve doğrudan API'ye gider.

*2.1.0'dan itibaren zincir kısalıyor: ExchangeRate-API ve tek yedek olarak
Avrupa Merkez Bankası'nın günlük referans kur akışı.*

Sunucu terminaline erişiminiz varsa kurları `wp mhm-cs rates-sync` ile senkronize edebilir veya `wp mhm-cs cache-flush` ile önbelleği elle temizleyebilirsiniz — bkz. [WP-CLI Komutları](/docs/wp-cli).
