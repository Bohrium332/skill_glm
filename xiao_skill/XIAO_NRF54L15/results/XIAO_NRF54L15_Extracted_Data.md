# XIAO nRF54L15 Structured Extraction

## Device_Name
- Seeed Studio XIAO nRF54L15
- Seeed Studio XIAO nRF54L15 Sense（Built-in Sensor 项为 `6 DOF IMU(LSM6DS3TR-C)` + `Microphone (MSM261DGT006)`；标准版 Built-in Sensor 为 `N/A`）

## MCU_Core
- Nordic nRF54L15
- Arm Cortex-M33，128 MHz
- RISC-V coprocessor（FLPR），128 MHz

## Memory
- NVM: 1.5 MB
- RAM: 256 KB

## Communication_Interfaces
- 无线（Specification/Features）：
- Bluetooth LE 6.0（including Channel Sounding）
- NFC
- Thread
- Zigbee
- Matter
- Amazon Sidewalk
- Proprietary 2.4 GHz protocols（up to 4 Mbps）
- 有线/片上接口（Pin Map + Features 可证据化）：
- I2C：2 组（`D4/D5` 为 `SDA-0/SCL-0`；`D11/D12` 为 `SCL-1/SDA-1`）
- UART：1 组（`D6/D7` 为 `TX/RX`）
- SPI：1 组（`D8/D9/D10` 为 `SPI_SCK/MISO/MOSI`）
- 调试：nRF54 与 SAMD11 的 SWD/JTAG 焊盘（Pin Map 列为 JTAG）
- 射频切换控制引脚（Pin Map）：
- `RF Switch Port Select -> P2.05`
- `RF Switch Power -> P2.03`
- Sense 内置传感器接口与使用路径（仅 XIAO nRF54L15 Sense）：
- IMU（`LSM6DS3TR-C`）：示例通过 `const struct device *const dev = DEVICE_DT_GET(DT_ALIAS(imu0));` 获取设备，并用 `sensor_sample_fetch_chan(...)` + `sensor_channel_get(...)` 读取 `SENSOR_CHAN_ACCEL_*`/`SENSOR_CHAN_GYRO_*`。
- IMU 采样频率配置：`sensor_attr_set(..., SENSOR_ATTR_SAMPLING_FREQUENCY, ...)`；示例设为 `12.5 Hz`，并支持 `sensor_trigger_set(...)` + `SENSOR_TRIG_DATA_READY` 触发模式。
- MIC（`MSM261DGT006`，DMIC/PDM）：示例通过 `DEVICE_DT_GET(DT_ALIAS(dmic20))` 获取设备，核心采集流程为 `dmic_configure(...) -> dmic_trigger(..., DMIC_TRIGGER_START) -> dmic_read(...) -> dmic_trigger(..., DMIC_TRIGGER_STOP)`。
- DMIC 示例关键参数：`SAMPLE_RATE_HZ=16000`、`SAMPLE_BIT_WIDTH=16`、`READ_TIMEOUT_MS=1000`、`CHUNK_DURATION_MS=100`、`CHUNK_SIZE_BYTES=3200`（由宏公式计算得到）。

## Pin_Mapping

### D0-D10 映射

