function flush_dns -d "Flush DNS Cache"
  if type -q /usr/bin/dscacheutil
    /usr/bin/dscacheutil -flushcache
  else if type -q /usr/bin/resolvectl
    sudo /usr/bin/resolvectl flush-caches
  else
    echo "I don't know how"
  end
end
