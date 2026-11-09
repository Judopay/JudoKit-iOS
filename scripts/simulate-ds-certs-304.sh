#!/usr/bin/env bash
#
# simulate-ds-certs-304.sh
#
# Ages the SDK's cached 3DS2 DS-certificate bundle so the next payment-screen
# prefetch treats it as stale and issues a *conditional* request
# (If-None-Match / If-Modified-Since). If the CDN content is unchanged the
# server answers 304 Not Modified and the repository just bumps `fetchedAt`
# while keeping the cached entries — which is the path this script lets you
# exercise on the iOS Simulator without waiting out the 24h TTL.
#
# The cache lives under the key "judokit_ds_certs_v1" as a JSON blob inside
# the dedicated "com.judopay.judokit.dscerts" NSUserDefaults suite (see
# JPDsCertificatesCacheStore) — not the app's standard defaults domain, so it
# survives a host-app defaults wipe. NSUserDefaults for a sandboxed simulator
# app is backed by a plist inside the app's own container — it is NOT
# reachable through the plain `defaults`/cfprefsd CLI from outside the
# sandbox (that talks to the simulator's un-sandboxed default domain, which
# is a different store) — so this edits the container's Preferences plist
# directly with `plutil -extract`/`-replace`, which understands NSData
# values natively (base64 in, base64 out) and rewrites the file in place.
#
# Requires: a Simulator booted with the examples app installed, and Xcode
# command line tools (xcrun/plutil) on PATH.
# Pure bash + xcrun/plutil/base64 — no perl/python/jq.
#
# Usage:
#   scripts/simulate-ds-certs-304.sh                # age cache (fetchedAt = 0)
#   scripts/simulate-ds-certs-304.sh 1700000000      # set fetchedAt to given epoch-seconds
#   scripts/simulate-ds-certs-304.sh show            # print current cache metadata
#   UDID=<udid> BUNDLE_ID=com.example.app scripts/simulate-ds-certs-304.sh
#
set -euo pipefail

BUNDLE_ID="${BUNDLE_ID:-com.judo.JudoPayDemoObjC}"
SUITE_NAME="com.judopay.judokit.dscerts"
CACHE_KEY="judokit_ds_certs_v1"
ARG="${1:-0}"

die() { echo "error: $*" >&2; exit 1; }

command -v xcrun >/dev/null || die "xcrun not found on PATH"

# --- resolve the target simulator -------------------------------------------
if [ -n "${UDID:-}" ]; then
    resolved_udid="$UDID"
else
    booted="$(xcrun simctl list devices booted)"
    count="$(printf '%s\n' "$booted" | grep -c "(Booted)" || true)"
    [ "$count" -gt 0 ] || die "no booted simulator found (see: xcrun simctl list devices booted; set UDID to pick one)"
    [ "$count" -eq 1 ] || die "more than one booted simulator; set UDID to pick one:
$(printf '%s\n' "$booted" | grep "(Booted)")"
    resolved_udid="$(printf '%s\n' "$booted" | grep "(Booted)" | sed -E 's/.*\(([-0-9A-F]+)\) \(Booted\).*/\1/')"
fi

# --- locate the app's Preferences plist -------------------------------------
data_container="$(xcrun simctl get_app_container "$resolved_udid" "$BUNDLE_ID" data 2>/dev/null)" \
    || die "package '$BUNDLE_ID' is not installed on simulator $resolved_udid"

PREFS="$data_container/Library/Preferences/$SUITE_NAME.plist"
[ -f "$PREFS" ] || die "no preferences file for suite '$SUITE_NAME' yet ($PREFS).
Run a card payment in the app once so the SDK fetches and caches the certs, then re-run."

# Pull one JSON scalar out of $CONTENT. $1 = key name. Echoes the value, or
# nothing if absent. Handles backslash-escaped quotes inside string values
# (ETags are often themselves quoted, e.g. "etag":"\"abc123\"").
json_scalar() {
    local key="$1" re
    re="\"$key\"[[:space:]]*:[[:space:]]*\"((\\\\.|[^\"\\\\])*)\""
    if [[ $CONTENT =~ $re ]]; then printf '%s\n' "${BASH_REMATCH[1]}"; return; fi
    re="\"$key\"[[:space:]]*:[[:space:]]*(-?[0-9]+)"
    if [[ $CONTENT =~ $re ]]; then printf '%s\n' "${BASH_REMATCH[1]}"; fi
}

show_meta() {
    local k v
    for k in etag lastModified fetchedAt maxAge; do
        v="$(json_scalar "$k")"
        printf '  %-13s %s\n' "$k" "${v:-<absent>}"
    done
}

# --- load current cache ------------------------------------------------------
B64="$(plutil -extract "$CACHE_KEY" raw -expect data "$PREFS" 2>/dev/null || true)"
[ -n "$B64" ] || die "DS-cert cache not found or empty (key '$CACHE_KEY' in $PREFS).
Run a card payment in the app once so the SDK fetches and caches the certs, then re-run."

CONTENT="$(printf '%s' "$B64" | base64 -D)"
[ -n "$CONTENT" ] || die "failed to decode cached DS-cert blob"

if [ "$ARG" = "show" ]; then
    echo "current DS-cert cache ($BUNDLE_ID on $resolved_udid):"
    show_meta
    exit 0
fi

case "$ARG" in
    ''|*[!0-9]*) die "fetchedAt must be an epoch-seconds integer (or 'show'); got '$ARG'" ;;
esac

CURRENT="$(json_scalar fetchedAt)"
[ -n "$CURRENT" ] || die "could not find 'fetchedAt' in cached blob — cache JSON layout may have shifted"

echo "before:"
show_meta

# --- stop the app so the edit is not masked by its in-memory prefs ---------
echo "> terminating $BUNDLE_ID"
xcrun simctl terminate "$resolved_udid" "$BUNDLE_ID" >/dev/null 2>&1 || true

# --- rewrite fetchedAt -------------------------------------------------------
NEW_CONTENT="$(printf '%s' "$CONTENT" | sed -E "s/\"fetchedAt\":${CURRENT}/\"fetchedAt\":${ARG}/")"
[ "$NEW_CONTENT" != "$CONTENT" ] || die "rewrite produced no change — cache JSON layout may have shifted"

# --- write it back directly into the container's Preferences plist ---------
echo "> writing $PREFS"
NEW_B64="$(printf '%s' "$NEW_CONTENT" | base64)"
plutil -replace "$CACHE_KEY" -data "$NEW_B64" "$PREFS"

# --- verify ------------------------------------------------------------------
B64="$(plutil -extract "$CACHE_KEY" raw -expect data "$PREFS" 2>/dev/null || true)"
CONTENT="$(printf '%s' "$B64" | base64 -D)"
got="$(json_scalar fetchedAt)"
[ "$got" = "$ARG" ] || die "write-back verification failed (fetchedAt is '$got', expected '$ARG')"
echo "after:"
show_meta

cat <<EOF

Done. fetchedAt = ${ARG} (stale).

Next: open the app and start a card payment. On the payment screen the DS-cert
prefetch runs, sees a stale cache and sends:
    If-None-Match: <etag>
    If-Modified-Since: <lastModified>
Unchanged CDN content -> HTTP 304 -> entries kept, fetchedAt bumped to ~now.

Watch the '.../judokit/ds-certs' call in your proxy of choice, then verify with:
    scripts/simulate-ds-certs-304.sh show
EOF