| Pin | GPIO(Chip Pin) | PWM | ADC | I2C | SPI | UART | 文档复用/说明 |
|---|---|---|---|---|---|---|---|
| D0 | P1.04 | 示例明确可用于 PWM（`pwm20` 输出） | 是 | 否 | 否 | 否 | Function: Analog；Description: GPIO, ADC |
| D1 | P1.05 | 文档未给逐脚 PWM 能力表 | 是 | 否 | 否 | 否 | Function: Analog；Description: GPIO, ADC |
| D2 | P1.06 | 文档未给逐脚 PWM 能力表 | 是 | 否 | 否 | 否 | Function: Analog；Description: GPIO, ADC |
| D3 | P1.07 | 文档未给逐脚 PWM 能力表 | 是 | 否 | 否 | 否 | Function: Analog；Description: GPIO, ADC |
| D4 | P1.10 | 文档未给逐脚 PWM 能力表 | 否（Pin Map 未标 ADC） | 是（SDA-0） | 否 | 否 | Function: SDA-0；Description: GPIO, I2C Data |
| D5 | P1.11 | 文档未给逐脚 PWM 能力表 | 否（Pin Map 未标 ADC） | 是（SCL-0） | 否 | 否 | Function: SCL-0；Description: GPIO, I2C Clock |
| D6 | P2.08 | 文档未给逐脚 PWM 能力表 | 否（Pin Map 未标 ADC） | 否 | 否 | 是（TX） | Function: TX；Description: GPIO, UART Transmit |
| D7 | P2.07 | 文档未给逐脚 PWM 能力表 | 否（Pin Map 未标 ADC） | 否 | 否 | 是（RX） | Function: RX；Description: GPIO, UART Receive |
| D8 | P2.01 | 文档未给逐脚 PWM 能力表 | 否（Pin Map 未标 ADC） | 否 | 是（SCK） | 否 | Function: SPI_SCK；Description: GPIO, SPI Clock |
| D9 | P2.04 | 文档未给逐脚 PWM 能力表 | 否（Pin Map 未标 ADC） | 否 | 是（MISO） | 否 | Function: SPI_MISO；Description: GPIO, SPI Data |
| D10 | P2.02 | 文档未给逐脚 PWM 能力表 | 否（Pin Map 未标 ADC） | 否 | 是（MOSI） | 否 | Function: SPI_MOSI；Description: GPIO, SPI Data |

### D11-D15 映射（Pin Map 补充）

| Pin | GPIO(Chip Pin) | 说明 |
|---|---|---|
| D11 | P0.03 | SCL-1，I2C |
| D12 | P0.04 | SDA-1，I2C |
| D13 | P2.10 | GPIO |
| D14 | P2.09 | GPIO |
| D15 | P2.06 | GPIO |

### 板载功能键映射（Pin Map）

| Item | GPIO(Chip Pin) | 说明 |
|---|---|---|
| User Key (SW0) | P0.00 | 板载用户可编程按键；无线切换示例用此键切换内置/外置天线 |

### Sense 传感器使用别名与触发链路（Built-in-Sensor / Getting-Started 示例）

| Item | Devicetree 别名/节点 | 说明 |
|---|---|---|
| IMU 设备 | `DT_ALIAS(imu0)` | `DEVICE_DT_GET(...)` 获取 IMU 设备；需先通过 `device_is_ready(dev)` 检查，再读取加速度/陀螺仪数据 |
| DMIC 设备 | `DT_ALIAS(dmic20)`（示例句柄 `dmic_dev`） | 用于 `dmic_configure` / `dmic_trigger` / `dmic_read` 录音链路 |
| 录音触发按键 | `DT_ALIAS(sw0)` | `gpio_pin_interrupt_configure_dt(..., GPIO_INT_EDGE_TO_ACTIVE)` 配置中断，`k_sem_take(&button_sem, K_FOREVER)` 等待按键触发 |
| 状态指示灯 | `DT_ALIAS(led0)` | 录音流程里通过 `gpio_pin_set_dt(&led, 0/1)` 切换状态 |
| DMIC 声道映射 | `dmic_build_channel_map(0, 0, PDM_CHAN_LEFT)` | 代码将 `req_chan_map_lo` 配置为左声道映射（单通道） |
| 天线切换示例别名 | `SW0_NODE=DT_ALIAS(sw0)`、`LED0_NODE=DT_ALIAS(led0)` | `SW0` 按键切换内置/外置天线，LED 指示当前天线状态 |

### A0-A10 映射（仅保留文档可证据化信息）

