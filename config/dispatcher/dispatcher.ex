defmodule Dispatcher do
  use Matcher
  define_accept_types [
    html: [ "text/html", "application/xhtml+html" ],
    json: [ "application/json", "application/vnd.api+json" ]
  ]

  @any %{}
  @json %{ accept: %{ json: true } }
  @html %{ accept: %{ html: true } }

  define_layers [ :static, :services, :fall_back, :not_found ]

  # In order to forward the 'themes' resource to the
  # resource service, use the following forward rule:
  #
  # match "/themes/*path", @json do
  #   Proxy.forward conn, path, "http://resource/themes/"
  # end
  #
  # Run `docker-compose restart dispatcher` after updating
  # this file.

  get "/concepts/*path", @json do
    Proxy.forward conn, path, "http://resource/concepts/"
  end

  get "/concept-schemes/*path", @json do
    Proxy.forward conn, path, "http://resource/concept-schemes/"
  end

  get "/administrative-units/*path", @json do
    Proxy.forward conn, path, "http://resource/administrative-units/"
  end

  get "/organizations/*path", @json do
    Proxy.forward conn, path, "http://resource/organizations/"
  end

  match "/sessions/*path", @json do
    Proxy.forward conn, path, "http://login/sessions/"
  end

  get "/users/*path", @json do
    Proxy.forward conn, path, "http://resource/users/"
  end

  get "/accounts/*path", @json do
    Proxy.forward conn, path, "http://resource/accounts/"
  end

  match "/*_", %{ layer: :not_found } do
    send_resp( conn, 404, "Route not found.  See config/dispatcher.ex" )
  end
end
