---
layout: post
title: "📡 Réseau domestique"
topic: "Tech & Dev"
date: 2026-08-12
image: "/assets/images/posts/reseau-domestique.jpg"
---

![reseau-domestique](/assets/images/posts/reseau-domestique.jpg)

## Contexte

Nouvelle maison, 1'000 m² de terrain, villa de 150 m² en béton armé — pas de Wi-Fi maillé possible. Tout part en filaire depuis une armoire rack 19" 12U au sous-sol.

Réseau et Wi-Fi sur [UniFi](https://ui.com). Serrure et capteurs en Matter/Thread, pilotés depuis Home Assistant. Pas de vidéosurveillance.

## Matériel

| Produit | Rôle | Qté | Prix |
|---|---|---|---|
| [Cloud Gateway Ultra](https://www.galaxus.ch/fr/s1/product/ubiquiti-passerelle-cloud-ultra-routeur-43908900) | Routeur (1 Gbps IPS) | 1 | CHF 85 |
| [Switch Lite 8 PoE](https://www.galaxus.ch/fr/s1/product/ubiquiti-lite-8-poe-8-ports-switch-reseau-13751323) | Switch 8 ports, 4x PoE+ (52W), sur étagère | 1 | CHF 105 |
| [U7 Lite](https://www.galaxus.ch/fr/s1/product/ubiquiti-u7-lite-4300-mbits-point-dacces-55702552) | Borne Wi-Fi 7 plafond (Sous-sol, Rez, Étage) | 3 | CHF 90 |
| [UK-Ultra](https://www.galaxus.ch/fr/s1/product/ubiquiti-point-dacces-uk-ultra-swiss-army-knife-ultra-867-mbits-point-dacces-42077987) | Borne extérieure jardin | 1 | CHF 95 |
| [Nuki Smart Lock Ultra](https://nuki.io/en/products/smart-lock-ultra) | Serrure connectée (Matter/Thread) | 1 | CHF 349 |
| [Connect ZBT-2](https://www.home-assistant.io/connect/zbt-2/) | Dongle Zigbee/Thread pour Home Assistant | 1 | CHF 49 |
| [Aqara Door & Window Sensor P2](https://www.digitec.ch/en/s1/product/aqara-dw-s02d-burglary-protection-alarm-systems-33347603) | Capteur ouverture porte/fenêtre (Matter/Thread) | 6 | CHF 32 |
| [Aqara Thermostat W600](https://www.galaxus.ch/fr/s2/product/aqara-thermostat-w600-thermostat-62433864) | Vanne thermostatique radiateur (Matter/Thread) | 2 | CHF 46 |
| **Total** | | | **~CHF 1'237** |

Le Cloud Gateway Ultra plafonne à 1 Gbps d'IPS, largement suffisant sans caméras. Tout l'accès passe par Thread/Matter plutôt qu'une passerelle propriétaire : Home Assistant Green + Connect ZBT-2 dans l'armoire, et une [Apple TV 4K](https://www.apple.com/ch-fr/apple-tv-4k/) en Ethernet au salon comme second border router Thread — ça renforce le maillage à travers la dalle en béton.

## Infrastructure rack

| Produit | Rôle | Qté | Prix |
|---|---|---|---|
| [Coffret 12U](https://www.galaxus.ch/fr/s1/product/digitus-dn-19-12u-66-armoire-murale-12-he-rack-19-pouces-armoire-serveur-266092) | Armoire murale 19" | 1 | CHF 212 |
| [Patch panel 12 ports](https://www.galaxus.ch/fr/s1/product/delock-panneau-de-brassage-19-keystone-12-ports-19-rack-serveur-accessoires-16399972) | Brassage 19" | 1 | CHF 33 |
| [Étagère 1U](https://www.galaxus.ch/de/s1/product/startech-1u-vented-rack-shelf-serverschrank-zubehoer-54738049) | Support Cloud Gateway/switch/NAS | 1 | ~CHF 30 |
| [PDU Bachmann](https://www.galaxus.ch/fr/s1/product/bachmann-pdu-accessoire-asi-257270) | Multiprise 8x T13, 1U | 1 | CHF 53 |
| [Patch cables](https://eu.store.ui.com/eu/en/category/accessories-cables-dacs/collections/accessories-pro-patch-cables/products/uacc-cable-patch-el-c6a) | Jarretières 0.3m patch panel↔switch | 6 | ~CHF 12 |
| [Onduleur PowerWalker VI 750 R1U](https://www.galaxus.ch/fr/s1/product/powerwalker-vi-750-r1u-750-va-450-w-asi-line-interactive-onduleur-10378379) | UPS 750VA/450W, 1U | 1 | CHF 197 |
| [Apple TV 4K](https://www.galaxus.ch/en/s1/product/apple-tv-4k-3rd-gen-ethernet-128-gb-streaming-box-22720374) | Second border router Thread (salon) | 1 | ~CHF 219 |
| [Home Assistant Green](https://www.home-assistant.io/green/) | Hub domotique + Matter/Thread | 1 | ~CHF 99 |
| **Total** | | | **~CHF 855** |

5 des 12 ports du patch panel utilisés (4 bornes Wi-Fi + Apple TV). L'armoire tourne à ~7-8U sur 12 — encore de la marge.

## Câblage

Box [Yallo Home Supermax](https://www.yallo.ch/fr/promo-internet) (câble coaxial, 2.5 Gbit/s) directement au sous-sol, à côté de l'armoire. En étoile depuis le patch panel : 4 câbles vers les bornes Wi-Fi (Rez, Étage, jardin, Sous-sol), 1 vers l'Apple TV au salon. Câble extérieur blindé anti-UV pour tout ce qui sort de la maison.

Nuki, les capteurs et les vannes Aqara sont sans fil — rien à câbler pour eux.

![Schéma du câblage Ethernet et du maillage Thread](/assets/images/posts/reseau-domestique-cablage.svg)

## NAS

Le Synology DS918+ actuel (tour, pas rackable) reste sur une étagère — le 12U laisse assez de marge pour ses ~5U de dégagement vertical. Garde Download Station et Plex.

## Son

[Sonos Era 100](https://www.sonos.com/fr-ch/shop/era-100) en cuisine, salon et couloir à l'étage, en Wi-Fi pur. Elles rejoignent celle déjà en place.
