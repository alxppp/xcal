# Xcal

Create anonymous ASCII calendars to paste in your email.

Calendars are pulled from macOS' system calendar, so it works with iCloud, Google, Facebook, or any other WebDAV feed.

## Usage

```
$ xcal -h
Usage: xcal [options] [startdate [enddate]]
    -b, --begin-time=TIME            Time day starts at, default: 08:00
    -e, --end-time=TIME              Time day ends at, default: 19:59
    -s, --step-size=MINUTES          Step size that time proceeds with, default: 60
    -w, --day-width=CHARS            Width of one day in characters, default: 6
    -t, --theme=THEMENAME            Available themes: ascii, lines, courier, courier_x; default: courier_x
    -d, --hide-weekday               Hide name of weekday, default: off
    -n, --show-event-name            Prints the name of each event, default: off
    -h, --help                       Prints this help
```

## Themes

**courier_x**
```
      ║ Mon  ║ Tue  ║ Wed  ║ Thu  ║ Fri  ║ Sat  ║ Sun  
      ║16.10.║17.10.║18.10.║19.10.║20.10.║21.10.║22.10.
══════╬══════╬══════╬══════╬══════╬══════╬══════╬══════
08:00 ║      ║      ║      ║      ║      ║      ║      
09:00 ║      ║      ║      ║      ║      ║      ║      
10:00 ║XXXXXX║      ║      ║      ║      ║      ║      
11:00 ║      ║XXXXXX║      ║      ║      ║      ║      
══════╬══════╬══════╬══════╬══════╬══════╬══════╬══════
12:00 ║XXXXXX║      ║XXXXXX║      ║      ║      ║      
13:00 ║XXXXXX║XXXXXX║      ║XXXXXX║      ║      ║      
14:00 ║XXXXXX║XXXXXX║      ║      ║      ║      ║      
15:00 ║XXXXXX║XXXXXX║      ║      ║      ║      ║      
══════╬══════╬══════╬══════╬══════╬══════╬══════╬══════
16:00 ║      ║XXXXXX║      ║      ║      ║      ║      
17:00 ║XXXXXX║XXXXXX║      ║XXXXXX║      ║      ║      
18:00 ║      ║XXXXXX║      ║XXXXXX║      ║      ║      
19:00 ║      ║XXXXXX║XXXXXX║XXXXXX║      ║      ║      
```

**lines**
```
      ┃ Mon  ┃ Tue  ┃ Wed  ┃ Thu  ┃ Fri  ┃ Sat  ┃ Sun  
      ┃16.10.┃17.10.┃18.10.┃19.10.┃20.10.┃21.10.┃22.10.
━━━━━━╋━━━━━━╇━━━━━━╇━━━━━━╇━━━━━━╇━━━━━━╇━━━━━━╇━━━━━━
08:00 ┃      │      │      │      │      │      │      
09:00 ┃      │      │      │      │      │      │      
10:00 ┃▓▓▓▓▓▓│      │      │      │      │      │      
11:00 ┃      │▓▓▓▓▓▓│      │      │      │      │      
━━━━━━╉──────┼──────┼──────┼──────┼──────┼──────┼──────
12:00 ┃▓▓▓▓▓▓│      │▓▓▓▓▓▓│      │      │      │      
13:00 ┃▓▓▓▓▓▓│▓▓▓▓▓▓│      │▓▓▓▓▓▓│      │      │      
14:00 ┃▓▓▓▓▓▓│▓▓▓▓▓▓│      │      │      │      │      
15:00 ┃▓▓▓▓▓▓│▓▓▓▓▓▓│      │      │      │      │      
━━━━━━╉──────┼──────┼──────┼──────┼──────┼──────┼──────
16:00 ┃      │▓▓▓▓▓▓│      │      │      │      │      
17:00 ┃▓▓▓▓▓▓│▓▓▓▓▓▓│      │▓▓▓▓▓▓│      │      │      
18:00 ┃      │▓▓▓▓▓▓│      │▓▓▓▓▓▓│      │      │      
19:00 ┃      │▓▓▓▓▓▓│▓▓▓▓▓▓│▓▓▓▓▓▓│      │      │      
```

**ascii**
```
      | Mon  | Tue  | Wed  | Thu  | Fri  | Sat  | Sun  
      |16.10.|17.10.|18.10.|19.10.|20.10.|21.10.|22.10.
------+------+------+------+------+------+------+------
08:00 |      |      |      |      |      |      |      
09:00 |      |      |      |      |      |      |      
10:00 |XXXXXX|      |      |      |      |      |      
11:00 |      |XXXXXX|      |      |      |      |      
------+------+------+------+------+------+------+------
12:00 |XXXXXX|      |XXXXXX|      |      |      |      
13:00 |XXXXXX|XXXXXX|      |XXXXXX|      |      |      
14:00 |XXXXXX|XXXXXX|      |      |      |      |      
15:00 |XXXXXX|XXXXXX|      |      |      |      |      
------+------+------+------+------+------+------+------
16:00 |      |XXXXXX|      |      |      |      |      
17:00 |XXXXXX|XXXXXX|      |XXXXXX|      |      |      
18:00 |      |XXXXXX|      |XXXXXX|      |      |      
19:00 |      |XXXXXX|XXXXXX|XXXXXX|      |      |      
```
