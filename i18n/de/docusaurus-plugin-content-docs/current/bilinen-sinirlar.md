---
sidebar_position: 14
title: "Bekannte Einschränkungen"
slug: /known-limits
---

# Bekannte Einschränkungen

Dies sind Folgen der Funktionsweise des Plugins, keine Fehler. Sie werden hier aufgeführt, damit du deine Entscheidung in voller Kenntnis der Sachlage treffen kannst.

## Cache-Kompatibilitätsmodus

### Das Ausschalten des Modus stellt nicht exakt das Verhalten von 1.0.0 wieder her

Drei Korrekturen stehen über der Einstellung und bleiben unabhängig davon aktiv, ob sie ein- oder ausgeschaltet ist: Preise werden in Admin-Ansichten und bei Admin-AJAX nicht mehr umgerechnet (früher wurde dadurch ein umgerechneter Preis in eine Bestellposition geschrieben), `wc/v3`-REST-Lesezugriffe sind fest auf die Basiswährung gesetzt, und geplante Aufgaben sowie WP-CLI rechnen nicht mehr um. Das Ausschalten des Modus stellt das *Anzeige*verhalten von 1.0.0 wieder her – serverseitig umgerechnete Preise – und sonst nichts.

*Seit 1.1.0.* Falls eine dieser Regeln für einen Drittanbieter-Kontext, den das Plugin nicht erkennen kann, falsch ist, ist der Filter `mhmcs_should_convert` der Notausgang. Er erhält die Entscheidung und den Zweig, der sie getroffen hat – einen von `force`, `admin`, `rest`, `cron_cli`, `cache_compat_off`, `money`, `logged_in`, `pre_wp`, `display` –, und die Rückgabe von `true` bewirkt eine Umrechnung, während `false` die Basiswährung beibehält. Sobald eine Anfrage auf Umrechnung festgelegt ist, wird der Filter für diese Anfrage nicht erneut befragt: Genau das erneute Öffnen der Entscheidung mitten im Rendern hat früher dazu geführt, dass eine Seite Basispreise anzeigte, während ihr AJAX-Checkout den umgerechneten Betrag berechnete.

### Suchmaschinen und Crawler sehen deine Basispreise

Bei aktiviertem Modus ist die Seite, die ein Crawler abruft, nicht durch den Browser gelaufen. Sie enthält daher Preise in der Basiswährung, ebenso wie die maschinenlesbaren Produktdaten darin. Siehe die entsprechende Frage in den [FAQ](/docs/faq); die Abweichung ist beabsichtigt.

### Umgerechnete Preise ersetzen die Basispreise einen Moment nach dem Erscheinen der Seite

Die Seite kommt mit deinen Preisen in der Basiswährung bereits sichtbar an – nichts wird versteckt, während auf JavaScript gewartet wird –, und der Browser tauscht die umgerechneten Preise ein, sobald seine Anfrage zurückkommt, wobei jeder Preis beim Wechsel über 200 ms überblendet wird. Bei einer langsamen Verbindung ist der Basispreis vor dem Austausch länger lesbar. Besucher, die in ihrem System reduzierte Bewegung eingestellt haben, erhalten den Austausch ohne Überblendung.

### Bei deaktiviertem JavaScript oder unerreichbarem Endpunkt bleiben die Basispreise stehen

Nichts geht kaputt und dem Besucher wird kein Fehler angezeigt – die Seite behält einfach die Preise in der Basiswährung, mit denen sie gerendert wurde, und der Grund wird in die Browserkonsole geschrieben. Warenkorb und Kasse sind nicht betroffen, da sie von vornherein nie vom Browser abhingen.

### Variable Produkte lösen eine zusätzliche Anfrage aus, und manche Swatch-Plugins verlieren den Preis

Auf einer cachebaren Seite zwingt das Plugin WooCommerce, Variantenpreise per AJAX abzurufen, da das Varianten-JSON, das WooCommerce sonst in die Seite einbetten würde, Preise in der Basiswährung enthält, die WooCommerces eigene Skripte direkt in die Seite schreiben. Der Preis dafür ist eine Anfrage, wenn ein Besucher eine Variante auswählt, und dass `data-product_variations` `false` ist: Swatch-Plugins von Drittanbietern für Farbe oder Größe, die Preise aus diesem JSON auslesen, statt WooCommerce zu fragen, zeigen möglicherweise keinen Preis mehr an. Wenn du ein solches Plugin verwendest, prüfe vor dem Livegang ein variables Produkt.

### Der Mini-Warenkorb ist auf die Warenkorb-Fragmente von WooCommerce angewiesen