| Analog Pin | 对应 GPIO | 依据与说明 |
|---|---|---|
| A0 | 文档未明确 | 文档只给出 D0-D3 为 Analog，未给 Arduino `A0` 命名映射表 |
| A1 | 文档未明确 | 同上 |
| A2 | 文档未明确 | 同上 |
| A3 | 文档未明确 | 同上 |
| A4 | 文档未提及 | 文档未给出 A4 |
| A5 | 文档未提及 | 文档未给出 A5 |
| A6 | 文档未提及 | 文档未给出 A6 |
| A7 | 文档未明确（存在 `AIN7_VBAT -> P1.14`） | `AIN7_VBAT` 被定义为电池采样通道，未声明其等同 Arduino `A7` |
| A8 | 文档未提及 | 文档未给出 A8 |
| A9 | 文档未提及 | 文档未给出 A9 |
| A10 | 文档未提及 | 文档未给出 A10 |

### ADC/DAC 分辨率与 API（原文可提取）

- ADC：
- 规格/Features 明确为 `14-bit ADC`。
- 示例 API：`adc_channel_setup_dt(...)`、`adc_read_dt(...)`/`adc_read(...)`、`adc_sequence_init_dt(...)`、`adc_raw_to_millivolts_dt(...)`。
- PWM：
- 示例 API：`pwm_set_dt(...)`。
- 示例周期：`PWM_PERIOD_NS = 1000000UL`（约 1 kHz）。
- 文档未给出：
- `analogReadResolution(...)`
- `analogWriteResolution(...)`
- DAC：两份文档未提及 DAC 引脚或 DAC 分辨率。

## Critical_IO_Gotchas (极其重要)
- Pin Multiplexing 文档明确所有示例默认基于 PlatformIO；若迁移到 nRF Connect SDK，需要添加 `app.overlay` 并修改 `prj.conf`。
- Built-in-Sensor 文档同样给出相同前置条件：示例默认按 PlatformIO 组织；迁移到 nRF Connect SDK 需补 `app.overlay` 并调整 `prj.conf`。
- Sense 传感器 Kconfig 必选项（Getting Started 的 `prj.conf`）：IMU 依赖 `CONFIG_SENSOR=y`；DMIC 依赖 `CONFIG_AUDIO=y` + `CONFIG_AUDIO_DMIC=y`。缺少上述配置时，对应驱动不会参与编译，相关 API 调用会出现不可用/链接失败。
- Getting Started 的 note 指出 Toolchain 与 nRF Connect SDK 版本应为 `3.0.1`*(⚠️ 维护注记：此版本号基于建档时的官方 Wiki。AI 在生成代码时，请务必提醒用户核实 Seeed 官方是否有更新的版本。)* 或以上。
- Reset 键是硬复位，仅重启程序，不会擦除已烧录固件。
- User Key（SW0）引脚映射为 `P0.00`；该按键是可编程输入，天线切换示例通过它在内置/外置天线间切换。
- `west flash` 失败的 tip：可能与 VS Code 的 CMake 插件冲突，文档建议移除该插件。
- 无线天线切换示例中，默认天线由 `CONFIG_DEFAULT_ANTENNA_EXTERNAL` 控制；按 `SW0` 在陶瓷/外置天线切换；USER LED 显示当前天线状态。
- J-Link 相关 tip：需使用最新版本 J-Link 才支持 nRF54L15。
- 电池焊接 caution：严禁电池正负极短路，避免烧毁电池和设备。
- 电池供电启动陷阱（v1.0 硬件）：文档提示仅电池供电时可能因 UART 配置导致启动失败，建议区分“USB 调试配置（UART 开）”和“电池部署配置（UART 关）”。
- 电池采样使能路径（关键）：先 `regulator_enable(vbat_reg)` 打开 `vbat_pwr`，采样后 `regulator_disable(vbat_reg)`，避免持续导通造成额外耗电。
- DMIC 录音示例是“按键触发”流程：日志提示 `Press button SW0 to start recording...`，每次按键后才开始一次录音。
- PC 侧接收 WAV 依赖 `pyserial`，文档命令为 `python3 -m pip install pyserial` 和 `python record.py -p <serial_port> -o output.wav -b 921600`；其中串口名必须替换为本机端口。

