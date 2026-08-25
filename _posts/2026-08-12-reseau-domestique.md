---
layout: post
title: "📡 Réseau domestique"
topic: "Tech & Dev"
date: 2026-08-12
image: "/assets/images/posts/reseau-domestique.jpg"
---

![reseau-domestique](/assets/images/posts/reseau-domestique.jpg)

## Contexte

Nouvelle maison (1'000 m² de terrain, villa de 150 m² en béton armé) donc pas de Wi-Fi maillé possible — tout part en filaire depuis une armoire rack 19" 12U au sous-sol vers le reste de la maison et le jardin, sur l'écosystème [UniFi](https://ui.com).

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
| [SuperLink Gateway](https://eu.store.ui.com/eu/en/category/physical-security-sensors-alarms/collections/superlink-gateway) | Passerelle capteurs (PoE) | 1 | €115 |
| [Entry Sensor](https://eu.store.ui.com/eu/en/products/usl-entry) | Capteur ouverture porte/fenêtre | 6 | €35 |
| **Total** | | | **€1'965** |

Plus l'armoire ([coffret 12U](https://www.galaxus.ch/fr/s1/product/digitus-dn-19-12u-66-armoire-murale-12-he-rack-19-pouces-armoire-serveur-266092), [patch panel 24 ports](https://www.galaxus.ch/de/s1/product/rm-patchpanel-24-port-kat-6a-1he-19-ungeschirmt-leer-server-zubehoer-12738645), [étagère](https://www.galaxus.ch/de/s1/product/startech-1u-vented-rack-shelf-serverschrank-zubehoer-54738049), [PDU](https://www.galaxus.ch/de/s1/product/intellinet-19-8-fach-steckdosenleiste-pdu-schutzkontakt-1-he-usv-zubehoer-22820372), [patch cables](https://eu.store.ui.com/eu/en/category/accessories-cables-dacs/collections/accessories-pro-patch-cables/products/uacc-cable-patch-el-c6a) 10-pack, [onduleur PowerWalker VI 750 R1U](https://www.galaxus.ch/fr/s1/product/powerwalker-vi-750-r1u-750-va-450-w-asi-line-interactive-onduleur-10378379) 1U) pour ~400 CHF, et une **Home Assistant Green** (~99 CHF) pour piloter énergie, clim et chauffage.

## Variante allégée (sans vidéosurveillance, accès par Nuki)

Pour comparaison, la même base réseau/Wi-Fi/capteurs sans caméras ni contrôle d'accès UniFi, avec une serrure [Nuki Smart Lock Ultra](https://nuki.io/en/products/smart-lock-ultra) pilotée en local depuis Home Assistant (Matter over Thread) :

| Produit | Rôle | Qté | Prix |
|---|---|---|---|
| [Cloud Gateway Ultra](https://eu.store.ui.com/eu/en/category/cloud-gateways-compact/products/ucg-ultra) | Routeur (1 Gbps IPS) | 1 | €90 |
| [Switch Pro 8 PoE](https://eu.store.ui.com/eu/en/products/usw-pro-8-poe) | Switch 8 ports PoE (120W), sur étagère | 1 | €269 |
| [U7 Lite](https://eu.store.ui.com/eu/en/products/u7-lite) | Borne Wi-Fi 7 plafond (Sous-sol, Rez, Étage) | 3 | €89 |
| [UK-Ultra](https://eu.store.ui.com/eu/en/products/uk-ultra) | Borne extérieure jardin | 1 | €75 |
| [SuperLink Gateway](https://eu.store.ui.com/eu/en/category/physical-security-sensors-alarms/collections/superlink-gateway) | Passerelle capteurs (PoE) | 1 | €115 |
| [Entry Sensor](https://eu.store.ui.com/eu/en/products/usl-entry) | Capteur ouverture porte/fenêtre | 6 | €35 |
| [Nuki Smart Lock Ultra](https://nuki.io/en/products/smart-lock-ultra) | Serrure connectée (Matter/Thread) | 1 | €349 |
| [Connect ZBT-2](https://www.home-assistant.io/connect/zbt-2/) | Dongle Zigbee/Thread pour Home Assistant | 1 | €49 |
| **Total** | | | **€1'424** |

Le Cloud Gateway Ultra plafonne à 1 Gbps d'IPS (vs 2.3 Gbps pour le Max) — suffisant sans caméras, mais ça bride le débit effectif de la ligne Yallo 2.5 Gbit/s si l'inspection de sécurité est activée. La Home Assistant Green + Connect ZBT-2 restent dans l'armoire au sous-sol ; le maillage Thread jusqu'à la Nuki est assuré par les futures prises connectées, avec au moins une prise proche de l'escalier pour faire le premier relais.

Même armoire que la config principale ([coffret 12U](https://www.galaxus.ch/fr/s1/product/digitus-dn-19-12u-66-armoire-murale-12-he-rack-19-pouces-armoire-serveur-266092)), avec un [patch panel 12 ports](https://www.galaxus.ch/fr/s1/product/delock-panneau-de-brassage-19-keystone-12-ports-19-rack-serveur-accessoires-16399972) (19", ~CHF 33) suffisant pour les ~6 câbles de cette config.

## Câblage

En étoile depuis le patch panel du sous-sol : 1 câble depuis le salon (câble coaxial, [Yallo Home Supermax](https://www.yallo.ch/fr/promo-internet) 2.5 Gbit/s), 4 vers les bornes Wi-Fi (Sous-sol, Rez, Étage, jardin), 3 vers les caméras extérieures, 1 vers la serrure. Câble extérieur blindé anti-UV pour tout ce qui sort de la maison.

## NAS

Le Synology DS918+ actuel (tour, pas rackable) reste sur une étagère dans l'armoire — le passage en 12U donne assez de marge pour ses ~5U de dégagement vertical. Garde Download Station et Plex, pas besoin de migrer vers un modèle rackable pour l'instant.

## Son

Enceintes [Sonos Era 100](https://www.sonos.com/fr-ch/shop/era-100) en cuisine, salon et salle de bain, en Wi-Fi pur (l'Era 100 ne supporte plus SonosNet, pas besoin de câbler). Elles rejoignent celle déjà en place.

## Électrique

Sur batterie 14 kWh, la zone secourue se limite à l'armoire réseau et au frigo. La PAC, la borne Tesla et les futurs moteurs de clim restent hors batterie.

## À venir

Clim gainable Mitsubishi PEAD au grenier pour les 4 chambres, zonage Airzone, pilotée depuis Home Assistant.
