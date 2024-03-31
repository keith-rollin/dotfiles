#!/usr/bin/env python3

import argparse
import calendar
import dataclasses
import pathlib
import re
import sys
from typing import Callable, Generator

RenamePair = tuple[pathlib.Path, pathlib.Path]

YEAR = r"(?P<YEAR>20[1-3][0-9])"
MONTH = r"(?P<MONTH>[0-1][0-9])"
DAY = r"(?P<DAY>[0-3][0-9])"

DIG1 = "[0-9]{1}"
DIG3 = "[0-9]{3}"
# DIG4 = "[0-9]{4}"
DAY2 = f"(?P<DAY2>[0-3]{DIG1})"
MON2 = f"(?P<MON2>[0-1]{DIG1})"
# YEAR2 = f"(?P<YEAR2>[1-3]{DIG1})"
YEAR4 = f"(?P<YEAR4>20[1-3]{DIG1})"
ACCT3 = f"(?P<ACCT3>{DIG3})"
# ACCT4 = f"(?P<ACCT4>{DIG4}"
# FORM4 = f"(?P<DESC4>{DIG4}"
# DESC = "(?P<DESC>[a-z][a-z ]*[a-z])"
# OPT_DUPE = r"(?P<OPT_DUPE>( \(.*\))?)"


MONTH_NAMES = list(calendar.month_name)


@dataclasses.dataclass
class RenameData:
    path: pathlib.Path  # Directory containing the files to be renamed
    renamer: Callable  # Function to rename the files
    unchanged_pattern: str  # Match the original name
    changed_pattern: str | None  # Match the new name
    replacement: str | None  # Replacement for the new name


def fname(f: pathlib.Path) -> str:
    return f"{f.parent.name}/{f.name}"


# Function to generate a list of files to be renamed. This operation is bottle-necked so
# that we can monkey-patch it for testing.
#
def produce_files(path: pathlib.Path) -> Generator[pathlib.Path, None, None]:
    if not path.is_dir():
        print(f"### Directory not found: {path}", file=sys.stderr)
        return

    yield from path.glob("*.pdf", case_sensitive=False)


# Given a file path, a regular expression to detect files that have already been
# renamed, a regular expression to detect files that have not been renamed, and a
# replacement string, rename the file if it has not already been renamed.
#
def std_renamer(
    f: pathlib.Path,
    unchanged_regex: re.Pattern,
    changed_regex: re.Pattern,
    replacement: str,
) -> RenamePair | None:
    if changed_regex and changed_regex.match(f.name):
        return None

    new_name = unchanged_regex.sub(replacement, f.name)
    if new_name == f.name:
        print(f"... Skipping non-matching file: {fname(f)}")
        return None

    return (f, f.with_name(new_name))


# Iterate over the files in the given directory and rename them according to the
# provided regular expression and replacement string.
#
def rename_common(data: RenameData) -> list[RenamePair]:
    flags = re.IGNORECASE
    unchanged_regex = re.compile(data.unchanged_pattern, flags)
    changed_regex = data.changed_pattern and re.compile(data.changed_pattern, flags)
    return [
        f2
        for f in produce_files(data.path)
        if (f2 := data.renamer(f, unchanged_regex, changed_regex, data.replacement))
    ]


def rename_apple(root) -> list[RenamePair]:
    def apple_renamer(f, unchanged_regex, changed_regex, _):
        if changed_regex.match(f.name):
            return None

        m = unchanged_regex.match(f.name)
        if not m:
            print(f"... Skipping non-matching file: {fname(f)}")
            return None

        try:
            month_index = MONTH_NAMES.index(m.group("MONTH"))
        except ValueError:
            print(f"... Skipping file with unknown month: {fname(f)}")
            return None

        new_name = f"{m.group("PREFIX")} - {m.group("YEAR")}-{month_index:02}.pdf"
        return (f, f.with_name(new_name))

    return rename_common(
        RenameData(
            root / "Apple Card",
            apple_renamer,
            # Apple Card Statement - April 2020.pdf
            rf"(?P<PREFIX>Apple Card Statement) - (?P<MONTH>[a-z]+) {YEAR}\.pdf",
            rf"Apple Card Statement - {YEAR}-{MONTH}.pdf",
            None,
        )
    )


def rename_bofa(_) -> list[RenamePair]:
    # These are already in the right format: eStmt_2024-02-16.pdf
    return []


def rename_chase(root) -> list[RenamePair]:
    return rename_common(
        RenameData(
            root / "Chase",
            std_renamer,
            # 2024'03'16-statements-5033-.pdf
            rf"{YEAR}{MONTH}{DAY}-(?P<PREFIX>.*)-5033.*\.pdf",
            rf".*-{YEAR}-{MONTH}-{DAY}.pdf",
            r"\g<PREFIX>-\g<YEAR>-\g<MONTH>-\g<DAY>.pdf",
        )
    )


def rename_farmers(_) -> list[RenamePair]:
    # These are all downloaded with the same name, so I give them a name in the right
    # format at that time. TODO: Look inside the PDF and generate an appropriate name
    # from that, regardless of its current name.
    return []


def rename_kaiser(_) -> list[RenamePair]:
    # These are already in the right format: Kaiser Physician Bill 2024-01-19.pdf
    return []


