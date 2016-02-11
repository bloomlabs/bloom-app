Rails.configuration.stripe = {
    :publishable_key => "pk_test_KjDDe3Cg8UBQBBF6y60wMkLe",
    :secret_key      => "sk_test_NinhGYyULFnn6CmHXkScHtYP"
}

Stripe.api_key = Rails.configuration.stripe[:secret_key]