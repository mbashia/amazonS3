defmodule AmazonS3Web.PageController do
  use AmazonS3Web, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
