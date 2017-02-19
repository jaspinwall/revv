$(document).bind 'pay_products.load', (e,obj) =>
  console.log('loading paybutton')
  submitting = false

  payButton = $('.pay-button')
  form = payButton.closest('form')
  indicator = form.find('.indicator').height(form.outerHeight())
  handler = StripeCheckout.configure
    key: window.stripe.publishable
    email: window.stripe.currentUserEmail
    allowRememberMe: false
    closed: ->
      form.removeClass('processing') unless submitting
    token: (token) ->
      submitting = true
      form.find('input[name=token]').val(token.id)
      form.get(0).submit()


  payButton.click (e) ->
    e.preventDefault()
    form.addClass('processing')

    handler.open
      name: window.stripe.product
      description: window.stripe.description
      amount: window.stripe.amount
