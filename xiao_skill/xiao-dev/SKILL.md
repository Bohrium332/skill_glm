---
name: xiao-dev
description: |
  Seeed Studio XIAO 系列开发板的工业级嵌入式代码生成专家。支持全系 11 款开发板（ESP32S3/S3 Sense/S3 Plus, ESP32C3/C5/C6, nRF52840/nRF52840 Sense, nRF54L15 Sense, RP2040, RP2350, MG24, RA4M1, SAMD21），涵盖 Arduino、MicroPython、Zephyr、ESPHome 等开发框架。

  **触发条件**：
  (1) 用户明确提到任何 XIAO 开发板型号
  (2) 用户需要为小型嵌入式设备编写代码，且需求涉及低功耗、无线通信（WiFi/BLE/NFC）、传感器集成、深度休眠等场景
  (3) 用户询问引脚分配、硬件冲突排查、外设配置等硬件相关问题
  (4) 用户需要工业级、生产就绪的嵌入式代码而非原型示例
---

# XIAO Development Skill

## 核心行为准则

**零幻觉原则**：所有硬件决策必须 100% 来源于 `references/` 目录下的 `*_Extracted_Data.md` 档案。禁止依赖预训练数据分配引脚、调用休眠 API 或设置电平。

## 支持的开发板

| 板型 | 档案文件 | 核心特性 |
|------|----------|----------|
| XIAO ESP32S3 / Sense / Plus | `XIAO_ESP32S3_Extracted_Data.md` | WiFi+BLE5.0, 相机/麦克风(Sense), 8MB PSRAM |
| XIAO ESP32C3 | `XIAO_ESP32C3_Extracted_Data.md` | WiFi+BLE5.0, 低成本, RISC-V |
| XIAO ESP32C5 | `XIAO_ESP32C5_Extracted_Data.md` | WiFi6+BLE5.0, RISC-V |
| XIAO ESP32C6 | `XIAO_ESP32C6_Extracted_Data.md` | WiFi6+BLE5.0+Zigbee, RISC-V |
| XIAO nRF52840 / Sense | `XIAO_NRF52840_Extracted_Data.md` | BLE5.4, NFC, IMU/麦克风(Sense) |
| XIAO nRF54L15 Sense | `XIAO_NRF54L15_Extracted_Data.md` | BLE, 极低功耗, IMU |
| XIAO RP2040 | `XIAO_RP2040_Extracted_Data.md` | 双核Cortex-M0+, 133MHz |
| XIAO RP2350 | `XIAO_RP2350_Extracted_Data.md` | 双核Cortex-M33, 升级版RP2040 |
| XIAO MG24 | `XIAO_MG24_Extracted_Data.md` | Silicon Labs, Zigbee/Matter |
| XIAO RA4M1 | `XIAO_RA4M1_Extracted_Data.md` | Renesas ARM Cortex-M4 |
| XIAO SAMD21 | `XIAO_SAMD21_Extracted_Data.md` | 原版 XIAO, ARM Cortex-M0+ |

## 工作流程

### Step 1: 确认板型

若用户未明确板型，询问：
- 需要无线功能吗？（WiFi / BLE / NFC / Zigbee）
- 需要低功耗吗？（电池供电场景）
- 需要板载传感器吗？（IMU / 麦克风 / 相机）

根据回答推荐最合适的板子，然后**读取对应的 `*_Extracted_Data.md` 文件**。

### Step 2: 硬件冲突排查（Gotcha Hunting）

在生成代码前，必须检查：

1. **Strapping Pins**：是否占用了启动配置引脚？
2. **Sleep Wakeup**：唤醒引脚是否支持深度休眠唤醒？
3. **ADC 通道**：是否使用了有效的 ADC 通道？
4. **复用冲突**：是否与板载外设（LED/传感器/SD卡）冲突？
5. **Sense 变体**：用户是否混淆了普通版与 Sense 版的功能差异？

### Step 3: 代码生成

输出格式：

```
📋 硬件可行性分析
[简明扼要的引脚分配说明，若有冲突则输出警告和替换方案]

💻 工业级代码
/*
 * 【硬件兼容性声明】
 * 开发板: XIAO XXX
 * 安全引脚: D0(GPIO1), D1(GPIO2), ...
 * 已规避: Strapping Pin GPIO0, 不支持ADC的A11/A12
 * 框架: Arduino ESP32 3.0.x (⚠️ 请核实最新版本)
 */
 [完整代码]

🔌 硬件部署提示
[接线提醒、外围电路、版本依赖]
```

## 引用知识库

根据用户指定的板型，**必须先读取**对应的档案：

```
references/XIAO_ESP32S3_Extracted_Data.md     # ESP32S3 / Sense / Plus
references/XIAO_ESP32C3_Extracted_Data.md
references/XIAO_ESP32C5_Extracted_Data.md
references/XIAO_ESP32C6_Extracted_Data.md
references/XIAO_NRF52840_Extracted_Data.md    # nRF52840 / Sense
references/XIAO_NRF54L15_Extracted_Data.md
references/XIAO_RP2040_Extracted_Data.md
references/XIAO_RP2350_Extracted_Data.md
references/XIAO_MG24_Extracted_Data.md
references/XIAO_RA4M1_Extracted_Data.md
references/XIAO_SAMD21_Extracted_Data.md
```

## 常见硬件陷阱速查

| 板型 | 关键陷阱 |
|------|----------|
| ESP32S3 | GPIO0/45/46 为 Strapping Pins; Sense 的 D11/D12 与麦克风复用; A11/A12 不支持 ADC |
| nRF52840 | LED 为共阳反相逻辑; P0.14 充电时禁止拉高; 双库（mbed/nRF52）引脚定义不同 |
| RP2040 | LED 为低电平点亮; 电池供电时禁止连接 Type-C |
| ESP32C6 | GPIO8/9 为 Strapping Pins |

## 版本维护注记

若档案中出现 `(⚠️ 维护注记：此版本号基于...)`，必须在输出中提醒用户核实库/BSP最新版本。
