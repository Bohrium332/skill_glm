# XIAO ESP32-C5 Structured Extraction

## Device_Name
- Seeed Studio XIAO ESP32-C5

## MCU_Core
- ESP32-C5
- 32-bit RISC-V 单核
- 主频最高 240 MHz

## Memory
- 规格表：8 MB PSRAM + 8 MB Flash
- Features 段：384 KB on-chip SRAM + 320 KB ROM

## Communication_Interfaces
- 无线：
- 2.4 GHz / 5 GHz 双频 Wi‑Fi 6（IEEE 802.11 a/b/g/n/ac/ax）
- Bluetooth 5 (LE)；并在 Features 中提到 Bluetooth mesh
- 有线/串行与总线：
- 1×I2C, 1×SPI, 2×UART（文档摘要与 Features 一致）
- 两路硬件串口接口在 Pin Multiplexing 中写明为：`USB Serial` + `UART1 Serial`
- UART1 默认引脚：`RX=D7(GPIO12)`, `TX=D6(GPIO11)`
- 软串口（软件模拟）示例引脚：`RX=D2`, `TX=D1`（非硬件 UART）

## Pin_Mapping

### D0-D10 映射（来自 Getting Started Pin Map）

| Pin | GPIO | 默认/主功能 | 复用功能（文档列出） | PWM | ADC | I2C | SPI | UART |
|---|---|---|---|---|---|---|---|---|
| D0 | GPIO1 | Analog | LP_UART_DSRN, LP_GPIO1 | 支持（文档写 D0~D10 为数字功能，另有 PWM 段说明） | 是（GPIO, ADC） | 否 | 否 | 否 |
| D1 | GPIO0 | GPIO | LP_UART_DTRN, LP_GPIO0 | 支持 | 文档未标明 | 否 | 否 | 否 |
| D2 | GPIO25 | GPIO | 文档未列出 | 支持 | 文档未标明 | 否 | 否 | 否 |
| D3 | GPIO7 | GPIO | SDIO_DATA1 | 支持 | 文档未标明 | 否 | 否 | 否 |
| D4 | GPIO23 | SDA | 文档未列出 | 支持 | 文档未标明 | 是（SDA） | 否 | 否 |
| D5 | GPIO24 | SCL | 文档未列出 | 支持 | 文档未标明 | 是（SCL） | 否 | 否 |
| D6 | GPIO11 | TX | 文档未列出 | 支持 | 文档未标明 | 否 | 否 | 是（TX） |
| D7 | GPIO12 | RX | 文档未列出 | 支持 | 文档未标明 | 否 | 否 | 是（RX） |
| D8 | GPIO8 | SCK | TOUCH7 | 支持 | 文档未标明 | 否 | 是（SCK） | 否 |
| D9 | GPIO9 | MISO | TOUCH8 | 支持 | 文档未标明 | 否 | 是（MISO） | 否 |
| D10 | GPIO10 | MOSI | TOUCH9 | 支持 | 文档未标明 | 否 | 是（MOSI） | 否 |

### A0-A10 映射（按文档可证据化信息）

| Analog Pin | 对应 GPIO | 说明 |
|---|---|---|
| A0 | 文档未明确给出 | 文档示例使用 A0 进行 `analogRead`，但未在文本中给出 A0→GPIO 映射表 |
| A1 | 文档未明确给出 | 文档仅说明 A0~A5 支持模拟读取 |
| A2 | 文档未明确给出 | 文档仅说明 A0~A5 支持模拟读取 |
| A3 | 文档未明确给出 | 文档仅说明 A0~A5 支持模拟读取 |
| A4 | 文档未明确给出 | 文档仅说明 A0~A5 支持模拟读取 |
| A5 | 文档未明确给出 | 文档仅说明 A0~A5 支持模拟读取 |
| A6 | 文档未提及 | 文档未给出 A6 信息 |
| A7 | 文档未提及 | 文档未给出 A7 信息 |
| A8 | 文档未提及 | 文档未给出 A8 信息 |
| A9 | 文档未提及 | 文档未给出 A9 信息 |
| A10 | 文档未提及 | 文档未给出 A10 信息 |

### 额外与 ADC/调试相关引脚（非 D0-D10）

| 信号 | GPIO | 描述 |
|---|---|---|
| MTDI | GPIO3 | JTAG, ADC |
| MTCK | GPIO4 | JTAG, ADC |
| MTMS | GPIO2 | JTAG, ADC |
| MTDO | GPIO5 | JTAG |
| ADC_BAT | GPIO6 | 读取电池电压 |
| ADC_CRL | GPIO26 | 控制电池电压测量电路使能（省电） |

