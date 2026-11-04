---
slug: currency-switcher-v2.3.0-release
title: "Currency Switcher 2.3.0 — klavyeyle çalışan dönüştürücü, gerçek fiyatı izleyen dönüştürülmüş fiyatlar"
authors: [maxhandmade]
tags: [release, currency-switcher]
date: 2026-11-04T02:30
---

2.3.0 ile para birimi dönüştürücüsü klavyeyle kullanılabiliyor. Ürünün kendi fiyatı gizlendiğinde dönüştürülmüş fiyatlar da gizleniyor, dönüştürücüye ihtiyaç duymayan sayfalar da daha az yükleniyor. Sürüm WooCommerce tabanını 9.1'e çıkarıyor; güncellemeden önce WooCommerce sürümünüzü kontrol edin.

{/* truncate */}

## WooCommerce 9.1 veya sonrası

Eklenti WooCommerce 7.4'ü desteklediğini söylüyordu, ama bunu sınayan hiçbir şey yoktu. Taban artık eklentinin otomatik testlerinin gerçekten kurduğu en eski WooCommerce'i gösteriyor: **9.1**. Mağazanız WooCommerce 7.4–9.0 kullanıyorsa önce WooCommerce'i güncelleyin. Gereksinimlerin tamamı [kurulum sayfasında](/docs/installation).

## Dönüştürücü klavyeyle çalışıyor

Dönüştürücüye Tab ile gelip Enter ile açabiliyordunuz, ama hiçbir tuş para birimi seçemiyordu. Artık **Enter**, **Boşluk**, **↓** ya da **↑** listeyi geçerli para biriminde açıyor. **↑ ↓ Home End** liste içinde geziniyor, **Enter** ya da **Boşluk** para birimini seçiyor, **Escape** hiçbir şeyi değiştirmeden listeyi kapatıyor. Klavye odağı çerçeveyle gösteriliyor; daha önce hiç görünmediği gezinme menüsünde de. Bu davranış kısa kodda, Elementor bileşeninde ve menü öğesinde aynı. Bkz. [Görüntüleme seçenekleri](/docs/display-options).

## Fiyat gizlendiğinde dönüştürülmüş fiyatlar da gizleniyor

Bir tema ya da eklenti ürünün fiyatını gizlediğinde (katalog veya bakım modu, "fiyatı görmek için giriş yapın") WooCommerce'in fiyatı kayboluyor, ama dönüştürülmüş fiyatlar altında görünmeye devam ediyordu. Ürün fiyat bileşeni artık ürünün kendi fiyatını izliyor. Fiyat gizlendiğinde ya da bir mesajla değiştirildiğinde dönüştürülmüş fiyatlar da gizleniyor. Fiyata yalnızca ek yapan bir eklentide, örneğin "KDV dahil" yazısında, görünmeye devam ediyorlar.

## Dönüştürücünün kullanılmadığı sayfalarda daha az yükleme

Fiyatlar sunucunuzda dönüştürüldüğünde (önbellek uyumluluğu kapalıyken, giriş yapmış müşterilerde, sepet ve ödeme sayfasında) dönüştürücünün betiği artık yalnızca dönüştürücü gösteren sayfalarda yükleniyor. Fiyatların tarayıcıda dönüştürüldüğü yerlerde (varsayılan olan önbellek uyumluluğu açıkken, giriş yapmamış ziyaretçilerde, sepet ve ödeme sayfası dışında) hiçbir şey değişmiyor.

[GitHub'da 2.3.0](https://github.com/MaxHandMade/mhm-currency-switcher/releases/tag/v2.3.0)
