Rails.configuration.stripe = {
    :publishable_key => ENV["STRIPE_PUBLISHABLE_KEY".freeze],
    :secret_key      => ENV["STRIPE_SECRET_KEY".freeze]
}

Stripe.api_key = Rails.configuration.stripe[:secret_key]