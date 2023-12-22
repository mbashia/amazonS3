defmodule AmazonS3.Puppies.Puppy do
  use Ecto.Schema
  import Ecto.Changeset

  schema "puppies" do
    field :breed, :string
    field :color, :string
    field :name, :string
    field :photo, :string

    timestamps()
  end

  @doc false
  def changeset(puppy, attrs) do
    puppy
    |> cast(attrs, [:name, :color, :breed, :photo])
    |> validate_required([:name, :color, :breed, :photo])
  end
end
