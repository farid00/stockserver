defmodule StockGameWeb.LiveChannel do
  use StockGameWeb, :channel

  def join("live:lobby", payload, socket) do
    if authorized?(payload) do
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  def handle_in("ping", payload, socket) do
    msg = "https://api.polygon.io/v1/last/stocks/" <> payload <> "?apiKey=dHES5_4lab1dePZE1H60TFzlP3lMq_YJ_uiPbC"
    resp = HTTPoison.get!(msg)
    price = Poison.decode!(resp.body)["last"]["price"]
    push socket, "new_msg", %{name: payload, price: price}
    {:noreply, socket}
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (live:lobby).
  def handle_in("shout", payload, socket) do
    broadcast socket, "shout", payload
    {:noreply, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
