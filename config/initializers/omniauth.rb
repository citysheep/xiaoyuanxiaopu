# Renren::Config.api_key = "8acfecc266db419faccbe06059c43865"
# Renren::Config.api_secret = "dfb0643f283a45bd92ad1ce277e7873f"
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :qzone, "100395137", "7b3f53fc92e84182d6cb9157c9eb8b8c"
end
