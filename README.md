<!-- adopted from https://github.com/Louis3797/awesome-readme-template & https://github.com/othneildrew/Best-README-Template -->

<div align="center">

  <img src="assets/images/icon-no_bg.png" alt="icon" width="200" height="auto" />
  <h1>Anki Visualizer</h1>

  <p>
    Visualize your Anki learning progress over time!
  </p>

<!-- Badges -->
<p>
  <a href="">
    <img src="https://img.shields.io/github/last-commit/KaFaiFai/anki_visualizer" alt="last update" />
  </a>
  <a href="https://github.com/KaFaiFai/anki_visualizer/stargazers">
    <img src="https://img.shields.io/github/stars/KaFaiFai/anki_visualizer" alt="stars" />
  </a>
  <a href="https://github.com/KaFaiFai/anki_visualizer/issues/">
    <img src="https://img.shields.io/github/issues/KaFaiFai/anki_visualizer" alt="open issues" />
  </a>
  <a href="https://github.com/KaFaiFai/anki_visualizer/blob/master/LICENSE">
    <img src="https://img.shields.io/github/license/KaFaiFai/anki_visualizer.svg" alt="license" />
  </a>
</p>

<h4>
    <a href="https://github.com/KaFaiFai/anki_visualizer/blob/master/doc/README.md">Documentation</a>
  <span> · </span>
    <a href="https://github.com/KaFaiFai/anki_visualizer/issues/">Report Bug</a>
  <span> · </span>
    <a href="https://github.com/KaFaiFai/anki_visualizer/issues/">Request Feature</a>
  </h4>
</div>

<br />

<!-- About the Project -->
## 🌟 About the Project

<!-- Screenshots -->
### 📷 Screenshots

<img src="doc/assets/export.gif" alt="screenshot 1"/>
<img src="doc/assets/screenshot 1.png" alt="screenshot 1" width="40%"/>
<img src="doc/assets/screenshot 2.png" alt="screenshot 2" width="40%"/>
<img src="doc/assets/screenshot 3.png" alt="screenshot 3" width="40%"/>
<img src="doc/assets/screenshot 4.png" alt="screenshot 4" width="40%"/>

<!-- TechStack -->
### 👾 Tech Stack

* [![Flutter](https://img.shields.io/badge/flutter-e1e4e4?style=for-the-badge&logo=flutter&logoColor=44d1fd)](https://flutter.dev/)
* [![SQLite](https://img.shields.io/badge/sqlite-f4f9f9?style=for-the-badge&logo=sqlite&logoColor=0c3958
)](https://www.sqlite.org/)

<!-- Features -->
### 🎯 Features

* Read the anki database
* Customize the animation preferences
* Display learning progress each day
* Exports in multiple formats

<!-- Color Reference -->
### 🎨 Color Reference

| Color             | Hex                                                                |
| ----------------- | ------------------------------------------------------------------ |
| Easy | ![#006CFF](https://via.placeholder.com/10/006CFF?text=+) #006CFF |
| Good | ![#04AC04](https://via.placeholder.com/10/04AC04?text=+) #04AC04 |
| Hard | ![#CA7700](https://via.placeholder.com/10/CA7700?text=+) #CA7700 |
| Again | ![#AC3134](https://via.placeholder.com/10/AC3134?text=+) #AC3134 |

<!-- Getting Started -->
## 🧰 Getting Started

<!-- Run Locally -->
### 🏃 Run Locally

Clone the project

```bash
git clone https://github.com/KaFaiFai/anki_visualizer.git
```

Go to the project directory

```bash
cd anki_visualizer
```

Install dependencies

```bash
flutter pub get
```

Run the project

```bash
flutter run -d windows
```

<!-- Deployment -->
### 🚩 Deployment

To deploy this project run

```bash
flutter build windows
```

<!-- Usage -->
## 👀 Usage

1. Select your collection.anki2 file. Please refer to <https://docs.ankiweb.net/files.html>
1. Select your deck
1. Select fields to show for each note type in the deck
1. Click next

1. Change you animation preferences
1. Select captures folder.  
  This folder is used to temporarily store screenshots during animation which can be later exported into gif or video format.  
  Please clean up this when you are done.
1. Click confirm

1. Play!
1. Click export

1. Install FFmpeg  
  This program uses **FFmpeg** to convert the captured images into animations in the form of video or gif.  
  Read more about it here: <https://ffmpeg.org/>  
  *Note: This process may take serveral minutes*
1. Choose your desired output format
1. Click export

<!-- Roadmap -->
## 🧭 Roadmap

* [ ] Optimize performance
* [ ] More output formats
* [ ] Support for AnkiDroid

<!-- Contributing -->
## 👋 Contributing

<a href="https://github.com/KaFaiFai">
  <img src="https://github.com/KaFaiFai.png" width="50"/>
</a>
<a href="https://github.com/Rapid-Rabbit-Tech">
  <img src="https://github.com/Rapid-Rabbit-Tech.png" width="50"/>
</a>

Contributions are always welcome!

<!-- FAQ -->
## ❔ FAQ

* Where do I find my Anki database?

  * For Windows, usually it is in `%APPDATA%\Anki2\User 1`. For more information, please refer to <https://docs.ankiweb.net/files.html>

<!-- License -->
## ⚠️ License

See `LICENSE` for more information.

<!-- Contact -->
## 🤝 Contact

Rapid Rabbit - [@rapid.rabbit.tech](https://www.threads.net/@rapid.rabbit.tech) - <rapid.rabbit.tech@gmail.com>

Project Link: [https://github.com/KaFaiFai/anki_visualizer](https://github.com/KaFaiFai/anki_visualizer)

<!-- Acknowledgments -->
## 💎 Acknowledgements

* [Anki](https://apps.ankiweb.net/)
