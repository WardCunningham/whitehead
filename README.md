# whitehead
Convert [archive.org](https://archive.org/stream/AlfredNorthWhiteheadProcessAndReality/Alfred%20North%20Whitehead%20-%20Process%20and%20Reality_djvu.txt) Whitehead text to wiki page json.

# build

Create the local wiki site `white.localhost` then run scripts to fill this with pages.

Read each part and construct part, chapter and section pages where
the bulk of the text is in sections and other pages provide basic navigaton.
```
ruby part.rb
```

Read the table of contents to rewrite the part and chapter pages with more navigational guidance.
```
ruby toc.rb
```

Create a public wiki site `anw.fed.wiki` then rsync json pages there.
```
sh sync.sh
```
