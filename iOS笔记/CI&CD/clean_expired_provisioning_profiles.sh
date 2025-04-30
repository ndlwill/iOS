for f in ~/Library/MobileDevice/Provisioning\ Profiles/*.mobileprovision; do
  EXPIRY=$(security cms -D -i "$f" | plutil -extract ExpirationDate xml1 -o - - | xmllint --xpath "//date/text()" - 2>/dev/null)
  if [[ -n "$EXPIRY" ]]; then
    EXPIRY_TS=$(date -j -f "%Y-%m-%dT%H:%M:%SZ" "$EXPIRY" +%s)
    NOW_TS=$(date +%s)
    if [[ $EXPIRY_TS -lt $NOW_TS ]]; then
      echo "Expired: $f (expired on $EXPIRY)"
      rm "$f"
    fi
  fi
done
