class Article < ActiveRecord::Base
  has_many :comments
  has_many :taggings
  has_many :tags, through: :taggings

  def tag_list
    #tags.collect do |t|
    #  t.name
    #end.join(', ')
    # we have redefined Tag model's #to_s method instead
    tags.join(', ')
  end

  def tag_list=(tags_string)
    tags_names = tags_string.split(',').collect{|name| name.strip}.uniq
    new_or_found_tags = tags_names.collect {|name| Tag.find_or_create_by(name: name) }
    self.tags = new_or_found_tags
  end
end
