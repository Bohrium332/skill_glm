# XIAO nRF52840 Structured Extraction

## Device_Name
- Seeed Studio XIAO nRF52840
- Seeed Studio XIAO nRF52840 Sense（同系列，额外带 6 轴 IMU（LSM6DS3TR-C）与 PDM 麦克风（MSM261D3526H1CPM））

## MCU_Core
- Nordic nRF52840
- ARM Cortex-M4 32-bit（with FPU）
- 主频 64 MHz

## Memory
- RAM: 256 KB（Specifications comparison）
- Flash: 1 MB 片内 Flash + 2 MB 板载 Flash（Specifications comparison 原文为 `1MB Flash 2MB onboard Flash`）

## Communication_Interfaces
- 无线：
- Bluetooth Low Energy（原文存在版本表述差异：Introduction 段写 Bluetooth 5.0；Specifications comparison 行写 BLE 5.4）
- NFC（板上功能与引脚均给出）
- 有线/片上接口（针对 nRF52840 / nRF52840 Sense，非 Plus）：
- UART x1
- I2C x1
- SPI x1
- SWD x1
- GPIO(PWM) x11
- ADC x6
- D0-D10 默认总线引脚：
- I2C: `D4(P0.04)=SDA`, `D5(P0.05)=SCL`
- UART: `D6(P1.11)=TX`, `D7(P1.12)=RX`
- SPI: `D8(P1.13)=SCK`, `D9(P1.14)=MISO`, `D10(P1.15)=MOSI`
- 其他接口：
- NFC: `NFC1(P0.09)`, `NFC2(P0.10)`
- Sense 传感器能力边界（IMU/PDM usage 文档）：
- `XIAO nRF52840 Sense` 具备 6 轴 IMU（LSM6DS3TR-C）与 PDM 麦克风（MSM261D3526H1CPM）；`XIAO nRF52840`（非 Sense）不具备这两个模块。
- Sense 传感器使用路径（Arduino）：
- IMU：安装 `Seeed_Arduino_LSM6DS3` 库后，使用示例 `File > Examples > Accelerometer And Gyroscope LSM6DS3 > HighLevelExample`，上传后打开 `Serial Monitor` 查看加速度/陀螺仪/温度数据。
- PDM（Raw Data）：安装 `Seeed_Arduino_Mic` 库后，使用 `File > Examples > Seeed Arduino Mic > mic_serial_plotter`，上传后先打开 `Serial Monitor`，再用 `Tools > Serial Plotter` 观察波形。
- PDM（录音到 SD）：在 `Seeed_Arduino_Mic` 基础上安装 `Seeed_Arduino_FS`，使用 `mic_Saved_OnSDcard` 示例；可用 XIAO Expansion Board 的 SD 卡槽，或通过 SPI 外接 SD 模块。
- 函数级 API 说明边界：当前 IMU/PDM usage 文档主要提供“库安装 + 示例工程路径 + 运行步骤”，未给出具体函数名调用链。

## Pin_Mapping

### D0-D10 映射（基于 nRF52840 / Sense Pin Map）

| Pin | GPIO(Chip Pin) | PWM | ADC | I2C | SPI | UART | 文档复用/说明 |
|---|---|---|---|---|---|---|---|
| D0 | P0.02 | 是（11 digital I/O 可作 PWM） | 是（AIN0） | 否 | 否 | 否 | Function: Analog |
| D1 | P0.03 | 是 | 是（AIN1） | 否 | 否 | 否 | Function: Analog |
| D2 | P0.28 | 是 | 是（AIN4） | 否 | 否 | 否 | Function: Analog |
| D3 | P0.29 | 是 | 是（AIN5） | 否 | 否 | 否 | Function: Analog |
| D4 | P0.04 | 是 | 是（AIN2） | 是（SDA） | 否 | 否 | Function: Analog,SDA |
| D5 | P0.05 | 是 | 是（AIN3） | 是（SCL） | 否 | 否 | Function: Analog,SCL |
| D6 | P1.11 | 是 | 否（Pin Map 未标 ADC） | 否 | 否 | 是（TX） | Function: TX |
| D7 | P1.12 | 是 | 否（Pin Map 未标 ADC） | 否 | 否 | 是（RX） | Function: RX |
| D8 | P1.13 | 是 | 否（Pin Map 未标 ADC） | 否 | 是（SCK） | 否 | Function: SPI_SCK |
| D9 | P1.14 | 是 | 否（Pin Map 未标 ADC） | 否 | 是（MISO） | 否 | Function: SPI_MISO |
| D10 | P1.15 | 是 | 否（Pin Map 未标 ADC） | 否 | 是（MOSI） | 否 | Function: SPI_MOSI |