def rename_pge(root) -> list[RenamePair]:
    return rename_common(
        RenameData(
            root / "PG&E",
            std_renamer,
            # 8897custbill'12'04'2023.pdf
            rf"(?P<PREFIX>.*custbill){MONTH}{DAY}{YEAR}\.pdf",
            rf".*-{YEAR}-{MONTH}-{DAY}.pdf",
            r"\g<PREFIX>-\g<YEAR>-\g<MONTH>-\g<DAY>.pdf",
        )
    )


def rename_phh(_) -> list[RenamePair]:
    # These are all downloaded with the same name, so I give them a name in the right
    # format at that time. TODO: Look inside the PDF and generate an appropriate name
    # from that, regardless of its current name.
    return []


def rename_schwab(root) -> list[RenamePair]:
    results = []

    # results += rename_common(
    #     # 1099CompositeandYearEndSummary 2019 02 07 20 1071.pdf
    #     root / "Schwab",
    #     std_renamer,
    #     rf"{DESC}{YEAR4}{MON2}{DAY2}{YEAR2}{ACCT4}{OPT_DUPE}\.pdf",
    #     None,
    #     r"20\g<YEAR2>-\g<MON2>-\g<DAY2>_\g<ACCT4>_\g<DESC>_\g<YEAR4>\g<OPT_DESC>.pdf",
    # )
    #
    # results += rename_common(
    #     # 5498 2020 05 22 21 0990.pdf
    #     root / "Schwab",
    #     std_renamer,
    #     rf"{FORM4}{YEAR4}{MON2}{DAY2}{YEAR2}{ACCT4}{OPT_DUPE}\.pdf",
    #     None,
    #     r"20\g<YEAR2>-\g<MON2>-\g<DAY2>_\g<ACCT4>_Form \g<FORM4>_\g<YEAR4>\g<OPT_DUPE>.pdf",
    # )
    #
    # results += rename_common(
    #     # BrokerageStatement 12 31 20 7033.pdf
    #     root / "Schwab",
    #     std_renamer,
    #     rf"{DESC}{MON2}{DAY2}{YEAR2}{ACCT4}{OPT_DUPE}\.pdf",
    #     None,
    #     r"20\g<YEAR2>-\g<MON2>-\g<DAY2>_\g<ACCT4>_\g<DESC>\g<OPT_DUPE>.pdf",
    # )

    results += rename_common(
        RenameData(
            root / "Schwab",
            std_renamer,
            # Brokerage Statement_2022-12-31_990.PDF
            rf"(?P<DESC>Brokerage ?Statement)_{YEAR4}-{MON2}-{DAY2}_{ACCT3}\.pdf",
            rf"{YEAR4}-{MON2}-{DAY2}_{ACCT3}_.*.pdf",
            r"\g<YEAR4>-\g<MON2>-\g<DAY2>_\g<ACCT3>_\g<DESC>.pdf",
        )
    )
    #
    # results += rename_common(
    #     # Brokerage Statement_2022-12-31_990.PDF
    #     root / "Schwab",
    #     std_renamer,
    #     rf"{DESC}_{YEAR4}-{MON2}-{DAY2}_{ACCT3}\.pdf",
    #     None,
    #     r"\g<YEAR2>-\g<MON2>-\g<DAY2>_\g<ACCT3>_\g<DESC>.pdf",
    # )

    return results


def rename_utilities(root) -> list[RenamePair]:
    return rename_common(
        RenameData(
            root / "Utilities",
            std_renamer,
            # eBill_01_25_2024.pdf
            rf"(?P<PREFIX>eBill)_{MONTH}_{DAY}_{YEAR}\.pdf",
            rf".*-{YEAR}-{MONTH}-{DAY}.pdf",
            r"\g<PREFIX>-\g<YEAR>-\g<MONTH>-\g<DAY>.pdf",
        )
    )


def main() -> int:
    parser = argparse.ArgumentParser(description="Rename financial statements")
    parser.add_argument("-n", "--dry-run", action="store_true", help="Dry run")
    parser.add_argument(
        "target",
        nargs="?",
        type=pathlib.Path,
        help="Statements directory "
        "(default: current directory or ~/Documents/Statements)",
    )
    args = parser.parse_args()

    if args.target:
        root = args.target
    elif (pathlib.Path.cwd() / "Schwab").is_dir():
        root = pathlib.Path.cwd()
    else:
        root = pathlib.Path.home() / "Documents" / "Statements"

    print(f"Renaming files in {root}")

    results = []
    results += rename_apple(root)
    results += rename_bofa(root)
    results += rename_chase(root)
    results += rename_farmers(root)
    results += rename_kaiser(root)
    results += rename_pge(root)
    results += rename_phh(root)
    results += rename_schwab(root)
    results += rename_utilities(root)

    results = sorted(results)

    if not results:
        print("No files to rename")
        return 0

    for old, new in results:
        print(f"{fname(old)} -> {fname(new)}")

    if args.dry_run:
        return 0

    x = input("Rename files? [y/N]: ")
    if not x or x.lower() == "n":
        print("Aborted")
        return 0

    for old, new in results:
        assert old.exists()
        assert not new.exists()

    for old, new in results:
        old.rename(new)
    # XATTR_NAME="com.phantomprogrammer.name.original"

    return 0


if __name__ == "__main__":
    sys.exit(main())


#
