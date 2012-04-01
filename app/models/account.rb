class Account < ActiveRecord::Base
  belongs_to :user
  attr_accessible :personal_website, :location, :signature, :introduction, :twitter_id

  after_initialize :set_default_value

  private
    def set_default_value
      self.personal_website ||= ''
      self.location ||= ''
      self.signature ||= ''
      self.introduction ||= ''
      self.twitter_id ||= ''
    end

end
# == Schema Information
#
# Table name: accounts
#
#  id               :integer         not null, primary key
#  user_id          :integer
#  personal_website :string(255)
#  location         :string(255)
#  signature        :string(255)
#  introduction     :text
#  twitter_id       :string(255)
#  created_at       :datetime
#  updated_at       :datetime
#

