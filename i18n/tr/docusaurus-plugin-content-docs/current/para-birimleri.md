---
sidebar_position: 3
title: Para Birimlerini Yönet
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

Sıralama, dönüştürücü açılır menüsündeki görüntülenme sırasını belirler. Ana para birimi her zaman listenin en başında yer alır.

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

Kurlar şu kaynaklardan alınır:

1. **ExchangeRate-API** (birincil) — `api.exchangerate-api.com`
2. **Fawaz Ahmed Currency API** (yedek) — birincil kaynak yanıt vermezse devreye girer

Her iki kaynak da ücretsizdir ve **API anahtarı gerektirmez**. Çekilen kurlar 1 gün boyunca önbellekte tutulur; bu süre dolmadan yapılan senkronizasyonlar önbellekteki değeri kullanır.
