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
end
