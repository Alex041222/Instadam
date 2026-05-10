# Instadam - Projecte de Pràctiques

Instadam és una aplicació de xarxa social (clon d'Instagram) desenvolupada amb **Flutter** . L'objectiu principal ha estat crear una interfície funcional, simple i, sobretot, altament accessible.

## 🎨 Decisions de Disseny

### Simplicitat i Estètica
S'ha optat per un disseny **minimalista** per evitar la sobrecàrrega cognitiva. La interfície se centra en el contingut (les publicacions) i les interaccions essencials (likes i comentaris).

### Paleta de Colors
*   **Color Primari:** Blau corporatiu (`#1565C0`). S'ha triat per la seva sobrietat i perquè transmet professionalitat.
*   **Contrast:** S'han utilitzat fons blancs en mode clar i grisos molt foscos en mode nit per garantir un contrast de text elevat, facilitant la lectura a persones amb dificultats visuals.
*   **Mode Fosc:** L'aplicació inclou suport complet per a mode fosc, permetent a l'usuari triar l'entorn que més li convingui segons la il·luminació o preferència personal.

## ♿ Accessibilitat (WCAG 2.1)

Un dels pilars d'aquest projecte ha estat l'accessibilitat. S'ha seguit la normativa **WCAG 2.1** per assegurar que l'app sigui inclusiva:

*   **Semàntica:** S'han implementat widgets de `Semantics` en tota l'aplicació per garantir que els lectors de pantalla (TalkBack/VoiceOver) puguin descriure correctament els botons, imatges i estats.
*   **Etiquetatge descriptiu:** Les imatges i accions tenen descripcions clares (ex: "Imatge de la publicació de [usuari]").
*   **Objectius tàctils:** Tots els botons tenen una mida mínima de **48x48 píxels**, el mínim recomanat per evitar errors en la interacció tàctil.
*   **Regions Vives:** Els missatges d'error s'anuncien immediatament mitjançant regions semàntiques vives.
*   **Internacionalització:** Suport complet per a **Català i Castellà**, permetent que l'usuari consumeixi el contingut en la seva llengua preferida.

## 🛠️ Tecnologies Utilitzades
- **Flutter & Dart**: Per al desenvolupament multiplataforma.
- **SQLite (sqflite)**: Per a la persistència de dades local.
- **ValueNotifier**: Per a una gestió d'estat reactiva i eficient del tema i l'idioma.

---
*Desenvolupat com a part de pràctiques de classe - Maig 2026*
