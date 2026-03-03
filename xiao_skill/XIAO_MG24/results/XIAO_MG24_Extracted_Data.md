# XIAO MG24 Structured Extraction

## Device_Name
- Seeed Studio XIAO MG24
- Seeed Studio XIAO MG24 Sense（同系列板型；Built-in-Sensor 文档给出内置 6 轴 IMU `LSM6DS3TR-C` 与麦克风相关示例）

## MCU_Core
- Silicon Labs EFR32MG24
- ARM Cortex-M33（32-bit RISC）
- 最高主频 78 MHz
- 文档特性描述：支持 DSP/FPU，带 AI/ML 硬件加速器 MVP

## Memory
- RAM: 256 KB
- Flash: 1536 KB + 4 MB Onboard（规格表原文表述）

## Communication_Interfaces
- 无线（Introduction/Features）：
- 2.4 GHz 多协议无线，支持 Matter / Thread(OpenThread) / Zigbee / Bluetooth LE 5.3 / Bluetooth mesh
- 有线/片上接口（文档有信息差异，需并列保留）：
- `Getting_Started` 规格表：`1x I²C`, `2x UART`, `2x SPI`
- `Pin_Multiplexing` 开头：`2x I2C`, `2x UART`, `2x SPI`
- D0-D10 范围内可直接映射的默认总线：
- I2C: `D4(SDA)`, `D5(SCL)`
- UART: `D6(TX0)`, `D7(RX0)`
- SPI: `D8(SCK0)`, `D9(MISO0)`, `D10(MOSI0)`
- 额外复用（超出 D0-D10）：
- I2C: `D13`, `D14`
- SPI: `D15`, `D16`, `D17`
- UART: `D11`, `D12`（Pin Map 描述为 UART Receive/Transmit，Alternate Functions 标注 `SAMD11_TX/RX`）
- 内置传感器相关接口（`XIAO-MG24-Built-in-Sensor`）：
- IMU 示例使用 `LSM6DS3` 库，I2C 模式地址 `0x6A`
- IMU 示例在初始化阶段通过 `PD5` 拉高使能传感器电源
- 麦克风示例（Seeed Demo）使用 `mic.h` + `MG24_ADC_Class`，示例采样率 `16000 Hz`
- 麦克风示例（Silicon Labs Demo）使用模拟麦克风 `MSM381ACT001`，并给出引脚：`MIC_DATA_PIN=PC9`, `MIC_PWR_PIN=PC8`

## Pin_Mapping

### D0-D10 映射

| Pin | GPIO(Chip Pin) | PWM | ADC | I2C | SPI | UART | 文档复用/说明 |
|---|---|---|---|---|---|---|---|
| D0 | PC00 | 是（文档写 all PWM / all GPIO PWM） | 是 | 否 | 否 | 否 | Function: Analog；Description: GPIO, ADC |
| D1 | PC01 | 是 | 是 | 否 | 否 | 否 | Function: Analog；Description: GPIO, ADC |
| D2 | PC02 | 是 | 是 | 否 | 否 | 否 | Function: Analog；Description: GPIO, ADC |
| D3 | PC03 | 是 | 是 | 否 | 是（SPI） | 否 | Description: GPIO, SPI, ADC |
| D4 | PC04 | 是 | 是 | 是（SDA） | 否 | 否 | Function: Analog,SDA；Description: GPIO, I2C Data, ADC |
| D5 | PC05 | 是 | 是 | 是（SCL） | 否 | 否 | Function: Analog,SCL；Description: GPIO, I2C Clock, ADC |
| D6 | PC06 | 是 | 是 | 否 | 否 | 是（TX0） | Function: Analog,TX0；Description: GPIO, UART Transmit, ADC |
| D7 | PC07 | 是 | 是 | 否 | 否 | 是（RX0） | Function: Analog,RX0；Description: GPIO, UART Receive, ADC |
| D8 | PA03 | 是 | 是 | 否 | 是（SCK0） | 否 | Function: Analog,SCK0；Description: GPIO, SPI Clock, ADC |
| D9 | PA04 | 是 | 是 | 否 | 是（MISO0） | 否 | Function: Analog,MISO0；Description: GPIO, SPI Data, ADC |
| D10 | PA05 | 是 | 是 | 否 | 是（MOSI0） | 否 | Function: Analog,MOSI0；Description: GPIO, SPI Data, ADC |

### A0-A10 映射（仅保留文档可证据化信息）

| Analog Pin | 对应 GPIO | 依据与说明 |
|---|---|---|
| A0 | PC00（对应 D0） | Pin Multiplexing 明确提到扩展板接口 `A0/D0`；Pin Map 中 `D0=PC00` 且为 Analog/ADC |
| A1 | 文档未明确 | 两份文档未给出 `A1 -> GPIO` 对照表 |
| A2 | 文档未明确 | 两份文档未给出 `A2 -> GPIO` 对照表 |
| A3 | 文档未明确 | 两份文档未给出 `A3 -> GPIO` 对照表 |
| A4 | 文档未明确 | 两份文档未给出 `A4 -> GPIO` 对照表 |
| A5 | 文档未明确 | 两份文档未给出 `A5 -> GPIO` 对照表 |
| A6 | 文档未提及 | 两份文档未给出 |
| A7 | 文档未提及 | 两份文档未给出 |
| A8 | 文档未提及 | 两份文档未给出 |
| A9 | 文档未提及 | 两份文档未给出 |
| A10 | 文档未提及 | 两份文档未给出 |

