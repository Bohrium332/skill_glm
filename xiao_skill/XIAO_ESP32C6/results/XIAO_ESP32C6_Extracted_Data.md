# XIAO ESP32C6 Structured Extraction

## Device_Name
- Seeed Studio XIAO ESP32C6

## MCU_Core
- Espressif ESP32-C6 SoC
- Two 32-bit RISC-V processors
- High-performance core: up to 160 MHz
- Low-power core: up to 20 MHz

## Memory
- 512 KB SRAM
- 4 MB Flash

## Communication_Interfaces
- 无线（Getting Started Introduction/Features/Specifications）：
- 2.4 GHz Wi-Fi 6
- Bluetooth Low Energy（文档存在表述差异：Introduction 写 5.3；规格表对比行写 5.0）
- Zigbee
- Thread (802.15.4)
- 有线/片上接口（Specifications + Pin Map + Pin Multiplexing）：
- 1x UART
- 1x LP_UART
- 1x IIC
- 1x LP_IIC
- 1x SPI
- 1x SDIO
- 11x GPIO(PWM)
- 7x ADC
- 默认引脚（D0-D10 范围内）：
- I2C: `D4(GPIO22)=SDA`, `D5(GPIO23)=SCL`
- UART: `D6(GPIO16)=TX`, `D7(GPIO17)=RX`
- SPI: `D8(GPIO19)=SCK`, `D9(GPIO20)=MISO`, `D10(GPIO18)=MOSI`

## Pin_Mapping

### D0-D10 映射（来自 Getting Started Pin Map）

| Pin | GPIO(Chip Pin) | PWM | ADC | I2C | SPI | UART | 文档复用/说明 |
|---|---|---|---|---|---|---|---|
| D0 | GPIO0 | 文档未逐脚给出；规格写 11x GPIO(PWM) | 是 | 否 | 否 | 否 | Function: Analog；Alt: LP_GPIO0；Description: GPIO, ADC |
| D1 | GPIO1 | 文档未逐脚给出；规格写 11x GPIO(PWM) | 是 | 否 | 否 | 否 | Function: Analog；Alt: LP_GPIO1；Description: GPIO, ADC |
| D2 | GPIO2 | 文档未逐脚给出；规格写 11x GPIO(PWM) | 是 | 否 | 否 | 否 | Function: Analog；Alt: LP_GPIO2；Description: GPIO, ADC |
| D3 | GPIO21 | 文档未逐脚给出；规格写 11x GPIO(PWM) | 否（Pin Map 未标 ADC） | 否 | 可作 CS 示例 | 否 | Function: Digital；Alt: SDIO_DATA1 |
| D4 | GPIO22 | 文档未逐脚给出；规格写 11x GPIO(PWM) | 否（Pin Map 未标 ADC） | 是（SDA） | 否 | 否 | Alt: SDIO_DATA2；Description: GPIO, I2C Data |
| D5 | GPIO23 | 文档未逐脚给出；规格写 11x GPIO(PWM) | 否（Pin Map 未标 ADC） | 是（SCL） | 否 | 否 | Alt: SDIO_DATA3；Description: GPIO, I2C Clock |
| D6 | GPIO16 | 文档未逐脚给出；规格写 11x GPIO(PWM) | 否（Pin Map 未标 ADC） | 否 | 否 | 是（TX） | Function: TX；Description: GPIO, UART Transmit |
| D7 | GPIO17 | 文档未逐脚给出；规格写 11x GPIO(PWM) | 否（Pin Map 未标 ADC） | 否 | 否 | 是（RX） | Function: RX；Description: GPIO, UART Receive |
| D8 | GPIO19 | 文档未逐脚给出；规格写 11x GPIO(PWM) | 否（Pin Map 未标 ADC） | 否 | 是（SCK） | 否 | Alt: SPI_CLK；Description: GPIO, SPI Clock |
| D9 | GPIO20 | 文档未逐脚给出；规格写 11x GPIO(PWM) | 否（Pin Map 未标 ADC） | 否 | 是（MISO） | 否 | Alt: SPI_MISO；Description: GPIO, SPI Data |
| D10 | GPIO18 | 文档未逐脚给出；规格写 11x GPIO(PWM) | 否（Pin Map 未标 ADC） | 否 | 是（MOSI） | 否 | Alt: SPI_MOSI；Description: GPIO, SPI Data |

