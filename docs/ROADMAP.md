# Roadmap — assignments

Each assignment: **goal → acceptance criteria → tests**. Do them in order.
Ask Claude Code `/next` to get the detailed brief for the next one.

## Stage 1 — Foundations

| # | Assignment | Done when |
|---|-----------|-----------|
| A0 | Lab setup: wiring, enable I2C, headers, checkpatch | `i2cdetect -y 1` shows 0x68/0x69, `tools/check.sh` runs |
| A1 | Hello-world kernel module (out-of-tree) | insmod/rmmod prints in `dmesg`, module params work |
| A2 | User-space reader via `/dev/i2c-1` (no driver) | Prints WHO_AM_I = 0xEA, raw accel Z ≈ 1 g |
| A3 | `i2c_driver` skeleton + DT overlay | `probe()` called on boot/overlay load, `remove()` on unbind |

## Stage 2 — Talking to the chip from the kernel

| # | Assignment | Done when |
|---|-----------|-----------|
| A4 | regmap + bank switching + reset/power-up | WHO_AM_I checked in probe; wrong chip → probe fails cleanly |
| A5 | IIO device: accel, gyro, temp raw channels | `cat in_accel_z_raw` gives sane value |
| A6 | Scale, offset, sampling frequency (+ `_available`) | Values in SI units, writes change hardware config |

## Stage 3 — Streaming

| # | Assignment | Done when |
|---|-----------|-----------|
| A7 | Buffered mode with data-ready IRQ trigger | `iio_generic_buffer` streams at the set rate |
| A8 | Polled mode (no IRQ): hrtimer/sysfs trigger | Same app works with `interrupts` removed from DT |
| A9 | FIFO + watermark (optional, advanced) | Lower CPU load at high rate, no data loss |

## Stage 4 — Complete driver

| # | Assignment | Done when |
|---|-----------|-----------|
| A10 | Magnetometer AK09916 via aux I2C master | `in_magn_*` channels in µT, ~25–65 µT total field |
| A11 | Runtime PM / system suspend | Sensor sleeps when unused, resumes correctly |
| A12 | SPI support (core + i2c + spi modules) | Same functionality over SPI |

## Stage 5 — Mainline

| # | Assignment | Done when |
|---|-----------|-----------|
| A13 | DT binding YAML | `make dt_binding_check` clean |
| A14 | Port to IIO `togreg` tree, full test matrix (`docs/TESTING.md`) | All mainline checks pass |
| A15 | RFC/patch series to linux-iio | Sent with `git send-email`, cover letter, review answered |

> Tip: Send an **early RFC** (around A5) to ask the maintainers about design
> (new driver vs. extending an existing InvenSense driver).
