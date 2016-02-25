class User < ActiveRecord::Base
	establish_connection "admin".to_sym
	
	attr_accessible :email , :password, :password_confirmation
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
    devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

end
