# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

## This is for the Layout Choice partial, and handles the optional inputs for
## the author if they choose to use their pen-name instead of their real name.
jQuery ->
  field = $("input[name=project\\[layout_attributes\\]\\[use_pen_name_on_title\\]]:radio")
  field_value = $("input[name=project\\[layout_attributes\\]\\[use_pen_name_on_title\\]]:checked")

  if ! field.is(':checked') || field_value.val() == 'false'
    $('.pen_name_optional').hide()

  $(field).change (event) =>
     if field.is(':checked')
       field_value = $("input[name=project\\[layout_attributes\\]\\[use_pen_name_on_title\\]]:checked")

       if field_value.val() == 'true'
         $('.pen_name_optional').slideDown()
       else
         $('.pen_name_optional').slideUp()
         $('.pen_name_optional input').val('').prop("checked", false)

## Custom validation rules for the Layout Choice partial, since the collection_radio_buttons
## do not have a required option without a bunch of custom code, and form validation on the
## back-end in the model is messy, especially for a partial.
  $( "#edit_layout_style" ).validate({
    rules: {
      'project[layout_attributes][layout_style_choice]': {
        required: true
      },
      'project[layout_attributes][page_header_display_name]': {
        required: true
      },
      'project[layout_attributes][use_pen_name_on_title]': {
        required: true
      },

      'project[layout_attributes][pen_name]': {
        required: {
          depends: (element) =>
            return $("input[name=project\\[layout_attributes\\]\\[use_pen_name_on_title\\]]:radio").is(':checked');
        }
      },
      'project[layout_attributes][use_pen_name_for_copyright]': {
        required: {
          depends: (element) =>
            return $("input[name=project\\[layout_attributes\\]\\[use_pen_name_on_title\\]]:radio").is(':checked');
        }
      },
      'project[layout_attributes][exact_name_on_copyright]': {
        required: {
          depends: (element) =>
            return $("input[name=project\\[layout_attributes\\]\\[use_pen_name_on_title\\]]:radio").is(':checked');
        }
      }
    }
  });

## upload layout form validations
jQuery ->
  $("#upload_layout_form").validate({
    rules: {
      'project[layout_attributes][layout_upload]': {
        required: true,
        accept: "application/pdf",
      }
    },
    messages: {
      'project[layout_attributes][layout_upload]': "You must upload a pdf file.",
    }
  })


## Custom validation rules for the Revenue Split partial
jQuery ->
  $("#revenue_allocation_split").validate({
    ignore: []
    rules: {
      fullAmount: {
        revenueSplitValidation: [".percentage"]
      }
    }
  });

## Revenue Split Partial javascript - Sums the revenue split and displays it so the user
## can easily tell if they have exceeded the threshold or not.
jQuery(document).ready () ->
  $(".percentage").bind("propertychange change click keyup input paste", (event) =>
    total = 0
    $(".percentage").each (index, obj) =>
      field_val = parseFloat($(obj).val())
      field_val = if isNaN(field_val) then 0 else field_val
      total += field_val

    $("#split_threshold").html(total + "%")

    if(maxPercent && total > maxPercent)
      $("#split_threshold").addClass('alert-danger')
    else
      $("#split_threshold").removeClass('alert-danger')

  )

  $(".percentage").first().trigger("change")

jQuery ->
  selector = "input[name=project\\[publication_fact_sheet_attributes\\]\\[age_range\\]]"

  field = $(selector + ":radio")
  ageRange = $(selector + ":checked")

  options = getStartingGradesForAgeRange(ageRange.val())
  renderStartingGradeIndexDropdown(options)

  # when the age range has been changed reset the starting grade level dropdown
  $(field).change (event) =>
    ageRange = $(selector + ":checked")
    options = getStartingGradesForAgeRange(ageRange.val())
    renderStartingGradeIndexDropdown(options)

    # blank out the starting grade level (this will compensate for when the user selects an option without a starting grade level)
    $("#project_publication_fact_sheet_attributes_starting_grade_index").val("")

  # upon saving the form, set the grade level to what was chosen.
  $("#publication_fact_sheet").submit (event) ->
    starting_grade_level = $("#starting_grade_level").val()
    $("#project_publication_fact_sheet_attributes_starting_grade_index").val(starting_grade_level)

# given a list of options renders the dropdown for #starting_grade_level
renderStartingGradeIndexDropdown = (options) ->
  startingGradeIndex = $("#project_publication_fact_sheet_attributes_starting_grade_index").val()

  startingGradeLevel = $("#starting_grade_level")
  startingGradeLevel.empty()
  for key, val of options
    selected = ""
    if (parseInt(val) == parseInt(startingGradeIndex))
      selected = "selected"
    startingGradeLevel.append("<option " + selected + " value=\"" + val + "\">" + key + "</option>")

