class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :validatable, :trackable, :confirmable,
         :jwt_authenticatable, jwt_revocation_strategy: Devise::JWT::RevocationStrategies::Null

  has_many :user_documents, dependent: :destroy
  has_many :documents, through: :user_documents
  has_many :owned_documents, inverse_of: :owner, class_name: 'Document', foreign_key: 'owner_id', dependent: :destroy
  has_one_attached :profile_image

  validates :password, confirmation: true
  validates :password_confirmation, presence: true, on: :create
  validates :password_confirmation, presence: true, on: :update, unless: ->(user){ user.password.to_s.empty? }
  validates :first_name, :last_name, :encrypted_password, :sign_in_count, presence: true

  def password_token_valid?
    (reset_password_sent_at + 4.hours) > Time.now.utc
  end

  def reset_password!(password, password_confirmation)
    self.reset_password_token = nil
    self.password = password
    self.password_confirmation = password_confirmation
    save!
  end

  def full_name
    "#{first_name} #{last_name}"
  end
end
