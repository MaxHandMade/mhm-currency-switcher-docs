---
slug: currency-switcher-v2.3.1-release
title: "Currency Switcher 2.3.1 — Almanca ve İspanyolca, her ekrana ulaşan çeviriler"
authors: [maxhandmade]
tags: [release, currency-switcher]
date: 2026-11-21T09:40
---

2.3.1 Almanca ve İspanyolca çeviri ekliyor ve birden fazla çeviri olduğunda eklentinin hangisini kullandığını değiştiriyor. Başka bir şey değişmiyor, ayarlanacak bir şey de yok.

{/* truncate */}

## Almanca ve İspanyolca

Eklenti artık İngilizce, Türkçe, Almanca ve İspanyolca geliyor. Almanca ya da İspanyolca bir sitede ayarlar ekranı, menü etiketleri, yönetici bildirimleri ve dönüştürücü o dilde görünüyor. Bkz. [Diller](/docs/installation#diller).

## WordPress.org çevirileri ayarlar ekranına ulaşıyor

[translate.wordpress.org](https://translate.wordpress.org/projects/wp-plugins/mhm-currency-switcher/) üzerinde yapılan çeviriler bir dil paketi olarak gelir. Şimdiye kadar ayarlar ekranı, eklentinin kendi taşıdığı dillerde bu paketi yok sayıp hep eklentinin çevirisini gösteriyordu; translate.wordpress.org'da yapılan bir düzeltme oraya hiç ulaşmıyordu. Artık her ekranda öncelik dil paketinde.

## Eksik metin eklentinin çevirisine düşüyor

Dil paketi yeni bir sürümün gerisinde kalabilir: sürümde eklenen metin, çevirmenler yetişene kadar İngilizce görünür. Artık bu metin eklentinin kendi çevirisini kullanıyor; dil paketinin taşıdığı her metinde yine paket kazanıyor.

## WordPress 6.6 ve 6.7

WordPress 6.6 ve 6.7'de menü etiketleri, yönetici bildirimleri ve dönüştürücü, eklenti dilinizin çevirisini taşısa bile İngilizce kalıyordu. Artık orada da çevriliyor; eklenti desteklenen her sürümde aynı görünüyor.

[GitHub'da 2.3.1](https://github.com/MaxHandMade/mhm-currency-switcher/releases/tag/v2.3.1)
