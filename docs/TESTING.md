# Test plan

## Per-assignment (always)

- `make W=1` — no warnings
- `tools/check.sh` — checkpatch `--strict`, no errors
- `dmesg` clean (no WARN, BUG, oops)

## Functional (on the Pi)

| Test | Expected |
|------|----------|
| WHO_AM_I in probe | 0xEA; wrong address → probe fails, no leak |
| Board flat, accel | X,Y ≈ 0 g, Z ≈ +1 g (≈ 9.81 m/s² after scale) |
| Board still, gyro | ≈ 0 rad/s (small bias ok) |
| Temp | Room temp ± a few °C |
| Magnetometer | Total field ≈ 25–65 µT, rotates with board |
| Sampling rate | Measured rate (timestamps) matches `sampling_frequency` ±2 % |
| IRQ mode | `iio_generic_buffer -n icm20948 -g -c 100` streams |
| Polled mode | Same, with hrtimer trigger and no `interrupts` in DT |
| Scale changes | Doubling full-scale halves raw value |

## Robustness

| Test | How |
|------|-----|
| Load/unload loop | `for i in $(seq 100); do insmod …; rmmod …; done` |
| Unbind/bind loop | `echo 1-0068 > /sys/bus/i2c/drivers/icm20948/unbind` (and `bind`) |
| Unplug sensor during read | Errors returned, no hang, no oops |
| Concurrent access | Several `cat` loops + buffer streaming at once |
| Leak check | kernel with `CONFIG_DEBUG_KMEMLEAK`, `echo scan > /sys/kernel/debug/kmemleak` |
| Locking check | kernel with `CONFIG_PROVE_LOCKING` (lockdep) |
| Memory errors | kernel with `CONFIG_KASAN` |

## Mainline gate

| Check | Command |
|-------|---------|
| Style | `scripts/checkpatch.pl --strict` on every patch |
| Static analysis | `make C=1` (sparse), `make W=1` |
| Coccinelle | `make coccicheck MODE=report M=drivers/iio/imu/` |
| DT binding | `make dt_binding_check DT_SCHEMA_FILES=invensense,icm20948.yaml` |
| DT check | `make CHECK_DTBS=y` for a dts using it |
| Builds | arm64 + x86_64, `=y` and `=m`, `allmodconfig` |
| Recipients | `scripts/get_maintainer.pl` |