# returns a list of corresponding grade levels for the provided ageRange
getStartingGradesForAgeRange = (ageRange) ->
  options = {}
  options["Please choose a starting grade level"] = ""
  switch ageRange
    when 'grade_school'
      $("#starting_grade_level_wrapper").slideDown()
      options["Pre-K"] = 0
      options["Kindergarten"] = 1
      options["1st Grade"] = 2
      options["2nd Grade"] = 3
      options["3rd Grade"] = 4
      options["4th Grade"] = 5
    when 'middle_school'
      $("#starting_grade_level_wrapper").slideDown()
      options["5th Grade"] = 6
      options["6th Grade"] = 7
      options["7th Grade"] = 8
      options["8th Grade"] = 9
    when 'high_school'
      $("#starting_grade_level_wrapper").slideDown()
      options["9th Grade"] = 10
      options["10th Grade"] = 11
      options["11th Grade"] = 12
      options["12th Grade"] = 13
    else
      $("#starting_grade_level_wrapper").slideUp()

  options

## price change promotion form event handlers
jQuery ->
  selector = "input[name=project\\[price_change_promotions_attributes\\]\\[0\\]\\[type\\]]"

  field = $(selector + ":radio")
  field_value = $(selector + ":checked")

  $(field).change (event) =>
    if field.is(':checked')
      $(".submit_button").slideDown()
      field_value = $(selector + ":checked")

      switch field_value.val()
        when "temporary_force_free"
          $(".start_date").slideDown()
          $(".end_date").slideDown()
          $(".price_promotion").slideUp()
          $(".price_after_promotion").slideDown()
          $(".temp_price_promotion").slideUp()
        when "temporary_price_drop"
          $(".start_date").slideDown()
          $(".end_date").slideDown()
          $(".price_promotion").slideDown()
          $(".price_after_promotion").slideDown()
          $(".temp_price_promotion").slideDown()
        when "permanent_force_free"
          $(".start_date").slideDown()
          $(".end_date").slideUp()
          $(".price_promotion").slideUp()
          $(".price_after_promotion").slideUp()
          $(".temp_price_promotion").slideUp()
        when "permanent_price_drop"
          $(".start_date").slideDown()
          $(".end_date").slideUp()
          $(".price_promotion").slideDown()
          $(".price_after_promotion").slideUp()
          $(".temp_price_promotion").slideUp()

## price change promotion form validators
## Blog Tour Form validations
jQuery.validator.addMethod("priceAfterPromotionValidator", (value, element, params) ->
  return value > 0
, jQuery.validator.format("Price After Promotion must be greater than 0.")
)
jQuery.validator.addMethod("priceValidator", (value, element, params) ->
  if value >= 0.99 && value <= 9.99
    return true
  else
    return false
, jQuery.validator.format("Price must be within $0.99 and $9.99 Use force free promotion for free book promotions")
)
jQuery ->
  $("#price_promotion_form").validate({
    rules: {
      'project[price_change_promotions_attributes][0][type]': {
        required: true
      },
      'project[price_change_promotions_attributes][0][start_date]': {
        required: false
      },
      'project[price_change_promotions_attributes][0][end_date]': {
        required: false
      },
      'project[price_change_promotions_attributes][0][price_promotion]': {
        required: true,
        priceValidator: 'price_promotion_form'
      },
      'project[price_change_promotions_attributes][0][price_after_promotion]': {
        required: true,
        priceAfterPromotionValidator: "#price_promotion_form",
        priceValidator: 'price_promotion_form'
      }
    }
  })

## status update form validations
jQuery ->
  $("#status_update").validate({
    rules: {
      'project[status_updates_attributes][0][type]': {
        required: true
      },
      'project[status_updates_attributes][0][status]': {
        required: true
      }
    }
  })

## Media Kit Form validations
jQuery ->
  $("#media_kit").validate({
    rules: {
      'project[media_kits_attributes][0][document]': {
        required: true,
        accept: "application/(pdf|msword|vnd\.openxmlformats-officedocument\.wordprocessingml\.document)",
      }
    },
    messages: {
      'project[media_kits_attributes][0][document]': "You must upload either a pdf, doc, or docx file."
    }
  })

