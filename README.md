# ics2hugo

This will convert any [ics calendar][ics] url into an `events.md` file
which can be imported into a [Hugo website][hugo]. It will contain only
upcoming events.

There are two versions: Bash and Python.

## Bash

This requires [icsp][].

Example:

```bash
bash ics2hugo.sh -u "https://example.org/calendar.ics" -p ~/path/to/hugo/content/calendar
```

## Python

Example:

```py
python ics2hugo.py --url "https://example.org/calendar.ics" --path ~/path/to/hugo/content/calendar
```

If you want *all* events in *separate* markdown files (like in [the
origin repository][origin]), just remove the `#` at the beginning of
some lines in `ics2hugo.py`.

### Upgrade python and dependencies

```bash
pyenv install --list
pyenv install $latest_version
pip install -r requirements.txt
cat requirements.txt | cut -f1 -d= | xargs pip install -U
pip freeze >requirements.txt
```

[hugo]: https://gohugo.io
[ics]: https://en.wikipedia.org/wiki/ICalendar
[icsp]: https://github.com/loteoo/icsp
[origin]: https://github.com/tomluvoe/ics2hugo
