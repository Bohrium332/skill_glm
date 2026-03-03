# XIAO ESP32S3 Structured Extraction

## Device_Name
- Seeed Studio XIAO ESP32S3
- Seeed Studio XIAO ESP32S3 Sense
- Seeed Studio XIAO ESP32S3 Plus

## MCU_Core
- ESP32-S3R8
- Xtensa LX7 dual-core, 32-bit processor
- Up to 240 MHz

## Memory
- XIAO ESP32S3: 8 MB PSRAM + 8 MB Flash
- XIAO ESP32S3 Sense: 8 MB PSRAM + 8 MB Flash（并带 SD 卡槽，支持 32GB FAT32）
- XIAO ESP32S3 Plus: 8 MB PSRAM + 16 MB Flash

## Communication_Interfaces
- 无线（Specifications）：
- 2.4 GHz Wi-Fi
- Bluetooth Low Energy 5.0 / Bluetooth Mesh
- 有线/片上接口（按变体）：
- XIAO ESP32S3: `1x UART`, `1x IIC`, `1x SPI`, `11x GPIO(PWM)`, `9x ADC`
- XIAO ESP32S3 Sense: 在上项基础上额外列 `1x IIS`、`1x B2B Connector (with 2 additional GPIOs)`
- XIAO ESP32S3 Plus: `2x UART`, `1x IIC`, `1x IIS`, `2x SPI`, `18x GPIOs(PWM)`, `9x ADC`, `1x B2B Connector`
- 默认主引脚（D0-D10）：
- I2C: `D4(GPIO5)=SDA`, `D5(GPIO6)=SCL`
- UART: `D6(GPIO43)=TX`, `D7(GPIO44)=RX`
- SPI: `D8(GPIO7)=SCK`, `D9(GPIO8)=MISO`, `D10(GPIO9)=MOSI`
- Sense 相机/麦克风/文件系统能力边界：
- `xiao_esp32s3_camera_usage`、`xiao_esp32s3_sense_mic`、`xiao_esp32s3_sense_filesystem` 文档均明确其 Sense 相关内容仅适用于 `XIAO ESP32S3 Sense`（非 Sense 机型不具备对应 B2B 扩展板上的相机/麦克风/microSD 路径）。
- Sense 相机型号说明（Getting Started + camera usage）：
- `OV2640` 已停产，后续 Sense 默认为 `OV3660`（文档给出 `2048x1536`）；可选升级 `OV5640`，并提供自动对焦示例。
- 相机示例兼容范围：Getting Started 文档明确 Wiki camera 程序兼容 `OV2640/OV3660/OV5640` 三款相机。
- 相机（Sense 扩展板）使用链路（Arduino）：
- 相机配置与采集核心 API：`camera_config_t` -> `esp_camera_init(...)` -> `esp_camera_fb_get()` -> `esp_camera_fb_return(...)`；可通过 `esp_camera_sensor_get()` 获取传感器控制句柄。
- `esp_camera_init(...)` 限制（camera 文档 note）：该函数当前只能调用一次，且无反初始化接口。
- 文档给出相机参数保存/恢复 API：`esp_camera_save_to_nvs(...)`、`esp_camera_load_from_nvs(...)`。
- 相机示例普遍组合 `SD.begin(21)` + `SD.open(..., FILE_WRITE)` + `file.write(...)` 实现拍照/短视频保存到 microSD。
- 麦克风（PDM over I2S）使用链路（Sense）：
- `esp32` 2.0.x*(⚠️ 维护注记：此版本号基于建档时的官方 Wiki。AI 在生成代码时，请务必提醒用户核实 Seeed 官方是否有更新的版本。)* 示例：`I2S.setAllPins(-1, 42, 41, -1, -1)`、`I2S.begin(PDM_MONO_MODE, 16000, 16)`、`I2S.read()`。
- `esp32` 3.0.x*(⚠️ 维护注记：此版本号基于建档时的官方 Wiki。AI 在生成代码时，请务必提醒用户核实 Seeed 官方是否有更新的版本。)* 示例：`I2S.setPinsPdmRx(42, 41)`、`I2S.begin(I2S_MODE_PDM_RX, 16000, I2S_DATA_BIT_WIDTH_16BIT, I2S_SLOT_MODE_MONO)`、`I2S.read()`。
- 录音到 WAV（2.0.x*(⚠️ 维护注记：此版本号基于建档时的官方 Wiki。AI 在生成代码时，请务必提醒用户核实 Seeed 官方是否有更新的版本。)* 示例）关键流程：`ps_malloc(...)` -> `esp_i2s::i2s_read(...)` -> `generate_wav_header(...)` -> `SD.open(...)`/`file.write(...)`。
- 录音到 WAV（3.0.x*(⚠️ 维护注记：此版本号基于建档时的官方 Wiki。AI 在生成代码时，请务必提醒用户核实 Seeed 官方是否有更新的版本。)* 示例）关键流程：`i2s.recordWAV(20, &wav_size)` -> `SD.open(...)` -> `file.write(wav_buffer, wav_size)`。
- microSD 文件系统（Sense 扩展板）常用 API：
- `SD.begin(21)`、`SD.cardType()`、`SD.cardSize()`、`SD.totalBytes()`、`SD.usedBytes()`、`listDir(...)`、`createDir(...)`、`readFile(...)`、`writeFile(...)`、`appendFile(...)`、`renameFile(...)`、`deleteFile(...)`。

