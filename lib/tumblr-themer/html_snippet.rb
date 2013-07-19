class TumblrThemer::HtmlSnippet
  attr_reader :str

  def initialize(str)
    @str = str.dup
  end

  def self.tag str, key, val
    str.gsub! "{#{key}}", val.to_s
  end

  def tag key, val
    self.class.tag str, key, val
  end

  def block _type, tf=true
    self.class.block str, _type, tf
  end

  def self.block str, _type, tf=true
    regex = Regexp.new("{block:#{_type}}(.*?){/block:#{_type}}",Regexp::MULTILINE)

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
