# Hardware setup — Raspberry Pi 4 + ICM-20948

## Wiring (I2C)

| ICM-20948 board | RPi 4 header | GPIO |
|-----------------|--------------|------|
| VIN / 3V3 | pin 1 (3.3 V) | — |
| GND | pin 6 | — |
| SDA | pin 3 | GPIO2 (I2C1 SDA) |
| SCL | pin 5 | GPIO3 (I2C1 SCL) |
| INT | pin 11 | **GPIO17** |
| AD0 / SDO | GND → 0x68, 3V3 → 0x69 | — |

**Why GPIO17?** Any free GPIO works as an interrupt line. GPIO17 is a plain GPIO with
no default alternate function on the Pi (unlike GPIO4 = 1-wire/GPCLK0, GPIO7–11 = SPI0,
GPIO14/15 = UART). So it never clashes with other overlays.

> Only 3.3 V logic. Never feed 5 V into a Pi GPIO.

## INT pin behaviour (register INT_PIN_CFG, bank 0, 0x0F)

| Bit | Name | Default | Meaning |
|-----|------|---------|---------|
| 7 | INT1_ACTL | 0 | 0 = active high, 1 = active low |
| 6 | INT1_OPEN | 0 | 0 = push-pull, 1 = open-drain |
| 5 | INT1_LATCH_EN | 0 | 0 = ~50 µs pulse, 1 = latched until cleared |
| 4 | INT_ANYRD_2CLEAR | 0 | 1 = any read clears the status |

Default (active high, pulse) → DT: `interrupts = <17 IRQ_TYPE_EDGE_RISING>;`
The driver should read the IRQ type from DT and program ACTL/LATCH to match
(see how `inv_mpu6050` does it).

## Enable I2C on Bookworm

```bash
sudo raspi-config nonint do_i2c 0        # or add dtparam=i2c_arm=on to /boot/firmware/config.txt
sudo apt install i2c-tools linux-headers-rpi-v8 build-essential git
sudo reboot
i2cdetect -y 1                            # expect 68 or 69
i2cget -y 1 0x68 0x00                     # expect 0xea
```

## IRQ or polling?

Both must work. INT is **optional** in the DT binding.

| Mode | How | Analogy |
|------|-----|---------|
| sysfs read | `cat in_accel_x_raw` → driver does I2C read on demand | Ask the shop when you need something |
| Data-ready IRQ trigger | Chip pulses INT, driver pushes a sample into the buffer | Doorbell rings when the post arrives |
| Polled trigger (no INT) | `iio-trig-hrtimer` / sysfs trigger fires the same capture path | Check the mailbox every N ms |

Driver rule: if `client->irq <= 0`, skip registering the data-ready trigger;
everything else (sysfs + buffer with an external trigger) still works.
