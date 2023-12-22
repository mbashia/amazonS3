defmodule AmazonS3.PuppiesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `AmazonS3.Puppies` context.
  """

  @doc """
  Generate a puppy.
  """
  def puppy_fixture(attrs \\ %{}) do
    {:ok, puppy} =
      attrs
      |> Enum.into(%{
        breed: "some breed",
        color: "some color",
        name: "some name",
        photo: "some photo"
      })
      |> AmazonS3.Puppies.create_puppy()

    puppy
  end
end
