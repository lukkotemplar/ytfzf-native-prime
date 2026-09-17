# ytfzf-prime native setup

A lightweight native setup for [`ytfzf`](https://github.com/pystardust/ytfzf), based on the
[`tabletseeker/ytfzf`](https://github.com/tabletseeker/ytfzf) fork and extended with custom
`yt-dlp` scrapers, thumbnail handling and configuration.

This repository replaces the previous Docker-based `ytfzf_prime` setup with a fully native
installation.

No Docker, containerd or Alpine container is required.

## Features

- Native installation, without Docker
- Search powered by a custom `yt-dlp` scraper
- Subscription feed powered by `yt-dlp`
- Video playback with `mpv`
- Search interface with `fzf`
- Thumbnail previews with `chafa`
- Automatic thumbnail downloading
- Quiet `mpv` output
- Displays video title and channel cleanly
- Separate search and subscription modes
- Keeps personal subscriptions outside the Git repository

## Supported systems

This setup is intended for **Arch Linux and Arch-based distributions using `pacman`**.

The provided `install.sh` installs the required dependencies automatically with `pacman`.

Other Linux distributions may also work, but dependencies and installation paths may need
to be configured manually.

## Dependencies

The installer uses the following packages:

```text
mpv
yt-dlp
jq
fzf
curl
chafa
python
```

They are installed automatically with:

```bash
sudo pacman -S --needed mpv yt-dlp jq fzf curl chafa python
```

## Installation

Clone the repository:

```bash
git clone https://github.com/YOUR_USERNAME/YOUR_REPOSITORY.git
cd YOUR_REPOSITORY
```

Run:

```bash
./install.sh
```

The installer will:

1. Install the required Arch Linux packages
2. Download the `tabletseeker/ytfzf` fork
3. Install the custom addons
4. Install the custom configuration
5. Create the thumbnail cache directory
6. Install the `ytfzf-prime` launcher

The resulting installation uses:

```text
~/.local/bin/ytfzf-prime
~/.local/lib/ytfzf-prime/
~/.local/share/ytfzf-prime/
~/.config/ytfzf-prime/
```

Make sure `~/.local/bin` is in your `$PATH`.

For example:

```bash
export PATH="$HOME/.local/bin:$PATH"
```

## Usage

### Search YouTube

```bash
ytfzf-prime "linux"
```

or:

```bash
ytfzf-prime "geometry dash"
```

This uses the custom `search-ytdlp` scraper.

### Subscriptions

Running the command without arguments opens the subscription feed:

```bash
ytfzf-prime
```

This uses the custom `subs-ytdlp` scraper.

Subscriptions are stored locally in:

```text
~/.config/ytfzf-prime/subscriptions
```

This file is intentionally **not included in the repository**.

## Configuration

The repository contains the reproducible configuration under:

```text
config/
├── conf.sh
├── extensions/
│   └── smart-thumb-download
├── scrapers/
│   ├── search-ytdlp
│   └── subs-ytdlp
└── thumbnail-viewers/
    ├── chafa-kitty
    └── chafa-stable
```

During installation these files are copied to:

```text
~/.config/ytfzf-prime/
```

Existing user configuration is preserved where possible.

Generated thumbnails are stored in:

```text
~/.config/ytfzf-prime/thumbnails/
```

They are cache files and are not tracked by Git.

## Project structure

```text
.
├── config/
│   ├── conf.sh
│   ├── extensions/
│   ├── scrapers/
│   └── thumbnail-viewers/
├── ytfzf/
│   └── addons/
├── install.sh
├── launch.sh
├── .gitignore
└── README.md
```

`launch.sh` provides two modes:

```text
ytfzf-prime <query>    Search mode
ytfzf-prime            Subscription mode
```

## Why this exists

The standard `ytfzf` scraper may currently fail with:

```text
[ERROR]: Nothing was scraped
```

This setup avoids depending on that scraper for normal usage.

Searches and subscription feeds are instead obtained through custom `yt-dlp` based scrapers.

An earlier version of this setup ran `ytfzf_prime` inside Docker. That worked, but required
Docker, containerd, runc and an entire container image just to run a shell-based application.

The current version runs everything directly on the host.

Conceptually:

```text
Kitty / terminal
      │
      ▼
 ytfzf-prime
      │
      ├── search-ytdlp
      ├── subs-ytdlp
      ├── smart-thumb-download
      │
      ├── fzf
      ├── yt-dlp
      ├── chafa
      └── mpv
```

## Updating ytfzf-prime

Running the installer again downloads the current version of the
`tabletseeker/ytfzf` fork:

```bash
./install.sh
```

The executable is stored at:

```text
~/.local/lib/ytfzf-prime/ytfzf
```

## Uninstall

Remove the native installation:

```bash
rm -f ~/.local/bin/ytfzf-prime
rm -rf ~/.local/lib/ytfzf-prime
rm -rf ~/.local/share/ytfzf-prime
```

To also remove the configuration and subscriptions:

```bash
rm -rf ~/.config/ytfzf-prime
```

The second command deletes personal configuration, subscription data and cached thumbnails.

Dependencies installed through `pacman` are intentionally not removed automatically because
they may be used by other applications.

## Credits

This setup builds on:

- [ytfzf](https://github.com/pystardust/ytfzf)
- [tabletseeker/ytfzf](https://github.com/tabletseeker/ytfzf)
- [yt-dlp](https://github.com/yt-dlp/yt-dlp)
- [fzf](https://github.com/junegunn/fzf)
- [mpv](https://mpv.io/)
- [Chafa](https://hpjansson.org/chafa/)

The custom scrapers, thumbnail handling and native installation scripts in this repository
are intended to provide a small terminal-centric YouTube setup without requiring Docker.