jQuery ->
  $("#publish_book").validate({
    rules: {
      'project[published_file_attributes][mobi]': {
        required: true,
        extension: '.mobi'
      },
      'project[published_file_attributes][epub]': {
        required: true,
        extension: '.epub'
      },
      'project[published_file_attributes][pdf]': {
        required: false,
        extension: '.pdf'
      }
    },
    messages: {
      'project[published_file_attributes][mobi]': 'You must upload a mobi file.'
      'project[published_file_attributes][epub]': 'You must upload an epub file.'
      'project[published_file_attributes][pdf]':  'You must upload a pdf.'
    }
  })


## Blog Tour Form validations
jQuery.validator.addMethod("blogTourCostValidator", (value, element, params) ->
  return value <= 100
, jQuery.validator.format("Cost must not exceed $100.")
)

jQuery ->
  $("#blog_tour").validate({
    rules: {
      'project[blog_tours_attributes][0][cost]': {
        required: true,
        blogTourCostValidator: "#project_blog_tour_cost"
      }
    }
  })

## per task 205 https://booktrope.acunote.com/projects/47888/tasks/205
## previously published was removed from the submit proofed form, but I left the jquery
## that shows and hides the related fields since the fields are going to be moved to another
## form.
jQuery ->

  field = $("#submit_proofread input[name=project\\[previously_published\\]]:radio")
  field_value = $("#submit_proofread input[name=project\\[previously_published\\]]:checked")

  if ! field.is(':checked') || field_value.val() == 'false'
    $('.previously_published_true').hide()

  $(field).change (event) =>
     if field.is(':checked')
       field_value = $("#submit_proofread input[name=project\\[previously_published\\]]:checked")

       if field_value.val() == 'true'
         $('.previously_published_true').slideDown()
       else
         $('.previously_published_true').slideUp()
         $('.optional input').val('').prop("checked", false)

jQuery ->
  field = $("input[name=does_contain_images]:radio")
  field_value = $("input[name=does_contain_images]:checked")

  $(field).change (event) =>
    if field.is(':checked')
      field_value = $("input[name=does_contain_images]:checked")

      if field_value.val() == '1'
        $('.does_contain_images_1').slideDown()
        $('.does_contain_images_2').slideUp()
      else if field_value.val() == '2'
        $('.does_contain_images_2').slideDown()
        $('.does_contain_images_1').slideUp()
      else
        $('.does_contain_images_1').slideUp()
        $('.does_contain_images_2').slideUp()


## checklist custom validator
jQuery.validator.addMethod("checklistValidator", (value, element, params) ->
  is_user_ready_to_upload = true
  $(params[0]).each (index, obj) ->
    if ! $(obj).is(':checked')
      is_user_ready_to_upload = false
  return is_user_ready_to_upload
, jQuery.validator.format("You must sign off that you have completed all steps in order to submit the form.")
)

## upload_cover_templates
jQuery ->
  $("#upload_cover_templates").validate({
    rules: {
      checklist_0: {
        checklistValidator: [".upload_cover_checklist"]
      },
      font_list: {
        required: true,
        minlength: 3
      }
    }
  })

# Custom ASIN Format Validator
jQuery.validator.addMethod('bisacFormatValidator', (value, element, params) ->
  match = value.match(/([A-z]{3}[0-9]{6})/gi)
  return ((value.length == 9 && match != null) || value == '')
, jQuery.validator.format('Bisac must be 9 characters long and follow the foramt: ABC123456.')
)

jQuery ->
  $("#publication_fact_sheet").validate({
    rules: {
      'starting_grade_level':{
        required: true
      },
      'project[publication_fact_sheet_attributes][age_range]': {
        required: true
      },
      'project[publication_fact_sheet_attributes][paperback_cover_type]': {
        required: true
      },
      'project[publication_fact_sheet_attributes][one_line_blurb]':{
        required: true,
        maxlength: 300
      },
      'project[publication_fact_sheet_attributes][bisac_code_one]': {
        required: true,
        bisacFormatValidator: true
      },
      'project[publication_fact_sheet_attributes][bisac_code_two]': {
        bisacFormatValidator: true
      },
      'project[publication_fact_sheet_attributes][bisac_code_three]': {
        bisacFormatValidator: true
      }
    }
  })

jQuery ->
  field = $("#project_layout_attributes_trim_size")

  $(field).bind("change", (event) =>
    if field.val() == "other"
      $("#update_final_page_count_other_trim").show()
      $("#project_layout_attributes_trim_size_w").val('')
      $("#project_layout_attributes_trim_size_h").val('')
    else
      $("#update_final_page_count_other_trim").hide()
      trim_size = field.val()
      dimensions = trim_size.split(',')
      $("#project_layout_attributes_trim_size_w").val(dimensions[0])
      $("#project_layout_attributes_trim_size_h").val(dimensions[1])
  )


