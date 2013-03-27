Rails.application.config.middleware.use OmniAuth::Builder do
  provider :qq_connect, "100395137", "7b3f53fc92e84182d6cb9157c9eb8b8c"
  provider :renren, "8acfecc266db419faccbe06059c43865", "dfb0643f283a45bd92ad1ce277e7873f"
  provider :facebook, "208690692477625", "8968b1a3f4810a38bc0c520e7ec867d0"
end
