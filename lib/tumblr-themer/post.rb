class TumblrThemer::Post
  include TumblrThemer::TagHelper
  attr_reader :data, :post_index, :html

  def initialize html, data, index=0
    @html = html
    @data = data
    @post_index = index
  end

  def render
    return '' unless html

    self.class.blocks.each do |name,blk|
      html.block(name,instance_exec(self,&blk))
    end

    self.class.tags.each do |name, blk|
      html.tag(name,instance_exec(self,&blk))
    end

    html.str
  end

  def reblogged?
    boolify(data['reblogged_from_id'])
  end

  tag('PostType')      { data['type'] }
  tag('Permalink')     { data['post_url'] }
  tag('ShortURL')      { data['short_url'] }
  tag('PostID')        { data['id'] }
  tag 'TagsAsClasses' do
    classes = data['tags']||[]
    classes << 'reblog' if reblogged?
    classes.join(' ')
  end

  15.times do |i|
    block "Post#{i+1}" do
      post_index == i
    end
  end

  block('Even') { post_index%2==1 }
  block('Odd')  { post_index%2==0 }

  block('RebloggedFrom')   { reblogged? }
  tag('ReblogParentName')  { data['reblogged_from_name'] }
  tag('ReblogParentTitle') { data['reblogged_from_title'] }
  tag('ReblogParentURL')   { data['reblogged_from_url'] }
  tag('ReblogRootName')    { data['reblogged_root_name'] }
  tag('ReblogRootTitle')   { data['reblogged_root_title'] }
  tag('ReblogRootURL')     { data['reblogged_root_url'] }
  block('NotReblog')       { !reblogged? }
end
