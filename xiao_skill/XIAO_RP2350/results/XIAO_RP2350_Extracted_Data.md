# XIAO RP2350 Structured Extraction

## Device_Name
- Seeed Studio XIAO RP2350

## MCU_Core
- Raspberry Pi RP2350
- Symmetric dual Arm Cortex-M33
- 主频 150 MHz（文档写 `@150MHz`）
- 支持 FPU（Features/Specification 明确）

## Memory
- SRAM: 520 kB
- Flash: 2 MB

## Communication_Interfaces
- 无线：文档未提及无线连接能力。
- 有线/片上接口（以 RP2350 列为准）：
- Digital: 19
- Analog: 3
- PWM: 19（文档写 `All PWM`）
- I2C: 2
- UART: 2
- SPI: 2
- D0-D10 范围内默认接口（来自 Pin Map）：
- I2C: `D4(GPIO6)=SDA1`, `D5(GPIO7)=SCL1`
- UART: `D6(GPIO0)=TX0`, `D7(GPIO1)=RX0`
- SPI: `D3(GPIO5)=SPI0_CSn`, `D8(GPIO2)=SPI0_SCK`, `D9(GPIO4)=SPI0_MISO`, `D10(GPIO3)=SPI0_MOSI`
- 额外复用（超出 D0-D10）：
- UART1: `D11(GPIO21)=RX1`, `D12(GPIO20)=TX1`
- I2C0: `D13(GPIO17)=SCL0`, `D14(GPIO16)=SDA0`
- SPI1: `D15(GPIO11)=MOSI`, `D16(GPIO12)=MISO`, `D17(GPIO10)=SCK`, `D18(GPIO9)=CSn`

## Pin_Mapping

### D0-D10 映射

| Pin | GPIO(Chip Pin) | PWM | ADC | I2C | SPI | UART | 文档复用/说明 |
|---|---|---|---|---|---|---|---|
| D0 | GPIO26 | 是（文档写 19 Pins All PWM / all GPIO PWM） | 是 | 否 | 否 | 否 | Function: Analog；Description: GPIO, ADC |
| D1 | GPIO27 | 是 | 是 | 否 | 否 | 否 | Function: Analog；Description: GPIO, ADC |
| D2 | GPIO28 | 是 | 是 | 否 | 否 | 否 | Function: Analog；Description: GPIO, ADC |
| D3 | GPIO5 | 是 | 否（Pin Map 未标 ADC） | 否 | 是（SPI0_CSn） | 否 | Function: SPIO_CSn；Description: GPIO, SPI |
| D4 | GPIO6 | 是 | 否（Pin Map 未标 ADC） | 是（SDA1） | 否 | 否 | Function: SDA1；Description: GPIO, I2C Data |
| D5 | GPIO7 | 是 | 否（Pin Map 未标 ADC） | 是（SCL1） | 否 | 否 | Function: SCL1；Description: GPIO, I2C Clock |
| D6 | GPIO0 | 是 | 否（Pin Map 未标 ADC） | 否 | 否 | 是（TX0） | Function: TX0；Description: GPIO, UART Transmit |
| D7 | GPIO1 | 是 | 否（Pin Map 未标 ADC） | 否 | 否 | 是（RX0） | Function: RX0；Description: GPIO, UART Receive |
| D8 | GPIO2 | 是 | 否（Pin Map 未标 ADC） | 否 | 是（SPI0_SCK） | 否 | Function: SPIO_SCK；Description: GPIO, SPI Clock |
| D9 | GPIO4 | 是 | 否（Pin Map 未标 ADC） | 否 | 是（SPI0_MISO） | 否 | Function: SPIO_MISO；Description: GPIO, SPI Data |
| D10 | GPIO3 | 是 | 否（Pin Map 未标 ADC） | 否 | 是（SPI0_MOSI） | 否 | Function: SPIO_MOSI；Description: GPIO, SPI Data |

### A0-A10 映射（仅保留文档可证据化信息）

| Analog Pin | 对应 GPIO | 依据与说明 |
|---|---|---|
| A0 | GPIO26（对应 D0） | Pin Multiplexing 多处写扩展板接口 `A0/D0`，且 Pin Map 中 D0=GPIO26 |
| A1 | 文档未明确 | 文档未给出 `A1 -> GPIO` 对照表 |
| A2 | 文档未明确 | 文档未给出 `A2 -> GPIO` 对照表 |
| A3 | 文档未明确 | 文档未给出 `A3 -> GPIO` 对照表（虽有“3x Analog”描述） |
| A4 | 文档未提及 | 文档未给出 |
| A5 | 文档未提及 | 文档未给出 |
| A6 | 文档未提及 | 文档未给出 |
| A7 | 文档未提及 | 文档未给出 |
| A8 | 文档未提及 | 文档未给出 |
| A9 | 文档未提及 | 文档未给出 |
| A10 | 文档未提及 | 文档未给出 |

### ADC/DAC 分辨率与 API（原文可提取）