## Pin_Mapping

### D0-D10 映射（Getting Started Pin Map）

| Pin | GPIO(Chip Pin) | PWM | ADC | I2C | SPI | UART | 文档复用/说明 |
|---|---|---|---|---|---|---|---|
| D0 | GPIO1 | 支持（Pin Multiplexing: all GPIO pins support PWM output） | 是 | 否 | 否 | 否 | Function: Analog；Alt: TOUCH1；Description: GPIO, ADC |
| D1 | GPIO2 | 支持 | 是 | 否 | 否 | 否 | Function: Analog；Alt: TOUCH2；Description: GPIO, ADC |
| D2 | GPIO3 | 支持 | 是 | 否 | 否 | 否 | Function: Analog；Alt: TOUCH3；Description: GPIO, ADC |
| D3 | GPIO4 | 支持 | 是 | 否 | 否 | 否 | Function: Analog；Alt: TOUCH4；Description: GPIO, ADC |
| D4 | GPIO5 | 支持 | 是 | 是（SDA） | 否 | 否 | Function: Analog,SDA；Alt: TOUCH5；Description: GPIO, I2C Data, ADC |
| D5 | GPIO6 | 支持 | 是 | 是（SCL） | 否 | 否 | Function: Analog,SCL；Alt: TOUCH6；Description: GPIO, I2C Clock, ADC |
| D6 | GPIO43 | 支持 | 否（Pin Map 未标 ADC） | 否 | 否 | 是（TX） | Function: TX；Description: GPIO, UART Transmit |
| D7 | GPIO44 | 支持 | 否（Pin Map 未标 ADC） | 否 | 否 | 是（RX） | Function: RX；Description: GPIO, UART Receive |
| D8 | GPIO7 | 支持 | 是 | 否 | 是（SCK） | 否 | Function: Analog,SCK；Alt: TOUCH7；Description: GPIO, SPI Clock, ADC |
| D9 | GPIO8 | 支持 | 是 | 否 | 是（MISO） | 否 | Function: Analog,MISO；Alt: TOUCH8；Description: GPIO, SPI Data, ADC |
| D10 | GPIO9 | 支持 | 是 | 否 | 是（MOSI） | 否 | Function: Analog,MOSI；Alt: TOUCH9；Description: GPIO, SPI Data, ADC |

### A0-A10 映射（按文档可证据化信息）

| Analog Pin | 对应 GPIO | 依据与说明 |
|---|---|---|
| A0 | GPIO1 | 与 D0 对应（D0 为 Analog） |
| A1 | GPIO2 | 与 D1 对应（D1 为 Analog） |
| A2 | GPIO3 | 与 D2 对应（D2 为 Analog） |
| A3 | GPIO4 | 与 D3 对应（D3 为 Analog） |
| A4 | GPIO5 | 与 D4 对应（D4 为 Analog,SDA） |
| A5 | GPIO6 | 与 D5 对应（D5 为 Analog,SCL） |
| A6 | 文档未提及 | 文档未给 A6 映射 |
| A7 | 文档未提及 | 文档未给 A7 映射 |
| A8 | GPIO7 | Pin Multiplexing 表中明确给出 `D8 / A8 / GPIO7` |
| A9 | GPIO8 | Pin Multiplexing 表中明确给出 `D9 / A9 / GPIO8` |
| A10 | GPIO9 | Pin Multiplexing 表中明确给出 `D10 / A10 / GPIO9` |

### 额外关键引脚（非 D0-D10）

