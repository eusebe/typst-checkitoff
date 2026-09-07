#!/bin/bash
echo "🚀 Compiling Typst Equator..."
cd "$(dirname "$0")"

# Root is the parent "typst templates" directory, not this one: equator's
# own source now imports ../../typst-contexture/lib.typ (a sibling
# package, unpublished for now) directly, so the sandbox has to cover
# both directories. See CLAUDE.md, "Migration vers contexture".

status=0

# Tests requiring the bundle export (a subdirectory with its own
# main.typ) — both the default plain compile (manuscript.pdf +
# checklist.pdf) and the preview one (manuscript.pdf only, with
# check()'d passages highlighted — see src/pilot.typ for why preview
# never also builds the checklist).
#
# tests/bundle-strict-fail/ is the one deliberate exception: it exists
# specifically to prove that `strict: true` turns an uncovered item into a
# hard compile error, so a non-zero exit there is a pass, and a *zero*
# exit is the actual failure.
for dir in tests/bundle-*/; do
    file="${dir}main.typ"
    name="$(basename "$dir")"
    if [ -f "$file" ]; then
        if [ "$name" = "bundle-strict-fail" ]; then
            if typst compile --features bundle --format bundle --root .. "$file" 2>/dev/null; then
                echo "❌ $file: expected a strict-mode compile failure, but it compiled successfully"
                status=1
            else
                echo "✅ $file: failed to compile as expected (strict mode)"
            fi
            continue
        fi

        if ! typst compile --features bundle --format bundle --root .. "$file"; then
            echo "❌ $file (plain) failed to compile"
            status=1
        fi
        if ! typst compile --features bundle --format bundle --root .. --input preview=true "$file"; then
            echo "❌ $file (preview) failed to compile"
            status=1
        fi
    fi
done

exit $status
