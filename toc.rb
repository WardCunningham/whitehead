# translate table of contents
# usage: ruby toc.rb

require 'json'

@now = Time.now.to_i*1000
@pages = []

def asSlug title
  title.gsub(/\s/, '-').gsub(/[^A-Za-z0-9-]/, '').downcase
end

def divide p1, p2, regex, text
  key = nil
  text.split(regex).each do |item|
    unless key
      p1[:story].last[:text] += item if p1
      p2[:story].push(item(nil,item))
    end
    yield key, item if key && (key.match(regex.dup))
    key = item
  end
end

def title segs
  segs.join(' ').strip
    .sub(/PART/,'Part')
    .sub(/Chapter/,'Chapt')
    .sub(/Section/,'Sect')
    .gsub(/\./,'')
    .gsub(/  +/,' ')
    .sub(/^$/,'Table of Contents')
end

def page segs
  json = {
    title: title(segs),
    story: []
  }
  @pages.push(json)
  json
end

def item segs, more
  link = segs ? "[[#{title(segs)}]] — " : ''
  text = more
    .sub(/SECTION/,'')
    .sub(/Contents [xvi]+/,'')
  {
    type: 'paragraph',
    text: "#{link} #{text.strip.gsub(/- *\n/,'').gsub(/\n/,' ').gsub(/  +/,' ')}",
    id: (rand()*10000000000000000).to_i.to_s
  }
end

text = File.read('text/04.contents.txt')
toc = page([])

divide(nil, toc, /^(PART [IV]+)/, text) do |part, more|

  puts "1: #{part} #{more.length}"
  toc[:story].push(item([part],''))
  parts = page([part])

  divide(toc, parts, /^(Chapter [IV]+\.)/, more) do |chapt, more|

    puts "2: #{part} #{chapt} #{more.length}"
    parts[:story].push(item([part,chapt],''))
    chapts = page([part, chapt])

    divide(parts, chapts, /^([IV]+\.)/, more) do |sect, more|

      puts "3: #{part} #{chapt} Section #{sect} #{more.length}"
      chapts[:story].push(item([part,chapt,"Section #{sect}"],more))
    end
  end
end

# puts JSON.pretty_generate @pages
@pages.each do |page|
  page[:journal] = [{
    type: 'create',
    item: page.dup,
    date: @now
  }]
  File.open("/Users/ward/.wiki/white.localhost/pages/#{asSlug(page[:title])}",'w') do |file|
    file.puts JSON.pretty_generate(page)
  end
end