| 信号 | GPIO(Chip Pin) | 说明 |
|---|---|---|
| Boot | GPIO0 | Enter Boot Mode |
| Reset | CHIP_PU | 复位 |
| USER_LED | GPIO21 | User Light |
| CHARGE_LED | 文档存在两种写法 | S3/Sense Pin Map 写 `CHG-LED`；Plus Pin Map 写 `VCC_3V3` |
| MTDO | GPIO40 | JTAG |
| MTDI | GPIO41 | JTAG, ADC |
| MTCK | GPIO39 | JTAG, ADC |
| MTMS | GPIO42 | JTAG, ADC |
| D11 / D12（Sense 扩展板） | GPIO42 / GPIO41 | 默认与麦克风复用；需断开 J1/J2 才可当通用数字口使用 |

### Sense 相机/麦克风/microSD 占用引脚（扩展板）

| 信号 | GPIO(Chip Pin) | 说明 |
|---|---|---|
| XMCLK | GPIO10 | Camera clock（camera slot） |
| DVP_Y8 | GPIO11 | Camera data |
| DVP_Y7 | GPIO12 | Camera data |
| DVP_PCLK | GPIO13 | Camera pixel clock |
| DVP_Y6 | GPIO14 | Camera data |
| DVP_Y2 | GPIO15 | Camera data |
| DVP_Y5 | GPIO16 | Camera data |
| DVP_Y3 | GPIO17 | Camera data |
| DVP_Y4 | GPIO18 | Camera data |
| DVP_VSYNC | GPIO38 | Camera vsync |
| CAM_SCL | GPIO39 | Camera SCCB clock |
| CAM_SDA | GPIO40 | Camera SCCB data |
| DVP_HREF | GPIO47 | Camera href |
| DVP_Y9 | GPIO48 | Camera data |
| PDM Microphone DATA | GPIO41 | 麦克风数据输入（mic 文档 Pin 表） |
| PDM Microphone CLK | GPIO42 | 麦克风时钟（mic 文档 Pin 表） |
| microSD CS | GPIO21 | `SD.begin(21)` 指定的 CS 引脚 |
| microSD SCK | GPIO7（D8/A8） | 与主 SPI SCK 复用 |
| microSD MISO | GPIO8（D9/A9） | 与主 SPI MISO 复用 |
| microSD MOSI | GPIO9（D10/A10） | 与主 SPI MOSI 复用 |

### ADC/DAC 分辨率与 API（原文可提取）

- ADC：
- 文档未给出 `analogReadResolution(...)` 示例或 ADC 位宽配置 API。
- 示例 API 为 `analogRead(...)`。
- PWM：
- 文档明确“all GPIO pins ... support PWM output”。
- 示例 API：`analogWrite(...)`。
- DAC：
- Pin Multiplexing 的功能支持表中 `ESP32-S3` 列写明 `DAC: Not Supported`。
- 文档未给出 `analogWriteResolution(...)`。

