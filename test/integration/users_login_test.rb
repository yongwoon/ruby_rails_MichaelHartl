require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  def setup
    @admin     = users(:michael)
    @non_admin = users(:archer)
  end

  test "login with invalid information" do
    get login_path
    assert_template 'sessions/new'
    post login_path, params: { session: { email: "", password: "" } }
    assert_template 'sessions/new'
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end

  test "login with valid information followed by logout" do
    # get login_path
    # post login_path, params: { session: { email:    @user.email,
    #                                       password: 'password' } }
    # assert is_logged_in?
    # assert_redirected_to @user
    # follow_redirect!
    # assert_template 'users/show'
    # assert_select "a[href=?]", login_path, count: 0
    # assert_select "a[href=?]", logout_path
    # assert_select "a[href=?]", user_path(@user)
    # delete logout_path
    # assert_not is_logged_in?
    # assert_redirected_to root_url
    # # Simulate a user clicking logout in a second window.
    # delete logout_path
    # follow_redirect!
    # assert_select "a[href=?]", login_path
    # assert_select "a[href=?]", logout_path,      count: 0
    # assert_select "a[href=?]", user_path(@user), count: 0
  end

  test "login with remembering" do
    # log_in_as(@user, remember_me: '1')
    # assert_not_empty cookies['remember_token']
    # # assert_equal FILL_IN, assigns(:user).FILL_IN
  end

  test "login without remembering" do
    # # Log in to set the cookie.
    # log_in_as(@user, remember_me: '1')
    # # Log in again and verify that the cookie is deleted.
    # log_in_as(@user, remember_me: '0')
    # assert_empty cookies['remember_token']
  end

  test "index as admin including pagination and delete links" do
    log_in_as(@admin)
    get users_path
    assert_template 'users/index'
    assert_select 'div.pagination'
    first_page_of_users = User.paginate(page: 1)
    first_page_of_users.each do |user|
      assert_select 'a[href=?]', user_path(user), text: user.name
      unless user == @admin
        assert_select 'a[href=?]', user_path(user), text: 'delete'
      end
    end
    assert_difference 'User.count', -1 do
      delete user_path(@non_admin)
    end
  end

  test "index as non-admin" do
    log_in_as(@non_admin)
    get users_path
    assert_select 'a', text: 'delete', count: 0
  end
end