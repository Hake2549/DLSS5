# DLSS 5 Neural Rendering สำหรับ Wuthering Waves

สคริปต์ติดตั้ง/ถอน/ตรวจสอบ สำหรับเปิดใช้ **DLSS 5 neural rendering** ใน Wuthering Waves
พร้อมคู่มือภาษาไทยและค่าที่แนะนำ

เกมมี DLSS ในตัวอยู่แล้ว ส่วนเสริม RenoDX จะไปดักคำสั่ง DLSS ของเกม แล้วแทรกขั้นตอน
neural rendering เข้าไปหลัง DLSS ทำงานเสร็จ ผลคือรายละเอียดพื้นผิว แสงเงา และความคม
ดีขึ้นกว่า DLSS ปกติ

---

## ⚠️ อ่านก่อน — ความเสี่ยงที่ต้องรับเอง

### 1. เสี่ยงโดนแบนบัญชี

Wuthering Waves ใช้ anti-cheat ชื่อ **ACE** ที่ทำงานระดับ kernel วิธีนี้ต้องใส่ `dxgi.dll`
เข้าไปในโปรเซสของเกม ซึ่ง ACE มองเห็น

จากการใช้งานจริง ACE เคยขึ้นข้อความเตือนว่า

> Some game or system files are missing or corrupt, please re-install the game client

ทั้งที่ไฟล์เกมไม่ได้เสียหายเลย — ตรวจสอบแล้ว `Client-Win64-Shipping.exe` ตรงทุกไบต์

Kuro Games ไม่เคยอนุญาตให้ทำแบบนี้ **ถ้าโดนระงับบัญชีคือรับเอง**
ถ้าบัญชีมีค่ากับคุณมาก อย่าใช้

### 2. ปิด Frame Generation เสมอ

เปิด DLSS Frame Generation พร้อม neural rendering ทำให้ GPU ค้าง เกมดับด้วย
`DXGI_ERROR_DEVICE_REMOVED` / `DEVICE_HUNG` ภายในไม่ถึงนาที

เลือกอย่างใดอย่างหนึ่ง — จะเอา neural rendering ต้องปิด Frame Gen

### 3. ไม่ใช่ของทางการ

ไม่ได้มาจาก NVIDIA, Kuro Games หรือผู้พัฒนา ReShade/RenoDX ไม่มีใครรับประกันหรือซัพพอร์ต

---

## ต้องมีอะไรบ้าง

- การ์ดจอ **NVIDIA RTX** (ซีรีส์ 20 ขึ้นไป) ไดรเวอร์ใหม่พอสมควร
- Windows 10/11 64-bit
- Wuthering Waves เวอร์ชัน PC (Steam, Epic หรือ launcher ของ Kuro)
- พื้นที่ว่าง ~180 MB

---

## วิธีติดตั้ง

### ขั้นที่ 1 — โหลดรีโปนี้

กด **Code → Download ZIP** แล้วแตกไฟล์ หรือ

```
git clone https://github.com/Hake2549/DLSS5.git
```

### ขั้นที่ 2 — หาไบนารี 3 ตัวมาใส่ `files\`

รีโปนี้**ไม่ได้แนบไบนารีมาด้วย** (ไฟล์หนึ่งขนาด 158 MB เกินลิมิตของ GitHub และเป็น
ซอฟต์แวร์ลิขสิทธิ์ของ NVIDIA)

