class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable, :omniauthable

  validates :name,  presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }

  validates :password, length: { minimum: 6 }, allow_blank: false

  has_many :memberships
  has_many :groups, :through => :memberships
  has_many :conversations, :foreign_key => :sender_id

  def self.find_for_facebook_oauth(auth, signed_in_resource = nil)

    user = User.where(:provider => auth.provider, :uid => auth.uid).first
    
    if user
    
      return user
    
    else
    
       registered_user = User.where(:email => auth.info.email).first
    
       if registered_user
    
         return registered_user
    
       else
    
         auth.provider = "Facebook"
    
         user = User.create!(name:auth.extra.raw_info.name,
                             provider:auth.provider,
                             email:auth.info.email,
                             password:Devise.friendly_token[0,20],
                             confirmed_at:Time.zone.now # if u don’t want to send any confirmation mail
                            )
       end

    end

  end


  def self.find_for_google_oauth2(access_token, signed_in_resource = nil)

    data = access_token.info

    user = User.where(:provider => access_token.provider, :uid => access_token.uid ).first
    
    if user
    
      return user
    
    else
    
       registered_user = User.where(:email => access_token.info.email).first
    
       if registered_user
    
         return registered_user
    
       else
    
         access_token.provider = "Google"
    
         user = User.create(name: data[“first_name”],
                            provider:access_token.provider,
                            email: data[“email”],
                            password: Devise.friendly_token[0,20],
                            confirmed_at:Time.zone.now # if u don’t want to send any confirmation mail
                           )
    
       end
    
    end
    
  end 
end
