class TumblrThemer::Post
  include TumblrThemer::TagHelper
  attr_reader :data, :post_index, :html

  def initialize html, data, index=0
    @html = TumblrThemer::HtmlSnippet.new(html.dup) if html
    @data = data.dup
    @post_index = index
  end

  def type
    self.class.to_s.sub('TumblrThemer::Post::','').downcase
  end

  def self.render html, data, i=0
    type = data['type']
    if type == 'photo'
      if data['photos'].size > 1
        klass = TumblrThemer::Post::Photoset
      else
        klass = TumblrThemer::Post::Photo
      end
    else
      klass = TumblrThemer::Post.const_get(type.capitalize)
    end

    klass.new(html,data,i).render
  # rescue NameError
    # ''
  end

  def render
    return '' unless html

    render_blocks

    tag_iterators.each do |name,opts|
      vals = instance_exec(self,&opts[:blk])
      html.block(name) do |str|
        strs = []
        vals.each_with_index { |val,i| strs << opts[:klass].new(str,val,i).render }
        strs.join("\n")
      end
    end

    render_tags

    html.str
  end

  def reblogged?
    boolify(data['reblogged_from_id'])
  end

  def created_at
    @created_at ||= Time.parse(data['date'])
  end

  POST_TYPES = %w{
    text
    photo
    panorama
    photoset
    quote
    link
    chat
    audio
    video
    answer
  }.each do |_type|
    block(_type.capitalize) { self.type == _type }
  end

  tag('PostType')      { data['type'] }
  tag('Permalink')     { "/post/#{data['id']}" }
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

  block('HasTags') { boolify(data['tags']) }
  for_each('Tags',TumblrThemer::Tag) { data['tags'] }

  block('Date') { true }
  block('NewDayDate')        { post_index%2==1 }
  block('SameDayDate')       { post_index%2==0 }
  tag('DayOfMonth')          { created_at.strftime('%-d') }
  tag('DayOfMonthWithZero')  { created_at.strftime('%d') }
  tag('DayOfWeek')           { created_at.strftime('%A') }
  tag('ShortDayOfWeek')      { created_at.strftime('%a') }
  tag('DayOfWeekNumber')     { created_at.strftime('%u') }
  # tag('DayOfMonthSuffix')    { 'fixme' }
  tag('DayOfYear')           { created_at.yday }
  tag('WeekOfYear')          { created_at.strftime('%U') }
  tag('Month')               { created_at.strftime('%B') }
  tag('ShortMonth')          { created_at.strftime('%b') }
  tag('MonthNumber')         { created_at.strftime('%-m') }
  tag('MonthNumberWithZero') { created_at.strftime('%m') }
  tag('Year')                { created_at.strftime('%Y') }
  tag('ShortYear')           { created_at.strftime('%y') }
  tag('AmPm')                { created_at.strftime('%P') }
  tag('CapitalAmPm')         { created_at.strftime('%p') }
  tag('12Hour')              { created_at.strftime('%l') }
  tag('24Hour')              { created_at.strftime('%k') }
  tag('12HourWithZero')      { created_at.strftime('%I') }
  tag('24HourWithZero')      { created_at.strftime('%H') }
  tag('Minutes')             { created_at.strftime('%M') }
  tag('Seconds')             { created_at.strftime('%S') }
  tag('Beats')               { created_at.strftime('%L') }
  tag('Timestamp')           { created_at.to_i}
  # tag('TimeAgo')             { 'fixme' }

  block_tag('NoteCount')
  tag('NoteCountWithLabel') do
    num = data['note_count'].to_i
    str = num.to_s.reverse.gsub(/...(?=.)/,'\&,').reverse
    str << (num == 1 ? 'note' : 'notes')
  end

  block('ContentSource', 'source_url')
  tag('SourceURL')
  tag('SourceTitle')
  tag('BlackLogoURL') { 'http://assets.tumblr.com/images/source_logos/fastcompany_7f8b98.png?1092' }
  tag('LogoWidth') { 74 }
  tag('LogoHeight') { 11 }

  def source_logo; @source_logo ||= rand(2); end
  block('SourceLogo') { source_logo == 0 }
  block('NoSourceLogo') { source_logo == 1 }
end
