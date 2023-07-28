defmodule FoodieFriends.Posts do
  @moduledoc """
  The Posts context.
  """

  import Ecto.Query, warn: false
  alias FoodieFriends.Repo

  alias FoodieFriends.Posts.Post

  @doc """
  Returns the list of posts.

  ## Examples

      iex> list_posts()
      [%Post{}, ...]

  """
  def list_posts do
    from(p in Post, where: p.visible and p.published_on <= ^DateTime.utc_now(), order_by: [desc: p.published_on])
    |> Repo.all()
  end

  def search(search_params) do
    query =
      if String.trim(search_params) == "" do
        # If the search term is empty, return all posts
        from p in Post, where: p.visible, order_by: [desc: p.published_on]
      else
        # Perform the search based on the post title or content
        from p in Post,
          where: p.visible,
          where: ilike(p.title, ^"%#{search_params}%") or ilike(p.content, ^"%#{search_params}%"),
          order_by: [desc: p.published_on]
      end

    posts = Repo.all(query)
  end

  @doc """
  Gets a single post.

  Raises `Ecto.NoResultsError` if the Post does not exist.

  ## Examples

      iex> get_post!(123)
      %Post{}

      iex> get_post!(456)
      ** (Ecto.NoResultsError)

  """
  def get_post!(id), do: Repo.get!(Post, id)

  @doc """
  Creates a post.

  ## Examples

      iex> create_post(%{field: value})
      {:ok, %Post{}}

      iex> create_post(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_post(attrs \\ %{}) do
    %Post{}
    |> Post.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a post.

  ## Examples

      iex> update_post(post, %{field: new_value})
      {:ok, %Post{}}

      iex> update_post(post, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_post(%Post{} = post, attrs) do
    post
    |> Post.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a post.

  ## Examples

      iex> delete_post(post)
      {:ok, %Post{}}

      iex> delete_post(post)
      {:error, %Ecto.Changeset{}}

  """
  def delete_post(%Post{} = post) do
    Repo.delete(post)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking post changes.

  ## Examples

      iex> change_post(post)
      %Ecto.Changeset{data: %Post{}}

  """
  def change_post(%Post{} = post, attrs \\ %{}) do
    Post.changeset(post, attrs)
  end
end
