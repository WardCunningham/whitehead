# translate parts i through v
# usage: ruby parts.rb

require 'json'

def asSlug title
  title.gsub(/\s/, '-').gsub(/[^A-Za-z0-9-]/, '').downcase
end

now = Time.now.to_i*1000

Dir.glob("text/*.part*.txt") do |filename|
  part = filename.sub(/text\/\d\d\./,'').sub(/\.txt/,'').sub(/\-/,' ').upcase
  text = File.read(filename)
  puts
  part = chapter = section = ''
  text.split(/^([A-Z ]+)$/).each_slice(2) do |body, sep|
    title = "#{part} #{chapter} #{section}".strip
      .sub(/PART/,'Part')
      .sub(/CHAPTER/,'Chapt')
      .sub(/SECTION/,'Sect')
      .sub(/DIAGRAMS/,'Diag')
      .gsub(/  +/,' ')
    unless sep.nil?
      if sep.match(/PART/)
        part = sep
        chapter = section = ''
      elsif sep.match(/CHAPTER/)
        chapter = sep
        section = ''
      elsif sep.match(/SECTION|DIAGRAMS/)
        section = sep
      else
        body = sep
      end
    end
    body = body.strip

    labels = Hash.new { |hash, key| hash[key] = 0 }
    body.gsub!(/\d+ (Discussions and Applications|The Speculative Scheme|The Theory of Extension|The Theory of Prehensions|Final Interpretation) *$/,'')
    body.gsub!(/^(Fact and Form|The Extensive Continuum|The Order of Nature|Organisms and Environment|Locke and Hume|From Descartes To Kant|The Subjectivist Principle|Symbolic Reference|The Propositions|Process|Speculative Philosophy|The Categoreal Scheme|Some Derivative Notions|Coordinate Division|Extensive Connection|Flat Loci|Strains|Measurement|The Theory of Feelings|The Primary Feelings|The Transmission of Feelings|Propositions and Feelings|The Higher Phases of Experience|Ideal Opposites) *\d+ *$/,'')
    # body.match(/(^.*\d+ *$)/) {|line| puts line}

    unless body.empty?
      # puts "[[#{title}]]"
      page = {
        title: title,
        story: []
      }
      body.split(/\n\n/).each do |para|
        unless para.empty?
          page[:story].push({
            type: 'paragraph',
            text: para.gsub(/- *\n/,'').gsub(/\n/,' '),
            id: (rand()*10000000000000000).to_i.to_s
          })
        end
      end
      page['journal'] = [{
        type: 'create',
        item: page.dup,
        date: now
      }]
      File.open("/Users/ward/.wiki/white.localhost/pages/#{asSlug(title)}","w") do |file|
        file.puts JSON.pretty_generate(page)
      end
    end
  end
end