อ่านวิธีใน [`files/PUT-FILES-HERE.md`](files/PUT-FILES-HERE.md) — ทางที่ง่ายที่สุดคือ
ใช้ตัวติดตั้ง [RHI](https://github.com/RankFTW/RHI/releases) โหลดให้อัตโนมัติ

### ขั้นที่ 3 — ปิดเกมให้สนิท แล้วดับเบิลคลิก `install.bat`

สคริปต์หาโฟลเดอร์เกมเอง โดยอ่าน Steam library จากทุกไดรฟ์ ถ้าหาไม่เจอมันจะถามพาธ
ให้วางพาธของโฟลเดอร์ที่มี `Client-Win64-Shipping.exe`

### ขั้นที่ 4 — ตั้งค่าในเกม

| ตั้งค่า | ค่า |
|---|---|
| **Super Resolution** | **DLSS** ← ขาดไม่ได้ |
| **Frame Generation** | **ปิด** |
| ความละเอียด | ให้ตรงกับจอ |

ส่วนเสริมทำงานด้วยการดักคำสั่ง DLSS ของเกม **ถ้าไม่เปิด DLSS ก็ไม่มีอะไรให้ดัก**

### ขั้นที่ 5 — เปิดใช้งาน

กด **Home** → แท็บ **Add-ons** → **DLSS 5 Neural Rendering** → ติ๊ก *Enable DLSS Neural Rendering*

### ขั้นที่ 6 — ตรวจว่าได้ผลจริง

ดับเบิลคลิก `check.bat` ต้องขึ้น

```
feature 18 WORKING (N evaluations logged)
>>> ALL FILES PRESENT
```

---

## ปุ่มลัด

| ปุ่ม | ทำอะไร |
|---|---|
| `Home` | เปิด/ปิดเมนู ReShade |
| `F6` | เปิด/ปิด neural rendering (ใช้เทียบภาพก่อน-หลัง) |
| `F5` | ถ่ายภาพหน้าจอของส่วนเสริม |

---

## ตั้งค่าให้ภาพสวย

ค่าเริ่มต้นมักตั้งไว้แรงเกินไป ภาพจะดูคมจัดเกินจริง แนะนำให้เริ่มจากค่านี้

| ตัวปรับ | ค่าแนะนำ | หมายเหตุ |
|---|---|---|
| NR Intensity | **1.0** | ไม่ใช่ 2.0 |
| Local Structure Strength | **1.0** | สูงไปเป็น over-sharpen |
| Skin Structure Strength | **0.5 – 0.8** | สูงไปผิวตัวละครจะดูหยาบ |
| Local Tone Strength | **1.0** | สูงไปได้ลุค HDR ปลอม |
| NR UI Correction | **เปิด** | กันเมนูในเกมเพี้ยน |
| Automatic Mask | **เปิด** | |
| Enable Upscaling (WIP) | **ปิด** | ยังไม่เสร็จ ทำให้พังได้ |
| Guide overrides | **อย่าแตะ** | ตัวโปรแกรมเขียนเองว่าให้ปล่อยค่าเริ่มต้น |

**วิธีจูนที่ได้ผล:** ยืนในฉากที่มีทั้งใบไม้ ผ้า และใบหน้าตัวละครใกล้ ๆ กด `F6` สลับเทียบ
ปรับทีละค่าเท่านั้น และหมุนกล้องดูด้วย — ค่าที่สวยตอนยืนนิ่งอาจทำให้ภาพสั่นตอนเคลื่อนไหว

**ที่ 1080p ใช้ DLAA แทน DLSS Quality** เพราะ Quality เรนเดอร์จริงแค่ ~720p
ส่วน DLAA เรนเดอร์เต็มความละเอียด คมกว่าชัดเจน

---

## ถอนการติดตั้ง

ดับเบิลคลิก `uninstall.bat` แล้วพิมพ์ `YES`

ลบเฉพาะไฟล์ของ mod ไม่แตะไฟล์เกม ถ้าสงสัยว่าเกมมีปัญหาจากตัวนี้ ให้ถอนออกก่อน
แล้วไป Steam → คลิกขวาที่เกม → Properties → Installed Files → **Verify integrity of game files**

---

## แก้ปัญหา

| อาการ | สาเหตุ / วิธีแก้ |
|---|---|
| เกมเตือนว่าไฟล์เสียหาย / เปิดไม่ขึ้น | ACE ตรวจเจอ → รัน `uninstall.bat` แล้ว Verify integrity ใน Steam |
| กด Home แล้วไม่มีเมนู | `dxgi.dll` ไม่ได้อยู่ข้าง `Client-Win64-Shipping.exe` (รัน `check.bat` ดู) หรือลองเปลี่ยนเป็น Windowed Fullscreen |
| เมนูขึ้นแต่ภาพไม่เปลี่ยน | ยังไม่ได้เปิด DLSS ในเกม |
| เกมดับกลางคัน GPU ค้าง | ปิด Frame Generation — ถ้ายังเป็นอีกให้กด `F6` ปิด NR แล้วเล่นดู ถ้ายังพังแปลว่าไม่เกี่ยวกับ mod |
| เฟรมตก | ลด NR Intensity หรือลด Texture Quality ลงหนึ่งขั้น (VRAM 8 GB ค่อนข้างตึง) |

---

## ทดสอบกับอะไรมาแล้ว

| | |
|---|---|
| เกม | Wuthering Waves (Steam), Unreal Engine 4.26.2, DirectX 12 |
| GPU | RTX 5060 8 GB |
| OS | Windows 11 |
| ReShade | 6.8.0.2155 (add-on build, 64-bit) |
| renodx-dlss5 | 0.2026.0828.0517 |
| nvngx_dlssnr | 310.8.0 |

ยืนยันจาก `ReShade.log` ว่า `inline feature 18 evaluation succeeded` — neural rendering
ทำงานจริงทุกเฟรม

---

## เครดิต

| โปรเจกต์ | ผู้พัฒนา |
|---|---|
| [ReShade](https://github.com/crosire/reshade) | Patrick Mours (crosire) — BSD-3-Clause |
| [RenoDX](https://github.com/clshortfuse/renodx) | clshortfuse |
| DLSS / DLSSNR | NVIDIA Corporation |
| [RHI](https://github.com/RankFTW/RHI) | RankFTW |

รีโปนี้มีแค่สคริปต์ช่วยติดตั้งกับคู่มือ ไม่ได้ดัดแปลงตัวโปรแกรมใด ๆ
ดูรายละเอียดใน [THIRD-PARTY-NOTICES.md](THIRD-PARTY-NOTICES.md)