jQuery ->
  $("#final_page_count").validate({
    rules:{
      'project[publication_fact_sheet_attributes][print_price]': {
        required: true
      },
      'project[layout_attributes][final_page_count]': {
        required: true
      },
      'project[layout_attributes][trim_size]': {
        required: true
      }
    }
  })

jQuery ->
  field = $("#project_marketing_expenses_attributes_0_expense_type")

  $(field).bind("change", (event) =>
    if field.val() == "Other - Please Describe below"
      $("#other_expense_type_li").show()
    else
      $("#other_expense_type_li").hide()
  )

jQuery ->
  field = $("#project_marketing_expenses_attributes_0_service_provider")

  $(field).bind("change", (event) =>
    if field.val() == "Other - Please specify below"
      $("#other_service_provider_li").show()
    else
      $("#other_service_provider_li").hide()
  )

jQuery ->
  $("#marketing_expense").validate({
    rules: {
    }
  })

## Check Imprint
jQuery ->
  $("#check_imprint").validate({
    rules:{
      'project[imprint_id]': {
        required: true
      },
      'project[control_number_attributes][paperback_isbn]': {
        required: true
      }
    }
  })

## Control Numbers

# Strip spaces out of the inputs for all inputs matching control_number_attributes
jQuery(document).ready () ->
  $('input[name^=project\\[control_number_attributes\\]]').change (event) ->
    this.value = this.value.replace(/\s/g, '')

# Custom ISBN Format validator
jQuery.validator.addMethod('isbnFormatValidator', (value, element, params) ->
  value = value.replace(/-/g, '')
  return ((value.length == 13 && ! isNaN(value)) || value == '')
, jQuery.validator.format('ISBN must be in the format XXX-X-XXXXX-XXX-X or XXXXXXXXXXXXX')
)

# Custom ASIN Format Validator
jQuery.validator.addMethod('asinFormatValidator', (value, element, params) ->
  match = value.match(/([A-z0-9]{10})/gi)
  return ((value.length == 10 && match != null) || value == '')
, jQuery.validator.format('ASIN must be 10 characters long using only alphanumeric characters.')
)

jQuery ->
  $('#control_numbers').validate({
    rules: {
      'project[control_number_attributes][apple_id]': {
        number: true
      },
      'project[control_number_attributes][asin]': {
        asinFormatValidator: true
      },
      'project[control_number_attributes][encore_asin]': {
        asinFormatValidator: true
      },
      'project[control_number_attributes][bnid]': {
        number: true
      },
      'project[control_number_attributes][epub_isbn]': {
        isbnFormatValidator: true
      },
      'project[control_number_attributes][hardback_isbn]': {
        isbnFormatValidator: true
      },
      'project[control_number_attributes][paperback_isbn]': {
        isbnFormatValidator: true
      },
    }
  })

## submit proofread

## target marketing launch date custom validator -- Must be 5 weeks in the future or more
jQuery.validator.addMethod("targetMarketLaunchDateValidator", (value, element, params) ->
  inputDate = Date.parse(value);

  if($('input[name=have_target_market_date]:checked').val() != 'yes')
    return true;

  if (isNaN(inputDate))
    return false

  # Three weeks in the future is the minimum
  fiveWeeks = new Date();
  fiveWeeks.setDate(fiveWeeks.getDate() + 34);

  return (fiveWeeks <= inputDate)
, jQuery.validator.format("You must select a date at least five weeks in the future.")
)

jQuery ->
  $("#submit_proofread").validate({
    rules:{
      checklist_0: {
        checklistValidator: ["input.proofread_manuscript_checklist"]
      },
      'project[has_sub_chapters]': {
        required: true
      },
      'project[previously_published]': {
        required: true
      },

      'project[previously_published_title]': {
        required: {
          depends: (element) =>
            return ($("input[name=project\\[previously_published\\]]:checked").val() == "true");
        }
      },

      'project[previously_published_year]': {
        required: {
          depends: (element) =>
            return ($("input[name=project\\[previously_published\\]]:checked").val() == "true");
        }
      },

      'project[previously_published_publisher]': {
        required: {
          depends: (element) =>
            return ($("input[name=project\\[previously_published\\]]:checked").val() == "true");
        }
      },

      does_contain_images: {
        required: true
      },
      teamtrope_link: {
        required: {
          depends: (element) =>
            return $("input[name=does_contain_images]:checked").val() == '1';
        }
      },
      dropbox_link: {
        required: {
          depends: (element) =>
            return $("input[name=does_contain_images]:checked").val() == '2';
        }
      },
      'project[manuscript_attributes][proofed]': {
        required: true
        accept: "application/(msword|vnd\.openxmlformats-officedocument\.wordprocessingml\.document)"
      },

      'have_target_market_date' : {
        required: true
      },
      'target_market_launch_date_display': {
        required: {
          depends: (element) =>
            return $('input[name=have_target_market_date]:checked').val() == 'yes'
        },
        targetMarketLaunchDateValidator: true
      }
    }
  })

