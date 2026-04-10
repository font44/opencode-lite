---
name: fetch-website-in-markdown
description: Fetch website content as markdown.
---

If you want to fetch content for https://example.com, first try:

```sh
curl defuddle.md/example.com
```

If that doesn't work:

```sh
curl -sS https://markdown.new/ -H 'Content-Type: application/json' -d '{"url":"https://example.com"}'
```
