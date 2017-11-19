defmodule StockGameWeb.StockController do
  use StockGameWeb, :controller

  alias StockGame.Market
  alias StockGame.Market.Stock

  action_fallback StockGameWeb.FallbackController

  def index(conn, _params) do
    stocks = Market.list_stocks()
    render(conn, "index.json", stocks: stocks)
  end

  def create(conn, %{"stock" => stock_params}) do
    with {:ok, %Stock{} = stock} <- Market.create_stock(stock_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", stock_path(conn, :show, stock))
      |> render("show.json", stock: stock)
    end
  end

  def show(conn, %{"id" => id}) do
    #stock = Market.get_stock!(id)
    render(conn, "show.json", stock: id)
  end

  def update(conn, %{"id" => id, "stock" => stock_params}) do
    stock = Market.get_stock!(id)

    with {:ok, %Stock{} = stock} <- Market.update_stock(stock, stock_params) do
      render(conn, "show.json", stock: stock)
    end
  end

  def delete(conn, %{"id" => id}) do
    stock = Market.get_stock!(id)
    with {:ok, %Stock{}} <- Market.delete_stock(stock) do
      send_resp(conn, :no_content, "")
    end
  end
end
