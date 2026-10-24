# 🏋️ IronPace - Gym Rest Timer & Set Counter
**แอปพลิเคชันจับเวลาพักและนับเซ็ตสำหรับการเวทเทรนนิ่ง (สไตล์มินิมอล & คล่องตัวสูง)**

พัฒนาด้วย **Flutter 3.x** สำหรับ build ติดตั้งลงบน **iOS / Android** ได้ทันที พร้อมไฟล์ทดสอบจำลองบนเบราว์เซอร์ **preview.html**

---

## ✨ จุดเด่นที่ออกแบบมาเพื่อคนยกเวทโดยเฉพาะ (Gym UX)

1. **ปุ่มขนาดยักษ์ (One-Tap Action):**
   - เมื่อยกเซ็ตเสร็จ เพียงกดปุ่มยักษ์ **"COMPLETE SET & REST"** เพียงครั้งเดียว ระบบจะนับเซ็ตถัดไปให้ทันที และเริ่มนับเวลาพักอัตโนมัติ
2. **หน้าจอไม่ดับระหว่างซ้อม (Screen WakeLock):**
   - หน้าจอมือถือจะเปิดค้างไว้ตลอดการออกกำลังกาย ไม่ต้องคอยใช้นิ้วที่เปื้อนชอล์กหรือเหงื่อปลดล็อกหน้าจอ
3. **พรีเซ็ตเวลาพักยอดนิยม (Rest Presets):**
   - เลือกเวลาพักได้สะดวกรวดเร็ว: `30s`, `45s`, `60s`, `90s`, `2m`, `3m`
   - ระหว่างที่เวลากำลังนับถอยหลัง สามารถกด `+15s` หรือ `-15s` เพิ่ม/ลดเวลาได้อย่างยืดหยุ่น
   - หากพร้อมยกก่อนเวลา สามารถกดปุ่ม **"LIFT NOW (SKIP)"** ได้ทันที
4. **สัญญาณเสียง & ระบบสั่นเตือน (Audio & Haptic Alerts):**
   - สัญญาณนับถอยหลัง 3... 2... 1... (Beep Beep Beep)
   - สัญญาณเตือนเมื่อพร้อมยกเซ็ตต่อไป (Finish Chime)
   - สั่นเตือนตามจังหวะเตือนความรู้สึกผ่านมือถือ
5. **นับรอบและตั้งเป้าหมาย (Set Tracker):**
   - ปรับเพิ่ม/ลดเซ็ตได้ด้วยปุ่ม `+` / `−`
   - ตั้งเป้าหมายจำนวนเซ็ตได้ เช่น 3, 4, 5 เซ็ต หรือแบบไม่จำกัด (∞)
   - แสดงเวลา Workout Session ทั้งหมด และจำนวนเซ็ตรวมที่เล่นไปในวันนี้
6. **สลับท่าฝึกได้สะดวกรวดเร็ว (Exercise Switcher):**
   - แตะที่ชื่อท่าเพื่อเลือกท่าฝึกยอดนิยม เช่น Bench Press, Squat, Deadlift, Barbell Row, Lat Pulldown หรือพิมพ์ชื่อท่าเองได้

---

## 🚀 ทดสอบใช้งานได้ทันที (Instant Browser Preview)

ในโฟลเดอร์นี้มีไฟล์ `preview.html` ซึ่งเป็นเว็บแอปจำลองขนาดกะทัดรัด (Zero External Dependencies):
- ดับเบิลคลิกไฟล์ **`preview.html`** เพื่อเปิดใน Google Chrome, Microsoft Edge หรือ Safari
- สามารถทดลองฟังเสียงเตือน, ทดสอบระบบสัมผัส, ทดสอบการจับเวลาพักและนับเซ็ตได้ทันทีโดยไม่ต้องติดตั้ง Flutter

---

## 🛠️ ขั้นตอนการรันและ Build ด้วย Flutter

### 1. ติดตั้ง Dependencies
เปิด Terminal ในโฟลเดอร์นี้ แล้วรันคำสั่ง:
```bash
flutter pub get
```

### 2. รันแอปพลิเคชัน (Development Mode)
- รันบน Android / iOS Simulator หรือเครื่องจริงที่เชื่อมต่ออยู่:
```bash
flutter run
```
- หรือทดสอบบนเว็บเบราว์เซอร์:
```bash
flutter run -d chrome
```

### 3. Build APK สำหรับมือถือ Android
```bash
flutter build apk --release
```
*ไฟล์ APK จะถูกสร้างไว้ที่ `build/app/outputs/flutter-apk/app-release.apk` สามารถนำไปติดตั้งลงบนโทรศัพท์ Android ได้ทันที*

### 4. Build สำหรับ iOS (ต้องทำบน macOS ที่มี Xcode)
```bash
cd ios
pod install
cd ..
flutter build ipa --release
```

---

## 📂 โครงสร้างโฟลเดอร์ของโปรเจกต์ (Project Structure)

```text
dazzling-fermi/
├── lib/
│   ├── main.dart                      # จุดเริ่มต้นของแอปและตั้งค่า Theme มืดสไตล์ยิม
│   ├── constants/
│   │   └── app_colors.dart            # รหัสสี Electric Cyan, Neon Green, OLED Dark
│   ├── models/
│   │   └── workout_state.dart         # Data model ควบคุมสถานะเซ็ตและเวลา
│   ├── services/
│   │   ├── audio_service.dart         # ตัวจัดการเสียงเตือน 3-2-1 และสัญญาณจบเซ็ต
│   │   └── haptic_service.dart        # ตัวจัดการระบบสั่นแจ้งเตือน Haptic Feedback
│   ├── widgets/
│   │   ├── circular_timer.dart        # วงแหวนจับเวลาพักขนาดใหญ่พร้อมเวลาตัวเลขดิจิทัล
│   │   ├── preset_chips.dart          # ชิปเลือกเวลาพักด่วน (30s, 60s, 90s, 120s...)
│   │   ├── set_counter_card.dart      # การ์ดแสดงเซ็ตปัจจุบันและปุ่มปรับ +/-
│   │   └── exercise_selector_modal.dart # หน้าต่างเลือกท่าฝึกเวท
│   └── screens/
│       └── workout_timer_screen.dart  # หน้าจอหลักของการออกกำลังกาย
├── assets/
│   └── sounds/                        # ไฟล์เสียงคุณภาพสูงสำหรับเตือนนับถอยหลัง
├── android/                           # โครงสร้างสำหรับ Android Platform
├── ios/                               # โครงสร้างสำหรับ iOS Platform
├── web/                               # โครงสร้างสำหรับ Web Platform
├── preview.html                       # ไฟล์จำลองการทำงานเปิดผ่านเว็บได้ทันที
├── pubspec.yaml                       # การตั้งค่า Dependencies ของ Flutter
└── README.md
```
