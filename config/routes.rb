Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  #
  root to: 'home#index'

  ruby_versions = Rails.configuration.ruby_versions.collect { |v| Regexp.escape(v) }

  scope "(:version)", constraints: { version: /#{ruby_versions.join("|")}/ } do
    get 's', to: 'search#index', as: :search
    get 'o/*object', to: 'objects#show', as: :object
  end
end