## Critical_IO_Gotchas (极其重要)
- A11/A12 误区（多处 caution）：虽然映射到 GPIO41/GPIO42，但 **A11/A12 不支持 ADC**。
- Plus 兼容性限制（Getting Started caution）：XIAO ESP32S3 Plus 的 B2B 连接器兼容 Wio-SX1262 扩展板，但不兼容 Plug-in camera sensor board。
- Sense 专属范围：camera/mic/filesystem 三份新增文档都仅针对 `XIAO ESP32S3 Sense` 相关扩展板能力。
- Sense 的 D11/D12 复用陷阱：
- 默认用于麦克风；若要作通用 IO，需要切断扩展板 `J1/J2`。
- 切断后麦克风功能不可用；需重新焊回对应焊盘才能恢复。
- 当前文档说明 D11/D12 在部分环境下未宏定义，需用 `GPIO42/GPIO41` 控制（而非 `D11/A11`、`D12/A12`）。
- Sense SPI 与 SD 卡互斥路径（J3）：
- 扩展板 SD 卡会占用 SPI 引脚。
- 切断 J3 可恢复 SPI、禁用 SD；焊接 J3 可启用 SD、占用 SPI。
- 文档强调切 J3 实质是断开 R4~R6 上拉，不只是“开关 SD”。
- Sense + Round Display 场景：camera 文档 Troubleshooting 说明原则上需切断 Sense 板 J3，且两板同时使用时仅 Round Display 的 SD 卡槽可用；否则易出现 `SD card mount failure`。
- camera 文档与 mic 录音到 SD 文档均要求在 Arduino IDE 中开启 PSRAM（mic 文档包含 `ps_malloc()` / `recordWAV` 录音路径），否则相机/录音相关程序无法按文档流程正常工作。
- mic 文档限制：当前 ESP32-S3 麦克风路径仅支持 `PDM_MONO_MODE`（或 3.0.x*(⚠️ 维护注记：此版本号基于建档时的官方 Wiki。AI 在生成代码时，请务必提醒用户核实 Seeed 官方是否有更新的版本。)* 对应 `I2S_MODE_PDM_RX`）与 `16-bit` 采样位宽；文档给出的稳定采样率为 `16kHz`。
- 版本分支注意：camera webserver 和 mic 示例均按 `esp32` 板包 `2.0.x`*(⚠️ 维护注记：此版本号基于建档时的官方 Wiki。AI 在生成代码时，请务必提醒用户核实 Seeed 官方是否有更新的版本。)* / `3.0.x`*(⚠️ 维护注记：此版本号基于建档时的官方 Wiki。AI 在生成代码时，请务必提醒用户核实 Seeed 官方是否有更新的版本。)* 分别给出不同代码，混用版本会导致示例不匹配。
- microSD 介质要求：新增三份文档一致要求 Sense 使用 `<=32GB` 且 `FAT32` 格式卡。
- 文件系统文档的 `SD` 示例需要把默认 `SD.begin()` 改成 `SD.begin(21)`；若使用 Round Display，文档说明参数应改为 `D2`。
- camera 长时间视频流 caution：文档明确提示长时间运行会发热，需要关注散热与烫伤风险。
- 电源相关：
- `5V` 既是 USB 5V 输出，也可作输入，但文档要求串联二极管（anode→电池侧，cathode→5V pin）。
- `3V3` 为稳压输出，文档写可拉取 `700mA`。
- 电池供电时 `5V` 引脚无电压（caution）。
- 串口/上传相关：
- Arduino ESP32 板包版本需 `2.0.8`*(⚠️ 维护注记：此版本号基于建档时的官方 Wiki。AI 在生成代码时，请务必提醒用户核实 Seeed 官方是否有更新的版本。)* 及以上（caution）。
- 若串口监视器报错或空输出，文档建议开启 `USB CDC On Boot`。
- 软串口建议使用 `EspSoftwareSerial 7.0.0`*(⚠️ 维护注记：此版本号基于建档时的官方 Wiki。AI 在生成代码时，请务必提醒用户核实 Seeed 官方是否有更新的版本。)*（tip），其它版本可能导致软串口不可用或异常。
- 若系统中安装了其他软串口库，可能与 `EspSoftwareSerial` 冲突（caution），需自行排查并避免并存冲突。
- 深睡后重烧（Sleep 文档 tip）：按住 BOOT，再按 Reset 重启进入可烧录状态。
- Strapping pins（Getting Started）：
- Boot mode: `GPIO0`, `GPIO46`
- VDD_SPI: `GPIO45`
- ROM messages: `GPIO46`
- JTAG source: `GPIO3`
- 这些脚在复位采样阶段受上下拉与时序约束，复位后才作为常规 IO 使用。

## LED_Status
- USER_LED：`GPIO21`（User Light）。
- Blink 结果描述：成功上传后右侧橙色 LED 闪烁。
- LED 电平逻辑（note）：用户 LED 为反相逻辑，`HIGH` 灭、`LOW` 亮。
- CHARGE_LED（红灯）行为（Battery Usage）：
- 无电池 + Type-C：红灯亮，约 30 秒后灭。
- 有电池 + Type-C 充电：红灯闪烁。
- 充满：红灯熄灭。

## Power_&_Battery
- 供电规格（Specifications）：`Type-C 5V`，`BAT 3.7V`。
- 内置电源管理芯片支持：电池独立供电 + USB 充电。
- 电池焊接方向：负极靠近 USB 端，正极远离 USB 端。
- 5V/3V3 说明（Power Pins）：
- `5V` 为 USB 5V 输出，也可作输入（需串二极管）。
- `3V3` 为稳压输出，文档写可拉取 700mA。
- 仅电池供电时：5V 引脚无电压（caution）。
- 电池电压读取：
- Getting Started 中 note 说明默认**无专用 GPIO 电池采样路径**，软件层无法直接读取电池电压；若需要可外接方式测量。
- 文档存在变体差异：Plus Pin Map 额外列 `ADC_BAT(GPIO10)`；S3/Sense Pin Map 未列该项。

## Sleep_&_Wakeup
- 低功耗指标（Getting Started 规格表，3.8V 供电，按变体）：
- XIAO ESP32S3: Modem-sleep 27mA, Light-sleep 2mA, Deep Sleep 14μA
- XIAO ESP32S3 Sense: Modem-sleep 44mA, Light-sleep 5mA, Deep Sleep 3mA
- XIAO ESP32S3 Plus: Modem-sleep 31.6mA, Light-sleep 2.45mA, Deep Sleep 33.51μA
- `XIAO_ESP32S3_Sleep.md` 给出的 Deep-Sleep 唤醒方式：
- Timer wake-up
- Touchpad wake-up
- External wake-up（EXT0/EXT1）
- ULP wake-up
- GPIO wake-up
- Light-Sleep 说明：CPU halt，但 RAM 与部分外设保持上电，支持快速唤醒。
- Modem-Sleep 说明：Wi-Fi/Bluetooth 模块睡眠、CPU 保持活动。