### Sense 内置传感器相关引脚（来自 Built-in-Sensor 文档）

| 信号 | 引脚 | 说明 |
|---|---|---|
| IMU I2C 地址 | `0x6A` | LSM6DS3 示例中 `LSM6DS3 myIMU(I2C_MODE, 0x6A)` |
| IMU 使能 | `PD5` | 示例中 `pinMode(PD5, OUTPUT); digitalWrite(PD5, HIGH);` |
| 麦克风数据 | `PC9` | Silicon Labs 模拟麦克风示例 `MIC_DATA_PIN` |
| 麦克风供电 | `PC8` | Silicon Labs 模拟麦克风示例 `MIC_PWR_PIN` |

### ADC/PWM 分辨率与 API（原文明确）

- ADC：
- Pin Multiplexing 明确写 `12 bit ADC`
- 多处示例按 `0~4095` 进行映射/换算（如 `map(..., 0, 4095, 0, 255)`）
- PWM：
- Pin Multiplexing 写明“所有 GPIO 支持 PWM 输出”
- 示例使用 `analogWrite(pin, value)`，示例值范围 `0~255`
- 采样相关 API（文档示例）：
- `analogRead(...)`
- `analogReadDMA(...)`（并有版本限制提示）
- 文档未给出：
- `analogReadResolution(...)`
- `analogWriteResolution(...)`
- DAC：文档未提及 DAC 引脚或 DAC 分辨率

## Critical_IO_Gotchas (极其重要)
- USB 线材提示（tip）：部分 USB-C 线只能供电、不能传输数据。
- 5V 引脚反灌/并电源注意：若把外部电源接到 5V，原文要求串联二极管（阳极接电池侧、阴极接 5V 引脚）。
- 电池焊接警告（caution）：必须避免电池正负极短路，否则可能烧毁电池和设备。
- 电池供电状态判断陷阱：电池供电时板上可能无 LED 亮起（除非程序主动控制），不能仅凭 LED 判断是否在运行。
- 电量读取相关“信息差异”：
- Battery Usage 段写“暂无软件方式检查剩余电量（无更多可用引脚）”
- 同文档另有“Reading Battery Voltage”示例，给出 `PD3` 使能 + `PD4` 采样电压方法
- 电池电压读取关键步骤：先 `pinMode(PD3, OUTPUT); digitalWrite(PD3, HIGH);`，再 `analogRead(PD4)`，并按 `voltage = value * (2 * 3.3 / 4095.0)` 换算。
- 深睡眠风险：文档明确 MG24 可能在 Deep Sleep 后无法正常唤醒、导致无法上传程序（“bricked”风险）。
- BOOT 恢复限制：文档明确 MG24 没有 dedicated BOOT button，也没有文档化 BOOT recovery method。
- 深睡眠防砖关键点：
- 复位时将 `PC1` 拉低可进入无限循环，便于重新上传程序
- 避免不必要地让 Flash 进入 `Deep Power Down`
- 若要让 Flash 进入 deep sleep，文档 tip 指出需发送 `0xB9` 寄存器命令
- DMA 模拟采样限制（tip）：`analogReadDMA` 相关示例要求库版本 `> 2.2.0`*(⚠️ 维护注记：此版本号基于建档时的官方 Wiki。AI 在生成代码时，请务必提醒用户核实 Seeed 官方是否有更新的版本。)*，且文档称当时需手动安装新版本。
- Unbricking 脚本 note：macOS 若识别不到 OpenOCD 需检查安装与路径；恢复脚本仅适用于 XIAO MG24。
- IMU 库版本提示（Built-in-Sensor tip）：若已安装旧版 `LSM6DS3` 库，需更新到 `2.0.4`*(⚠️ 维护注记：此版本号基于建档时的官方 Wiki。AI 在生成代码时，请务必提醒用户核实 Seeed 官方是否有更新的版本。)* 或更高版本。
- IMU 供电使能步骤：Built-in-Sensor 示例要求先拉高 `PD5`，再初始化 `myIMU.begin()`。
- 麦克风库使用提示（Built-in-Sensor tip）：Seeed 麦克风示例在文档中提示需要手动替换 `gsdk.a`（SiliconLabs `2.2.0`*(⚠️ 维护注记：此版本号基于建档时的官方 Wiki。AI 在生成代码时，请务必提醒用户核实 Seeed 官方是否有更新的版本。)* 路径）后再使用。
- Silicon Labs 麦克风示例提示（Built-in-Sensor tip）：需安装较新的板包版本（文档写 `2.3.0`*(⚠️ 维护注记：此版本号基于建档时的官方 Wiki。AI 在生成代码时，请务必提醒用户核实 Seeed 官方是否有更新的版本。)*）才能在示例中看到对应官方代码。

