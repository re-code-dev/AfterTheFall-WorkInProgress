# 🧟‍♂️ AfterTheFall (Build 42)

> **AfterTheFall** is a modular **gameplay extension for Project Zomboid (Build 42)** focused on  
> **realism**, **skill-based progression**, **developer transparency**, and  
> **engine-compliant implementation**.

Designed for **players and modders** who expect **deep systems**, **clean architecture**, and  
**predictable, debuggable behavior**.

---

## 📑 Table of Contents
- 🚀 Features Overview  
- ✅ Supported Systems  
- 🗂 Project Structure  
- 📦 Installation  
- 🎮 Controls  
- 💾 Persistence & Data Handling  
- 🧩 Compatibility  
- 🐞 Debugging  
- 🛣 Roadmap  
- 🤝 Development & Contributions  
- 📜 Lizenz  
- ⭐ Credits  

---

## 🚀 Features Overview

### 🔧 Dynamic Gameplay Systems
- 🧮 Skill-based calculations instead of static values  
- 🛡 Fully engine-compliant (no client-side cheating)  
- 🧩 Designed specifically for **Build 42 mechanics**

### 🧠 Advanced Tooltips
- 🧬 Custom tooltip pipeline  
- 📍 Context-aware information display  
- 🪟 Optional separate tooltip panel  
- 📐 Proper text wrapping & spacing (UI-optimized)

### 🧪 Debug & Developer Tools
- 🧰 Dedicated **AfterTheFall Debug / Settings Panel**  
- ⌨️ Hotkey-based access (**CTRL + SHIFT + F11**)  
- 🗂 Tabs, checkboxes & sliders  
- 💾 Persistent settings via `ModData` / `SandboxOptions`

### ⚙️ Modular Architecture
- 🧱 Clean separation of `client`, `server`, and `shared`  
- 🔌 Easily extensible without touching core systems  
- 🔀 Multiple subsystems can run in parallel  

---

## ✅ Supported Systems (Current)
✔ Custom UI panels  
✔ Custom hotkeys  
✔ Build-42-compatible events  
✔ Persistent configuration  
✔ Tooltip overlays  
✔ Debug logging  
✔ Foundation for future gameplay modules  

---

## 🗂 Project Structure (Build 42)

```text
AfterTheFall/
└── Contents/
    └── mods/
        └── AfterTheFall/
            ├── common/
            │   └── media/
            │       └── ...
            └── 42/
                ├── media/
                │   ├── lua/
                │   │   ├── client/
                │   │   ├── server/
                │   │   └── shared/
                │   └── ui/
                ├── mod.info
                └── poster.png
```

**Notes**
- 📦 `common/` → version-independent assets  
- 🔧 `42/` → Build-42-specific code  
- 🔁 Load order: **common → 42**

---

## 📦 Installation

### 🛠 Manual Installation (recommended for development)
1. Copy the mod folder to  
   `%UserProfile%/Zomboid/Workshop/`  
2. Ensure **no duplicate versions** exist  
3. Enable the mod in the in-game mod menu  

### 🌐 Steam Workshop
- 📄 Upload handled via `workshop.txt`  
- 🖼 `preview.png` must be **256 × 256**

---

## 🎮 Controls

| Action | Input |
|------|------|
| Open AfterTheFall Panel | **CTRL + SHIFT + F11** |
| Switch Tabs | 🖱 Mouse |
| Save Settings | 💾 Automatic (persistent) |

---

## 💾 Persistence & Data Handling

The mod relies **exclusively** on **stable Build-42 systems**:
- 🧠 `ModData` for runtime data  
- 🌍 `SandboxOptions` for world-level defaults  
- 🚫 No client-side modification of authoritative values  

✔ Multiplayer-safe  
✔ Predictable behavior  
✔ Server-authoritative  

---

## 🧩 Compatibility
- ✅ Project Zomboid **Build 42**  
- ✅ Singleplayer  
- ✅ Multiplayer-safe architecture  
- ❌ Not intended for Build 41  

---

## 🐞 Debugging

**Active log tag**
- [AfterTheFall]

Typical log output:
- Bootstrap status  
- Panel initialization  
- Event registration  
- Hotkey binding  

---

## 🛣 Roadmap (Planned)
⏳ Expanded skill integrations  
⏳ Additional modular gameplay systems  
⏳ Extended UI configuration  
⏳ Optional standalone tooltip window  

---

## 🤝 Development & Contributions

Pull requests and technical discussions are welcome.

Please ensure:
- ✔ Full **Build-42 API compliance**  
- ❌ No direct engine overrides  
- 🧩 Clear **client / server separation**

---

## 📜 Lizenz

Dieses Projekt steht unter der **MIT-Lizenz**.  
Siehe die Datei **LICENSE** für Details.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

---

## ⭐ Credits

👨‍💻 **Entwickelt von:** **Volt & Seppel**  
🏗 Für **Re:Code – Modular Game Mod Development**

🧟‍♂️ *Survive smarter. Mod cleaner.*