### A0-A10 映射（按文档可证据化信息）

| Analog Pin | 对应 GPIO | 依据与说明 |
|---|---|---|
| A0 | 文档未直接给出 A0->GPIO 对照 | Pin Map 给出 `D0=GPIO0(Analog)`；Battery Voltage 示例使用 `A0` 做 ADC 读取 |
| A1 | 文档未明确 | Pin Map 给出 `D1=GPIO1(Analog)`，但未给 Arduino `A1` 命名映射 |
| A2 | 文档未明确 | Pin Map 给出 `D2=GPIO2(Analog)`，但未给 Arduino `A2` 命名映射 |
| A3 | 文档未提及 | 文档未给出 A3 |
| A4 | 文档未提及 | 文档未给出 A4 |
| A5 | 文档未提及 | 文档未给出 A5 |
| A6 | 文档未提及 | 文档未给出 A6 |
| A7 | 文档未提及 | 文档未给出 A7 |
| A8 | 文档未提及 | 文档未给出 A8 |
| A9 | 文档未提及 | 文档未给出 A9 |
| A10 | 文档未提及 | 文档未给出 A10 |

### 额外关键引脚（非 D0-D10）

| 信号 | GPIO(Chip Pin) | 说明 |
|---|---|---|
| MTDI | GPIO5 | JTAG, ADC |
| MTCK | GPIO6 | JTAG, ADC |
| MTMS | GPIO4 | JTAG, ADC |
| MTDO | GPIO7 | JTAG |
| Boot | GPIO9 | Enter Boot Mode |
| RF Switch Port Select | GPIO14 | 选择板载天线/UFL 外置天线 |
| RF Switch Power | GPIO3 | RF Switch 供电/使能控制 |
| Light | GPIO15 | User Light |

### ADC/DAC 分辨率与 API（原文可提取）

- ADC：
- 示例明确使用 `analogReadResolution(12)`（12-bit，0~4095）。
- 示例 API：`analogRead(...)`、`analogReadMilliVolts(...)`。
- PWM：
- 文档写明有 `6 LEDC channels`。
- 示例 API：`analogWrite(...)`、`ledcAttach(...)`、`ledcWrite(...)`。
- LEDC 软件淡入示例参数：`LEDC_TIMER_12_BIT`、`LEDC_BASE_FREQ=5000`。
- DAC：两份文档未提及 DAC 能力或 DAC 引脚。
- 文档未给出 `analogWriteResolution(...)`。

## Critical_IO_Gotchas (极其重要)
- RF Switch（tip）必须满足前置条件：要切外置天线，先把 `GPIO3` 置低以激活 RF switch 控制，再配置 `GPIO14`；`GPIO14` 低电平为默认内置天线，高电平切外置天线。
- USB 线材提示（tip）：部分 Type-C 线仅供电，不传数据。
- 焊接警告：板子出厂不带排针，焊接时不要把不同焊盘连锡，也不要把锡蹭到屏蔽罩/其他器件，否则可能短路或异常。
- 版本门槛：
- 文档 tip 写板载包至少 `2.0.8`*(⚠️ 维护注记：此版本号基于建档时的官方 Wiki。AI 在生成代码时，请务必提醒用户核实 Seeed 官方是否有更新的版本。)*。
- 文档 note 又写 ESP32 board 版本需 `>3.0.0`*(⚠️ 维护注记：此版本号基于建档时的官方 Wiki。AI 在生成代码时，请务必提醒用户核实 Seeed 官方是否有更新的版本。)* 才可用。
- 串口库版本（tip）：`EspSoftwareSerial` 推荐 `7.0.0`*(⚠️ 维护注记：此版本号基于建档时的官方 Wiki。AI 在生成代码时，请务必提醒用户核实 Seeed 官方是否有更新的版本。)*，其它版本可能导致软串口异常。
- SPI 注意（note）：程序内引脚定义必须和实际接线一致。
- 电池 caution：电池供电时 `5V` 引脚无电压。
- 深睡外部唤醒示例说明：ESP32-C6 不支持 `ext0`，示例使用 `ext1`；并给出 RTC GPIO 可用范围中 C6 为 `0-7`。

