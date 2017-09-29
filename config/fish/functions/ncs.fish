function ncs -d  "Use open ssl to nc to server on 443" -a HOST PORT
  test -n "$PORT"; or set PORT 443
  openssl s_client -connect $HOST:$PORT
end
