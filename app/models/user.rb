class User < ActiveRecord::Base
  has_many :microposts, dependent: :destroy
  has_many :userrelationships, foreign_key: "follower_id", dependent: :destroy
  has_many :followed_users, through: :userrelationships, source: :followed 
  has_many :reverse_userrelationships, class_name: "Userrelationship", foreign_key: "followed_id", dependent: :destroy
  has_many :followers, through: :reverse_userrelationships

	before_save { self.email = email.downcase }
	before_create :create_remember_token
	validates :name, presence: true, length: { maximum: 50 }
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  	validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
  							uniqueness: { case_sensitive: false }

	has_secure_password
	validates :password, length: { minimum: 6 }

	def User.new_remember_token
    	SecureRandom.urlsafe_base64
  	end

  	def User.encrypt(token)
    	Digest::SHA1.hexdigest(token.to_s)
  	end

    def feed
      Micropost.from_users_followed_by(self)
    end

    def following?(other_user)
      userrelationships.find_by(followed_id: other_user.id)
    end

    def follow!(other_user)
      userrelationships.create!(followed_id: other_user.id)
    end

    def unfollow!(other_user)
      userrelationships.find_by(followed_id: other_user.id).destroy!
    end

  	private

    	def create_remember_token
      		self.remember_token = User.encrypt(User.new_remember_token)
   		end

end