### Sense 内置传感器相关引脚（Pin Map，适用于 nRF52840 Sense）

| 信号 | GPIO(Chip Pin) | 说明 |
|---|---|---|
| 6 DOF IMU_PWR | P1.08 | 6 轴 IMU 模块电源开关（power switch of the 6D module） |
| 6 DOF IMU__INT1 | P0.11 | 6 轴 IMU 中断信号引脚 |
| PDM Microphone_DATA | P0.16 | PDM 音频数据输入 |
| PDM Microphone_CLK | P1.00 | PDM 音频时钟输出 |

### A0-A10 映射（仅基于文档证据）

| Analog Pin | 对应 GPIO | 依据与说明 |
|---|---|---|
| A0 | P0.02（对应 D0） | Pin Map 中 D0 为 Analog，Arduino Name 为 0 |
| A1 | P0.03（对应 D1） | Pin Map 中 D1 为 Analog，Arduino Name 为 1 |
| A2 | P0.28（对应 D2） | Pin Map 中 D2 为 Analog，Arduino Name 为 2 |
| A3 | P0.29（对应 D3） | Pin Map 中 D3 为 Analog，Arduino Name 为 3 |
| A4 | P0.04（对应 D4） | Pin Map 中 D4 为 Analog,SDA，Arduino Name 为 4 |
| A5 | P0.05（对应 D5） | Pin Multiplexing 示例写“接到 A5”，代码用 `sensorPin=5`（对应 D5） |
| A6 | 文档未提及 | 文档未给出 A6 |
| A7 | 文档未提及 | 文档未给出 A7 |
| A8 | 文档未提及 | 文档未给出 A8 |
| A9 | 文档未提及 | 文档未给出 A9 |
| A10 | 文档未提及 | 文档未给出 A10 |

### ADC/DAC 分辨率与 API

- ADC：
- 文档说明有 6 路 ADC（AIN0~AIN5 对应 D0~D5）。
- 示例 API：`analogRead(...)`。
- PWM：
- 文档说明 11 路数字 IO 可用作 PWM。
- 示例 API：`analogWrite(...)`，示例占空比范围 `0~255`。
- 文档未给出：
- `analogReadResolution(...)`
- `analogWriteResolution(...)`
- DAC：文档未提及 DAC 引脚或 DAC 分辨率/API。

## Critical_IO_Gotchas (极其重要)
- LED 逻辑反相：板载 3-in-1 LED 为共阳，`LOW` 点亮、`HIGH` 熄灭。
- 双库差异提示（tip）：
- `Seeed nRF52 Boards` 下 `Serial` 可能编译失败，需加 `#include <Adafruit_TinyUSB.h>`。
- 若使用 `Seeed nRF52 mbed-enabled Boards`，`Serial` 编译通常无需额外修改。
- 引脚定义差异：文档明确两套库的 pin definition 可能不同。
- IMU/PDM 使用文档与主文档共同建议：IMU 与 PDM 功能更推荐 `Seeed nRF52 mbed-enabled Boards`；若偏向蓝牙与低功耗验证，主文档建议 `Seeed nRF52 Boards`。
- USB 线材提示（tip）：部分 Type-C 线仅供电不传数据。
- 电池充电电流控制：`P0_13` 高/低电平切换 50mA / 100mA 充电电流。
- 电池充电风险（FAQ Q3）：
- 文档指出当 `P0.14`（文中写 `D14`）关闭 ADC 并被拉高至 3.3V 时，`P0.31` 可能接近其输入上限（3.6V），存在损坏风险。
- 官方建议充电时不要关闭 `P0.14` 的 ADC 功能，也不要将其置高。
- 深睡验证示例关键点：
- 代码把外部 Flash 发送 `0xB9`（deep power-down）后再 `sd_power_system_off()`。
- 若 deep power-down 检测失败，示例会点亮内置 LED 并停在循环中。
- 文档信息差异（需注意）：
- 本板 Pin Map 中 `P0.14` 标为 `ADC_BAT`，FAQ 文本同时写成 `D14`；命名存在混用。
- 同一 Getting Started 文档包含 Plus 与非 Plus 两套 Pin Map，提取时需区分板型。
- IMU/PDM 示例触发点：两份 usage 文档均强调上传后需手动打开 `Serial Monitor` 才开始执行/输出；PDM 重新采样需按一次 `Reset` 后再打开 `Serial Monitor`。

