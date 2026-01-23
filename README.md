<h1 align="center">🌱 Re:Code — After the Fall (RMATF)</h1>

<p align="center">
  <i>World degradation, overgrowth & decay for Project Zomboid (Build 42)</i>
</p>

---

## 🧠 Overview

**Re:Code — After the Fall (RCATF)** is a *TYL-inspired, clean-room world mutation mod* for  
**Project Zomboid (Build 42)**.

Instead of running constant background checks, RCATF applies **deterministic world changes on chunk load**, creating a believable *“after the fall”* atmosphere:

- 🌿 Nature reclaiming buildings  
- 🧱 Subtle structural decay  
- 🌳 Sparse trees and uncontrolled vegetation  
- 🕰️ A world that visibly ages over time  

All behavior is **sandbox-driven**, performance-aware, and fully configurable.

---

## ✨ Features

### 🌍 Chunk-Load World Generator
- Mutates the world **only when chunks are loaded**
- Already-processed chunks are cached to prevent re-processing
- No global per-tick scanning → **excellent performance**

---

### 🌱 Overgrowth & Vegetation
- Outdoor ground overgrowth
- Indoor overgrowth (separate chance & multiplier)
- Wall & fence vines 🌿
- Optional **hard caps** to limit vegetation density
- Water tiles are respected (no vegetation on water)

---

### 🌳 Trees
- Optional tree spawning
- Spawn chance controlled via divisor
- 🚧 Option to **prevent trees from spawning on roads**

---

### 🏚️ Decay / Aging System
- Optional visual aging of the world
- Wall damage chance
- Roof damage chance
- Global decay multiplier for fine-tuning intensity

---

### 🎛️ Extensive Sandbox Options
- Dedicated **RMATF sandbox page**
- Presets + custom values
- Fully localized (EN / DE)
- Debug logging available for testing

---

## ⚙️ Installation

1. Download or clone this repository
2. Place it inside your `ProjectZomboid/mods/` directory
3. Enable **Re:Mind — After the Fall** in the Mods menu
4. Configure the mod via **Sandbox → RMATF**
5. Start or load a game

⚠️ *Most effects apply when new chunks are loaded.*

---

## 🧩 Sandbox Options (Highlights)

### 🔧 Core
- ✅ Enable / disable mod
- 🐞 Debug logging
- 🌍 Enable chunk-load world generator
- 🚦 Max processed squares per tick (performance throttle)
- 💧 Respect water tiles

### 🌿 Vegetation
- Base vegetation chance (preset or custom)
- Indoor / Outdoor / Vine multipliers
- Optional hard caps

### 🌳 Trees
- Tree spawn chance
- ❌ Disable tree spawning on roads

### 🏚️ Decay
- Enable world aging
- Wall damage chance
- Roof damage chance
- Global decay multiplier

---

## 🚀 Performance Philosophy

- ❌ No per-tick world scanning
- ✅ Chunk-based deterministic processing
- ✅ Cached processed chunks
- ⚡ Designed for long-running saves

---

## ⚠️ Tile Overlay Note

RMATF includes experimental support for **TileOverlays**, but:

- Some B42 tiles may cause log spam
- Therefore **TileOverlays are disabled by default**
- The **Chunk Generator mode is the recommended approach**

---

## 🧪 Troubleshooting

**Nothing seems to happen?**
- Ensure the mod is enabled
- Ensure *World Generator* is active
- Move into unexplored chunks

**Stuttering while exploring?**
- Lower *Max Squares Per Tick* in sandbox options

**Log spam?**
- Avoid TileOverlay features
- Enable Debug Logs only when needed

---

## 👤 Credits

- **Author:** Seppel & Volt
- **Concept:** Inspired by **The Last Of Us**

---

## 📜 License

MIT
