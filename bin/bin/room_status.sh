#!/usr/bin/env bash
#
# Stripped-down VC-4 lookup: given a room id (ProgramInstanceId, e.g. "SE2270"),
# list the devices assigned to it and whether each is connected.
#
# Usage:
#   VC4_SERVER=... VC4_WEB_USER=... VC4_WEB_PASS=... ./room_status.sh SE2270
#   ./room_status.sh --server edw-vc4.isg.siue.edu --web-user U --web-pass P SE2270
#
# A "room" is not its own VC-4 API resource -- it's the ProgramInstanceId that
# devices in /DeviceMap are grouped under. DeviceMap only covers paired
# devices though (it misses things like offline RoomView-discovered
# displays), so this also queries the status WebApi's IpTableEntryByPID,
# which has the full IPID table, and merges the two. Both live under VC-4's
# undocumented status WebApi (VC-4 web console login, i.e. Basic auth --
# not the config/api token).
#
# Requires: curl, jq
# Credentials (or set via flags/env): pass entries crestron/vc4/host,
# work/username, work/password

set -euo pipefail

usage() {
    cat <<EOF
Usage: $(basename "$0") [--server SERVER] [--web-user USER] [--web-pass PASS] [--insecure] ROOM_ID

  ROOM_ID       Room / ProgramInstanceId, e.g. SE2270
  --server      VC-4 host (or set VC4_SERVER)
  --web-user    VC-4 web console username (or set VC4_WEB_USER)
  --web-pass    VC-4 web console password (or set VC4_WEB_PASS)
  --insecure    Disable TLS verification
EOF
}

server="${VC4_SERVER:-}"
web_user="${VC4_WEB_USER:-}"
web_pass="${VC4_WEB_PASS:-}"
insecure=0
room_id=""

while [[ $# -gt 0 ]]; do
    case "$1" in
        --server)
            server="$2"
            shift 2
            ;;
        --web-user)
            web_user="$2"
            shift 2
            ;;
        --web-pass)
            web_pass="$2"
            shift 2
            ;;
        --insecure)
            insecure=1
            shift
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        *)
            if [[ -n "$room_id" ]]; then
                echo "Unexpected argument: $1" >&2
                usage >&2
                exit 2
            fi
            room_id="$1"
            shift
            ;;
    esac
done

if [[ -z "$room_id" ]]; then
    echo "Need ROOM_ID" >&2
    usage >&2
    exit 2
fi

if [[ -z "$server" ]]; then
    server="$(pass show crestron/vc4/host 2>/dev/null | head -n1)" || true
fi
if [[ -z "$web_user" ]]; then
    web_user="$(pass show work/username 2>/dev/null | head -n1)" || true
fi
if [[ -z "$web_pass" ]]; then
    web_pass="$(pass show work/password 2>/dev/null | head -n1)" || true
fi

if [[ -z "$server" ]]; then
    echo "Need --server/VC4_SERVER (or 'pass' entry crestron/vc4/host)" >&2
    exit 2
fi
if [[ -z "$web_user" || -z "$web_pass" ]]; then
    echo "Need --web-user/VC4_WEB_USER and --web-pass/VC4_WEB_PASS (or 'pass' entries work/username and work/password)" >&2
    exit 2
fi

if [[ "$server" != http* ]]; then
    server="https://${server}"
fi
server="${server%/}"

curl_opts=(-sS -f --max-time 30 -u "${web_user}:${web_pass}" -H "Accept: application/json")
if [[ "$insecure" -eq 1 ]]; then
    curl_opts+=(-k)
fi

devicemap="$(curl "${curl_opts[@]}" "${server}/VirtualControl/config/status/WebApi/DeviceMap")"
iptable="$(curl "${curl_opts[@]}" "${server}/VirtualControl/config/status/WebApi/IpTableEntryByPID/${room_id}")"

rows="$(jq -rn --arg room "$room_id" --argjson devicemap "$devicemap" --argjson iptable "$iptable" '
    [$devicemap.Device.Programs.DeviceMapLibrary
        | to_entries[]
        | .value
        | select(.ProgramInstanceId == $room)] as $dm
    | (reduce $dm[] as $d ({}; .[$d.ProgramIpId | tostring] //= $d))
    as $byIpid
    | $iptable.Device.Programs.IpTableEntryByPID
    | sort_by(.ProgramIpId // 0)
    | .[]
    | . as $e
    | ($byIpid[$e.ProgramIpId | tostring]) as $d
    | [
        ($d.Hostname // ""),
        ($d.Model // $e.Model // ""),
        (($e.ProgramIpId // "") | tostring),
        ($d.MacAddress // ""),
        ($e.Status // "")
      ]
    | @tsv
')"

if [[ -z "$rows" ]]; then
    echo "No devices found for room '${room_id}'"
    exit 1
fi

{
    printf 'Hostname\tModel\tIPID\tMAC\tStatus\n'
    printf '%s\n' "$rows"
} | column -t -s $'\t'
