defmodule AmazonS3Web.Router do
  use AmazonS3Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {AmazonS3Web.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", AmazonS3Web do
    pipe_through :browser

    get "/", PageController, :index
    live "/puppies", PuppyLive.Index, :index
    live "/puppies/new", PuppyLive.Index, :new
    live "/puppies/:id/edit", PuppyLive.Index, :edit

    live "/puppies/:id", PuppyLive.Show, :show
    live "/puppies/:id/show/edit", PuppyLive.Show, :edit
  end

  # Other scopes may use custom stacks.
  # scope "/api", AmazonS3Web do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: AmazonS3Web.Telemetry
    end
  end

  # Enables the Swoosh mailbox preview in development.
  #
  # Note that preview only shows emails that were sent by the same
  # node running the Phoenix server.
  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through :browser

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
