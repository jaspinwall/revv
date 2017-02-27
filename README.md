

# Revv Technical Challenge

## Intro

Welcome to Revv's technical challenge.

Congrats, making it this far means you've impressed us. This exercise is your chance to show off your skills to other developers at Revv and to give you a brief introduction into what Revv does.

Please read this document completely. We recognize that you're busy and will need some time to complete this - do let us know about your timeframe estimate.

## About Revv

Revv is a donation platform built on top of Stripe Connect. Stripe Connect allows developers to easily build a "marketplace" application. This means that multiple sellers can accept payments by connecting their Stripe accounts to a central "application owner" and accept payments. The "application owner" can then take an application fee from payments made to any of the seller accounts.

The principle behind Revv is the same as any marketplace application, except that rather than selling goods or services, Revv allows nonprofits to accept donations. You can read about Stripe Connect here: https://stripe.com/connect

## The Challenge

Your task is to build a basic storefront application by integrating Stripe Connect into a Rails app. For simplicity's sake, your marketplace will have only 1 seller, and does not necessarily need to have a user authentication system (but if you have time and feel inclined - go right ahead!).

Here are the requirements of the app:

- I can add, edit and delete products from the store.
- I can view all the products that are currently being sold on the store.
- I can view details about a specific product, and purchase that product.
- When I purchase a product from the store, the store itself (application owner) earns a 10% fee on the price of the product.
- After a successful purchase, I am shown a thank you page that has details of my purchase.  (Or for bonus points, I receive an email.)

Remember, we are more interested in your ability to effectively integrate Stripe's API using Rails than we are in your CSS or JS prowess. It's up to you how much time you want to spend on the appearance/theme/branding of your storefront, but it should look presentable and be user friendly. You won't be penalized for using Rails scaffolding, CSS frameworks/templates etc.

## Hints

Here are some pointers to get you started:

- Give the [Connect docs](https://stripe.com/docs/connect) a good read. You will need to set up two Stripe accounts for this app, an application owner (parent) and a seller (child). You will need to connect the seller to the application owner using the OAuth flow. You will be using "standalone accounts" to do this: https://stripe.com/docs/connect/standalone-accounts

- You will be processing payments in test mode on your application, since your application will likely not have an SSL certificate. In order to charge a credit card, Stripe must first validate the card, return a one-time use token, and pass that token to your application through your payment form. The easiest way to achieve this is to use Stripe's out-of-the-box payment form, [Stripe Checkout](https://stripe.com/docs/tutorials/checkout]). However, you could also [obtain and submit the token manually](https://stripe.com/docs/tutorials/forms) by including Stripe.js (if you find that simpler to understand or want more customization). Here's a [list](https://stripe.com/docs/testing#cards) of test cards we should be able to use on your app.

- You will need to [make stripe Charges](https://stripe.com/docs/connect/payments-fees) directly on the seller's stripe account. For this challenge, you do not necessarily need to create Customers within stripe.

Some helpful gems: `stripe` and `devise`

- Try not to use other solutions out there, we want to see your process from inception to deployment
- To help style your application, use Bootstrap.

## What are we looking for?

In no particular order:

- legible, meaningful and concise code
- rails & ruby style and best practices
- ability to read, understand api docs and implement effectively
- ability to use git effectively and create meaningful commits, helpful README etc
- ability to take an idea from inception to deliverable
- ability to use gems effectively where appropriate
- ability to write meaningful tests
- ability to write CSS / JS cleanly

## Deliverables

- Your app must be deployed to a public facing URL (Heroku's free tier is probably your best bet)
- Source code must be viewable on Github
- We'll need access to the application owner and seller Stripe accounts that you create.
- Documentation on your software engineering process (nothing crazy, a markdown README in the repository is sufficient)


# Solution

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
