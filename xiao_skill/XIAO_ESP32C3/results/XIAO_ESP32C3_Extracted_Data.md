# XIAO ESP32C3 Structured Extraction

## Device_Name
- Seeed Studio XIAO ESP32C3

## MCU_Core
- ESP32-C3 SoC
- 32-bit RISC-V 单核（四级流水线）
- 最高 160 MHz

## Memory
- 400KB SRAM
- 4MB Flash

## Communication_Interfaces
- 无线：
- Wi-Fi（IEEE 802.11 b/g/n）
- Bluetooth LE 5.0 / Bluetooth Mesh（文档前文也写作 Bluetooth 5 BLE）
- 串行与总线（按原文）：
- 规格表：1x UART, 1x IIC, 1x SPI
- Features 段：2x UART
- Pin Multiplexing 段：支持 UART / I2C / SPI / I2S
- 常规方式：可选择 USB Serial 或 UART0
- UART0 默认引脚：D6(TX), D7(RX)
- Special way 章节给出三路串口同时可用示例：USB Serial + UART0 + UART1，并明确写到 “actually has three UARTs available”
- UART1：可通过 `HardwareSerial MySerial1(1)` 显式初始化并映射到 D9(RX/GPIO9)、D10(TX/GPIO10)
- “无 Serial2”语境：原文是没有可直接使用的 `Serial2` 变量名；并非 UART1 硬件不可用
- 默认引脚：
- UART0：D6(TX), D7(RX)
- UART1（显式映射）：D9(RX), D10(TX)
- I2C：D4(SDA), D5(SCL)
- SPI：D8(SCK), D9(MISO), D10(MOSI)

## Pin_Mapping

| XIAO Pin | GPIO | PWM | ADC | 默认功能 |
|---|---|---|---|---|
| D0 | GPIO2 | 是 | 是（A0 / ADC1_CH2） | GPIO；Strapping Pin |
| D1 | GPIO3 | 是 | 是（A1 / ADC1_CH3） | GPIO；低功耗示例中作唤醒脚 |
| D2 | GPIO4 | 是 | 是（A2 / ADC1_CH4） | GPIO |
| D3 | GPIO5 | 是 | 是（A3 / ADC2_CH0） | GPIO；A3 对应 ADC2（不建议可靠模拟采样） |
| D4 | GPIO6 | 是 | 否（文档映射未标 ADC） | I2C SDA |
| D5 | GPIO7 | 是 | 否（文档映射未标 ADC） | I2C SCL |
| D6 | GPIO21 | 是 | 否（文档映射未标 ADC） | UART TX |
| D7 | GPIO20 | 是 | 否（文档映射未标 ADC） | UART RX |
| D8 | GPIO8 | 是 | 否（文档映射未标 ADC） | SPI SCK；Strapping Pin |
| D9 | GPIO9 | 是 | 否（文档映射未标 ADC） | SPI MISO；BOOT 相关；Strapping Pin |
| D10 | GPIO10 | 是 | 否（文档映射未标 ADC） | SPI MOSI |

## Critical_IO_Gotchas (极其重要)
- A3（D3/GPIO5）：
- 使用 ADC2，文档说明可能因错误采样信号导致不可用。
- 可靠模拟读取建议使用 ADC1（A0/A1/A2）。
- D6（GPIO21/U0TXD）：
- 启动时默认 UART 输出；若当输入使用可能产生高电流。
- 建议仅输出使用。
- 待机不通信时常为 HIGH；上电后会出现 bootloader 文本导致高低电平翻转。
- D8（GPIO8）：
- 下载模式（按 BOOT）时 GPIO8 必须为 HIGH。
- 文档引用：GPIO8=0 且 GPIO9=0 组合无效并可能触发异常行为。
- 若使用下载模式，需加上拉电阻保证 GPIO8 启动时高电平。
- D9（GPIO9）：
- 连接 BOOT 按键和上拉电阻 R6。
- 按下 BOOT 会把 D9 拉到 GND。
- 文档建议 D9 更适合作开关输入。
- Strapping Pin 总体注意：
- GPIO2(D0)、GPIO8(D8)、GPIO9(D9) 为 Strapping Pins。
- 启动时电平会影响启动模式，错误配置可能导致无法上传或无法正常运行程序。
- ADC 量程提示（Pin Multiplexing tip）：ADC 映射范围为 `0~2500mV`，并非 `0~3300mV`。
- 软串口库版本提示（Pin Multiplexing tip）：推荐 `EspSoftwareSerial 7.0.0`*(⚠️ 维护注记：此版本号基于建档时的官方 Wiki。AI 在生成代码时，请务必提醒用户核实 Seeed 官方是否有更新的版本。)*；其他版本可能导致软串口工作异常。

