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

    $("#split_threshold").html(total + " %")

    if(maxPercent && total > maxPercent)
      $("#split_threshold").addClass('alert-danger')
    else
      $("#split_threshold").removeClass('alert-danger')

  )

  $(".percentage").first().trigger("change")


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
        required: true
      },
      'project[price_change_promotions_attributes][0][price_after_promotion]': {
        required: true,
        priceAfterPromotionValidator: "#price_promotion_form"
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
      }
    }
  })

jQuery ->
  $("#publication_fact_sheet").validate({
    rules: {
      'project[publication_fact_sheet_attributes][age_range]': {
        required: true
      },
      'project[publication_fact_sheet_attributes][paperback_cover_type]': {
        required: true
      },
      'project[publication_fact_sheet_attributes][one_line_blurb]':{
        required: true,
        maxlength: 300
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

## submit proofread
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
      }
    }
  })

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

## This is for the Approve Cover Art partial, and handles the optional inputs for
## the notes if they do not approve the Cover Art.
jQuery(document).ready () ->
  field = $("input[name=project\\[cover_art_approval_decision\\]]:radio")
  field_value = $("input[name=project\\[cover_art_approval_decision\\]]:checked")

  if ! field.is(':checked') || field_value.val() != 'true'
    $('#cover_concept_notes_box').hide()

  $(field).change (event) =>
    if field.is(':checked')
      field_value = $("input[name=project\\[cover_art_approval_decision\\]]:checked")

      if field_value.val() == 'true'
        $('#cover_concept_notes_box').hide()
      else
        $('#cover_concept_notes_box').show()

  ## Custom validation rules for the Approve Cover Art partial
  $( "#approve_cover_art" ).validate({
    rules: {
      'project[cover_art_approval_decision]': {
        required: true
      },
      'project[cover_concept_notes]': {
        required: {
          depends: (element) =>
            return $("input[name=project\\[cover_art_approval_decision\\]]:radio").is(':checked');
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

