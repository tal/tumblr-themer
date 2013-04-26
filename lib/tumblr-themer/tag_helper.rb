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
  end

  module ClassMethods
    def tags
      @tags ||= {}
    end

    def tag name, &blk
      tags[name] = blk
    end

    def blocks
      @blocks ||= {}
    end

    def block name, &blk
      blocks[name] = blk
    end

    def inherited subklass
      subklass.instance_variable_set(:@tags,@tags.dup)
      subklass.instance_variable_set(:@blocks,@blocks.dup)
    end
  end

  def self.included subklass
    subklass.send :include, InstanceMethods
    subklass.extend ClassMethods
  end
end
