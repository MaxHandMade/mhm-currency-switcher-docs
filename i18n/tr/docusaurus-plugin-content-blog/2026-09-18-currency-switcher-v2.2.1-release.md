---
slug: currency-switcher-v2.2.1-release
title: "Currency Switcher 2.2.1 — Türkçe eklentinin içinde, önbellek uyarıları yerinde"
authors: [maxhandmade]
tags: [release, currency-switcher, translation, cache]
date: 2026-09-18T20:07
---

2.2.1 gözle görülen iki şeyi düzeltiyor. Türkçe bir sitede eklenti İngilizce görünüyordu, ve iki önbellek uyumluluğu uyarısı sürekli kalkıp geri geliyordu. İkisi de düzeldi; güncellemeden sonra yapmanız gereken bir şey yok.

<!--truncate-->

## Türkçe çeviri eklentiyle birlikte geliyor

WordPress.org'dan kurulan eklenti Türkçe bir sitede İngilizce görünüyordu: sürüm paketi derlenmiş çeviri dosyalarını dışarıda bırakmıştı ve onların yerini alacak bir WordPress.org dil paketi yoktu. Dosyalar pakete geri döndü. WordPress 6.8 ve üstünde eklentinin tamamı Türkçe. 6.6 ve 6.7'de ayarlar ekranı Türkçe, ama eklentinin PHP kodundan gelen metinler, örneğin menü etiketi, İngilizce kalıyor — bkz. [Bilinen Sınırlar](/docs/known-limits). Başka diller [translate.wordpress.org](https://translate.wordpress.org/projects/wp-plugins/mhm-currency-switcher/) üzerinden eklenebilir.

## Önbellek uyarıları artık gelip gitmiyor

İki önbellek uyumluluğu uyarısı, sorunu gösteremeyen bir sayfa işlendiğinde — bir müşterinin sepeti açması ya da sizin mağazayı oturum açıkken gezmeniz — bütün yöneticilerin ertelemesiyle birlikte kalkıyor ve bir sonraki sayfa görüntülemesi onları geri getiriyordu. Artık her kontrol üç cevaptan birine varıyor: sorun var, sayfa temiz ya da bu sayfa karar veremez. Uyarı, sorunun ilk görüldüğü sayfayı göstermeye devam ediyor ve yalnızca aynı sayfa sorunsuz işlendiğinde, o sayfa artık olmadığında ya da önbellek uyumluluğunu kapatıp kaydettiğinizde kalkıyor. **Bu değişene kadar ertele** artık tutuyor ve iki uyarı da ne zaman kalkacağını söylüyor. Her uyarının nasıl çalıştığı [SSS](/docs/faq) sayfasında anlatılıyor.

[GitHub'da 2.2.1](https://github.com/MaxHandMade/mhm-currency-switcher/releases/tag/v2.2.1)
