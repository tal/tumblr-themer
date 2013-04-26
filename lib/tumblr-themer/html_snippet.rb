class TumblrThemer::HtmlSnippet
  attr_reader :str

  def initialize(str)
    @str = str.dup
  end

  def tag key, val
    # puts "tag, #{key.inspect}, #{val.inspect}"
    str.gsub! "{#{key}}", val.to_s
  end

  def block _type, tf=true
    regex = Regexp.new("{block:#{_type}}(.*){/block:#{_type}}",Regexp::MULTILINE)

    if tf
      if block_given?
        str.gsub!(regex) {yield($1)}
      else
        str.gsub!(regex, '\1')
      end
    else
      str.gsub!(regex, '')
    end
  end
end
