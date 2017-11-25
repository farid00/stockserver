defmodule StockGame.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias StockGame.Accounts.User


  schema "users" do
    field :money, :decimal
    field :username, :string
    field :stocks, {:array, :string}
    field :password, :string, virtual: true
    field :password_hash, :string

    timestamps()
  end

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:username, :password])
    |> validate_password(:password)
    |> put_pass_hash()
    |> validate_required([:username, :password_hash])
  end
  # Password validation
 # From Comeonin docs
 def validate_password(changeset, field, options \\ []) do
   validate_change(changeset, field, fn _, password ->
     case valid_password?(password) do
       {:ok, _} -> []
       {:error, msg} -> [{field, options[:message] || msg}]
     end
   end)
 end

 def put_pass_hash(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
   change(changeset, Comeonin.Argon2.add_hash(password))
 end
 def put_pass_hash(changeset), do: changeset

 def valid_password?(password) when byte_size(password) > 7 do
   {:ok, password}
 end
 def valid_password?(_), do: {:error, "The password is too short"}
end
