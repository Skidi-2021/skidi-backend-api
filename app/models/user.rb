class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one_attached    :avatar
  has_many            :symptoms
  
  enum gender: { pria: 1, wanita: 2 }

  # Token digunakan sebagai payload hashing
  before_save :ensure_personal_token

  # Memastikan bahwa token yang dibuat oleh Devise adalah token yang unik
  def ensure_personal_token
    # personal_token adalah salah satu kolom di Tabel User
    self.personal_token ||= generate_personal_token
  end

  private

  # Membuat Token Autentikasi
  # Token Autentikasi dibuat sendiri sejak versi Devise > 3.2
  def generate_personal_token
    loop do
      token = Devise.friendly_token
      break token unless User.where(personal_token: token).first
    end
  end
  
end
