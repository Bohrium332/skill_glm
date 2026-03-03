# XIAO RP2040 Structured Extraction

## Device_Name
- Seeed Studio XIAO RP2040

## MCU_Core
- Raspberry Pi RP2040
- Dual-core ARM Cortex-M0+
- 最高 133 MHz（文档表述：up to 133 MHz）

## Memory
- SRAM: 264 KB
- Flash: 2 MB Onboard Flash

## Communication_Interfaces
- 无线：无（Specification 中 `Wireless Connectivity: /`）
- 有线/片上接口（Features/Specification）：
- GPIO Pin x14
- Digital Pin x11
- Analog Pin x4
- PWM x11
- I2C x1
- UART x1
- SPI x1
- SWD Bonding pad interface x1
- D0-D10 范围内默认总线引脚（来自 Pin Map）：
- I2C: `D4(GPIO6)=SDA`, `D5(GPIO7)=SCL`
- UART: `D6(GPIO0)=TX`, `D7(GPIO1)=RX`
- SPI: `D8(GPIO2)=SCK`, `D9(GPIO4)=MISO`, `D10(GPIO3)=MOSI`

## Pin_Mapping

### D0-D10 映射

| Pin | GPIO(Chip Pin) | PWM | ADC | I2C | SPI | UART | 文档复用/说明 |
|---|---|---|---|---|---|---|---|
| D0 | GPIO26 | 文档未在 Pin Map 逐脚标注；规格写 PWM x11 | 是 | 否 | 否 | 否 | Function: Analog；Description: GPIO, ADC |
| D1 | GPIO27 | 文档未在 Pin Map 逐脚标注；规格写 PWM x11 | 是 | 否 | 否 | 否 | Function: Analog；Description: GPIO, ADC |
| D2 | GPIO28 | 文档未在 Pin Map 逐脚标注；规格写 PWM x11 | 是 | 否 | 否 | 否 | Function: Analog；Description: GPIO, ADC |
| D3 | GPIO29 | 文档未在 Pin Map 逐脚标注；规格写 PWM x11 | 是 | 否 | 否 | 否 | Function: Analog；Description: GPIO, ADC |
| D4 | GPIO6 | 文档未在 Pin Map 逐脚标注；规格写 PWM x11 | 否（Pin Map 未标 ADC） | 是（SDA） | 否 | 否 | Function: SDA；Description: GPIO, I2C Data |
| D5 | GPIO7 | 文档未在 Pin Map 逐脚标注；规格写 PWM x11 | 否（Pin Map 未标 ADC） | 是（SCL） | 否 | 否 | Function: SCL；Description: GPIO, I2C Clock |
| D6 | GPIO0 | 文档未在 Pin Map 逐脚标注；规格写 PWM x11 | 否（Pin Map 未标 ADC） | 否 | 否 | 是（TX） | Function: TX；Description: GPIO, UART Transmit |
| D7 | GPIO1 | 文档未在 Pin Map 逐脚标注；规格写 PWM x11 | 否（Pin Map 未标 ADC） | 否 | 否（但标注 CSn） | 是（RX） | Function: RX,CSn；Description: GPIO, UART Receive, CSn |
| D8 | GPIO2 | 文档未在 Pin Map 逐脚标注；规格写 PWM x11 | 否（Pin Map 未标 ADC） | 否 | 是（SCK） | 否 | Function: SCK；Description: GPIO, SPI Clock |
| D9 | GPIO4 | 文档未在 Pin Map 逐脚标注；规格写 PWM x11 | 否（Pin Map 未标 ADC） | 否 | 是（MISO） | 否 | Function: MISO；Description: GPIO, SPI Data |
| D10 | GPIO3 | 文档未在 Pin Map 逐脚标注；规格写 PWM x11 | 否（Pin Map 未标 ADC） | 否 | 是（MOSI） | 否 | Function: MOSI；Description: GPIO, SPI Data |

### A0-A10 映射（仅保留文档可证据化信息）

