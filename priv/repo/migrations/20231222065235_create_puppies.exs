defmodule AmazonS3.Repo.Migrations.CreatePuppies do
  use Ecto.Migration

  def change do
    create table(:puppies) do
      add :name, :string
      add :color, :string
      add :breed, :string
      add :photo, :string

      timestamps()
    end
  end
end
