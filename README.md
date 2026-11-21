# Hide Lineage Props

![Version](https://img.shields.io/badge/version-v1.0.0-4f8cff?style=flat-square)
![Platform](https://img.shields.io/badge/Android-11--14-3ddc84?style=flat-square)
![Root](https://img.shields.io/badge/KernelSU%20%7C%20Magisk%20%7C%20APatch-compatible-blue?style=flat-square)
![License](https://img.shields.io/badge/license-MIT-lightgrey?style=flat-square)

Lightweight, device-agnostic **KernelSU / Magisk / APatch** module that sanitizes custom-ROM / debug build properties before `zygote` starts and hides legacy LineageOS service lookups via `sepolicy.rule`.

---

## What It Does

1. **Pre-Zygote Property Sanitization (`post-fs-data.sh` & `service.sh`):**
   - Deletes `ro.modversion`, `ro.lineage.version`, and any property whose name contains `lineage`.
   - Strips `lineageos_` / `lineage_` prefixes and replaces `userdebug` -> `user` and `dev-keys` / `test-keys` -> `release-keys` across property values using `resetprop -n`.
   - Replaces `eng.*` values in `ro.bootimage.build.version.incremental` with `ro.build.version.incremental`.
2. **SELinux Audit & Legacy Service Hiding (`sepolicy.rule`):**
   - Silences `dontaudit` noise and denies `untrusted_app_all` / `isolated_app` lookups for `lineage_*_service` in `servicemanager`.

*(Device-specific `vbmeta` spoofing is separated into [vbmeta-sync](https://github.com/SuspectWorkers/vbmeta-sync), and device hardware tweaks into [m5-system-tweaks](https://github.com/SuspectWorkers/m5-system-tweaks).)*

---

## Installation

1. Download `hide_lineage_props.zip` from [**Releases**](https://github.com/SuspectWorkers/hide-lineage-props/releases/latest).
2. Flash in KernelSU / BakaSU / Magisk / APatch and reboot.

---

## Compatibility

- Generic across Android 11–14 custom ROMs (LineageOS, `-userdebug` / `test-keys` AOSP builds, custom boot ramdisks).
