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
$("#revenue_allocation_split").validate({
	rules: {
		fullAmount: {
			percentageSum: [".percentage"]
		}
	}
});
