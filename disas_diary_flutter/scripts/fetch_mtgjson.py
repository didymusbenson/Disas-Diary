#!/usr/bin/env python3
"""
Download and cache MTGJSON data for Disa's Diary.

Downloads AtomicCards.json.xz from MTGJSON API v5, decompresses it,
and caches the result locally. Uses version checking to avoid
re-downloading when already up to date.

Usage:
    python3 scripts/fetch_mtgjson.py
    (Run from disas_diary_flutter/)
"""

import json
import subprocess
import sys
from pathlib import Path

MTGJSON_META_URL = "https://mtgjson.com/api/v5/Meta.json"
MTGJSON_ATOMIC_URL = "https://mtgjson.com/api/v5/AtomicCards.json.xz"

SCRIPT_DIR = Path(__file__).parent
DATA_DIR = SCRIPT_DIR / "data"
VERSION_FILE = DATA_DIR / "version.json"
ATOMIC_FILE = DATA_DIR / "AtomicCards.json"


def get_local_version():
    """Get the version of locally cached data."""
    if not VERSION_FILE.exists():
        return None
    try:
        with open(VERSION_FILE, "r") as f:
            return json.load(f).get("version")
    except (json.JSONDecodeError, IOError):
        return None


def fetch_remote_version():
    """Fetch latest version from MTGJSON API."""
    print("Checking MTGJSON API for latest version...")
    result = subprocess.run(
        ["curl", "-s", MTGJSON_META_URL],
        capture_output=True,
        text=True,
    )
    if result.returncode != 0:
        print(f"Error fetching metadata: {result.stderr}")
        return None
    try:
        meta = json.loads(result.stdout)
        return meta.get("data", {}).get("date")
    except json.JSONDecodeError:
        print("Could not parse metadata JSON")
        return None


def download_and_decompress():
    """Download AtomicCards.json.xz and decompress."""
    compressed = DATA_DIR / "AtomicCards.json.xz"

    print("\nDownloading AtomicCards.json.xz (~25 MB)...")
    result = subprocess.run(
        ["curl", "-o", str(compressed), MTGJSON_ATOMIC_URL],
        capture_output=False,
    )
    if result.returncode != 0:
        print("Download failed!")
        return False

    print("Decompressing...")
    result = subprocess.run(
        ["unxz", "-f", str(compressed)],
        capture_output=True,
    )
    if result.returncode != 0:
        print(f"Decompression failed: {result.stderr}")
        return False

    if not ATOMIC_FILE.exists():
        print("Decompressed file not found!")
        return False

    size_mb = ATOMIC_FILE.stat().st_size / (1024 * 1024)
    print(f"Cached AtomicCards.json ({size_mb:.0f} MB)")
    return True


def main():
    """Check for updates and download if needed."""
    DATA_DIR.mkdir(exist_ok=True)

    print("=" * 60)
    print("Disa's Diary - MTGJSON Data Fetcher")
    print("=" * 60)

    local_version = get_local_version()
    if local_version:
        print(f"Local version: {local_version}")
    else:
        print("No local data found")

    remote_version = fetch_remote_version()
    if not remote_version:
        print("Could not fetch remote version.")
        return 1

    print(f"Remote version: {remote_version}")

    if local_version == remote_version and ATOMIC_FILE.exists():
        print(f"\nAlready up to date ({local_version}). No download needed.")
        return 0

    if local_version:
        print(f"\nUpdate available: {local_version} -> {remote_version}")
    else:
        print(f"\nDownloading initial version: {remote_version}")

    if not download_and_decompress():
        return 1

    with open(VERSION_FILE, "w") as f:
        json.dump({"version": remote_version}, f, indent=2)

    print(f"\nDone. Data version: {remote_version}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
