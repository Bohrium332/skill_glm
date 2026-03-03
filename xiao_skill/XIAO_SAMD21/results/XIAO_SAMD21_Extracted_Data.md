# XIAO SAMD21 Structured Extraction

## Device_Name
- Seeed Studio XIAO SAMD21（文中说明曾命名为 Seeeduino XIAO）

## MCU_Core
- Microchip ATSAMD21G18A-MU / SAMD21G18
- ARM Cortex-M0+（32-bit）
- 最高 48 MHz

## Memory
- SRAM: 32KB
- Flash: 256KB

## Communication_Interfaces
- 无线：无（`Wireless Connectivity: /`）
- 有线接口数量（规格表）：
- I2C x1
- UART x1
- SPI x1
- PWM x10（文中明确为 `D1-D10`）
- 默认引脚（由 Pin Map 与接口说明提取）：
- I2C: `SDA=D4(PA08)`, `SCL=D5(PA09)`
- UART: `TX=D6(PB08)`, `RX=D7(PB09)`
- SPI: `SCK=D8(PA07)`, `MISO=D9(PA05)`, `MOSI=D10(PA06)`

## Pin_Mapping

### D0-D10

| Pin | Chip Pin(GPIO) | PWM | ADC | I2C | SPI | UART | DAC | 文档列出的功能 |
|---|---|---|---|---|---|---|---|---|
| D0 | PA02 | 否 | 是 | 否 | 否 | 否 | 是 | Analog, GPIO, ADC；文中另述其为 DAC 输出引脚 |
| D1 | PA04 | 是（D1-D10） | 是 | 否 | 否 | 否 | 否 | Analog, GPIO, ADC |
| D2 | PA10 | 是（D1-D10） | 是 | 否 | 否 | 否 | 否 | Analog, GPIO, ADC |
| D3 | PA11 | 是（D1-D10） | 是 | 否 | 否 | 否 | 否 | Analog, GPIO, ADC |
| D4 | PA08 | 是（D1-D10） | 是 | 是（SDA） | 否 | 否 | 否 | Analog, SDA, GPIO, I2C Data, ADC |
| D5 | PA09 | 是（D1-D10） | 是 | 是（SCL） | 否 | 否 | 否 | Analog, SCL, GPIO, I2C Clock, ADC |
| D6 | PB08 | 是（D1-D10） | 是 | 否 | 否 | 是（TX） | 否 | Analog, TX, GPIO, UART Transmit, ADC |
| D7 | PB09 | 是（D1-D10） | 是 | 否 | 否 | 是（RX） | 否 | Analog, RX, GPIO, UART Receive, ADC |
| D8 | PA07 | 是（D1-D10） | 是 | 否 | 是（SCK） | 否 | 否 | Analog, SPI_SCK, GPIO, SPI Clock, ADC |
| D9 | PA05 | 是（D1-D10） | 是 | 否 | 是（MISO） | 否 | 否 | Analog, SPI_MISO, GPIO, SPI Data, ADC |
| D10 | PA06 | 是（D1-D10） | 是（Function 列为 Analog） | 否 | 是（MOSI） | 否 | 否 | Analog, SPI_MOSI, GPIO, SPI Data |

### A0-A10

| Analog Pin | 对应 GPIO | 功能 |
|---|---|---|
| A0 | 文档未给出明确 A0->GPIO 对照（文中仅说明 A0 支持 DAC） | DAC（0~3.3V 输出）、可作 ADC 采样示例 |
| A1 | 文档未明确 | 文档未明确 |
| A2 | 文档未明确 | 文档未明确 |
| A3 | 文档未明确 | 文档未明确 |
| A4 | 文档未明确 | 文档未明确 |
| A5 | 文档未明确 | 文档未明确 |
| A6 | 文档未明确 | 文档未明确 |
| A7 | 文档未明确 | 文档未明确 |
| A8 | 文档未明确 | 文档未明确 |
| A9 | 文档未明确 | 文档未明确 |
| A10 | 文档未明确 | 文档未明确 |

