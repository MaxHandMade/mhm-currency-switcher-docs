---
sidebar_position: 13
title: "FAQ"
slug: /faq
---

# FAQ

Diese Seite führt die FAQ aus der readme.txt des Plugins mit einigen Fragen zusammen, die speziell die Leser dieses Leitfadens betreffen. Wo eine Frage an beiden Stellen vorkommt, wird hier die Antwort aus der readme verwendet – die readme.txt ist die maßgebliche Quelle.

### Wie viele Währungen kann ich hinzufügen?

So viele, wie dein Shop benötigt – jede Währung, die WooCommerce anbietet, kann aktiviert werden, und nichts ist einer kostenpflichtigen Version vorbehalten. Die REST-API lehnt eine Anfrage mit mehr als 500 Währungszeilen ab; das ist ein Schutz gegen übergroße Payloads und liegt weit über der Anzahl der Codes, die WooCommerce selbst anbietet, sodass das Panel diese Grenze nicht erreichen kann. Die einzige Stelle, an der eine Obergrenze für Benutzer sichtbar ist, ist das Produktpreis-Widget: Im Tab **Anzeigeoptionen** kannst du dort höchstens 5 Währungen gleichzeitig anzeigen.

### Wie werden Wechselkurse abgerufen?

Wechselkurse werden in Echtzeit von ExchangeRate-API abgerufen, entweder auf Abruf oder nach einem von dir festgelegten Zeitplan (stündlich, zweimal täglich, täglich oder nur manuell), damit deine Kurse ohne manuelles Eingreifen aktuell bleiben.

Wenn diese Quelle nicht erreichbar ist, versucht das Plugin eine Ausweichquelle – den täglichen Referenzkurs-Feed der Europäischen Zentralbank –, bevor es aufgibt und deine bestehenden Kurse beibehält. Beide werden mit ihren Nutzungsbedingungen auf der Seite [Währungen verwalten](/docs/managing-currencies) genannt. Wenn dein Netzwerk die Ausweichquelle blockiert, kannst du sie mit dem Filter `mhmcs_fallback_rates_url` auf eine andere Adresse umleiten; seit 2.1.0 ist das Quellargument des Filters immer `ecb`, da die Kette nur eine einzige Ausweichquelle hat.

Abgerufene Kurse werden 1 Tag lang zwischengespeichert, und dieser Cache dient nur der Preisanzeige, die Kunden sehen – eine Synchronisierung umgeht ihn immer und geht direkt zur Quelle, egal ob du auf **Kurse synchronisieren** klickst, den WP-CLI-Befehl ausführst oder die geplante Aufgabe auslösen lässt.

### Welche Shortcodes gibt es?

`[mhmcs_currency_switcher]` gibt das Währungs-Dropdown aus. Er akzeptiert ein Attribut, `size`, das `small`, `medium` oder `large` sein kann; lässt du es weg, wird die in den Anzeigeoptionen gespeicherte Größe verwendet.

`[mhmcs_currency_prices]` gibt denselben Produktpreis in mehreren Währungen aus. Alle Attribute sind optional:

- `currencies` – kommagetrennte Codes, z. B. `currencies="USD,EUR"`. Ohne dieses Attribut werden die in den Anzeigeoptionen gewählten Währungen verwendet. Codes, die du nicht als Währungen eingerichtet hast, werden ignoriert.
- `product_id` – den Preis eines bestimmten Produkts statt des gerade angezeigten ausgeben.
- `price` – einen bestimmten Betrag statt des Preises eines Produkts ausgeben.
- `show_flags` – `true` oder `false`; überschreibt die gespeicherte Einstellung in den Anzeigeoptionen.

Beide sind auch als Elementor-Widgets verfügbar. Unter [Den Umschalter platzieren](/docs/placing-the-switcher) findest du die Umbenennungshistorie der Shortcodes und alle Möglichkeiten, sie zu deiner Website hinzuzufügen.

### Kann ich für ein bestimmtes Produkt einen festen Preis festlegen?

Ja. Verwende den Tab **Währungspreise** auf der Bearbeitungsseite des Produkts – Details findest du unter [Feste Preise pro Produkt](/docs/fixed-prices). Gut zu wissen: Ein fester Preis wird pro Produkt und Währung gespeichert, nicht pro Preistyp, daher wird derselbe Betrag für den regulären Preis und den Angebotspreis verwendet. Ein Produkt, das in deiner Basiswährung im Angebot ist, wird in einer Währung, für die du einen festen Preis festgelegt hast, als nicht im Angebot angezeigt. Wenn das Angebot übernommen werden soll, überlasse diese Währung dem Wechselkurs, statt sie festzulegen.

### Ist das Plugin mit WooCommerce HPOS kompatibel?

Ja. MHM Currency Switcher unterstützt WooCommerce High-Performance Order Storage (HPOS / Custom Order Tables) vollständig.

### In welcher Währung werden Bestellungen erfasst?

