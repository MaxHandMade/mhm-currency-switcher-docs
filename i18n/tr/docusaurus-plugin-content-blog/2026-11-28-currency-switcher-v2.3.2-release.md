---
slug: currency-switcher-v2.3.2-release
title: "Currency Switcher 2.3.2 — daha düzgün sütun başlıkları, WooCommerce 11.3 ile sınandı"
authors: [maxhandmade]
tags: [release, currency-switcher]
date: 2026-11-28T12:00
---

2.3.2 küçük bir bakım sürümü. Para Birimlerini Yönet sekmesindeki uzun sütun başlıkları artık heceden bölünüyor ve eklenti WooCommerce 11.3 ile sınandı. Ayarlanacak bir şey yok.

{/* truncate */}

## Sütun başlıkları heceden bölünüyor

**Para Birimlerini Yönet** sekmesindeki bir sütun başlığı sütununa sığmayınca ikinci satıra iner. Şimdiye kadar kenara hangi harf denk gelirse oradan bölünüyordu; örneğin Almanca "Reihenfolge" (Sıra) "Reihenf / olge" diye ayrılıyordu. Artık heceden bölünüyor ve araya tire konuyor: "Reihen- / folge". Türkçe ve İngilizce başlıklar eskisi gibi tek satıra sığıyor.

## WooCommerce 11.3 ile sınandı

Otomatik testler WordPress 7.1.5 üzerinde WooCommerce 11.3.1 ile, HPOS açık ve kapalıyken koştu ve geçti. Eklentinin "WC tested up to" başlığı artık 11.3 diyor.

[GitHub'da 2.3.2](https://github.com/MaxHandMade/mhm-currency-switcher/releases/tag/v2.3.2)