Ein Mini-Warenkorb wird auf jeder Seite gerendert und lässt sich daher nicht pro Anfrage einordnen. Er wird in der Basiswährung gerendert und anschließend durch die WooCommerce-eigene Aktualisierung der Warenkorb-Fragmente korrigiert, die eine serverseitige Umrechnung ist. Wenn Warenkorb-Fragmente auf deiner Website deaktiviert sind – manche Themes und Optimierungs-Plugins entfernen sie –, bleibt die Summe im gecachten Mini-Warenkorb in der Basiswährung, während der Rest der Seite umgerechnet wird. Das Plugin achtet darauf und weist im Adminbereich darauf hin, wenn es passiert; eine Website ganz ohne Mini-Warenkorb erhält diese Warnung nie.

### Ein Warenkorb oder eine Kasse auf einer Seite, die WooCommerce nicht kennt, muss von deinem Cache ausgeschlossen werden

Seiten-Caches schließen Warenkorb und Kasse automatisch aus, weil sie die Seiten erkennen, die WooCommerce zugewiesen hat. Wenn du einen Warenkorb- oder Kassen-Shortcode bzw. -Block auf einer anderen Seite eingefügt hast, musst du diese Seite selbst ausschließen. Andernfalls gehen zwei Dinge schief: Die Umrechnungsentscheidung springt mitten im Rendern auf „umrechnen“, sodass der Rest der Seite bereits umgerechnet und ohne die Markierungen ausgegeben wird, nach denen der Browser sucht, und blockbasierte Warenkörbe und Kassen betten ihre Beträge beim Rendern als JSON in die Seite ein. In beiden Fällen liefert der Cache dann die Währung des ersten Besuchers an alle aus. Warenkorbinhalte sind ohnehin persönlich; eine solche Seite sollte nicht gecacht werden.

### `?currency=` vervielfacht deine Cache-Einträge

Eine Währung kann in der URL angefordert werden, und ein Cache behandelt jede unterschiedliche URL als eigenen Eintrag. Verlinkst du also auf `?currency=EUR` und `?currency=GBP`, wird dieselbe Seite mehrfach gespeichert. Der Umschalter selbst erzeugt solche URLs nicht – er schreibt ein Cookie und lässt die Adresse unverändert. Auf einer gecachten Seite rechnet er die Preise an Ort und Stelle um; auf der Warenkorbseite, bei angemeldeten Besuchern oder bei ausgeschalteter Cache-Kompatibilität lädt er stattdessen die Seite neu. In beiden Fällen ist die URL diejenige, auf der sich der Besucher bereits befand, sodass kein zusätzlicher Cache-Eintrag entsteht.

Ein `?currency=`-Link gilt außerdem nur für diesen einen Seitenaufruf: Er setzt bewusst kein Cookie, sodass die nächste Seite, die der Besucher öffnet, wieder in deiner Basiswährung erscheint, sofern er nicht den Umschalter verwendet. Das ist kein Versehen – ein Link, der stillschweigend eine Währung festlegt, könnte im Katalog eine Währung anzeigen, während der Warenkorb, der das Cookie ausliest, in einer anderen abrechnet. Wenn du einen Kampagnenlink möchtest, der dauerhaft wirkt, schicke Besucher auf eine Seite mit dem Umschalter, statt dich auf den Parameter zu verlassen.

### WooCommerce Analytics addiert unterschiedliche Währungen

Eine Bestellung wird in der Währung gespeichert, in der der Kunde bezahlt hat, und WooCommerce Analytics weist die Zahlen jeder Bestellung in deiner Shopwährung aus, ohne sie zurückzurechnen. Eine Bestellung über 4,38 USD wird als 4,38 in deiner Basiswährung gezählt. Sobald du Bestellungen in mehr als einer Währung entgegennimmst, sind die Umsatzzahlen in Analytics und die Summen im Kundenbereich der Bestellansicht daher Summen ungleichartiger Beträge. Die Bestellungen selbst sind korrekt – jede behält ihre eigene Währung, ihre Summe und den Wechselkurs, zu dem sie aufgegeben wurde, und dieses Plugin speichert diesen Kurs in der Bestellung. Es sind die zusammengefassten Berichte, die sich nicht als Geldbeträge lesen lassen. Dieses Plugin kann das von außen nicht beheben; wenn du genaue Berichte über mehrere Währungen brauchst, exportiere die Bestellungen und rechne sie mit dem in jeder Bestellung gespeicherten Kurs um.

### Angemeldete Besucher werden auf dem Server umgerechnet

Angemeldete Besucher durchlaufen den serverseitigen Weg. Das ist korrekt, solange dein Cache das tut, was nahezu alle Caches tun, und angemeldeten Benutzern nie gecachte Seiten ausliefert. Ein Edge-Cache oder CDN, das so konfiguriert ist, dass es ohne Berücksichtigung von Cookies cacht, ist die Ausnahme; dort kann die umgerechnete Seite eines angemeldeten Besuchers gespeichert und weiter ausgeliefert werden. Wenn du am Edge cachst, stelle sicher, dass der Cache nach dem Anmelde-Cookie unterscheidet.
