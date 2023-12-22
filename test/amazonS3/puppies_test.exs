defmodule AmazonS3.PuppiesTest do
  use AmazonS3.DataCase

  alias AmazonS3.Puppies

  describe "puppies" do
    alias AmazonS3.Puppies.Puppy

    import AmazonS3.PuppiesFixtures

    @invalid_attrs %{breed: nil, color: nil, name: nil, photo: nil}

    test "list_puppies/0 returns all puppies" do
      puppy = puppy_fixture()
      assert Puppies.list_puppies() == [puppy]
    end

    test "get_puppy!/1 returns the puppy with given id" do
      puppy = puppy_fixture()
      assert Puppies.get_puppy!(puppy.id) == puppy
    end

    test "create_puppy/1 with valid data creates a puppy" do
      valid_attrs = %{breed: "some breed", color: "some color", name: "some name", photo: "some photo"}

      assert {:ok, %Puppy{} = puppy} = Puppies.create_puppy(valid_attrs)
      assert puppy.breed == "some breed"
      assert puppy.color == "some color"
      assert puppy.name == "some name"
      assert puppy.photo == "some photo"
    end

    test "create_puppy/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Puppies.create_puppy(@invalid_attrs)
    end

    test "update_puppy/2 with valid data updates the puppy" do
      puppy = puppy_fixture()
      update_attrs = %{breed: "some updated breed", color: "some updated color", name: "some updated name", photo: "some updated photo"}

      assert {:ok, %Puppy{} = puppy} = Puppies.update_puppy(puppy, update_attrs)
      assert puppy.breed == "some updated breed"
      assert puppy.color == "some updated color"
      assert puppy.name == "some updated name"
      assert puppy.photo == "some updated photo"
    end

    test "update_puppy/2 with invalid data returns error changeset" do
      puppy = puppy_fixture()
      assert {:error, %Ecto.Changeset{}} = Puppies.update_puppy(puppy, @invalid_attrs)
      assert puppy == Puppies.get_puppy!(puppy.id)
    end

    test "delete_puppy/1 deletes the puppy" do
      puppy = puppy_fixture()
      assert {:ok, %Puppy{}} = Puppies.delete_puppy(puppy)
      assert_raise Ecto.NoResultsError, fn -> Puppies.get_puppy!(puppy.id) end
    end

    test "change_puppy/1 returns a puppy changeset" do
      puppy = puppy_fixture()
      assert %Ecto.Changeset{} = Puppies.change_puppy(puppy)
    end
  end
end
