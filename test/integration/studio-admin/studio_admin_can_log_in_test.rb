require "test_helper"

class AdminCanLogInTest < ActionDispatch::IntegrationTest
  test "login with valid information" do
    studio = create_studio
    admin = studio.users.create(email: "admin@example.com",
                                password: "password",
                                )
    admin.roles << studio_admin_role
    visit login_path

    fill_in  "Email", with: "admin@example.com"
    fill_in  "Password", with: "password"

    within(".login") do
      click_on "Log In"
    end

    assert_equal admin_path(studio), current_path

    within(".studio-name") do
      assert page.has_content?(studio.name)
    end
  end
end