## Bootloader_Mode
- 标准 BootLoader 进入步骤（Getting Started）：
1. 按住 `BOOT`。
2. 保持按住 BOOT 并连接数据线到电脑。
3. 连接后松开 BOOT，上传 Blink 验证。
- 组合方式：上电时按住 BOOT，再按一次 Reset 也可进 BootLoader。
- UF2 BootLoader（Getting Started）：
- Windows 可通过 `boot_uf2.bat` 进入 UF2 盘符模式。
- 重新进入 UF2 模式可用快速按键序列：`Reset` 后紧接 `Boot`。

## Low_Power_Usage
- Deep-Sleep 相关 API（`XIAO_ESP32S3_Sleep.md` 示例）：
- `esp_sleep_enable_timer_wakeup(...)`
- `esp_sleep_enable_ext0_wakeup(...)`
- `esp_sleep_enable_ext1_wakeup_io(...)`
- `rtc_gpio_pullup_dis(...)`
- `rtc_gpio_pulldown_en(...)`
- `esp_sleep_get_wakeup_cause()`
- `touchSleepWakeUpEnable(pin, threshold)`
- `esp_deep_sleep_start()`
- `esp_sleep_pd_config(...)`
- `RTC_DATA_ATTR` 用于跨深睡保存变量（如 `bootCount`）。
- Light-Sleep 相关 API：
- `esp_light_sleep_start()`
- `esp_sleep_enable_timer_wakeup(...)`
- Modem-Sleep 相关 API（Wi-Fi 维持连接场景）：
- `WiFi.setSleep(true)` / `WiFi.setSleep(false)`
- Sleep 文档建议：依据业务在 Deep / Light / Modem 三种模式间做功耗与响应权衡。
- `xiao_esp32s3_sense_filesystem` 的数据记录示例采用“采集后立刻深睡”模式：`esp_sleep_enable_timer_wakeup(TIME_TO_SLEEP * uS_TO_S_FACTOR)` + `esp_deep_sleep_start()`。
- 同示例的调试特性：每次唤醒相当于复位，串口监视器通常只会输出一次本轮保存信息；需重新打开串口查看下一轮日志。

## Source_Files
- Wiki: [Getting Started with Seeed Studio XIAO ESP32S3 Series](https://wiki.seeedstudio.com/xiao_esp32s3_getting_started/)
- Wiki: [Pin Multiplexing with Seeed Studio XIAO ESP32S3 (Sense)](https://wiki.seeedstudio.com/xiao_esp32s3_pin_multiplexing/)
- Wiki: [Sleep Modes and Power Consumption](https://wiki.seeedstudio.com/XIAO_ESP32S3_Consumption/)
- Wiki: [Camera Usage in Seeed Studio XIAO ESP32S3 Sense](https://wiki.seeedstudio.com/xiao_esp32s3_camera_usage/)
- Wiki: [Usage of Seeed Studio XIAO ESP32S3 microphone](https://wiki.seeedstudio.com/xiao_esp32s3_sense_mic/)
- Wiki: [File System and XIAO ESP32S3 Sense](https://wiki.seeedstudio.com/xiao_esp32s3_sense_filesystem/)
- Datasheet: [Espressif ESP32-S3 Datasheet](https://files.seeedstudio.com/wiki/SeeedStudio-XIAO-ESP32S3/res/esp32-s3_datasheet.pdf)
- Schematic: [XIAO ESP32-S3 Sense Schematic](https://files.seeedstudio.com/wiki/SeeedStudio-XIAO-ESP32S3/new-res/new-XIAO%20ESP32S3%20Sense_v1.3_SCH_260210(1).pdf)
- Datasheet: [OV3660 Datasheet](https://files.seeedstudio.com/wiki/SeeedStudio-XIAO-ESP32S3/res/OV3660_datasheet.pdf)
- Datasheet: [OV5640 Datasheet](https://files.seeedstudio.com/wiki/SeeedStudio-XIAO-ESP32S3/res/OV5640_datasheet.pdf)
- Datasheet: [OV2640 Datasheet](https://files.seeedstudio.com/wiki/SeeedStudio-XIAO-ESP32S3/res/OV2640_datasheet.pdf)
