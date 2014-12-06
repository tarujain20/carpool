class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :rides, :dependent => :destroy
  has_many :connections, :dependent => :destroy

  validates_presence_of :first_name
  validates_presence_of :last_name
  validates_presence_of :email
  validates_uniqueness_of :email, :message => "Email in use. Try a new email or sign in."
  validates_format_of :email, :with => /\A[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z0-9.-]+\z/
  validates_presence_of :password, :unless => :encrypted_password
  validates_confirmation_of :password

  before_validation :force_email_lowercase
  before_validation :strip_email_whitespace

  def full_name
    "#{first_name} #{last_name}"
  end

  private

  def strip_email_whitespace
    if self.email
      email_no_whitespace = self.email.strip
      self.email = email_no_whitespace
    end
  end

  def force_email_lowercase
    if self.email
      email_downcase = self.email.downcase
      self.email = email_downcase
    end
  end
end
