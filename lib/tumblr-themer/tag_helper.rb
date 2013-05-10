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
