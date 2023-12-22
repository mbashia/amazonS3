defmodule AmazonS3Web.PuppyLive.FormComponent do
  use AmazonS3Web, :live_component

  alias AmazonS3.Puppies
  alias AmazonS3Web.SimpleS3Upload

  @impl true
  def update(%{puppy: puppy} = assigns, socket) do
    changeset = Puppies.change_puppy(puppy)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)
     |> assign(:uploaded_files, [])
     |> allow_upload(:photo,
       accept: ~w(.jpg .jpeg .png .webp),
       max_entries: 1,
       auto_upload: true,
       external: &presign_upload/2
     )}
  end

  @impl true
  def handle_event("validate", %{"puppy" => puppy_params}, socket) do
    changeset =
      socket.assigns.puppy
      |> Puppies.change_puppy(puppy_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"puppy" => puppy_params}, socket) do
    puppy_params = put_photo_urls(socket, puppy_params)
    save_puppy(socket, socket.assigns.action, puppy_params)
  end

  defp presign_upload(entry, %{assigns: %{uploads: uploads}} = socket) do
    # uploads = socket.assigns.uploads
    # bucket = "phx-upload-example"
    # key = "public/#{entry.client_name}"

    # config = %{
    #   region: "us-east-1",
    #   access_key_id: System.fetch_env!("AWS_ACCESS_KEY_ID"),
    #   secret_access_key: System.fetch_env!("AWS_SECRET_ACCESS_KEY")
    # }

    {:ok, SimpleS3Upload.meta(entry, uploads), socket}
  end

  defp save_puppy(socket, :edit, puppy_params) do
    case Puppies.update_puppy(socket.assigns.puppy, puppy_params) do
      {:ok, _puppy} ->
        {:noreply,
         socket
         |> put_flash(:info, "Puppy updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_puppy(socket, :new, puppy_params) do
    case Puppies.create_puppy(puppy_params) do
      {:ok, _puppy} ->
        {:noreply,
         socket
         |> put_flash(:info, "Puppy created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  defp put_photo_urls(socket, puppy) do
    uploaded_file_urls =
      consume_uploaded_entries(socket, :photo, fn _, entry ->
        {:ok, SimpleS3Upload.entry_url(entry)}
      end)

    %{puppy | "photo" => add_photo_url_to_params(List.first(uploaded_file_urls), puppy["photo"])}
  end

  defp add_photo_url_to_params(s3_url, photo) when is_nil(s3_url), do: photo
  defp add_photo_url_to_params(s3_url, photo), do: s3_url
end
