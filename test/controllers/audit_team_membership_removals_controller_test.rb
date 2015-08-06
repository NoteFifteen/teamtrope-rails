require 'test_helper'

class AuditTeamMembershipRemovalsControllerTest < ActionController::TestCase
  setup do
    @audit_team_membership_removal = audit_team_membership_removals(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:audit_team_membership_removals)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create audit_team_membership_removal" do
    assert_difference('AuditTeamMembershipRemoval.count') do
      post :create, audit_team_membership_removal: { member_id: @audit_team_membership_removal.member_id, notes: @audit_team_membership_removal.notes, notified_member: @audit_team_membership_removal.notified_member, percentage: @audit_team_membership_removal.percentage, reason: @audit_team_membership_removal.reason }
    end

    assert_redirected_to audit_team_membership_removal_path(assigns(:audit_team_membership_removal))
  end

  test "should show audit_team_membership_removal" do
    get :show, id: @audit_team_membership_removal
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @audit_team_membership_removal
    assert_response :success
  end

  test "should update audit_team_membership_removal" do
    patch :update, id: @audit_team_membership_removal, audit_team_membership_removal: { member_id: @audit_team_membership_removal.member_id, notes: @audit_team_membership_removal.notes, notified_member: @audit_team_membership_removal.notified_member, percentage: @audit_team_membership_removal.percentage, reason: @audit_team_membership_removal.reason }
    assert_redirected_to audit_team_membership_removal_path(assigns(:audit_team_membership_removal))
  end

  test "should destroy audit_team_membership_removal" do
    assert_difference('AuditTeamMembershipRemoval.count', -1) do
      delete :destroy, id: @audit_team_membership_removal
    end

    assert_redirected_to audit_team_membership_removals_path
  end
end
