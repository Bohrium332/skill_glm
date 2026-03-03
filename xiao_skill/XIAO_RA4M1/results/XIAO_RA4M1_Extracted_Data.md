# XIAO RA4M1 Structured Extraction

## Device_Name
- Seeed Studio XIAO RA4M1

## MCU_Core
- Renesas RA4M1（R7FA4M1AB3CNE）
- 32-bit Arm Cortex-M4（with FPU）
- 主频 48 MHz
- 板载转换器能力（文档 Introduction/Features）：
- 14-bit A/D converter（ADC）
- 12-bit D/A converter（DAC）

## Memory
- SRAM: 32 KB
- Flash: 256 KB
- EEPROM: 8 KB（Introduction 段提及）

## Communication_Interfaces
- 无线：文档未提及无线连接能力
- 有线/片上接口（规格表）：
- IIC x2
- UART x2
- SPI x2
- CAN BUS（Introduction/Features 段明确提及）
- USB 2.0（Introduction 段提及）
- 默认引脚（D0-D10 范围内可直接提取）：
- I2C: `D4(P206)=SDA1`, `D5(P100)=SCL1`
- UART: `D6(P302)=TXD2`, `D7(P301)=RXD2`
- SPI: `D8(P111)=SPI1_SCK`, `D9(P110)=SPI1_MISO`, `D10(P109)=SPI1_MOSI`
- 额外复用（超出 D0-D10）：
- `D15(P101)=TXD0`, `D16(P104)=RXD0`

## Pin_Mapping

### D0-D10 映射

| Pin | GPIO(Chip Pin) | PWM | ADC | I2C | SPI | UART | 文档复用/说明 |
|---|---|---|---|---|---|---|---|
| D0 | P014 | 是（Pin Multiplexing 文档写“all GPIO pins support PWM output”） | 是 | 否 | 否 | 否 | Function: Analog; Alternate: AN009 |
| D1 | P000 | 是 | 是 | 否 | 否 | 否 | Function: Analog; Alternate: AN000 |
| D2 | P001 | 是 | 是 | 否 | 否 | 否 | Function: Analog; Alternate: AN001 |
| D3 | P002 | 是 | 是 | 否 | 否 | 否 | Function: Analog; Alternate: AN002 |
| D4 | P206 | 是 | 否（Pin Map 未标 ADC） | 是（SDA1） | 否 | 否 | GPIO, I2C Data |
| D5 | P100 | 是 | 是 | 是（SCL1） | 否 | 否 | GPIO, I2C Clock, ADC |
| D6 | P302 | 是 | 否（Pin Map 未标 ADC） | 可复用（SDA2） | 否 | 是（TXD2） | GPIO, UART Transmit, I2C |
| D7 | P301 | 是 | 否（Pin Map 未标 ADC） | 可复用（SCL2） | 否 | 是（RXD2） | GPIO, UART Receive, I2C |
| D8 | P111 | 是 | 否（Pin Map 未标 ADC） | 否 | 是（SPI1_SCK） | 否 | GPIO, SPI Clock |
| D9 | P110 | 是 | 否（Pin Map 未标 ADC） | 否 | 是（SPI1_MISO） | 可复用（CRX0） | GPIO, SPI Data, UART |
| D10 | P109 | 是 | 否（Pin Map 未标 ADC） | 否 | 是（SPI1_MOSI） | 可复用（CTX0） | GPIO, SPI Data, UART |

### A0-A10 映射（仅基于文档可证据化信息）

| Analog Pin | 对应 GPIO | 依据与说明 |
|---|---|---|
| A0 | P014（与 D0 对应） | Pin Multiplexing 文档明确写到扩展板接口 `A0/D0` |
| A1 | 文档未明确给出 A1->GPIO 对照 | 示例代码使用 `A1` 做模拟输入，但未给 A1 与 Dx/Pxxx 的直接对照表 |
| A2 | 文档未提及 | 文档未给出 |
| A3 | 文档未提及 | 文档未给出 |
| A4 | 文档未提及 | 文档未给出 |
| A5 | 文档未提及 | 文档未给出 |
| A6 | 文档未提及 | 文档未给出 |
| A7 | 文档未提及 | 文档未给出 |
| A8 | 文档未提及 | 文档未给出 |
| A9 | 文档未提及 | 文档未给出 |
| A10 | 文档未提及 | 文档未给出 |

