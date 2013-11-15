class Article < ActiveRecord::Base
  has_many :comments
  has_many :taggings
  has_many :tags, through: :taggings
  belongs_to :author

  has_attached_file :image, styles: { medium: "300x300>", thumb: "100x100>" }

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

  def viewed!
    increment(:view_count)
    save
  end

  def self.find_by_month(month_number)
    where('extract(month from created_at) = ?', month_number)
  end

  def self.months_range
    pairs = all.map do |article|
      created_at = article.created_at.to_date
      [created_at.month, created_at.strftime('%B')]
    end.uniq
    Hash[pairs]
  end
end
