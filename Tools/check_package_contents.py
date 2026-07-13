#!/usr/bin/env python3
"""Validate the LibSpellDB release archive and its source contract."""

from __future__ import annotations

import argparse
import hashlib
import re
import sys
from pathlib import Path, PurePosixPath
from zipfile import BadZipFile, ZipFile


ADDON = "LibSpellDB"
BLOCKED_DIRECTORIES = {".agents", ".claude", ".git", ".github", "tools"}
BLOCKED_FILES = {
    ".gitignore",
    "agents.md",
    "claude.md",
    "readme.md",
    "skill.md",
    "todo.md",
}
TOC_VERSION_RE = re.compile(r"^## Version:\s*(\S+)\s*$", re.MULTILINE)
LIB_MINOR_RE = re.compile(r'local MAJOR, MINOR = "LibSpellDB-1\.0",\s*(\d+)')


def normalized_parts(archive_path: str) -> tuple[str, ...]:
    return PurePosixPath(archive_path.replace("\\", "/")).parts


def is_blocked(archive_path: str) -> bool:
    folded = tuple(part.casefold() for part in normalized_parts(archive_path))
    return (
        bool(BLOCKED_DIRECTORIES.intersection(folded))
        or (bool(folded) and folded[-1] in BLOCKED_FILES)
        or (len(folded) >= 2 and folded[1] == "tools")
    )


def find_archive(inputs: list[str]) -> Path:
    archives: set[Path] = set()
    for raw_path in inputs:
        path = Path(raw_path)
        if path.is_file() and path.suffix.casefold() == ".zip":
            archives.add(path)
        elif path.is_dir():
            archives.update(path.rglob("*.zip"))
        else:
            raise FileNotFoundError(f"Package path not found: {path}")
    if len(archives) != 1:
        raise ValueError(f"Expected exactly one package zip, found {len(archives)}.")
    return next(iter(archives))


def parse_toc_version(text: str, label: str) -> str:
    match = TOC_VERSION_RE.search(text)
    if not match:
        raise ValueError(f"No Version metadata found in {label}.")
    return match.group(1)


def parse_minor(text: str, label: str) -> int:
    match = LIB_MINOR_RE.search(text)
    if not match:
        raise ValueError(f"No LibSpellDB LibStub minor found in {label}.")
    return int(match.group(1))


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as stream:
        for chunk in iter(lambda: stream.read(1024 * 1024), b""):
            digest.update(chunk)
    return digest.hexdigest()


def validate_archive(archive: Path, source_root: Path) -> list[str]:
    errors: list[str] = []
    with ZipFile(archive) as package:
        names = [name for name in package.namelist() if not name.endswith("/")]

        blocked = sorted(name for name in names if is_blocked(name))
        errors.extend(f"source-only entry is packaged: {name}" for name in blocked)

        unsafe = [
            name
            for name in names
            if not normalized_parts(name)
            or ".." in normalized_parts(name)
            or name.startswith(("/", "\\"))
        ]
        errors.extend(f"unsafe archive path: {name}" for name in unsafe)

        roots = {normalized_parts(name)[0] for name in names if normalized_parts(name)}
        if roots != {ADDON}:
            errors.append(f"expected only the {ADDON} archive root, found: {sorted(roots)}")

        toc_name = f"{ADDON}/{ADDON}.toc"
        core_name = f"{ADDON}/Core/LibSpellDB.lua"
        for required in (toc_name, core_name):
            if required not in names:
                errors.append(f"required file is missing: {required}")
        if errors:
            return errors

        source_toc = (source_root / "LibSpellDB.toc").read_text(encoding="utf-8-sig")
        source_core = (source_root / "Core/LibSpellDB.lua").read_text(encoding="utf-8-sig")
        archive_toc = package.read(toc_name).decode("utf-8-sig")
        archive_core = package.read(core_name).decode("utf-8-sig")

        source_version = parse_toc_version(source_toc, "source LibSpellDB.toc")
        archive_version = parse_toc_version(archive_toc, toc_name)
        if archive_version != source_version:
            errors.append(
                f"archive version {archive_version} does not match source {source_version}"
            )

        source_minor = parse_minor(source_core, "source Core/LibSpellDB.lua")
        archive_minor = parse_minor(archive_core, core_name)
        if archive_minor != source_minor:
            errors.append(
                f"archive LibStub minor {archive_minor} does not match source {source_minor}"
            )

        changelog = (source_root / "CHANGELOG.md").read_text(encoding="utf-8-sig")
        if f"## [{source_version}]" not in changelog:
            errors.append(f"source changelog has no entry for {source_version}")

    return errors


def main(argv: list[str]) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("inputs", nargs="+", help="Zip archive or directory containing it.")
    parser.add_argument("--source-root", default=".")
    args = parser.parse_args(argv)

    try:
        archive = find_archive(args.inputs)
        errors = validate_archive(archive, Path(args.source_root).resolve())
    except (
        BadZipFile,
        FileNotFoundError,
        KeyError,
        OSError,
        UnicodeDecodeError,
        ValueError,
    ) as error:
        print(f"Package validation failed: {error}", file=sys.stderr)
        return 1

    if errors:
        print(f"Package validation failed for {archive}:", file=sys.stderr)
        for error in errors:
            print(f"  - {error}", file=sys.stderr)
        return 1

    print(f"Package OK: {archive.name} sha256={sha256(archive)}")
    print("Package boundary and release contract OK.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main(sys.argv[1:]))
