# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

## This is for the Layout Choice partial, and handles the optional inputs for
## the author if they choose to use their pen-name instead of their real name.
jQuery ->
  field = $("input[name=project\\[use_pen_name_on_title\\]]:radio")
  field_value = $("input[name=project\\[use_pen_name_on_title\\]]:checked")

  if ! field.is(':checked') || field_value.val() == 'false'
    $('.pen_name_optional').hide()

  $(field).change (event) =>
     if field.is(':checked')
       field_value = $("input[name=project\\[use_pen_name_on_title\\]]:checked")

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
      'project[layout_style_choice]': {
        required: true
      },
      'project[page_header_display_name]': {
        required: true
      },
      'project[use_pen_name_on_title]': {
        required: true
      },

      'project[pen_name]': {
        required: {
          depends: (element) =>
            return $("input[name=project\\[use_pen_name_on_title\\]]:radio").is(':checked');
        }
      },
      'project[use_pen_name_for_copyright]': {
        required: {
          depends: (element) =>
            return $("input[name=project\\[use_pen_name_on_title\\]]:radio").is(':checked');
        }
      },
      'project[exact_name_on_copyright]': {
        required: {
          depends: (element) =>
            return $("input[name=project\\[use_pen_name_on_title\\]]:radio").is(':checked');
        }
      }
    }
  });

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
			total += parseFloat($(obj).val())
		$("#split_threshold").html(total)
	)
	
	$(".percentage").first().trigger("change")  


## price change promotion form event handlers
jQuery ->
	selector = "input[name=project\\[price_change_promotions_attributes\\]\\[0\\]\\[type\\]]"
	
	field = $(selector + ":radio")
	field_value = $(selector + ":checked")
	
	$(field).change (event) =>
		if field.is(':checked')
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
jQuery ->
	$("#price_promotion_form").validate({
		rules: {
			'project[price_change_promotions_attributes][0][type]': {
				required: true
			},
			'project[price_change_promotions_attributes][0][start_date]': {
				required: true
			},
			'project[price_change_promotions_attributes][0][end_date]': {
				required: true
			},
			'project[price_change_promotions_attributes][0][price_promotion]': {
				required: true
			},
			'project[price_change_promotions_attributes][0][price_after_promotion]': {
				required: true
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

## final manuscript form validations
jQuery ->
	$("#final_manuscript").validate({
		rules: {
			'project[final_pdf]': {
				required: true,
				accept: "application/pdf",
			},
			'project[final_doc_file]': {
				required: true,
				accept: "application/(msword|vnd\.openxmlformats-officedocument\.wordprocessingml\.document)"
			}
		},
		messages: {
			'project[final_pdf]': "You must upload a pdf file.",
			'project[final_doc_file]': "You must upload a doc or docx file."
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
				#accept: "application/octet-stream"
			},
			'project[published_file_attributes][epub]': {
				required: true,
				#accept: "application/(epub\+zip|octet-stream)"
				extension: '.epub'
			},
			'project[published_file_attributes][pdf]': {
				required: true,
				accept: "application/pdf"
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
	return value < 100
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

  field = $("input[name=project\\[previously_published\\]]:radio")
  field_value = $("input[name=project\\[previously_published\\]]:checked")

  if ! field.is(':checked') || field_value.val() == 'false'
    $('.previously_published_true').hide()

  $(field).change (event) =>
     if field.is(':checked')
       field_value = $("input[name=project\\[previously_published\\]]:checked")

       if field_value.val() == 'true'
         $('.previously_published_true').slideDown()
       else
         $('.previously_published_true').slideUp()
         ##$('.optional input').val('').prop("checked", false)

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
		if ! obj.checked
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
			'project[cover_template_attributes][ebook_front_cover]': {
				required: true,
				accept: "image/p?jpeg"
			},
			'project[cover_template_attributes][createspace_cover]': {
				required: true,
				accept: "application/pdf"
			},
			'project[cover_template_attributes][lightning_source_cover]': {
				required: true,
				accept: "application/pdf"
			}
			'project[cover_template_attributes][alternative_cover]': {
				accept: "application/pdf"
			}
		}
	})

## submit proofread
jQuery ->
	$("#submit_proofread").validate({
		rules:{
			checklist_0: { 		
				checklistValidator: [".proofread_manuscript_checklist"] 
			},
			'project[has_sub_chapters]': {
				required: true
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
			'project[manuscript_proofed]': {
				required: true
			}
		}
	})

jQuery ->
	field = $("input[name=tax_id]:radio")
	field_value = $("input[name=tax_id]:checked")
	
	$(field).change (event) =>
		if field.is(':checked')
			field_value = $("input[name=tax_id]:checked")
			
			if field_value.val() == 'ssn'
				$('#social_security_number_wrapper').slideDown()
				$('#business_tax_id_wrapper').slideUp()
			else 
				$('#social_security_number_wrapper').slideUp()
				$('#business_tax_id_wrapper').slideDown()
				
jQuery -> 
  $("#form_1099").validate({
  	rules: {
  		first_name: {
  			required: true
  		},
  		last_name: {
  			required: true
  		},
  		phone: {
  			required: true
  		}
  		email: {
  			required: true
  		},
  		address: {
  			required: true
  		},
  		city: {
  			required: true
  		},
  		state: {
  			required: true
  		},
  		zip: {
  			required: true
  		},
  		bank_name: {
  			required: true
  		},
  		account_type: {
  			required: true
  		},
  		routing_number: {
  			required: true
  		},
  		account_number: {
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
