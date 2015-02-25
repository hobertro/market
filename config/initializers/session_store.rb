# Be sure to restart your server when you modify this file.

DotaMarket::Application.config.session_store :cookie_store, key: '_dota_market_session'
Rails.application.config.action_dispatch.cookies_serializer = :marshal

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rails generate session_migration")
# DotaMarket::Application.config.session_store :active_record_store
