# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#  provider               :string(255)
#  uid                    :string(255)
#  username               :string(255)
#  twitter_name           :string(255)
#  github_name            :string(255)
#  bio                    :text
#  learning_style         :string(255)
#  image                  :string(255)
#  avatar_file_name       :string(255)
#  avatar_content_type    :string(255)
#  avatar_file_size       :integer
#  avatar_updated_at      :datetime
#

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and 
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable
  has_many :roadmaps, dependent: :destroy

  validates_presence_of :username
  validates_uniqueness_of :username

  # paperclip #
  has_attached_file :avatar, styles: { 
      thumb: '100x100>',
      square: '200x200#',
      medium: '300x300>', 
      }, default_url: 'default_avatar.gif'
    
  validates_attachment_content_type :avatar, content_type: /\Aimage/, message: 'file type not allowed, please only upload images'
  # paperclip #

  def self.from_omniauth(auth)
  	where(auth.slice(:provider, :uid, :image)).first_or_create do |user|
  		user.provider = auth.provider
  		user.uid = auth.uid
  		user.username = auth.info.nickname
      user.email = auth.info.email
      user.image = auth.info.image
  	end
  end

  def self.new_with_session(params, session)
    if session["devise.user_attributes"]
      new(session["devise.user_attributes"], without_protection: true) do |user| 
        user.attributes = params
        user.valid?
      end
    else
      super
    end
  end

  def password_required?
    super && provider.blank?
  end

  def update_with_password(params, *options)
    if encrypted_password.blank?
      update_attributes(params, *options)
    else
      super
    end
  end
end
