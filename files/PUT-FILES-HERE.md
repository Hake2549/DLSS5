# วางไฟล์ 3 ตัวนี้ในโฟลเดอร์นี้

`install.bat` จะหาไฟล์เหล่านี้จากโฟลเดอร์ `files\` ถ้าไม่ครบมันจะบอกว่าขาดอะไร

| ไฟล์ | ขนาดโดยประมาณ | เอามาจากไหน |
|---|---|---|
| `dxgi.dll` | ~5.6 MB | ReShade **with full add-on support** จาก https://reshade.me |
| `renodx-dlss5.addon64` | ~1.7 MB | https://github.com/clshortfuse/renodx |
| `nvngx_dlssnr.dll` | ~158 MB | https://github.com/RankFTW/rhi-repo/releases (release ชื่อ `dlssnr-*`) |

`ReShade.ini` มีให้แล้วในโฟลเดอร์นี้ ไม่ต้องหาเพิ่ม

## ทางที่ง่ายที่สุด

ใช้ตัวติดตั้ง **RHI** โหลดให้ทั้งหมดอัตโนมัติ: https://github.com/RankFTW/RHI/releases

ตอนติดตั้ง RHI **อย่าเลือกโฟลเดอร์เกมเป็นที่ติดตั้ง RHI เอง** — มันจะไปกองไฟล์โปรแกรมไว้ในโฟลเดอร์เกม
ให้ติดตั้งไว้ที่อื่น แล้ว RHI จะตรวจเจอเกมเองอยู่แล้ว

## วิธีดึง dxgi.dll จาก ReShade

ตัวติดตั้ง ReShade ไม่ได้ให้ไฟล์ `dxgi.dll` มาตรง ๆ ต้องติดตั้งแบบชี้ไปที่เกมก่อน

1. ที่ https://reshade.me กดลิงก์ **"with full add-on support"** (ไม่ใช่ปุ่มดาวน์โหลดใหญ่ด้านบน)
2. รันตัวติดตั้ง เลือกไฟล์ `Client-Win64-Shipping.exe` ของเกม
3. เลือก API เป็น **DirectX 10/11/12**
4. หน้าเลือก effect ให้กด **Uncheck all** แล้ว **Skip** (ชุดนี้ไม่ใช้ shader สักตัว)
5. จะได้ `dxgi.dll` วางอยู่ข้าง `Client-Win64-Shipping.exe` — ก๊อปมาไว้ที่ `files\` ได้