In der Währung, die der Kunde beim Aufgeben der Bestellung verwendet hat. Die Bestellung speichert den Währungscode, den angewendeten Wechselkurs und die Basiswährung deines Shops zu diesem Zeitpunkt. Dieser Datensatz ermöglicht es dir, Bestellungen zu exportieren und mit ihren eigenen Kursen korrekt neu zu berechnen, auch wenn WooCommerce Analytics Bestellungen in verschiedenen Währungen zu einer einzigen, irreführenden Gesamtsumme addiert.

### Werden beim Entfernen einer Währung deren Daten gelöscht?

Nein. Wenn du eine Währung aus der Liste nimmst, wird sie nur aus deiner Konfiguration entfernt. Bereits in dieser Währung aufgegebene Bestellungen und der darin erfasste Wechselkurs bleiben unberührt.

### Gibt es eine Begrenzung, wie oft der Umrechnungs-Endpunkt aufgerufen werden kann?

Ja. Wenn der Cache-Kompatibilitätsmodus aktiviert ist, werden Preise auf zwischengespeicherten Seiten über einen öffentlichen REST-Endpunkt umgerechnet, und eine Adresse darf ihn standardmäßig 120-mal pro Minute aufrufen. Normales Surfen kommt dem nicht annähernd nahe – eine Seite stellt eine Anfrage. Wenn dein Shop hinter einem Reverse Proxy oder einem CDN liegt, durch das jeder Besucher wie dieselbe Adresse aussieht, erhöhe oder deaktiviere die Begrenzung mit dem Filter `mhmcs_convert_rate_limit`. Beachte, dass die Adresse aus den Proxy-Headern gelesen wird, die WooCommerce weitergibt, denen es bedingungslos vertraut und die gefälscht werden können; die Begrenzung bremst versehentliche Dauerabfragen, nicht einen entschlossenen Angreifer.

### Ich sehe eine Warnung, dass die Cache-Kompatibilität nicht angewendet wird. Was bedeutet das?

Manche Themes und Plugins definieren die Warenkorb-Konstante von WooCommerce auf jeder Seite, meist um eine Warenkorbsumme im Header anzuzeigen. In diesem Fall behandelt das Plugin jede Seite wie einen Bezahlvorgang – es geht um das Geld des Kunden – und rechnet Preise auf dem Server um, was genau das ist, was der Cache-Kompatibilitätsmodus vermeiden soll. Auf der Website sieht nichts falsch aus: Die Preise stimmen für denjenigen, der die Seite zuerst lädt, und danach kann ein Seiten-Cache die Währung dieser Person allen anderen ausliefern. Da es kein sichtbares Symptom gibt, weist das Plugin stattdessen im Admin-Bereich darauf hin.

**Welche Seite genannt wird.** Die Warnung nennt die erste Seite, auf der das Problem festgestellt wurde (nur den Pfad, ohne Query-String), und nennt diese Seite weiterhin, solange das Problem besteht, auch wenn andere Seiten dasselbe Problem zeigen. Ein Aufruf der echten Warenkorb- oder Kassenseite zählt in keiner Richtung: Dort ist die Konstante berechtigterweise definiert.

**Wann sie verschwindet.** Sobald dieselbe Seite wieder normal ausgegeben wird, sobald diese Seite nicht mehr existiert (eine Anfrage danach liefert „nicht gefunden“) oder sobald du die Einstellungen mit ausgeschalteter Cache-Kompatibilität speicherst. Eine aus deinem Seiten-Cache ausgelieferte Kopie erreicht die Prüfung des Plugins auf dem Server nie, leere also den Cache, nachdem du das Theme korrigiert hast.

**Wer sie sieht und wo.** Sie wird nur Benutzern angezeigt, die WooCommerce verwalten können, und nur auf drei Bildschirmen: der Einstellungsseite dieses Plugins, **WooCommerce > Einstellungen** und **WooCommerce > Status**.

**Ausblenden.** **Ausblenden, bis sich etwas ändert** blendet die Warnung nur für dich aus – andere Benutzer, die WooCommerce verwalten können, sehen sie weiterhin –, bis die Warnung verschwindet. Tritt das Problem danach erneut auf, wird die Warnung wieder angezeigt, auch auf derselben Seite.

### Ich sehe eine Warnung, dass der Mini-Warenkorb in der Basiswährung feststeckt. Was bedeutet das?

Auf einer Seite, die zwischengespeichert wird, wird der Mini-Warenkorb in deiner Basiswährung ausgegeben und dann durch das WooCommerce-Script `wc-cart-fragments` aktualisiert. Diese Aktualisierung läuft über den Server, wo die Umrechnung stattfindet. Themes und Optimierungs-Plugins entfernen das Script oft aus Geschwindigkeitsgründen, und wenn sie das tun, wird jeder andere Preis auf der Seite im Browser umgerechnet, während die Summe des Mini-Warenkorbs in deiner Basiswährung bleibt.

