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

jQuery ->
	field = $("input[name=tax_id]:radio")
	field_value = $("input[name=tax_id]:checked")
	
	if ! field.is(':checked')
		$('#business_tax_id_wrapper').hide()
		$('#social_security_number_wrapper').hide()
			
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