## LED_Status
- 板载 LED：3-in-1 User RGB + Charge LED。
- Pin Map：
- `USER_LED_R -> P0.26`
- `USER_LED_B -> P0.06`
- `USER_LED_G -> P0.30`
- `CHARGE_LED -> P0.17`（CHG-LED_Red）
- 逻辑说明：
- 用户 RGB LED：`LOW` 亮、`HIGH` 灭（共阳）。
- 充电指示（FAQ Q4）：
- `P0.17` 低电平：充电中（`RED_CHG` 亮）
- `P0.17` 高电平：未充电或已充满

## Power_&_Battery
- 支持锂电池充放电管理（Battery charging chip: BQ25101）。
- 低功耗特性描述：
- Features 写“Standby power consumption < 5μA”。
- 电池电压读取引脚：
- `ADC_BAT -> P0.14`（Read the BAT voltage value）
- 充电电流可配置：
- `P0_13 = HIGH`：50mA
- `P0_13 = LOW`：100mA
- 文档未提供：
- 电池电压换算公式/完整测量示例代码
- 5V/3.3V 输出电流上限数值

## Sleep_&_Wakeup
- 文档给出低功耗验证示例，最终进入系统关断：`sd_power_system_off()`。
- 示例还涉及外部 Flash deep power-down（`runCommand(0xB9)`）以降低功耗。
- 唤醒源、唤醒引脚、唤醒电平与具体唤醒流程：文档未明确给出。

## Bootloader_Mode
- 文档 FAQ 给出的进入方式：
1. 先按一次 `Reset` 尝试恢复。
2. 若无效，快速双击 `Reset` 进入 Bootloader 模式。
- 文档也给出 SWD/JLink 重新刷写 bootloader 的恢复流程（用于更深层恢复）。

## Low_Power_Usage
- 指标描述：
- Features：待机功耗小于 `5μA`。
- 文档“Power Consumption Verification”给出可运行示例与关键 API：
- `transport.runCommand(0xB9)`（Flash deep power-down）
- `sd_power_system_off()`（系统关断）
- `Bluefruit.begin()`（示例初始化）
- 文档建议该验证优先使用 `Seeed nRF52 Boards` 库。

## Source_Files
- Wiki: [Getting Started with Seeed Studio XIAO nRF52840 Series](https://wiki.seeedstudio.com/XIAO_BLE/)
- Wiki: [Pin Multiplexing on Seeed Studio XIAO nRF52840 (Sense)](https://wiki.seeedstudio.com/XIAO-BLE-Sense-Pin-Multiplexing/)
- Wiki: [IMU Usage for XIAO nRF52840 Sense](https://wiki.seeedstudio.com/XIAO-BLE-Sense-IMU-Usage/)
- Wiki: [PDM Usage for XIAO nRF52840 Sense](https://wiki.seeedstudio.com/XIAO-BLE-Sense-PDM-Usage/)
- Datasheet: [Nordic nRF52840 Datasheet](https://files.seeedstudio.com/wiki/XIAO-BLE/nRF52840_PS_v1.5.pdf)
- Datasheet: [IMU-LSM6DS3TR Datasheet](https://files.seeedstudio.com/wiki/XIAO-BLE/ST_LSM6DS3TR_Datasheet.pdf)
- Datasheet: [Mic-MSM261D3526H1CPM Datasheet](https://files.seeedstudio.com/wiki/XIAO-BLE/mic-MSM261D3526H1CPM-ENG.pdf)
- Datasheet: [Charger IC-BQ25101 Datasheet](https://files.seeedstudio.com/wiki/XIAO-BLE/BQ25101.pdf)
- Schematic: [XIAO nRF52840 Sense Schematic](https://files.seeedstudio.com/wiki/XIAO-BLE/Seeed_Studio_XIAO_nRF52840_PDF.pdf)
