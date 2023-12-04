<details><summary>Licensed under the LGPL license</summary><p>

Copyright (c) [Kokleeko S.L.](https://github.com/kokleeko) and contributors. All rights reserved.
<br>Licensed under the LGPL license. See [LICENSE](LICENSE) file in the project root for details.
</p></details>

# WordClock++
[![Qt](https://img.shields.io/badge/Qt-5.15%20LTS-green)](https://doc.qt.io/qt-5)
![ViewCount](https://views.whatilearened.today/views/github/kokleeko/WordClock.svg)

[![Android](https://github.com/kokleeko/WordClock/actions/workflows/android.yml/badge.svg?branch=main)](https://github.com/kokleeko/WordClock/actions/workflows/build-upload-android.yml)
[![iOS](https://github.com/kokleeko/WordClock/actions/workflows/ios.yml/badge.svg?branch=main)](https://github.com/kokleeko/WordClock/actions/workflows/build-upload-ios.yml)
[![macOS](https://github.com/kokleeko/WordClock/actions/workflows/macos.yml/badge.svg?branch=main)](https://github.com/kokleeko/WordClock/actions/workflows/macos.yml)
[![Ubuntu](https://github.com/kokleeko/WordClock/actions/workflows/ubuntu.yml/badge.svg?branch=main)](https://github.com/kokleeko/WordClock/actions/workflows/ubuntu.yml)
[![WebAssembly](https://github.com/kokleeko/WordClock/actions/workflows/wasm.yml/badge.svg)](https://github.com/kokleeko/WordClock/actions/workflows/wasm.yml)
[![Windows](https://github.com/kokleeko/WordClock/actions/workflows/windows.yml/badge.svg?branch=main)](https://github.com/johanrkokleekoemilien/WordClock/actions/workflows/windows.yml)

[![codefactor](https://www.codefactor.io/repository/github/kokleeko/WordClock/badge)](https://www.codefactor.io/repository/github/kokleeko/WordClock)
[![Codacy Badge](https://app.codacy.com/project/badge/Grade/52b97f63c7374ead9f582e8631cef76a)](https://www.codacy.com/gh/kokleeko/WordClock/dashboard?utm_source=github.com&amp;utm_medium=referral&amp;utm_content=kokleeko/WordClock&amp;utm_campaign=Badge_Grade)
[![Crowdin](https://badges.crowdin.net/wordclock/localized.svg)](https://crowdin.com/project/wordclock)

<p float="left">
	<a href="https://apps.apple.com/app/wordclock/id1626068981">
  		<picture>
    		<img src="https://github.com/kokleeko/WordClock/assets/15193153/9364ee0d-8a6d-4534-9938-4fd215286d4c" alt="App Store" width="180">
    	</picture>
  	</a>
  	<a href="https://play.google.com/store/apps/details?id=io.kokleeko.wordclock">
  		<picture>
   			<img src="https://github.com/kokleeko/WordClock/assets/15193153/190a9bdc-be5b-4f9b-809b-4ebf8a4819f4" alt="Google Play" width="180">
   		</picture>
  	</a>
  	<a href="https://wordclock.kokleeko.io">
   		<picture>
   			<img src="https://github.com/kokleeko/WordClock/assets/15193153/0422fc2f-5828-47c0-b78f-c270a084f942" alt="WebAssembly" width="180">
   		</picture>
  	</a>
</p>

Languages currently supported: 
- American English (🇺🇸)
- British English (🇬🇧)
- French (Français)
- Spanish (Español)

🗣 [WordClock++](https://github.com/kokleeko/WordClock) will use the language defined in the preferences of your device
(_if this language is not yet supported, English will be used by default_).

<details>
  <summary> (optional) </summary>
💡 Each grid contains a special message that will be displayed instead of the time for a minute at the following times 12:00 AM (00:00), 11:11 AM (*11:11), and 10:22 PM (22:22).
The minute indicator at the bottom of the panel will show 0, 1, or 2 lights, which will allow the user to distinguish between these different states.
This feature can be deactivated
</details>


## 🗽 English version:

### 📸 Examples
- #### ⌚️ 07:18 AM|PM
  <img width="752" alt="🇺🇸 (07:18 AM|PM)" src="https://user-images.githubusercontent.com/15193153/162678526-15a598f0-5d7d-4bbf-99f9-afb713767600.png">

<details>
  <summary> ➕ See more </summary>
  
  - #### 🕠 05:00 AM|PM
    <img width="752" alt="🇺🇸 (05:00 AM|PM)" src="https://user-images.githubusercontent.com/15193153/162683884-e6ef8f53-1cc0-4fee-9585-46a46eda7172.png">

  - #### 🕥 10:30 AM|PM
    <img width="752" alt="🇺🇸 (10:30 AM|30)" src="https://user-images.githubusercontent.com/15193153/162683695-aa76f62f-000c-49bd-ab2b-5a17c84e76f3.png">
</details>

#### 🎲 Can you find the message that has been hidden in this grid ([without looking at the code](res/english.qml#L202-L214))?

<img width="752" alt="🇺🇸 table)" src="https://user-images.githubusercontent.com/15193153/163260654-393641a8-34b2-4403-9e9b-f3b54cf4b120.png">

<details>
  <summary> 👀  The secret message is hidden here </summary>
  <img width="752" alt="🇺🇸 (00:00 AM)" src="https://user-images.githubusercontent.com/15193153/162680132-23fceb49-6dfc-4b97-ac28-293961389ddd.png">

  #### Had you guessed it? 🧠
  <details>
    <summary>🤩 Yes!! Get your present 🎁 </summary>

[![statue of liberty](http://www.guiadenuevayork.com/images/pi/39.jpg)]( https://www.youtube.com/watch?v=9bZkp7q19f0&t=69s)

*source of the picture: www.guiadenuevayork.com*

  </details>
  <details>
    <summary>😔 no..</summary>

*It's okay, you can still go get your present!* 😜

  </details>
</details>

## 💃🏻 Spanish version:
### 📸 Ejemplos
- #### ⌚️ 00:56 AM|PM
  <img width="752" alt="🇪🇸 (00:56 AM)" src="https://user-images.githubusercontent.com/15193153/162676280-8df20095-4983-4318-9da9-8ad3827f206f.png">

<details>
  <summary> ➕ Ver más </summary>
  
  - #### 🕞 03:30 AM|PM
    <img width="752" alt="🇪🇸 (03:30 AM|PM)" src="https://user-images.githubusercontent.com/15193153/162685208-773dac03-5db1-4446-8390-0da1c25c5f15.png">
  - #### 🕘 09:O0 AM|PM
    <img width="752" alt="🇪🇸 (09:00 AM|PM)" src="https://user-images.githubusercontent.com/15193153/162685274-7ccb880a-3289-447d-8630-42269b972282.png">

</details>

### 🎲 ¿Puedes descubrir el mensaje que se ha escondido en esta cuadrícula ([sin mirar el código](res/spanish.qml#L211-L234))?

<img width="752" alt="🇪🇸 table" src="https://user-images.githubusercontent.com/15193153/163260838-c7b38c36-2d22-48e4-a5ce-4eb0e519e956.png">

<details>
  <summary> 👀 El mensaje secreto se esconde aquí</summary>
  <img width="752" alt="🇪🇸 (11:11 AM)" src="https://user-images.githubusercontent.com/15193153/162683183-0a80e0f6-6a26-4ab9-b85f-46c48e60fe63.png">

  #### ¿Lo habías descubierto? 🧠
  <details>
    <summary>🤩 ¡¡Sí!! Reciba tu regalo 🎁 </summary>
    
[![flamenco](https://madridpourvous.com/wp-content/uploads/2018/09/tablao-flamenco-915x515.jpg)](https://www.youtube.com/watch?v=dQw4w9WgXcQ)
    
*origen de la fotografía: https://madridpourvous.com*

  </details>
  <details>
    <summary>😔 no..</summary>

*¡No pasa nada, aún puedes ir a buscar tu regalo!* 😜

  </details>
</details>

## 🥐 French version:
### 📸 Exemples
- #### ⌚️ 08:42 AM|PM
  <img width="752" alt="🇫🇷 (08:42 AM)" src="https://user-images.githubusercontent.com/15193153/163483966-d83d27f3-1095-4bb0-8810-c887f6c9d289.png">

<details>
  <summary> ➕ En voir plus </summary>

  - #### 🕛 12:00 AM
    <img width="752" alt="🇫🇷 (12:00 AM)" src="https://user-images.githubusercontent.com/15193153/163484018-2a64b60a-a314-4130-b3f0-d1e9205e9afb.png">

  - #### 🕡 06:30 AM|PM
    <img width="752" alt="🇫🇷 (06:30 AM|PM)" src="https://user-images.githubusercontent.com/15193153/163484065-17a64142-21cb-438a-8cbe-d8365b8c3e1f.png">

</details>

#### 🎲 Sauras-tu trouver le message qui a été dissimulé dans cette grille ([sans regarder le code](res/french.qml#L221-L235))?

<img width="752" alt="🇫🇷 table" src="https://user-images.githubusercontent.com/15193153/163484163-f8fae234-479c-4cd4-aaad-af98bf4c8ec3.png">

<details>
  <summary> 👀 Le message secret est caché ici</summary>
  <img width="752" alt="🇫🇷 (22:22 PM)" src="https://user-images.githubusercontent.com/15193153/163484447-e8b58713-d808-41c0-8295-16144ef89f68.png">

  #### Tu l'avais trouvé ? 🧠 
  <details>
    <summary>🤩 Oui!! Récupère ton cadeau 🎁 </summary>
    
[![croissants](https://www.cocinayvino.com/wp-content/uploads/2021/07/www.cocinayvino.com-el-croissant-el-preferido-del-desayuno-parisino-croissant-e1626216131239-696x392.jpg)](https://www.youtube.com/watch?v=kJQP7kiw5Fk&t=84s)

*source of the picture: www.cocinayvino.com*

  </details>
  <details>
    <summary>😔 non..</summary>

*C'est rien, tu peux quand même aller récupérer ton cadeau!* 😜

  </details>
</details>

## 🚀 Coming soon:
- 🍕 Italian
- 🥨 German
- ⚽ Portuguese