## Critical_IO_Gotchas (极其重要)
- 深睡相关：
- 文档明确支持 GPIO 唤醒与定时器唤醒；并建议低功耗开发时保留 JTAG（MTMS/MTDI/MTCK/MTDO）用于调试和固件烧录，不要作为深睡唤醒源。
- 深睡后串口端口会消失，需先唤醒板子才能再次看到端口。
- 示例中 D0 用于 GPIO 唤醒，且说明硬件支持高电平/低电平两种触发配置。
- 电池与测量相关：
- 电池焊接时注意防止正负极短路。
- 电池电压读取需先拉高 `BAT_VOLT_PIN_EN`（GPIO26）再读取 `BAT_VOLT_PIN`（GPIO6）。
- 电池检测电路为 1:2 分压（两颗 100K），示例用 16 次采样平均抑制噪声。
- 连接与使用相关：
- 部分 USB-C 线仅供电不传数据。
- 若按键/LED 实验无响应，文档建议先按板载 RESET 进行唤醒。
- 文档未给出 Strapping Pins 列表与启动电平限制。
- 原文信息差异（需注意）：
- Pin Multiplexing 写“PWM: D0~D11”，但同文档其它位置与 Pin Map 主要展示 D0~D10。
- Pin Multiplexing 写“A0~A5 可模拟读取”，而规格/Features 写“5×ADC channels”；A 引脚到 GPIO 的完整映射表未在这两份文档中给出。

## LED_Status
- 规格表写明板载 LED：Charge / USER LED。
- Getting Started 明确：`LED_BUILTIN` 对应开发板上的 `L LED`。
- Pin Map 给出：
- `USER_LED` -> GPIO27（User Light_Yellow）
- `CHARGE_LED` -> VCC_3V3（CHG-LED_Red）
- 电池供电说明中写明：电池供电时 `C LED` 会亮起，可据此判断充电管理状态。

## Power_&_Battery
- 供电引脚（Pin Map）：
- `5V(VBUS)`：Power Input/Output
- `3V3(3V3_OUT)`：Power Output
- 电池：
- 支持 3.7V 锂电池输入。
- 文档未给出 5V/3V3 引脚的最大输出电流限制数值。
- 电池电压读取方案（文档给出）：
- 芯片：SGM40567（充电管理）+ TPS22916CYFPR（电压采集通路）
- 使能与采样引脚：`BAT_VOLT_PIN_EN = GPIO26`，`BAT_VOLT_PIN = GPIO6`
- 测量流程：使能 EN -> `analogReadMilliVolts(BAT_VOLT_PIN)` -> 16 次平均 -> 按 1:2 分压换算
- 换算示例：`Vbatt = 2 * Vbatt_sum / 16 / 1000.0`
- 文档提示测量范围参考：0~3300 mV（ADC 有效测量范围）

## Sleep_&_Wakeup
- 深度休眠电流：文档未提及具体数值。
- 支持的唤醒类型：GPIO wake-up、timer wake-up。
- GPIO 唤醒具体引脚：文档未给出完整可用引脚清单；示例使用 `D0`。
- 触发电平：示例配置为高电平触发，并明确说明硬件支持高/低电平触发可配置。
- 低功耗开发建议：JTAG 引脚（MTMS/MTDI/MTCK/MTDO）建议保留，不作为唤醒源。

## Bootloader_Mode
- Pin Map 仅注明 `Boot` 对应 GPIO28，功能为 “Enter Boot Mode”。
- 这两份文档未提供“按键顺序/步骤”形式的物理进入 Bootloader/Download 模式操作说明。

## Low_Power_Usage
- 文档示例中的核心 C/C++ API 与参数样例：
- 唤醒原因检测：
- `esp_sleep_wakeup_cause_t wakeup_reason = esp_sleep_get_wakeup_cause();`
- 唤醒引脚 GPIO 模式配置（在唤醒配置前）：
- `pinMode(WAKEUP_PIN, INPUT_PULLUP);`
- 原文示例使用 `INPUT_PULLUP` + 高电平触发；文档同时说明硬件支持高/低电平触发可配置。
- 若切换为低电平触发，输入上下拉应与触发方向匹配（常见对应为 `INPUT_PULLDOWN`）。
- GPIO 唤醒配置：
- `uint64_t mask = 1ULL << WAKEUP_PIN;`
- `esp_deep_sleep_enable_gpio_wakeup(mask, ESP_GPIO_WAKEUP_GPIO_HIGH);`
- 其中 `WAKEUP_PIN` 示例为 `D0`，触发电平参数为 `ESP_GPIO_WAKEUP_GPIO_HIGH`
- 进入深度休眠：
- `esp_deep_sleep_start();`

## Source_Files
- Wiki: [Getting Started with Seeed Studio XIAO ESP32-C5](https://wiki.seeedstudio.com/xiao_esp32c5_getting_started/)
- Wiki: [Pin Multiplexing with Seeed Studio XIAO ESP32-C5](https://wiki.seeedstudio.com/xiao_esp32c5_pin_multiplexing/)
- Datasheet: [Espressif ESP32-C5 Datasheet](https://files.seeedstudio.com/wiki/XIAO_ESP32C5/res/esp32-c5_datasheet_en.pdf)
- Schematic: [XIAO ESP32-C5 Schematic](https://files.seeedstudio.com/wiki/XIAO_ESP32C5/res/Seeed_Studio_XIAO_ESP32C5.pdf)