## LED_Status
- 规格表：`1x User LED` + `1x Power LED`
- Pin Map：
- `USER_LED -> PA07`（User Light_Yellow）
- `CHARGE_LED -> VBUS`（CHG-LED_Red）
- 电池/充电指示（Battery Usage）：
- 未接电池但接 Type-C：红灯亮约 30 秒后熄灭
- 接电池并充电：红灯闪烁
- 充满后：红灯熄灭
- 额外注意：电池单独供电时默认可能无 LED 显示（除非程序控制）
- Built-in-Sensor 麦克风示例中，`LED_BUILTIN` 也被用作调试/音量可视化（声音变化对应 LED 亮度变化）。

## Power_&_Battery
- 板载电源管理：支持电池独立供电，并可通过 USB 口给电池充电。
- 电池建议：推荐 3.7V 可充锂电池；并要求注意正负极方向（靠近 USB 侧为负极）。
- 引脚供电说明（Hardware overview）：
- `5V(VBUS)`：Power Input/Output
- `3V3(3V3_OUT)`：Power Output（板载稳压输出）
- 5V 外部输入注意：原文要求串联二极管，防止不当并电源。
- 电池电压读取：
- 使能脚：`PD3`
- 采样脚：`PD4`
- 示例换算：`voltage = analogRead(PD4) * (2 * 3.3 / 4095.0)`
- 输出电流上限：文档未提及 5V/3V3 最大输出电流数值。

## Sleep_&_Wakeup
- Sleep 示例：
- `LowPower.sleep(2000)`（原文说明：CPU 停止，RAM 内容保留）
- Deep Sleep 示例：
- `LowPower.deepSleep(10000)`、`LowPower.deepSleep(600000)`
- 原文说明 Deep Sleep 下仅保留最小外设（如 Backup RAM/RTC），CPU 停止且 RAM 内容丢失，唤醒后从程序开头执行。
- “external or timed wakeup”文字有提及，但两份文档未给出可用 GPIO 唤醒引脚清单或具体配置 API 示例。
- 防砖相关复位逃生机制：`PC1` 在复位时拉低可进入可重刷的无限循环。

## Bootloader_Mode
- 两份文档未提供“按键步骤式”的 Bootloader 进入流程。
- Getting Started 的 Unbricking 部分明确说明：
- MG24 没有 dedicated `BOOT` 按键
- 没有文档化的 BOOT recovery method
- 文档提供的是“救砖/恢复串口上传”方案而非标准 BOOT 按键流程：
- Windows：运行 `flash_erase.bat`
- macOS：运行 `xiao_mg24_erase.sh`（依赖 OpenOCD）

## Low_Power_Usage
- 规格表功耗数据：
- `Low Power (Typ.)`: `1.95 μA`
- `Sleep (Typ.)`: `1.91 mA`
- `Normal (Typ.)`: `6.71 mA`
- 文档给出的低功耗 API 示例：
- `LowPower.sleep(ms)`
- `LowPower.deepSleep(ms)`
- 深睡相关附加注意：
- 若要把 Flash 置入 deep sleep，示例使用 `0xB9`
- 文档明确提示应避免不必要的 Flash `Deep Power Down`，否则可能影响后续上传恢复

## Source_Files
- Wiki: [Getting Started with Seeed Studio XIAO MG24](https://wiki.seeedstudio.com/xiao_mg24_getting_started/)
- Wiki: [Pin Multiplexing with Seeed Studio XIAO MG24](https://wiki.seeedstudio.com/xiao_mg24_pin_multiplexing/)
- Wiki（ES）: [Seeed Studio XIAO MG24 Sense sensor integrado](https://wiki.seeedstudio.com/es/xiao_mg24_sense_built_in_sensor/)
- Datasheet: [Silicon Labs EFR32MG24 Datasheet](https://files.seeedstudio.com/wiki/XIAO_MG24/Getting_Start/mg24-group-datasheet.PDF)
- Reference Manual: [Silicon Labs EFR32MG24 Reference Manual](https://files.seeedstudio.com/wiki/XIAO_MG24/Getting_Start/efr32xg24_rm.pdf)
- Schematic: [XIAO MG24 Schematic](https://files.seeedstudio.com/wiki/XIAO_MG24/Getting_Start/XIAO_MGM240S_KICAD_Prj.pdf)
- Datasheet: [LSM6DS3TR-C IMU Datasheet](https://statics3.seeedstudio.com/fusion/opl/sheets/314040211.pdf)
- Datasheet: [MSM381ACT001 Analog Microphone Datasheet](https://files.seeedstudio.com/wiki/mg24_mic/312030602_MEMSensing_MSM381ACT001_Datasheet.pdf)
