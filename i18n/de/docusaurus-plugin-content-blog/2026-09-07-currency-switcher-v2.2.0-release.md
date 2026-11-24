---
slug: currency-switcher-v2.2.0-release
title: "Currency Switcher 2.2.0 — IP-Adressen von Besuchern verlassen deinen Server nicht mehr"
authors: [maxhandmade]
tags: [release, currency-switcher, privacy, geolocation]
date: 2026-09-07T13:25
---

2.2.0 ist eine Datenschutz-Korrektur. In einem Shop ohne lokale MaxMind-Datenbank konnte die Geolokalisierung die IP-Adresse jedes neuen Besuchers an einen externen Geolokalisierungsdienst senden. Das ist nicht mehr möglich. Außerdem ist die Geolokalisierung bei Neuinstallationen standardmäßig deaktiviert. Wenn du darauf angewiesen bist, lies den letzten Abschnitt: In manchen Shops ist jetzt eine Einstellung nötig, damit sie weiterhin funktioniert.

{/* truncate */}

## Was sich geändert hat

Um die Währung eines Besuchers zu erkennen, fragt das Plugin WooCommerce, in welchem Land sich der Besucher befindet. Wenn WooCommerce keine lokale MaxMind-Datenbank hatte, konnte diese Abfrage auf einen externen Geolokalisierungsdienst zurückfallen, der die IP-Adresse des Besuchers erhielt. Der Storefront-Code von WooCommerce selbst schaltet diesen Fallback ab; dieses Plugin rief dieselbe Funktion mit ihren Standardwerten auf, sodass der Fallback für diese Funktion aktiv blieb. 2.2.0 schaltet ihn ebenfalls ab. Die Erkennung nutzt jetzt nur noch den Länder-Header von CloudFlare oder eine MaxMind-Datenbank auf deinem eigenen Server – **keine Daten über den Besucher verlassen deinen Server**.

## Geolokalisierung ist bei Neuinstallationen zunächst deaktiviert

Das Land eines Besuchers anhand seiner IP-Adresse zu ermitteln, ist eine Datenverarbeitung. Deshalb schaltest du sie bei einer Neuinstallation jetzt bewusst selbst ein, im Tab **Erweitert**. **Shops, die aktualisiert werden, behalten ihre bisherige Einstellung** – nichts wird ohne dein Zutun deaktiviert.

## ⚠️ Wenn du Geolokalisierung ohne CloudFlare oder MaxMind nutzt

Die Erkennung findet jetzt nichts mehr, statt einen externen Dienst abzufragen, und Besucher behalten deine Basiswährung, bis sie selbst eine auswählen. Um die Funktion beizubehalten, füge unter **WooCommerce > Einstellungen > Integration > MaxMind Geolocation** einen kostenlosen MaxMind-GeoLite2-Lizenzschlüssel hinzu. WooCommerce lädt dann die Datenbank herunter und hält sie aktuell, und jede Abfrage erfolgt auf deinem eigenen Server. Der Tab „Erweitert“ gibt jetzt an, was die Geolokalisierung benötigt – unabhängig davon, ob sie aktiviert ist. Details: [Erweiterte Einstellungen](/docs/advanced-settings) und [Währungserkennung](/docs/currency-detection).

[2.2.0 auf GitHub](https://github.com/MaxHandMade/mhm-currency-switcher/releases/tag/v2.2.0)
