# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  email      :string           not null
#  created_at :datetime
#  updated_at :datetime
#

class User < ActiveRecord::Base
  validates :email, presence: true, uniqueness: true

  has_many :shortened_urls,
    class_name: :ShortenedUrl,
    primary_key: :id,
    foreign_key: :submitter_id

  has_many :visits,
    class_name: :Visit,
    primary_key: :id,
    foreign_key: :user_id

  has_many :visited_urls, through: :visits, source: :visited_url
end
