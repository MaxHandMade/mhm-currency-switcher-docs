---
slug: currency-switcher-v2.2.1-release
title: "Currency Switcher 2.2.1 — Türkisch im Plugin und Cache-Warnungen, die bestehen bleiben"
authors: [maxhandmade]
tags: [release, currency-switcher, translation, cache]
date: 2026-09-18T20:07
---

2.2.1 behebt zwei Probleme, die du bemerken konntest. Auf einer türkischen Website erschien das Plugin auf Englisch, und die beiden Warnungen zur Cache-Kompatibilität verschwanden immer wieder und tauchten erneut auf. Beides ist behoben, und nach dem Update musst du nichts weiter tun.

{/* truncate */}

## Die türkische Übersetzung wird mit dem Plugin ausgeliefert

Bei Installation über WordPress.org erschien das Plugin auf einer türkischen Website auf Englisch: Im Release-Paket fehlten die kompilierten Übersetzungsdateien, und es gab kein WordPress.org-Sprachpaket, das sie hätte ersetzen können. Sie sind jetzt wieder im Paket enthalten. Ab WordPress 6.8 ist das gesamte Plugin auf Türkisch. Unter 6.6 und 6.7 ist der Einstellungsbildschirm auf Türkisch, aber Texte, die aus dem PHP-Code des Plugins stammen, etwa die Menübezeichnung, bleiben auf Englisch – siehe [Bekannte Einschränkungen](/docs/known-limits). Weitere Sprachen können auf [translate.wordpress.org](https://translate.wordpress.org/projects/wp-plugins/mhm-currency-switcher/) ergänzt werden.

## Cache-Warnungen kommen und gehen nicht mehr

Die beiden Warnungen zur Cache-Kompatibilität wurden früher – zusammen mit dem Ausblenden durch sämtliche Administratoren – jedes Mal zurückgesetzt, wenn eine Seite das Problem nicht zeigen konnte, etwa wenn ein Kunde den Warenkorb öffnete oder du angemeldet durch den Shop surftest, und beim nächsten Seitenaufruf tauchten sie wieder auf. Jede Prüfung kommt jetzt zu einem von drei Ergebnissen: Das Problem besteht, die Seite ist sauber, oder diese Seite kann es nicht feststellen. Eine Warnung nennt weiterhin die erste Seite, auf der das Problem festgestellt wurde, und verschwindet nur, wenn genau diese Seite ohne das Problem dargestellt wird, wenn diese Seite nicht mehr existiert oder wenn du die Einstellungen mit deaktivierter Cache-Kompatibilität speicherst. **Ausblenden, bis sich etwas ändert** bleibt jetzt bestehen, und beide Warnungen geben an, wann sie verschwinden. Wie die einzelnen Warnungen funktionieren, ist in den [FAQ](/docs/faq) beschrieben.

[2.2.1 auf GitHub](https://github.com/MaxHandMade/mhm-currency-switcher/releases/tag/v2.2.1)
