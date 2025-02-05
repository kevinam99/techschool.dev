defmodule Techschool.CoursesTest do
  use Techschool.DataCase

  alias Techschool.Courses

  import Techschool.ChannelsFixtures

  defp create_channel(_) do
    channel = channel_fixture()
    %{youtube_channel_id: channel.youtube_channel_id}
  end

  describe "courses" do
    setup [:create_channel]

    alias Techschool.Courses.Course

    import Techschool.CoursesFixtures

    @invalid_attrs %{
      name: nil,
      type: nil,
      locale: nil,
      image_url: nil,
      published_at: nil,
      youtube_course_id: nil
    }

    test "list_courses/0 returns all courses", %{youtube_channel_id: youtube_channel_id} do
      course = course_fixture(youtube_channel_id)

      assert Courses.list_courses() == [course]
    end

    test "get_course!/1 returns the course with given id", %{
      youtube_channel_id: youtube_channel_id
    } do
      course = course_fixture(youtube_channel_id)
      assert Courses.get_course!(course.id) == course
    end

    test "create_course/1 with valid data creates a course", %{
      youtube_channel_id: youtube_channel_id
    } do
      valid_attrs = %{
        name: "some name",
        type: :video,
        locale: :en,
        image_url: "some image_url",
        published_at: ~U[2024-01-05 17:44:00Z],
        youtube_course_id: "some youtube_course_id"
      }

      assert {:ok, %Course{} = course} =
               Courses.create_course(valid_attrs, youtube_channel_id)

      assert course.name == "some name"
      assert course.type == :video
      assert course.locale == :en
      assert course.image_url == "some image_url"
      assert course.published_at == ~U[2024-01-05 17:44:00Z]
      assert course.youtube_course_id == "some youtube_course_id"
    end

    test "create_course/1 with invalid data returns error changeset", %{
      youtube_channel_id: youtube_channel_id
    } do
      assert {:error, %Ecto.Changeset{}} =
               Courses.create_course(@invalid_attrs, youtube_channel_id)
    end

    test "delete_course/1 deletes the course", %{youtube_channel_id: youtube_channel_id} do
      course = course_fixture(youtube_channel_id)
      assert {:ok, %Course{}} = Courses.delete_course(course)
      assert_raise Ecto.NoResultsError, fn -> Courses.get_course!(course.id) end
    end
  end
end
