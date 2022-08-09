# ics2hugo

This will convert any [ics calendar][ics] url into an `events.md` file
which can be imported into a [Hugo website][hugo]. It will contain only
upcoming events.

Example:

```py
python ics2hugo.py --url "https://example.org/calendar.ics" --path ~/path/to/hugo/content/calendar
```

If you want *all* events in *separate* markdown files (like in [the
origin repository][origin]), just remove the `#` at the beginning of
some lines in `ics2hugo.py`.

[hugo]: https://gohugo.io
[ics]: https://en.wikipedia.org/wiki/ICalendar
[origin]: https://github.com/tomluvoe/ics2hugo
