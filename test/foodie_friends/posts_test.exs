defmodule FoodieFriends.PostsTest do
  use FoodieFriends.DataCase

  alias FoodieFriends.Posts

  describe "posts" do
    alias FoodieFriends.Posts.Post

    import FoodieFriends.PostsFixtures

    @invalid_attrs %{content: nil, subtitle: nil, title: nil}

    test "list_posts/0 returns all posts" do
      post = post_fixture()
      assert Posts.list_posts() == [post]
    end

    test "get_post!/1 returns the post with given id" do
      post = post_fixture()
      assert Posts.get_post!(post.id) == post
    end

    test "create_post/1 with valid data creates a post" do
      valid_attrs = %{content: "some content", subtitle: "some subtitle", title: "some title"}

      assert {:ok, %Post{} = post} = Posts.create_post(valid_attrs)
      assert post.content == "some content"
      assert post.title == "some title"
    end

    test "create_post/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Posts.create_post(@invalid_attrs)
    end

    test "update_post/2 with valid data updates the post" do
      post = post_fixture()
      update_attrs = %{content: "some updated content", subtitle: "some updated subtitle", title: "some updated title"}

      assert {:ok, %Post{} = post} = Posts.update_post(post, update_attrs)
      assert post.content == "some updated content"
      assert post.title == "some updated title"
    end

    test "update_post/2 with invalid data returns error changeset" do
      post = post_fixture()
      assert {:error, %Ecto.Changeset{}} = Posts.update_post(post, @invalid_attrs)
      assert post == Posts.get_post!(post.id)
    end

    test "delete_post/1 deletes the post" do
      post = post_fixture()
      assert {:ok, %Post{}} = Posts.delete_post(post)
      assert_raise Ecto.NoResultsError, fn -> Posts.get_post!(post.id) end
    end

    test "change_post/1 returns a post changeset" do
      post = post_fixture()
      assert %Ecto.Changeset{} = Posts.change_post(post)
    end

    test "search/1 pulls the post based off of input" do
      post = post_fixture(title: "burger")
      post1 = post_fixture(title: "ice-cream")
      post2 = post_fixture(title: "bacon cheeseburger")

      assert Posts.search("burger") == [post, post2]
      assert Posts.search("Bur") == [post, post2]
      assert Posts.search("BuRger") == [post, post2]
      assert Posts.search("Bur") == [post, post2]
      assert Posts.search("BURGER") == [post, post2]
      assert Posts.search("") == [post, post1, post2]
      refute Posts.search("burger") == [post1]
    end
  end
end