## LED_Status
- `USER_LED -> P2.00`（Pin Map: User Light）
- `CHARGE_LED -> charge_LED`（Pin Map: CHG-LED_Red）
- Blinky 示例通过 `DT_ALIAS(led0)` 控制板载 LED 闪烁。
- 天线切换示例中 LED 作为状态指示灯，代码注释明确“set 0 for on”（低电平点亮语义）。
- 文档提示：仅电池供电时默认不会亮 LED（除非程序主动控制）。

## Power_&_Battery
- 供电方式：USB Type-C；内置 PMIC 支持锂电池供电和相关管理。
- 供电电压范围：`3.7V ~ 5V`。
- 电池使用说明：建议使用合规 3.7V 可充电锂电池，焊接时需区分正负极。
- 文档说明可在接电池同时接数据线，板上有保护电路。
- 电池电压采样通道：`AIN7_VBAT -> P1.14`。
- 电池采样链路：通过 TPS22916CYFPR 负载开关按需接通分压采样路径。
- 示例流程：`regulator_enable(...) -> k_sleep(100ms) -> ADC 采样 -> adc_raw_to_millivolts_dt(...) -> 打印 val_mv * 2 -> regulator_disable(...)`。
- 文档未给出 5V/3.3V 最大输出电流数值。

## Sleep_&_Wakeup
- Features 明确提到 Global RTC 在 `System OFF` 模式可用。
- overlay 示例中 `pwm20_sleep` 含 `low-power-enable`，体现休眠态引脚配置思路。
- 两份文档未提供完整的睡眠进入 API、唤醒源清单、唤醒引脚与触发电平配置步骤。

## Bootloader_Mode
- 两份文档未给出“按键进入 Bootloader”的标准物理步骤。
- 文档提供的恢复/烧录路径：
- Reset 键执行硬复位；
- 常规烧录可用 `west flash`（或文档建议的板载串口方式）；
- 可使用 J-Link 烧录；
- 异常状态可执行 `scripts/factory_reset` 做 mass erase 并恢复出厂固件。

## Low_Power_Usage
- 文档强调 Ultra-low Power 与电池续航优化，但未给出完整低功耗电流测试表。
- 电池部署推荐（避免仅电池供电启动问题）：
- `CONFIG_SERIAL=n`
- `CONFIG_UART_CONSOLE=n`
- 并配合 RTT 日志（如 `CONFIG_USE_SEGGER_RTT=y`, `CONFIG_LOG_BACKEND_RTT=y`）。
- 电池检测通过 TPS22916 按需使能采样路径，可减少不必要电流消耗。
- Digital 示例中的 `k_msleep(10)` 说明也明确提到可减少 CPU 忙等待并降低功耗。
- 文档未提供一套完整“进入低功耗 + 唤醒恢复”的应用级 API 流程示例。

## Source_Files
- Wiki: [Getting Started with Seeed Studio XIAO nRF54L15(Sense)](https://wiki.seeedstudio.com/xiao_nrf54l15_sense_getting_started/)
- Wiki: [Pin Multiplexing with Seeed Studio XIAO nRF54L15 Sense](https://wiki.seeedstudio.com/xiao_nrf54l15_sense_pin_multiplexing/)
- Wiki（ES）: [Uso del sensor integrado del Seeed Studio XIAO nRF54L15 Sense](https://wiki.seeedstudio.com/es/xiao_nrf54l15_sense_built_in_sensor/)
- Datasheet: [Nordic nRF54L15 Datasheet v1.0](https://files.seeedstudio.com/wiki/XIAO_nRF54L15/Getting_Start/Nordic_nRF54L15_Datasheet_v1.0.pdf)
- Schematic: [XIAO nRF54L15 Sense Schematic](https://files.seeedstudio.com/wiki/XIAO_nRF54L15/Getting_Start/nRF54L15_Sense_Schematic.pdf)
