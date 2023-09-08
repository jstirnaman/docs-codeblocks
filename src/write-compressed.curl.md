 # Example: Write compressed data

```sh
echo "mem,host=host1 used_percent=23.43234543 1641024000
mem,host=host2 used_percent=26.81522361 1641027600
mem,host=host1 used_percent=22.52984738 1641031200
mem,host=host2 used_percent=27.18294630 1641034800" | gzip > system.gzip

curl -s -o /dev/null -w "%{http_code}\n" "https://{{< influxdb/host >}}/api/v2/write?bucket=DATABASE_NAME&precision=s" \
--header "Authorization: Token DATABASE_TOKEN" \
--header "Content-Type: text/plain; charset=utf-8" \
--header "Content-Encoding: gzip" \
--data-binary @system.gzip
```

If successful, InfluxDB responds with status `204` and `curl` exits with status `0`:

<!--pytest-codeblocks:expected-output-->

```
204
```

