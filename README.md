

This is a basic application to implement code for sellers and buyers.
It implement DEVISE for user authentication. 

Any registered user is automatically added as a buyer. To become a seller
a user has to connect his account by pressing the 'Stripe Connect' link at the top menu.

Once a user has connected the stripe account, he is allowed to enter new products to be sold.

This app implements multiple sellers and the products are associated to the seller account when created.

A buyer can purchase a product one at a time by clicking the pay link next to the product.

The user must press the order button in the pay page to purchase the product. At this time a modal window is open with the credit card, expiration date and CVC code input elements.

When the user presses the Pay button, a stripe trasaction is generated, the purchase record created and a charge record with the stripe information stored.

This app uses the gem Money to handle the interface for currency with ActiveRecord.

The app implements thread_mattr_accessor, a new feature from Rails 5, to pass the current_user from the controller to the model.

The buyer receives an email when the order is successfully executed with the basic purchase information. To view the emails generated, go to [App Generated Email](http://173.66.176.122:1080/ "Mail")

When a seller connects his Stripe account an email is also generated.

The app was generated with scaffold. There are five model/controller/view plus the User model used by devise.

```
User
  email: string
  has_one :buyer
  has_one :seller

Buyer
  name: string
  belongs_to :user
  has_many :purchases

Seller
  publishable_key: string
  secret_key: string
  stripe_user_id: string
  name: string
  belongs_to :user
  has_many :products

Product
  name: string
  price_cents: integer
  belongs_to :seller
  has_many :purchases

Purchase
  belongs_to :buyer
  belongs_to :product
  has_one :charge

Charge
  source: string
  stripe_response: text
  application_fee_cents: integer
  belongs_to :purchase
```

The product controller uses three callbacks. Note that Rails 5 requires the throw(:abort) to
prevent the action. Note also that Rails 5 makes belongs_to requires the associated record, in
contrast to previous version that the associated record was optional.

After_create to associate the new product with the current user as the product seller. The before_update and before_destroy check that the action is performed by product seller and prevents either a buyer or other sellers to make changes or delete the product.
The controllers are left generic to allow the demonstration of the callback feature. 

It is the Rails philosophy to keep the controllers thin, to restrict the models to act mostly
on persisting and retrieving records and to create ActiveSupport::Concern and Plain Old Ruby Objects (POGO) to deal
with business logic or code that requires access to more than one model.

To keep this application simple, I have created a ActiveSupport::Concern module StripeConnect to be mixed into the 
StripeController using 'include StripeConnect'. StripeConnect implements the logic to connect Stripe account
with OAuth.

The product model has the class method Product.allowed_to_create? which returns a boolean 
that determines whether the logged user is allowed to create a new product. This method
can be used also to make Show/Edit/Destroy visible, but it is not implemented to test the
callbacks.
