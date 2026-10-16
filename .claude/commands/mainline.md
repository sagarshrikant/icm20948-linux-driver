Judge mainline readiness of the driver. Use the "Mainline gate" in docs/TESTING.md
and the review checklist in CLAUDE.md. Also check: DT binding YAML present,
Kconfig/Makefile entries, MAINTAINERS entry, commit messages (subject prefix
"iio: imu: icm20948:"), Signed-off-by, patch split (binding first, then core,
then features). Output a checklist with PASS / FAIL / TODO and the next 3 actions.
$ARGUMENTS
