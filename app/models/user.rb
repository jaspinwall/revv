class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_one :seller
  has_one :buyer

  after_create {|user|
    # for this callenge we assume the user name to be the "left" of the '@' sign of the user email
    n = user.email.index('@') - 1
    name = user.email[0..n]
    Buyer.create(user: user, name: name)
  }
end
