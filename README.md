# ICM-20948 Linux IIO driver

Learning project: a Linux IIO driver for the TDK InvenSense ICM-20948 9-DoF IMU
(accel + gyro + AK09916 magnetometer), developed on Raspberry Pi 4 (64-bit Bookworm),
with the goal of upstreaming to mainline Linux.

## Layout

```
driver/      kernel driver (out-of-tree module)
dts/         device tree overlays
userspace/   test apps (i2c-dev reader, IIO readers)
tools/       checkpatch fetch + style check
docs/        ROADMAP, HARDWARE, TESTING, PROGRESS
.claude/     Claude Code mentor commands
```

## Quick start

```bash
tools/get-checkpatch.sh      # fetch checkpatch.pl from mainline
tools/check.sh               # style-check driver/
```

## Working with Claude Code (mentor mode)

| Command | Use |
|---------|-----|
| `/next` | Get the next assignment |
| `/hint` | Stuck? Get a hint (not the solution) |
| `/review` | Maintainer-style review of your code |
| `/tests` | Test cases for the current stage |
| `/mainline` | Mainline-readiness check |

## License

GPL-2.0-only (required for mainline). Every source file starts with
`// SPDX-License-Identifier: GPL-2.0-only`.
