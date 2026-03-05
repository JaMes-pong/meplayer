# MePlayer 🎬

A privacy-first media player for Windows, built with Flutter.  
No history. No tracking. Everything is forgotten when you close the app.

---

## Features

- 🔒 **Privacy First** — no data is ever saved to disk, no history, no logs
- 📁 **Folder-based browsing** — pick a folder on launch, browse sub-folders freely
- 📂 **Open with support** — right-click any media file and open directly with MePlayer
- 🎯 **Auto folder detection** — opening a file directly sets its parent folder as root
- 🎬 **Video playback** — MP4, MKV, AVI...
- 🎵 **Audio playback** — MP3, AAC, FLAC...
- 🖼️ **Image viewer** — JPG, PNG, GIF...
- 🗂️ **Thumbnail preview** — grid and list view with auto-generated thumbnails
- ⌨️ **Keyboard navigation** — arrow keys to go next/prev media
- ⛶ **Fullscreen support** — toggle fullscreen for video playback
- 🚫 **Folder lock** — cannot navigate above the selected root folder

---

## Privacy Guarantee

| What we do NOT do | Details |
|---|---|
| No history stored | File paths are never written to disk |
| No persistent cache | Thumbnails live in memory only, gone on close |
| No network requests | Fully offline, no telemetry |
| No recent folder memory | Folder picker always starts from `C:\` |
| No database | Zero use of SharedPreferences or any local DB |

---

## Getting Started

### Download released application (.exe)
- You can download the released version from Github [Release section](https://github.com/JaMes-pong/meplayer/releases).

### If you want to modify / build the application by yourself:
#### Prerequisites

- [Flutter SDK](https://flutter.dev/docs/get-started/install) (stable channel)
- [Visual Studio Code](https://code.visualstudio.com/) (if you want to modify the player)
- Windows 10 or later

#### Install & Run

```bash
git clone https://github.com/JaMes-pong/meplayer.git
cd meplayer
flutter pub get
flutter run -d windows
```

#### Build Release EXE
```bash
flutter build windows --release
```

#### Output will be at:
```text
build/windows/x64/runner/Release/
```
- Distribute the entire Release/ folder — the .exe depends on the .dll files alongside it.

---

### Usage
1. Launch the app — a folder picker appears immediately
2. Select any folder containing media files
3. Browse files and sub-folders in the left panel
4. Click any file to play/view it on the right
5. Close the app — everything is forgotten

### Open with MePlayer
1. Right-click any supported media file in Windows Explorer
2. Select **Open with → MePlayer**
3. The file plays immediately, with its parent folder loaded as the root
4. Browse sibling files freely — cannot navigate above the file's folder

### Keyboard Shortcuts
| Key   | Action              |
| ----- | ------------------- |
| → / ↓ | Next media file     |
| ← / ↑ | Previous media file |
| Esc   | Exit fullscreen     |

##### More shortcuts will be added later...

---

### Supported Formats
| Type  | Formats                            |
| ----- | ---------------------------------- |
| Video | MP4, MKV, AVI, MOV, WMV, FLV, WEBM |
| Audio | MP3, AAC, FLAC, WAV, OGG, M4A, WMA |
| Image | JPG, PNG, GIF, BMP, WEBP, TIFF     |

---

### Tech Stack
| Package                   | Purpose                                 |
| ------------------------- | --------------------------------------- |
| media_kit                 | Video & audio playback (libmpv)         |
| file_picker               | Folder picker dialog                    |
| fc_native_video_thumbnail | Video thumbnail generation              |
| window_manager            | Fullscreen support                      |
| path_provider             | Temp directory for thumbnail processing |

---

### Roadmap
- [x] Open with / file association support
- [ ] Playback speed control
- [ ] Slideshow mode for images
- [ ] Sort and filter by file type
- [ ] Drag & drop folder support

---

### License
MIT License