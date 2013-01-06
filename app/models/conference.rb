class Conference < ActiveRecord::Base
  belongs_to :organization

  has_many :events

  cattr_reader :per_page

  validates_uniqueness_of :name

  @@per_page = 10

  def to_param
    "#{id}-#{slug}"
  end

  def slug
    name.gsub(" ","-").gsub(".","-").downcase
  end
end
