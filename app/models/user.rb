class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates_presence_of :first_name
  validates_presence_of :last_name
  validates_presence_of :email
  validates_uniqueness_of :email, :message => "Email in use. Try a new email or sign in."
  validates_format_of :email, :with => /\A[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z0-9.-]+\z/
  validates_presence_of :password, :unless => :encrypted_password
  validates_confirmation_of :password

  def full_name
    "#{first_name} #{last_name}"
  end
end