## LED_Status
- 文档示例指出：XIAO ESP32C3 没有可直接使用的 `LED_BUILTIN`。
- Blink 示例使用外接 LED（接 D10）。
- Pin Map 中有 `Light -> CHG-LED`（充电指示灯相关）。
- 电池供电时，文档说明默认不会有 LED 亮（除非程序主动控制）。

## Power_&_Battery
- 电源参数（原文）：
- Max 3.3V Output Current: 500mA（规格表）
- Source Capability: 3A
- Charging current: 380mA(Fast) / 40mA(Trickle)
- Input voltage (VIN): 5V
- Input voltage (BAT): 3.7V
- Power Pins 说明：
- 5V：USB 5V 输出；也可作输入，但需串联二极管（阳极接电池，阴极接 5V 引脚）。
- 3V3：板载稳压输出（Power Pins 段写可取 700mA，与规格表 500mA 存在原文差异）。
- 电池电压读取建议方案（文档给法）：
- 电池经 200k 分压到 1/2 后接 A0。
- 通过 `analogReadMilliVolts(A0)` 读取校准后的毫伏值。
- 建议 16 次采样平均，减小通信期间尖峰误差。
- 示例换算：`Vbatt = 2 * (average_mV) / 1000`。

## Sleep_&_Wakeup
- 深度休眠电流：
- 规格表：44 uA
- Features 段：约 43uA（原文两处数值存在差异）
- 唤醒方式与引脚：
- 支持 GPIO 唤醒、定时器唤醒。
- 文档明确支持 GPIO 唤醒的引脚为 D0~D3。
- 示例中使用 D1 低电平唤醒。

## Bootloader_Mode
- 物理进入 bootloader 的操作：
- 先尝试按一次 RESET（板子已连接 PC）。
- 若无效，按住 BOOT 键连接到 PC，随后松开 BOOT，进入 bootloader mode。

## Low_Power_Usage (低功耗使用说明)
- 唤醒原因检测核心 API：
- `esp_sleep_get_wakeup_cause()`
- GPIO 唤醒配置函数及电平参数（示例）：
- `esp_deep_sleep_enable_gpio_wakeup(BIT(D1), ESP_GPIO_WAKEUP_GPIO_LOW);`
- 进入深度休眠指令：
- `esp_deep_sleep_start();`

## Source_Files
- Wiki: [Getting Started with Seeed Studio XIAO ESP32C3](https://wiki.seeedstudio.com/XIAO_ESP32C3_Getting_Started/)
- Wiki: [Pin Multiplexing](https://wiki.seeedstudio.com/XIAO_ESP32C3_Pin_Multiplexing/)
- Datasheet: [Espressif ESP32-C3 Datasheet](https://files.seeedstudio.com/wiki/XIAO_WiFi/Resources/esp32-c3_datasheet.pdf)
- Schematic: [XIAO ESP32-C3 Schematic](https://files.seeedstudio.com/wiki/XIAO_WiFi/Resources/XIAO_ESP32C3_v1.3_SCH_260116.pdf)
