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

# mechanics

Both scrips adopt a strategy of scanning the text for markers, such as chapter and section headings, then processing the marker and the text found between them. 
The `part.rb` script identifies markers as lines containing all uppercase letters and then uses case logic to customize subsequent handling.
The `toc.rb` script increases the specificity of scans by looking for each of part, chapter and section in turn and then applying the more specific scan to only the text found between the outer markers.

The nested structure of the markers is mirrored by the nested control flow in the `toc.rb` script.
We define a function that divides the text based on a marker and then yields (callback) to the nested code that then further divides the yielded text.

The nested control flow has worked well enough that were we to do this work again we would probably code one script that read the entire document using an even more deeply nested version of the same loops.
We recognize that our initial manual division of the text into separate files of consistent format is just a crude and non-reproducable version of what we are now doing with the `divide` abstraction.

One unexpected improvement of our `divide` mechanism involves the handling of a small fragment of text before the first instance of a marker.
The author uses these words to establish the goals or context of what follows.
We handle this separately from the yielded text by passing into `divide` the parent and grand-parent pages that are not quite complete until these words have been added to them.