# For the 1099 Form
jQuery ->
  $("#form_1099").validate({
    rules: {
      'form_1099[first_time]': {
        required: true
      },
      'form_1099[first_name]': {
        required: true
      },
      'form_1099[last_name]': {
        required: true
      },
      'form_1099[phone]': {
        required: true
      }
      'form_1099[email]': {
        required: true
      },
      'form_1099[us_citizen_or_resident]': {
        required: true
      },
      'form_1099[address]': {
        required: true
      },
      'form_1099[city]': {
        required: true
      },
      'form_1099[state]': {
        required: true
      },
      'form_1099[zip]': {
        required: true
      },
      'form_1099[tax_id]': {
        required: true
      },
      'form_1099[social_security_number]': {
        required: {
          depends: (element) =>
            return $("input[name=form_1099\\[tax_id\\]]:checked").val() == 'ssn';
        }
      },
      'form_1099[business_tax_id]': {
        required: {
          depends: (element) =>
            return $("input[name=form_1099\\[tax_id\\]]:checked").val() == 'eid';
        }
      },
      'form_1099[business_name]': {
        required: {
          depends: (element) =>
            return $("input[name=form_1099\\[tax_id\\]]:checked").val() == 'eid';
        }
      },
      'form_1099[bank_name]': {
        required: true
      },
      'form_1099[account_type]': {
        required: true
      },
      'form_1099[routing_number]': {
        required: true
      },
      'form_1099[account_number]': {
        required: true
      }
    }
  });

jQuery ->
  field = $("input[name=form_1099\\[tax_id\\]]:radio")

  $(field).change (event) =>
    if field.is(':checked')
      field_value = $("input[name=form_1099\\[tax_id\\]]:checked")

    if field_value.val() == 'ssn'
        $('#social_security_number_wrapper').slideDown()
        $('#business_tax_id_wrapper').slideUp()
      else if field_value.val() == 'eid'
        $('#business_tax_id_wrapper').slideDown()
        $('#social_security_number_wrapper').slideUp()


## This is for the Approve Cover Art partial, and handles the optional inputs for
## the notes if they do not approve the Cover Art.
jQuery(document).ready () ->


  ## Custom validation rules for the Approve Cover Art partial
  $( "#approve_cover_art" ).validate({
    rules: {
      'project[cover_art_approval_decision]': {
        required: true
      },
      'project[cover_concept_notes]': {
        required: {
          depends: (element) =>
            return $("input[name=project\\[cover_art_approval_decision\\]]:checked").val() == 'false';
        }
      }
    }
  });

## production_expense Form validations
jQuery.validator.addMethod("complimentaryCopyValidator", (value, element, params) ->
  return value <= 10 && value >= 0
, jQuery.validator.format("Complimentary orders must be 0 or less than or equal to 10")
)

## Custom validation rules for production_expense
jQuery ->
  $("#production_expense").validate({
    rules: {
      'project[production_expenses_attributes][0][complimentary_quantity]': {
        complimentaryCopyValidator: ''
      }
    }
  });

jQuery(document).ready () ->
  $(".complimentary").bind("propertychange change click keyup input paste", (event) =>
    total = $("#complimentary_quantity").val() / $("#total_quantity_ordered").val() * $("#total_cost").val()
    $("#complimentary_cost").val(total.toFixed(2)))

  $(".complimentary").first().trigger("change")

  $(".advance").bind("propertychange change click keyup input paste", (event) =>
    total = $("#advance_quantity").val() / $("#total_quantity_ordered").val() * $("#total_cost").val()
    $("#total_author_advance_cost").val(total.toFixed(2)))

  $(".advance").first().trigger("change")

  $(".purchased").bind("propertychange change click keyup input paste", (event) =>
    total = $("#total_cost").val() / $("#total_quantity_ordered").val() * $("#total_purchased_quantity").val()
    $("#total_purchased_cost").val(total.toFixed(2)))

  $(".purchased").first().trigger("change")

  $(".marketing").bind("propertychange change click keyup input paste", (event) =>
    total = $("#marketing_quantity").val() / $("#total_quantity_ordered").val() * $("#total_cost").val()
    $("#total_marketing_cost").val(total.toFixed(2)))

  $(".marketing").first().trigger("change")
