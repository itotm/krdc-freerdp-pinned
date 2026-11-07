# KRDC Flatpak with FreeRDP 3.32.2

An unofficial build of [KRDC](https://apps.kde.org/krdc/) as a Flatpak (`org.kde.krdc`) whose bundled FreeRDP is pinned to **3.32.2** instead of 3.33.0.

## Why this exists

FreeRDP 3.33.0 has a regression: remote audio falls further and further behind as the session goes on, and input (for example `Ctrl+Alt+D`) reacts late too. The reporter sees it with 3.33.0 and not with 3.32.2:

- Bug report: [FreeRDP/FreeRDP#14034](https://github.com/FreeRDP/FreeRDP/issues/14034)

The KRDC on Flathub ships its own copy of FreeRDP (3.33.0 at the time of writing), so the system FreeRDP does not matter and there is no way to pick another version from the Flathub package. This repo is the Flathub manifest with one change: the `freerdp` module builds the 3.32.2 tarball, and the automatic version bump (`x-checker-data`) is removed so it does not move back to 3.33.0.

Remmina on Flathub is not affected because it bundles an older FreeRDP (3.20.0).

**Status:** the pin is based on the report in the issue. It has not yet been confirmed here over a long session.

## Install

1. Download `krdc-26.08.3-freerdp-3.32.2.flatpak` from the [latest release](https://github.com/itotm/krdc-freerdp-pinned/releases/latest).
2. Install it (the KDE runtime `org.kde.Platform//6.10` is fetched from Flathub):

   ```
   flatpak install --user krdc-26.08.3-freerdp-3.32.2.flatpak
   ```

The bundle has the same application ID as the Flathub one but the branch `master`, so both can be installed side by side. The menu entry of the user installation launches the pinned build. To start it by hand:

```
flatpak run --branch=master org.kde.krdc
```

Settings are shared with the Flathub KRDC (`~/.var/app/org.kde.krdc`).

To check which FreeRDP is loaded while KRDC is running:

```
grep libfreerdp /proc/$(pidof krdc)/maps | awk '{print $6}' | sort -u
```

## Build it yourself

You need `flatpak-builder` (or the `org.flatpak.Builder` Flatpak) and the Flathub remote:

```
./build.sh                       # builds and installs for the current user
flatpak build-bundle --runtime-repo=https://dl.flathub.org/repo/flathub.flatpakrepo \
  ~/.local/share/flatpak/repo krdc-26.08.3-freerdp-3.32.2.flatpak org.kde.krdc master
```

`git diff upstream/master -- org.kde.krdc.json` (after `git remote add upstream https://github.com/flathub/org.kde.krdc.git && git fetch upstream`) shows the only change against Flathub.

## Limits

- **No automatic updates.** Neither KRDC nor FreeRDP will be updated by Flatpak, security fixes included. Rebuild when a new KRDC comes out.
- **Temporary.** Once a FreeRDP release after 3.33.0 fixes issue 14034 and the Flathub KRDC picks it up, remove this build and go back to the official package:

  ```
  flatpak uninstall --user org.kde.krdc//master
  ```

## Credits and licenses

The manifest is derived from [flathub/org.kde.krdc](https://github.com/flathub/org.kde.krdc). The applications and libraries it builds are unmodified upstream releases under their own licenses: KRDC (GPL-2.0-or-later), FreeRDP (Apache-2.0), libssh (LGPL-2.1-or-later), LibVNCServer (GPL-2.0-or-later), among others.

This repository was developed with the help of an LLM (Claude).