- ADC：
- Pin Multiplexing 的 Analog 段文字写到 `12 bit ADC`（该段出现 “XIAO MG24(Sense)” 字样，但仍位于 RP2350 文档内）。
- 示例使用 `analogRead(A0)` 读取模拟值。
- PWM：
- 文档明确所有 GPIO 支持 PWM。
- 示例使用 `analogWrite(pin, value)`，示例范围 `0~255`。
- 文档未给出：
- `analogReadResolution(...)`
- `analogWriteResolution(...)`
- DAC：文档未提及 DAC 引脚/分辨率/API。

## Critical_IO_Gotchas (极其重要)
- 版本门槛（note）：Arduino core 需 `4.2.0`*(⚠️ 维护注记：此版本号基于建档时的官方 Wiki。AI 在生成代码时，请务必提醒用户核实 Seeed 官方是否有更新的版本。)* 或更高，才能完整支持 XIAO RP2350。
- 兼容性修复步骤（Preparation 段）：文档明确 4.2.0*(⚠️ 维护注记：此版本号基于建档时的官方 Wiki。AI 在生成代码时，请务必提醒用户核实 Seeed 官方是否有更新的版本。)* 存在引脚使用兼容问题；在 4.2.1*(⚠️ 维护注记：此版本号基于建档时的官方 Wiki。AI 在生成代码时，请务必提醒用户核实 Seeed 官方是否有更新的版本。)* 发布前，需要手动替换 `Arduino15/packages/rp2040/hardware/rp2040/4.2.0/variants/seeed_xiao_rp2350`*(⚠️ 维护注记：此版本号基于建档时的官方 Wiki。AI 在生成代码时，请务必提醒用户核实 Seeed 官方是否有更新的版本。)* 中的文件。
- Boot 模式是上传前关键步骤：文档要求上传前先进入 BOOT 模式（见 Bootloader_Mode 两种方法）。
- 串口使用提示（tip）：
- `Serial` 用于设备与电脑通信。
- 设备与设备间通信应使用 `Serial1`（示例使用 D6/D7）。
- 模拟能力信息差异需注意：
- Getting Started 规格写 `3x Analog`；
- Pin Map 的 D0/D1/D2 标注 ADC，另外还有 `ADC_BAT(GPIO29)` 用于电池电压读取；
- 但文档未给出完整 `A1/A2/A3` 到 GPIO 对照表。

## LED_Status
- 规格表：`1x user LED` + `1x power LED` + `1x RGB LED`
- Pin Map：
- `USER_LED -> GPIO25`（User Light_Yellow）
- `RGB LED -> GPIO22`
- `CHARGE_LED -> NCHG`（CHG-LED_Red）
- 文档未说明 USER/RGB LED 的高低电平点亮逻辑。

## Power_&_Battery
- Features 描述：
- 睡眠模式功耗约 `50 μA`
- 支持电池供电
- 支持通过内部 IO 直接测量电池电压（用于 BMS）
- Pin Map 电池采样信息：
- `ADC_BAT -> GPIO29`（Read the BAT voltage value）
- 电源引脚：
- `5V(VBUS)`：Power Input/Output
- `3V3(3V3_OUT)`：Power Output
- 文档未给出：
- 电池电压读取示例代码/换算公式
- 5V/3.3V 最大输出电流上限数值

## Sleep_&_Wakeup
- 文档仅给出睡眠功耗级别描述：约 `50 μA`（Features）。
- 这两份文档未给出睡眠/深睡 API、唤醒源、唤醒引脚或触发电平配置说明。

## Bootloader_Mode
- 文档给出的 BOOT 进入方式（Uploading a Sketch）：
1. 方法一：按住 `BOOT` -> 插入 USB 线 -> 松开 `BOOT`。
2. 方法二：设备已连接时，按住 `BOOT` -> 点击 `RESET` -> 松开 `BOOT`。
- Pin Map 也明确 `Boot -> RP2040_BOOT -> Enter Boot Mode`。

## Low_Power_Usage
- 文档中的低功耗信息：
- Features 写明睡眠功耗约 `50 μA`。
- Assets 提供 `XIAO RP2350 Low Power Test Firmware`（UF2）下载资源。
- 这两份文档未给出低功耗 C/C++ API 代码（如进入睡眠、配置唤醒源的函数）。

## Source_Files
- Wiki: [Getting Started with Seeed Studio XIAO RP2350(Arduino)](https://wiki.seeedstudio.com/xiao_rp2350_arduino/)
- Wiki: [Pin Multiplexing (Arduino)](https://wiki.seeedstudio.com/XIAO_RP2350_Pin_Multiplexing/)
- Datasheet: [Raspberry Pi RP2350 Datasheet](https://datasheets.raspberrypi.com/rp2350/rp2350-datasheet.pdf)
- Schematic: [XIAO RP2350 Schematic](https://files.seeedstudio.com/wiki/XIAO-RP2350/res/Seeed-Studio-XIAO-RP2350-v1.0.pdf)