### ADC/DAC 分辨率与 API（原文明确）

- ADC 能力：
- 文档明确最高 `14-bit ADC`，并说明默认 `10-bit`，可切换为 `12-bit` 与 `14-bit`
- 文档给出的量化范围：
- `10-bit: 0~1024`
- `12-bit: 0~4096`
- `14-bit: 0~16383`
- 文档示例 API：
- `analogReadResolution(10);`
- `analogReadResolution(12);`
- `analogReadResolution(14);`
- DAC 能力：
- 文档明确为 `12-bit D/A converter`

## Critical_IO_Gotchas (极其重要)
- USB 线材提示：文档 tip 明确部分 USB Type-C 线只能供电不能传输数据。
- Bootloader 相关风险：上传失败或端口丢失时需进入 Bootloader 模式恢复（见 Bootloader_Mode）。
- 用户 LED 逻辑为反相：`HIGH` 时灭，`LOW` 时亮（Getting Started 的 note 明确说明）。
- 电池电压读取必须先使能：需将 `BAT_READ_EN/P400` 置高，才能读取 `BAT_DET_PIN/P105`。
- 焊接注意：文档 Troubleshooting 提醒不要把排针焊连、不要让焊锡粘到屏蔽罩/其他器件，否则可能短路或无法工作。
- 双板 CAN 下载注意：文档 tip 明确不允许两块 XIAO RA4M1 同时上电并同时下载程序。
- CAN 波特率限制注意：未焊接终端引脚 P1 时，仅可使用 125 以下的 CAN 波特率（文档 tip）。

## LED_Status
- 规格表：`1x User LED`, `1x Power LED`, `1x RGB LED`
- Pin Map：
- `USER_LED -> P011`（Arduino Name 19）
- `CHARGE_LED -> VBUS`
- `RGB LED -> P112`（Arduino Name 20）
- `RGB LED EN -> P500`（Arduino Name 21）
- 示例宏：
- `RGB_BUILTIN`（RGB LED 数据引脚）
- `PIN_RGB_EN`（RGB LED 使能）
- 用户 LED 电平逻辑：低电平点亮，高电平熄灭。

## Power_&_Battery
- 供电与输出电流限制：文档未给出 5V/3.3V 输出电流上限数值。
- 电池与功耗：
- 文档说明支持锂电池充电管理。
- Low Power (Typ.) 表项：`42.6μA@3.7V`
- Features 段另写：deep sleep 可低至约 `45μA`
- 电池电压读取方案（文档给出）：
- 读取引脚：`BAT_DET_PIN / P105`
- 使能引脚：`BAT_READ_EN / P400`（需先置高）
- 示例计算包含分压因子 `voltageDivider = 2.0`
- 示例电压换算：`voltage = rawValue * (3.3 / 1023.0) * 2.0`

## Sleep_&_Wakeup
- 深度休眠电流数据：
- 规格表：`42.6μA@3.7V`
- Features 段：低至 `45μA`
- GPIO 唤醒可用引脚：文档未给出具体引脚清单。
- 唤醒电平限制/配置函数：文档未提供。

## Bootloader_Mode
- 文档给出的进入方式：
1. 按住 `BOOT` 键不放。
2. 保持按住 `BOOT`，再用数据线连接电脑；连接后松开 `BOOT`。
- 文档还给出组合方式：
1. 上电时按住 `BOOT`。
2. 再按一次 `Reset`，也可进入 BootLoader 模式。

## Low_Power_Usage
- 这两份文档未提供“进入深度休眠/配置唤醒源”的 C/C++ API 示例代码。
- 仅提供低功耗电流指标（42.6μA@3.7V 或约45μA）和功能性描述。

## Source_Files
- Wiki: [Getting Started with Seeed Studio XIAO RA4M1](https://wiki.seeedstudio.com/getting_started_xiao_ra4m1/)
- Wiki: [Pin Multiplexing with Seeed Studio XIAO RA4M1](https://wiki.seeedstudio.com/xiao_ra4m1_pin_multiplexing/)
- Datasheet: [Renesas RA4M1 Datasheet](https://www.renesas.com/us/en/document/dst/ra4m1-group-datasheet)
- Schematic: [XIAO RA4M1 Schematic](https://files.seeedstudio.com/wiki/XIAO-R4AM1/res/XIAO%20RA4M1%20V1.01_SCH_PDF_260114%20.pdf.pdf)
