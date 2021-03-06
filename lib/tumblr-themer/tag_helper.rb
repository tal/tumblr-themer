module TumblrThemer::TagHelper
  module InstanceMethods
    def tag name
      blk = self.class.tags[name]

      instance_exec(self,&blk)
    end

    def block name
      instance_exec(self,&blk)
    end

    def boolify val
      if !val
        false
      elsif val.respond_to?(:empty?) && val.empty?
        false
      else
        true
      end
    end

    # File activesupport/lib/active_support/inflector/methods.rb, line 77
    def underscore(camel_cased_word)
      word = camel_cased_word.to_s.dup
      word.gsub!(/::/, '/')
      word.gsub!(/([A-Z\d]+)([A-Z][a-z])/,'\1_\2')
      word.gsub!(/([a-z\d])([A-Z])/,'\1_\2')
      word.tr!("-", "_")
      word.downcase!
      word
    end

    # File activesupport/lib/active_support/inflector/methods.rb, line 55
    def camelize(term)
      string = term.to_s
      string = string.sub(/^[a-z\d]*/) { $&.capitalize }
      string.gsub(/(?:_|(\/))([a-z\d]*)/) { "#{$1}#{$2.capitalize}" }.gsub('/', '::')
    end

    def tags
      self.class.tags
    end

    def blocks
      self.class.blocks
    end

    def tag_iterators
      self.class.tag_iterators
    end

    def render_blocks html=nil
      html ||= self.html
      blocks.each do |name,blk|
        html.block(name,instance_exec(self,&blk))
      end
    end

    def render_tags html=nil
      html ||= self.html
      tags.each do |name, blk|
        html.tag(name,instance_exec(self,&blk))
      end
    end

  end

  module ClassMethods
    def tags
      @tags ||= {}
    end

    def tag name, data_name=nil, &blk
      blk ||= Proc.new { data[data_name||underscore(name)] }
      tags[name] = blk
    end

    def for_each name, klass, &blk
      tag_iterators[name] = {:klass => klass, :blk => blk}
    end

    def tag_iterators
      @tag_iterators ||= {}
    end

    def blocks
      @blocks ||= {}
    end

    def block name, data_name=nil, &blk
      blk ||= Proc.new { boolify(data[data_name||underscore(name)]) }
      blocks[name] = blk
    end

    def block_tag name, data_name=nil
      block(name,data_name)
      tag(name,data_name)
    end

    def inherited subklass
      subklass.instance_variable_set(:@tags,@tags.dup)
      subklass.instance_variable_set(:@blocks,@blocks.dup)
      subklass.instance_variable_set(:@tag_iterators,@tag_iterators.dup)
    end
  end

  def self.included subklass
    subklass.send :include, InstanceMethods
    subklass.extend ClassMethods
  end
end
