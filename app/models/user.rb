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
  # after_initialize :set_default_role, :if => :new_record?

  # def set_default_role
  #   self.role ||= :user
  # end

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  def skip_confirmation!
    # self.confirmed_at = Time.now
    true
  end

end