| Analog Pin | 对应 GPIO | 依据与说明 |
|---|---|---|
| A0 | 文档未明确给出 A0->GPIO 对照 | 文档仅说明有 4 个模拟引脚，并在 Pin Map 中标出 D0-D3 为 Analog |
| A1 | 文档未明确 | 文档未给出 A1 对照表 |
| A2 | 文档未明确 | 文档未给出 A2 对照表 |
| A3 | 文档未明确 | 文档未给出 A3 对照表 |
| A4 | 文档未提及 | 文档未给出 |
| A5 | 文档未提及 | 文档未给出 |
| A6 | 文档未提及 | 文档未给出 |
| A7 | 文档未提及 | 文档未给出 |
| A8 | 文档未提及 | 文档未给出 |
| A9 | 文档未提及 | 文档未给出 |
| A10 | 文档未提及 | 文档未给出 |

### ADC/DAC 分辨率与 API

- ADC 分辨率：文档未提及具体位数或 `analogReadResolution(...)` API。
- PWM 分辨率/API：文档未提及 `analogWriteResolution(...)` 或占空比分辨率配置方式。
- DAC：文档未提及 DAC 引脚或 DAC 能力。

## Critical_IO_Gotchas (极其重要)
- I/O 电压上限（caution）：通用 I/O 工作电压为 3.3V，高于 3.3V 的输入可能损坏芯片。
- 电源输入路径（caution）：文档说明板载 DC-DC 可把 5V 转 3.3V，可通过 `VIN-PIN` 和 `5V-PIN` 以 5V 供电。
- 电池与 Type-C 并用风险（caution）：文档明确“当前仅支持电池供电，电池连接时不能再连接 Type-C”，否则有安全风险。
- 机械风险（caution）：文档明确提示“不要掀起 shield cover（屏蔽盖）”。
- LED 电平逻辑陷阱：内置可编程单色 LED（R/G/B）逻辑与常见 Arduino 相反，需要拉低点亮（active-low）。
- 烧录端口丢失恢复：文档给出通过长按 `B` 并重新连接电脑进入 Bootloader 的恢复方式。

## LED_Status
- 规格表 Onboard：
- User LED（3 Colors）x1
- Power LED x1
- RGB LED x1
- Pin Map：
- `RGB LED -> GPIO12`
- `USER_LED_R -> GPIO17`
- `USER_LED_G -> GPIO16`
- `USER_LED_B -> GPIO25`
- `CHARGE_LED -> VCC_3V3`（CHG-LED_Red）
- 逻辑注意：文档说明内置可编程单色 LED 为低电平点亮（active-low）。

## Power_&_Battery
- 规格表供电输入：
- Type-C 输入电压：5V
- BAT 输入电压：5V
- 文档 caution：
- 可通过 `VIN-PIN` / `5V-PIN` 以 5V 供电（板载 DC-DC 转 3.3V）
- 电池连接状态下不应再连接 Type-C（有安全风险）
- 文档未提及：
- 电池电压采样引脚/软件读取方式
- 5V/3.3V 最大输出电流上限数值

## Sleep_&_Wakeup
- 深度休眠电流：文档未提及（Specification 的 `Low Power Mode(Typ.)` 为 `/`）。
- Sleep/Deep Sleep API：文档未提供。
- GPIO 唤醒引脚、唤醒电平与配置函数：文档未提及。

## Bootloader_Mode
- 文档给出的进入 Bootloader 操作：
1. 长按 `"B"` 按键。
2. 连接 XIAO RP2040 到电脑。
3. 电脑会出现一个磁盘驱动器。
- 文档说明进入 Bootloader 后烧录端口会重新出现；并说明 RP2040 具有 Bootloader 分区和用户程序分区。

## Low_Power_Usage
- 文档未给出低功耗使用示例代码或 API（如休眠/唤醒流程）。
- 文档未给出典型低功耗电流数值（`Low Power Mode(Typ.)` 为 `/`）。

## Source_Files
- Wiki: [Getting Started with Seeed Studio XIAO RP2040](https://wiki.seeedstudio.com/XIAO-RP2040/)
- Datasheet: [Raspberry Pi RP2040 Datasheet](https://files.seeedstudio.com/wiki/XIAO-RP2040/res/rp2040_datasheet.pdf)
- Schematic: [XIAO RP2040 Schematic](https://files.seeedstudio.com/wiki/XIAO-RP2040/res/Seeed-Studio-XIAO-RP2040-v1.3.pdf)
