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

### Step 2.5: 内置模块确认（Sense 变体专用）

**在使用内置传感器/模块前，必须确认用户是否为 Sense 版本！**

以下板型存在普通版和 Sense 版差异：

| 板型 | 普通版 | Sense 版 |
|------|--------|----------|
| XIAO nRF52840 | 无内置传感器 | 6轴IMU(LSM6DS3TR-C) + PDM麦克风 |
| XIAO ESP32S3 | 无摄像头/麦克风 | 摄像头 + 麦克风 |

**确认流程**：
1. 若用户请求使用 IMU、麦克风、摄像头等内置传感器
2. **必须先询问**："你需要的是 Sense 版本吗？普通版没有内置 [传感器名]"
3. 确认后再读取对应档案并生成代码

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

### Step 4: Arduino CLI 编译验证

在代码生成后，执行编译验证以确保代码语法正确。

#### 4.1 检测 Arduino CLI

```bash
# 检查是否已安装
arduino-cli version
```

若未安装，提示用户运行安装脚本：

| 平台 | 安装命令 |
|------|----------|
| Linux/macOS | `bash scripts/install-arduino-cli.sh [board_type]` |
| Windows | `.\scripts\install-arduino-cli.ps1 -BoardType [board_type]` |

支持的 `board_type`：`esp32`, `nrf52`, `nrf54`, `rp2040`, `mg24`, `samd`, `ra4m1`, `all`

#### 4.2 FQBN 映射

根据板型从 `config/fqbn-mapping.json` 获取 FQBN：

| 板型 | FQBN |
|------|------|
| XIAO ESP32S3/Sense/Plus | `esp32:esp32:XIAO_ESP32S3` |
| XIAO ESP32C3 | `esp32:esp32:XIAO_ESP32C3` |
| XIAO ESP32C5 | `esp32:esp32:XIAO_ESP32C5` |
| XIAO ESP32C6 | `esp32:esp32:XIAO_ESP32C6` |
| XIAO nRF52840/Sense | `Seeeduino:nrf52:xiaonRF52840` |
| XIAO nRF54L15 | `Seeeduino:nrf54:xiaonRF54L15` |
| XIAO RP2040 | `rp2040:rp2040:seeed_xiao_rp2040` |
| XIAO RP2350 | `rp2040:rp2040:seeed_xiao_rp2350` |
| XIAO MG24 | `SiliconLabs:efr32mg24:xiao_mg24` |
| XIAO RA4M1 | `Seeeduino:renesas:xiao_ra4m1` |
| XIAO SAMD21 | `Seeeduino:samd:seeed_XIAO` |

#### 4.3 编译命令模板

```bash
# 创建临时 sketch 目录
mkdir -p /tmp/xiao_sketch_$$
cat > /tmp/xiao_sketch_$$/sketch.ino << 'EOF'
[生成的代码]
EOF

# 执行编译
arduino-cli compile \
  --fqbn <FQBN> \
  --warnings all \
  /tmp/xiao_sketch_$$

# 清理
rm -rf /tmp/xiao_sketch_$$
```

#### 4.4 编译结果处理

**编译成功**：
```
✅ 编译验证通过
   - 使用 FQBN: esp32:esp32:XIAO_ESP32S3
   - 程序大小: XXX bytes
   - 存储使用: XX%
```

**编译失败**：解析错误并提供建议

| 错误类型 | 特征模式 | 处理策略 |
|---------|----------|----------|
| 语法错误 | `expected ';' before`, `undeclared` | 指出行号，提供修复 |
| 库缺失 | `xxx.h: No such file or directory` | 提供 `arduino-cli lib install` 命令 |
| API 不兼容 | `class X has no member named Y` | 查阅档案提供替代方案 |
| 引脚错误 | `invalid pin`, `not a valid pin` | 参考档案替换引脚 |
| FQBN 未知 | `Unknown FQBN` | 提供板包安装命令 |

#### 4.5 错误处理流程

```
编译失败 → 解析错误类型 → 自动修复（最多3次）
                           ↓
                    修复失败 → 输出完整错误 → 询问用户：
                              1. 手动修复代码
                              2. 提供更多信息
                              3. 跳过验证继续
```

## AI 行为指引

### 代码生成规范

1. **必须先读取档案**：在生成任何代码前，读取 `references/*_Extracted_Data.md`
2. **声明硬件兼容性**：代码头部注明开发板型号、安全引脚、已规避陷阱
3. **使用 `config/fqbn-mapping.json`**：获取准确的 FQBN 和板包信息

### 编译验证流程

1. 代码生成后，**主动执行** `arduino-cli compile` 验证
2. 若 Arduino CLI 未安装，**询问用户**是否安装或跳过
3. 解析编译输出：
   - 成功：报告通过
   - 失败：尝试自动修复（最多3次），之后让用户决定

### 常见编译问题修复

```cpp
// 问题：ESP32 BLE 库版本不兼容
// 解决：使用条件编译适配不同版本
#if ESP_ARDUINO_VERSION_MAJOR >= 3
  BLEDevice::createServer();  // v3.x API
#else
  BLEServer* pServer = BLEDevice::createServer();  // v2.x API
#endif
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