Die Warnung erscheint nur, wenn alle vier Bedingungen zutreffen: Die Cache-Kompatibilität ist aktiviert, die Seite wird zwischengespeichert (ein abgemeldeter Besucher auf einer Seite, die nicht die Warenkorb-, Kassen- oder Kontoseite ist), ein Mini-Warenkorb wurde tatsächlich ausgegeben, und WordPress hat das Script auf dieser Seite nicht ausgegeben. Ein Shop ohne Mini-Warenkorb sieht sie nie, auch wenn das Script entfernt wurde. Um das zu beheben, lass das Script wieder laden oder entferne den Mini-Warenkorb von zwischengespeicherten Seiten.

Sie nennt eine Seite, wird denselben Personen auf denselben Bildschirmen angezeigt und lässt sich auf dieselbe Weise ausblenden wie die oben beschriebene Warnung zur Cache-Kompatibilität. Sie verschwindet von selbst, sobald dieselbe Seite für einen abgemeldeten Besucher mit geladenem Script ausgegeben wird – oder, falls du den Mini-Warenkorb entfernt hast, für einen abgemeldeten Besucher, der etwas im Warenkorb hat – oder sobald du die Einstellungen mit ausgeschalteter Cache-Kompatibilität speicherst. Wenn du angemeldet in deinem eigenen Shop surfst, verschwindet sie nie, weil diese Ansicht nicht die ist, die ein Cache speichert; und auf jeder Seite, auf der die Warenkorb-Konstante definiert ist – das Problem, das die obige Warnung meldet –, zählt ebenfalls keine Ausgabe als zwischenspeicherbar, also behebe zuerst dieses Problem. Wie bei der anderen Warnung solltest du nach der Korrektur deinen Seiten-Cache leeren.

### Warum zeigen die strukturierten Daten eine andere Währung als der Preis auf der Seite?

Bei aktivierter Cache-Kompatibilität wird die Seite in deiner Basiswährung erzeugt und der Browser rechnet die Preise anschließend um, sodass die maschinenlesbaren Produktdaten, die ein Crawler liest, in der Basiswährung bleiben. Das ist beabsichtigt und wird nicht korrigiert: Würde man es umgekehrt festlegen, würden die Daten genau in dem einen Fall von der Seite abweichen, in dem beide derzeit übereinstimmen – bei ausgeschalteter Cache-Kompatibilität, wenn sowohl die Seite als auch die strukturierten Daten auf dem Server umgerechnet werden.

### Liefert die WooCommerce REST-API umgerechnete Preise?

Nur wenn die Anfrage eine Währung angibt: `?currency=EUR` bei einer `wc/v3`-Produktanfrage rechnet `price`, `regular_price` und `sale_price` um und fügt ein Feld `currency_code` hinzu. Ohne den Parameter ist die Antwort auf deine Basiswährung festgelegt, sodass sie nie von den Cookies des Aufrufers abhängt. Ein fester Preis pro Produkt hat hier Vorrang vor dem Wechselkurs, genau wie auf der Shopseite.

Eine bekannte Einschränkung: Das Feld `price_html` ist nicht auf dieselbe Weise festgelegt. Ein normaler `wc/v3`-Client kann es in diesem Zustand nicht erreichen – nur Code, der während der Ausgabe einer Seite eine interne REST-Anfrage auslöst –, daher sieht es keine Integration, aber es ist nicht konsistent mit den drei numerischen Feldern und wird hier dokumentiert, statt verschwiegen zu werden.

### Die Preise ändern sich nicht – was sollte ich prüfen?

1. Stelle sicher, dass die Währung **Aktiv** ist.
2. Prüfe, dass der Kurs nicht null ist – bei einem Kurs von null bleiben Preise unumgerechnet.
3. Hole mit der Schaltfläche **Kurse synchronisieren** einen aktuellen Kurs.
4. Leere deinen Browser-Cache (Strg+Umschalt+R).
5. Wenn du ein Seiten-Caching-Plugin verwendest, leere dessen Cache – die gewählte Währung wird in einem Cookie gespeichert, daher kann eine zwischengespeicherte Seite weiterhin eine alte Währung anzeigen.

### Was passiert mit meinen Daten, wenn ich das Plugin lösche?

Standardmäßig bleiben beim Löschen des Plugins deine Einstellungen, die Währungskonfiguration sowie die bei jeder Bestellung erfasste Währung und der Wechselkurs erhalten – beim Löschen wird nur entfernt, was nie bestehen bleiben sollte, etwa zwischengespeicherte Kurse, geplante Aufgaben und Geheimnisse, die von inzwischen entfernten Einstellungen gespeichert wurden. Soll das Plugin stattdessen alles entfernen, einschließlich der Währungsdaten von Bestellungen (sowohl in den klassischen Bestell-Metadaten als auch in den Bestelltabellen von Shops mit HPOS), aktiviere **Alle Daten löschen, wenn das Plugin entfernt wird** in den [Erweiterten Einstellungen](/docs/advanced-settings), bevor du es löschst. Bleibt dieser Schalter ausgeschaltet, bleibt deine Verkaufshistorie in mehreren Währungen auch nach dem Entfernen des Plugins erhalten.

Etwas ist hier nicht beantwortet? Eröffne ein Issue auf
[GitHub](https://github.com/MaxHandMade/mhm-currency-switcher/issues).
