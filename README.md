

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

The app implements thread_mattr_accessor, a new feature from Rails 5, to pass 
the current_user from the controller to the model. The use of threads to pass data
from the controller to the model must be kept to a minimum.
We should avoid poluting classes and objects with 'magic' global variables.
I feel this is one of the few cases it is appropiate to use.
Most request require usesr authentication and 
their actions and activities are dependent on the user permissions.
By using CurrentScope class, the application shares the current_user across avoiding
passing it as parameter in each method call.

This project implements email delivery for new purchases and account connection.
The buyer receives an email when the order is successfully executed with the 
basic purchase information. 
The seller receives an email when he successfully connects his stripe account
to the application.
To view the emails generated, 
go to the link [App Generated Email](http://173.66.176.122:1080/ "Mail")

The app models and controllers were generated with the generic scaffold. 
There are five model/controller/view plus the User model used by devise.

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
contrast to previous versions that the associated record was optional.

After_create callback associates the newly created product seller with the current user.
The before_update and before_destroy callbacks check that the actions update and destroy 
is only performed by product's seller. 
These callbacks prevent either a buyer or other sellers to make changes or delete the products
which don't belong to them.
For this project, the controllers are purposely left generic to make it easy
the demonstration of these callbacks feature. 

It is the Rails philosophy to keep the controllers thin, to restrict the models to act mostly
on persisting and retrieving records and to create ActiveSupport::Concern and Plain Old Ruby Objects (POGO) to deal
with business logic or code that requires access to more than one model.

To separate areas of responsibilities, I have created a ActiveSupport::Concern module 
StripeConnect to be mixed into the 
StripeController.
StripeConnect implements the Oauth logic to connect the sellers' Stripe account 
with the application.
We achieve this by using 'include StripeConnect'. 
Another valid approach would be to create a Ruby class to decouple the logic.
I used the ActiveSupport::Concern to show how Rails allows the developer
to keep controllers and models simpler and thinner. 
Mixins and inheritance are very important techniques, each having advantagages modeling
real world objects and behaviors.


The product model has the class method Product.allowed_to_create? which returns a boolean 
that determines whether the logged user is allowed to create a new product. This method
can be used also to make Show/Edit/Destroy visible, but it is not implemented to test the
callbacks.

The products table is editable, so the app uses the rails optimistic locking to prevent two users
to edit the same record. The second user updating the product will receive an error notifying him
that the record can't be updated.
