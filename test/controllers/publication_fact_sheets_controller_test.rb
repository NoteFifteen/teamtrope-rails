require 'test_helper'

class PublicationFactSheetsControllerTest < ActionController::TestCase
  setup do
    @publication_fact_sheet = publication_fact_sheets(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:publication_fact_sheets)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create publication_fact_sheet" do
    assert_difference('PublicationFactSheet.count') do
      post :create, publication_fact_sheet: { age_range: @publication_fact_sheet.age_range, author_bio: @publication_fact_sheet.author_bio, author_name: @publication_fact_sheet.author_name, bisac_code_one: @publication_fact_sheet.bisac_code_one, bisac_code_three: @publication_fact_sheet.bisac_code_three, bisac_code_two: @publication_fact_sheet.bisac_code_two, description: @publication_fact_sheet.description, ebook_price: @publication_fact_sheet.ebook_price, endorsements: @publication_fact_sheet.endorsements, one_line_blurb: @publication_fact_sheet.one_line_blurb, paperback_cover_type: @publication_fact_sheet.paperback_cover_type, print_price: @publication_fact_sheet.print_price, project_id: @publication_fact_sheet.project_id, search_terms: @publication_fact_sheet.search_terms, series_name: @publication_fact_sheet.series_name, series_number: @publication_fact_sheet.series_number }
    end

    assert_redirected_to publication_fact_sheet_path(assigns(:publication_fact_sheet))
  end

  test "should show publication_fact_sheet" do
    get :show, id: @publication_fact_sheet
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @publication_fact_sheet
    assert_response :success
  end

  test "should update publication_fact_sheet" do
    patch :update, id: @publication_fact_sheet, publication_fact_sheet: { age_range: @publication_fact_sheet.age_range, author_bio: @publication_fact_sheet.author_bio, author_name: @publication_fact_sheet.author_name, bisac_code_one: @publication_fact_sheet.bisac_code_one, bisac_code_three: @publication_fact_sheet.bisac_code_three, bisac_code_two: @publication_fact_sheet.bisac_code_two, description: @publication_fact_sheet.description, ebook_price: @publication_fact_sheet.ebook_price, endorsements: @publication_fact_sheet.endorsements, one_line_blurb: @publication_fact_sheet.one_line_blurb, paperback_cover_type: @publication_fact_sheet.paperback_cover_type, print_price: @publication_fact_sheet.print_price, project_id: @publication_fact_sheet.project_id, search_terms: @publication_fact_sheet.search_terms, series_name: @publication_fact_sheet.series_name, series_number: @publication_fact_sheet.series_number }
    assert_redirected_to publication_fact_sheet_path(assigns(:publication_fact_sheet))
  end

  test "should destroy publication_fact_sheet" do
    assert_difference('PublicationFactSheet.count', -1) do
      delete :destroy, id: @publication_fact_sheet
    end

    assert_redirected_to publication_fact_sheets_path
  end
end
