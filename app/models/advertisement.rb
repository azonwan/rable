class Advertisement < ActiveRecord::Base
  validates :link, :banner, :title, :words, :start_date, :expire_date, :duration, :presence => true
  validates :duration, :numericality => {:only_integer => true, :less_than => 3650, :greater_than => 1}

  attr_accessible :link, :banner, :title, :words, :start_date, :duration
  mount_uploader :banner, AdBannerUploader
  before_validation :set_expire_date

  def self.available
    today = Date.today
    where(["start_date <= ? AND expire_date >= ?", today, today]).order('start_date DESC')
  end

  def showing?
    today = Date.today
    today >= self.start_date and today <= self.expire_date
  end

  private
    def set_expire_date
      if self.start_date.present? and self.duration.present?
        self.expire_date = self.start_date + self.duration.days
      end
    end
end
# == Schema Information
#
# Table name: advertisements
#
#  id          :integer         not null, primary key
#  link        :string(255)
#  banner      :string(255)
#  title       :string(255)
#  words       :string(255)
#  start_date  :date
#  expire_date :date
#  duration    :integer
#  created_at  :datetime
#  updated_at  :datetime
#