### DAC/ADC 分辨率与 API（原文明确）

- DAC（仅 A0/D0）：
- 最高 10-bit 分辨率，输出值范围 `0-1023` 对应 `0~3.3V`
- 原文要求在 `setup()` 中调用：`analogWriteResolution(10)`
- ADC（模拟输入）：
- 最高 12-bit 分辨率，输入值范围 `0-4095` 对应 `0~3.3V`
- 原文要求在 `setup()` 中调用：`analogReadResolution(12)`

## Critical_IO_Gotchas (极其重要)
- 通用 I/O 电压上限：MCU 工作电压 3.3V；通用 I/O 输入若高于 3.3V 可能损坏芯片。
- `D0/A0` 是 DAC 引脚而非 PWM 引脚；文档给出的 PWM 范围为 `D1-D10`。对 `D0` 使用 `analogWrite()` 时是 DAC 模拟电压输出，不是 PWM 方波。
- 文档原文提示：`Please pay attention to use, do not lift the shield cover.`
- 供电与电池注意：
- 板背 `VIN/GND` 焊盘不是电池直连口，且会绕过板载保护二极管。
- 明确不建议直接接入可充电锂电池（LiPo/Li-Ion）；需使用带充电/保护的外部电池管理模块，再将其稳压输出接入 5V 或 3V3。
- 中断限制：全部引脚支持中断，但 `pin 5` 和 `pin 7` 不能同时使用中断。
- 板载 LED 逻辑与常见 Arduino 相反：需要拉低点亮（active-low）。
- 使用提示（tip）：部分 USB Type-C 线只能供电不能传输数据。

## LED_Status
- 板载 LED（规格表）：
- User LED x1
- Power LED x1
- TX/RX 串口状态 LED 各 x1
- Pin Map 关联：
- `USER_LED` -> `PA17`（User Light_Yellow）
- `TX_LED` -> `PA19`
- `RX_LED` -> `PA18`
- `Power_LED` -> `VBUS`（CHG-LED_Red）
- 文档说明 Blink 使用 `pin 13 (L) LED`，且其电平逻辑为 active-low。

## Power_&_Battery
- 电源输入（规格表）：
- Type-C 输入电压：5V
- BAT 输入电压：5V
- 最大输出（规格表）：
- `5V@500mA`
- `3.3V@200mA`
- 供电路径说明：
- 板载 DC-DC 可将 5V 转 3.3V，可经 `VIN-PIN` 与 `5V-PIN` 提供 5V 电源。
- 电池方案说明：
- 文档强调 `VIN/GND` 背面焊盘不应直接接锂电池；
- 若电池供电，需外置电池管理模块（含充电与保护），再接入板子 `5V` 或 `3V3`。
- 连接提示（tip）：
- 部分 USB Type-C 线仅供电不传数据。

## Sleep_&_Wakeup
- 深度休眠电流：文档未提及。
- GPIO 唤醒支持引脚与触发条件：文档未提及。

## Bootloader_Mode
- 进入 Bootloader 操作：
1. 连接开发板到电脑。
2. 用镊子或导线将 `RST` 焊盘短接两次（double-tap reset）。
3. 橙色 LED 闪烁并点亮后，进入 Bootloader 模式，烧录端口重新出现。

## Low_Power_Usage
- 文档未提供深度休眠/唤醒的 C/C++ API 示例（如 `esp_deep_sleep_*` 这类）。
- 仅有“低功耗 MCU”与供电层面的描述，无具体睡眠代码流程。

## Source_Files
- Wiki: [Getting Started with Seeed Studio XIAO SAMD21](https://wiki.seeedstudio.com/Seeeduino-XIAO/)
- Datasheet: [Atmel SAMD21G18 Datasheet](https://files.seeedstudio.com/wiki/Seeeduino-XIAO/res/ATSAMD21G18A-MU-Datasheet.pdf)
- Schematic: [XIAO SAMD21 Schematic](https://files.seeedstudio.com/wiki/Seeeduino-XIAO/res/Seeeduino-XIAO-v1.0-SCH-191112.pdf)
