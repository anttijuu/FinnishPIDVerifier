 swift package --allow-writing-to-directory docs \
    generate-documentation --target FinnishPIDVerifier \
    --disable-indexing \
    --transform-for-static-hosting \
    --hosting-base-path FinnishPIDVerifier \
    --output-path docs
