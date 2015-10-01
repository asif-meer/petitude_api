# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string
#  last_sign_in_ip        :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  name                   :string
#  role                   :integer
#  first_name             :string
#  middle_name            :string
#  last_name              :string
#  mobile_number          :string
#  date_of_birth          :date
#  gender                 :string(1)
#  authentication_token   :string
#  password_salt          :string
#
# Indexes
#
#  index_users_on_authentication_token  (authentication_token)
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#

class User < ActiveRecord::Base
  acts_as_token_authenticatable
  enum role: [:user, :vip, :admin]
  
  # EMAIL_REGEX = /^([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})$/i
  before_save :encrypt_password
  # after_create :encrypt_password

  attr_accessor :password

  # after_initialize :set_default_role, :if => :new_record?

  # def set_default_role
  #   self.role ||= :user
  # end


  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  # devise :database_authenticatable, :registerable,
  #        :recoverable, :rememberable, :trackable, :validatable

  def skip_confirmation!
    # self.confirmed_at = Time.now
    true
  end

  # def self.authenticate(username_or_email="", login_password="")
  #   if  EMAIL_REGEX.match(username_or_email)
  #     user = User.find_by_email(username_or_email)
  #   # else
  #   #   user = User.find_by_username(username_or_email)
  #   end
  #   if user && user.match_password(login_password)
  #     return user
  #   else
  #     return false
  #   end
  # end   

  # def match_password(login_password="")
  #   encrypted_password == BCrypt::Engine.hash_secret(login_password, salt)
  # end

  def self.authenticate(email, password)
    user = find_by_email(email)
    if user && user.encrypted_password == BCrypt::Engine.hash_secret(password,user.password_salt)
      user
    else
      nil
    end
  end
  
  def encrypt_password
    self.password_salt = BCrypt::Engine.generate_salt
    self.encrypted_password = BCrypt::Engine.hash_secret(password, password_salt)
  end


end
