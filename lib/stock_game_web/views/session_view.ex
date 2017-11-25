defmodule StockGameWeb.SessionView do
  use StockGameWeb, :view
  alias StockGameWeb.SessionView
  alias StockGameWeb.StockController

  def render("show.json", %{session: user}) do
    %{data: render_one(user, SessionView, "session.json")}
  end

  def render("session.json", %{session: user}) do
    if user.stocks do
      stocks = Enum.map(user.stocks, fn stock -> msg = "https://api.polygon.io/v1/last/stocks/" <> stock <> "?apiKey=dHES5_4lab1dePZE1H60TFzlP3lMq_YJ_uiPbC"
      resp = HTTPoison.get!(msg)
      price = Poison.decode!(resp.body)["last"]["price"]
      %{name: stock,
        price: price} end) 
    end

    if !user.stocks do
      stocks = []
    end

    %{id: user.id,
      username: user.username,
      stock: stocks}

  end
end
