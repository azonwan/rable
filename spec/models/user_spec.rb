require 'spec_helper'

describe User do
  context "model" do
    before(:each) do
      @user = Factory(:user)
    end
    it { should validate_uniqueness_of(:nickname) }
    it { should validate_uniqueness_of(:email) }
    it { should validate_presence_of(:nickname) }
    it { should validate_presence_of(:email) }

    it { should allow_mass_assignment_of(:nickname) }
    it { should allow_mass_assignment_of(:email) }
    it { should allow_mass_assignment_of(:password) }
    it { should allow_mass_assignment_of(:password_confirmation) }
    it { should_not allow_mass_assignment_of(:role) }

    it { should have_one(:account).dependent(:destroy) }
    it { should have_many(:topics).dependent(:destroy) }
    it { should have_many(:comments).dependent(:destroy) }
    it { should have_many(:bookmarks).dependent(:destroy) }
    it { should have_many(:notifications).dependent(:destroy) }

    it { should have_many(:follower_relationships).dependent(:destroy) }
    it { should have_many(:followed_relationships).dependent(:destroy) }
    it { should have_many(:followers) }
    it { should_not have_many(:followers).dependent(:destroy) }
    it { should have_many(:followed_users) }
    it { should_not have_many(:followed_users).dependent(:destroy) }

    it "should have default account" do
      assert !@user.account.nil?
    end

    it "should not allow @, - in nickname" do
      expect {
        Factory(:user, :nickname => 'hello@world')
      }.should raise_error(ActiveRecord::RecordInvalid)

      expect {
        Factory(:user, :nickname => 'hello-world')
      }.should raise_error(ActiveRecord::RecordInvalid)
    end

    it "should follow other users" do
      nana = Factory(:user, :nickname => 'nana')
      @user.follow(nana)
      @user.following?(nana).should be_true
      nana.followers.include?(@user).should be_true
      nana.followed_by?(@user).should be_true
    end
  end
end

# == Schema Information
#
# Table name: users
#
#  id                     :integer         not null, primary key
#  email                  :string(255)     default(""), not null
#  encrypted_password     :string(128)     default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer         default(0)
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#  nickname               :string(255)
#  avatar                 :string(255)
#  role                   :string(255)
#

