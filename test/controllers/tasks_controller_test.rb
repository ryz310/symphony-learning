require "test_helper"

class TasksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @task = tasks(:one)
  end

  test "should get index" do
    get tasks_url
    assert_response :success
  end

  test "should show task" do
    get task_url(@task)
    assert_response :success
  end

  test "should create task with valid params" do
    assert_difference("Task.count", 1) do
      post tasks_url, params: { task: { title: "New task", description: "Desc" } }
    end

    assert_redirected_to tasks_url
  end

  test "should not create task with invalid params" do
    assert_no_difference("Task.count") do
      post tasks_url, params: { task: { title: "", description: "Desc" } }
    end

    assert_response :unprocessable_entity
  end

  test "should destroy task" do
    assert_difference("Task.count", -1) do
      delete task_url(@task)
    end

    assert_redirected_to tasks_url
  end

  test "should render markdown description on show" do
    task = Task.create!(title: "Markdown task", description: "**Bold**\n\n- Item")

    get task_url(task)

    assert_response :success
    assert_includes @response.body, "<strong>Bold</strong>"
    assert_match %r{<ul>.*<li>.*Item.*</li>.*</ul>}m, @response.body
  end

  test "should sanitize unsafe markdown links on show" do
    task = Task.create!(title: "Unsafe link task", description: "[xss](javascript:alert('xss'))")

    get task_url(task)

    assert_response :success
    refute_match %r{href="javascript:}i, @response.body
  end
end
