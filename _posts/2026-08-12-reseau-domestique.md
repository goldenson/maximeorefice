---
layout: post
title: "📡 Réseau domestique"
topic: "Tech & Dev"
date: 2026-08-12
image: "/assets/images/posts/reseau-domestique.jpg"
---

![reseau-domestique](/assets/images/posts/reseau-domestique.jpg)

## Contexte

Nouvelle maison (1'000 m² de terrain, villa de 150 m² en béton armé) donc pas de Wi-Fi maillé possible — tout part en filaire depuis une armoire rack 19" 7U au sous-sol vers le reste de la maison et le jardin, sur l'écosystème [UniFi](https://ui.com).

## Matériel

| Produit | Rôle | Qté | Prix |
|---|---|---|---|
| [Cloud Gateway Max](https://eu.store.ui.com/eu/en/products/ucg-max) | Routeur + NVR local | 1 | €250 |
| [Switch Pro Max 16 PoE](https://eu.store.ui.com/eu/en/products/usw-pro-max-16-poe) | Switch 16 ports PoE (180W) | 1 | €359 |
| [U7 Lite](https://eu.store.ui.com/eu/en/products/u7-lite) | Borne Wi-Fi 7 plafond (Sous-sol, Rez, Étage) | 3 | €89 |
| [UK-Ultra](https://eu.store.ui.com/eu/en/products/uk-ultra) | Borne extérieure jardin | 1 | €75 |
| [G6 Turret](https://eu.store.ui.com/eu/en/products/uvc-g6-turret) | Caméra 4K (entrée, terrasse, garage) | 3 | €179 |
| [Access Ultra](https://eu.store.ui.com/eu/en/products/ua-ultra) | Lecteur de badge porte | 1 | €90 |
| [Strike Lock](https://eu.store.ui.com/eu/en/products/uacc-lock-strike-secure-15mm) | Gâche fail-secure | 1 | €80 |
| **Total** | | | **€1'658** |

Plus l'armoire ([coffret 7U](https://www.galaxus.ch/de/s1/product/digitus-7he-dynamic-basic-wandgehaeuse-7-he-19-zoll-rack-serverschrank-10325219), [patch panel 24 ports](https://www.galaxus.ch/de/s1/product/rm-patchpanel-24-port-kat-6a-1he-19-ungeschirmt-leer-server-zubehoer-12738645), [étagère](https://www.galaxus.ch/de/s1/product/startech-1u-vented-rack-shelf-serverschrank-zubehoer-54738049), [PDU](https://www.galaxus.ch/de/s1/product/intellinet-19-8-fach-steckdosenleiste-pdu-schutzkontakt-1-he-usv-zubehoer-22820372), [patch cables](https://eu.store.ui.com/eu/en/category/accessories-cables-dacs/collections/accessories-pro-patch-cables/products/uacc-cable-patch-el-c6a) 10-pack) pour ~200 CHF, et une **Home Assistant Green** (~99 CHF) pour piloter énergie, clim et chauffage.

## Câblage

En étoile depuis le patch panel du sous-sol : 1 câble depuis le salon (fibre), 4 vers les bornes Wi-Fi (Sous-sol, Rez, Étage, jardin), 3 vers les caméras extérieures, 1 vers la serrure. Câble extérieur blindé anti-UV pour tout ce qui sort de la maison.

## NAS

Le Synology DS918+ actuel (tour, pas rackable) reste hors armoire pour l'instant. Options envisagées pour un remplacement rackable 1U : [Synology RS422+](https://www.galaxus.ch/fr/s1/product/synology-rs422-0-tb-nas-21046432) (4 baies, DSM, garde Download Station et Plex) ou [UniFi UNAS Pro 4](https://www.galaxus.ch/de/s1/product/ubiquiti-unas-pro-4-unifi-unas-pro-4-nas-69401902) (4 baies, 10G, intégré à la console UniFi mais sans les apps DSM).

## Son

Enceintes [Sonos Era 100](https://www.sonos.com/fr-ch/shop/era-100) en cuisine, salon et salle de bain, en Wi-Fi pur (l'Era 100 ne supporte plus SonosNet, pas besoin de câbler). Elles rejoignent celle déjà en place.

## Électrique

Sur batterie 14 kWh, la zone secourue se limite à l'armoire réseau et au frigo. La PAC, la borne Tesla et les futurs moteurs de clim restent hors batterie.

## À venir

Clim gainable Mitsubishi PEAD au grenier pour les 4 chambres, zonage Airzone, pilotée depuis Home Assistant.