## LED_Status
- 板载用户灯：Pin Map 为 `Light -> GPIO15 (User Light)`。
- Blink 段落描述：成功上传后可见板右侧橙色 LED 闪烁。
- 电池充电红灯（tip Red Indicator Light）：
- 无电池 + Type-C：红灯亮约 30 秒后灭。
- 有电池且 Type-C 充电：红灯闪烁。
- 充满电：红灯熄灭。
- 文档未给出红色充电灯对应 GPIO 编号。

## Power_&_Battery
- 供电输入（Specifications）：`Type-C 5V`，`BAT 3.7V`。
- 内置电源管理芯片：支持电池独立供电并可经 USB 充电。
- Pin Multiplexing 电源说明：
- `5V` 为 USB 口 5V 输出；也可作外部电压输入，但文档要求串联二极管（anode 接电池侧，cathode 接 5V pin）。
- `3V3` 为板载稳压输出，文档写可拉取 `700mA`。
- 电池焊接说明：建议 3.7V 可充电锂电池；负极焊盘在靠近丝印 `D8` 一侧，正极在靠近丝印 `D5` 一侧。
- 电池供电限制（caution）：仅电池供电时 5V 引脚无电压输出。
- 电池电压采样方案：
- 需外加 `200k` 电阻形成 `1:2` 分压。
- 通过 `A0` 读取 `analogReadMilliVolts(A0)`，16 次平均后按 2 倍换算电池电压。

## Sleep_&_Wakeup
- 功耗指标（Typ., 3.8V 供电）：
- Modem-sleep: `30 mA`
- Light-sleep: `3.1 mA`
- Deep Sleep: `15 μA`
- Demo1（外部唤醒）：使用 `GPIO0` 位掩码与 `esp_sleep_enable_ext1_wakeup(..., ESP_EXT1_WAKEUP_ANY_HIGH)`。
- Demo2（定时器唤醒）：`esp_sleep_enable_timer_wakeup(...)`，示例 `TIME_TO_SLEEP=5` 秒。
- 唤醒原因读取：`esp_sleep_get_wakeup_cause()`。
- 文档说明：若深睡未配置唤醒源，设备会一直睡眠直到硬件复位。

## Bootloader_Mode
- 文档给出的进入步骤：
1. 按住 `BOOT` 不放。
2. 保持按住 `BOOT`，连接数据线到电脑。
3. 连接后松开 `BOOT`，再上传 Blink 程序验证。
- 文档还给出另一种组合方式：上电时按住 BOOT，再按一次 Reset，也可进入 BootLoader。
- 触发场景：连电脑无端口，或端口存在但上传失败。

## Low_Power_Usage
- 深睡相关 API（文档示例）：
- `esp_sleep_enable_ext1_wakeup(...)`
- `esp_sleep_enable_timer_wakeup(...)`
- `esp_sleep_get_wakeup_cause()`
- `esp_deep_sleep_start()`
- 文档示例说明深睡时：CPU、绝大多数 RAM 与 APB 时钟数字外设会下电；RTC controller / RTC peripherals / RTC memories 可保持。
- 计数示例使用 `RTC_DATA_ATTR` 变量跨重启保存。
- 提供了可选电源域配置示例（注释行）：`esp_deep_sleep_pd_config(ESP_PD_DOMAIN_RTC_PERIPH, ESP_PD_OPTION_OFF)`。
- 若需更多低功耗与唤醒场景，文档 tip 建议直接使用 Arduino IDE 中 ESP 官方样例。

## Source_Files
- Wiki: [Getting Started with Seeed Studio XIAO ESP32C6](https://wiki.seeedstudio.com/xiao_esp32c6_getting_started/)
- Wiki: [Pin Multiplexing With Seeed Studio XIAO ESP32C6](https://wiki.seeedstudio.com/xiao_pin_multiplexing_esp32c6/)
- Datasheet: [Espressif ESP32-C6 Datasheet](https://files.seeedstudio.com/wiki/SeeedStudio-XIAO-ESP32C6/res/esp32-c6_datasheet_en.pdf)
- Schematic: [XIAO ESP32-C6 Schematic](https://files.seeedstudio.com/wiki/SeeedStudio-XIAO-ESP32C6/XIAO_ESP32_C6_v1.0_SCH_260114.pdf)
