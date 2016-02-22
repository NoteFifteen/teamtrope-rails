$(document).ready(function(){

  var stlPageValidator = $("#submit_to_layout_form").validate({
      errorElement: 'span',
      errorClass: 'validationError',
      errorPlacement: function(error, element) {
        // Put the error to the right
        if(element.attr('type') === 'radio') {
          var list = $(element).closest('ul');
          error.insertBefore(list);
        } else {
          error.insertBefore(element);
        }
      },
      rules: {
        checklist_0: {
          checklistValidator: ["input.submit_to_layout_checklist"]
        },
        "project[book_type]": {
          required: true
        },
        "project[previously_published]": {
          required: true
        },
        'project[previously_published_title]': {
          required: {
            depends: function(element) {
              return ($("input[name=project\\[previously_published\\]]:checked").val() == "true");
            }
          }
        },
        'project[previously_published_year]': {
          required: {
            depends: function(element) {
              return ($("input[name=project\\[previously_published\\]]:checked").val() == "true");
            }
          }
        },
        'project[previously_published_publisher]': {
          required: {
            depends: function(element) {
              return ($("input[name=project\\[previously_published\\]]:checked").val() == "true");
            }
          }
        },
        "project[book_genres_attributes][0][genre_id]": {
          required: true
        },
        "project[imprint_id]": {
          required: true
        },
        does_contain_images: {
          required: true
        },
        "project[has_sub_chapters]": {
          required: true
        },
        "project[does_contain_images]": {
          required: true
        },
        teamtrope_link: {
          required: {
            depends: function(element) {
              return $("input[name=does_contain_images]:checked").val() == '1';
            }
          }
        },
        dropbox_link: {
          required: {
            depends: function(element) {
              return $("input[name=does_contain_images]:checked").val() == '2';
            }
          }
        },
        "project[table_of_contents]": {
          required: true
        },
        "project[layout_attributes][layout_style_choice]": {
          required: true
        },
        "project[layout_attributes][page_header_display_name]": {
          required: true
        },
        "project[layout_attributes][use_pen_name_on_title]": {
          required: true
        },
        "project[layout_attributes][pen_name]": {
          required: true
        },
        "project[layout_attributes][use_pen_name_for_copyright]": {
          required: true
        },
        "project[layout_attributes][exact_name_on_copyright]": {
          required: true
        },
        "project[proofed_word_count]": {
          required: true
        },
        have_target_market_date: {
          required: true
        },
        target_market_launch_date_display: {
          required: {
            depends: function(element) {
              return $("input[name=have_target_market_date]:checked").val() == "yes"
            }
          },
          targetMarketLaunchDateValidator: true
        }
      },
      messages: {
        "project[book_type]": {
          required: "Please select a project type"
        },
        "project[previously_published]": {
          required: "Please indicate if the book has been previously published"
        },
        "project[book_genres_attributes][0][genre_id]": {
          required: "Please select a genre"
        },
        "project[imprint_id]": {
          required: "Please select an imprint"
        },
        does_contain_images: {
          required: "Please indicate if the book contains images"
        },
        "project[has_sub_chapters]": {
          required: "Please indicate if the book has subheadings"
        },
        teamtrope_link:
        {
          required: "Please provide a link to the docs section of teamroom"
        },
        dropbox_link: {
          required: "Please provide a dropbox link"
        },
        "project[table_of_contents]": {
          required: "Please indicate if you have provided a TOC for the paperback edition of your book"
        },
        "project[layout_attributes][layout_style_choice]": {
          required: "Please choose a style"
        },
        "project[layout_attributes][page_header_display_name]": {
          required: "Please choose a Left Side Page Header Display Name"
        },
        "project[layout_attributes][use_pen_name_on_title]": {
          required: "Please inidcate if you are using a pen name"
        },
        "project[layout_attributes][pen_name]": {
          required: "Please provide your pen name"
        },
        "project[layout_attributes][use_pen_name_for_copyright]": {
          required: "Pleae indicate if you are going to use your pen name on for the copyright"
        },
        "project[layout_attributes][exact_name_on_copyright]": {
          required: "Please provide the exact name you want on the copyright"
        },
        "project[proofed_word_count]": {
          required: "Please provide the manuscript word count"
        },
        have_target_market_date: {
          required: "Please indicate if you have a target market date"
        },
        target_market_launch_date_display: {
          required: "Please choose a launch date"
        }
      }
    });


  // next buttons
  $("#submit_to_layout_next_button_1").click(function() {

    stlPageValidator.element('[name=checklist_0]')
    if(stlPageValidator.valid()) {
      $("#submit-to-layout-page-1").hide();
      $("#submit-to-layout-page-2").show();
    }
  });

  $("#submit_to_layout_next_button_2").click(function() {

    var isValid = true
    if (!stlPageValidator.element('[name=project\\[book_type\\]]'))
      isValid = false
    if (!stlPageValidator.element('[name=project\\[previously_published\\]]'))
      isValid = false
    if (!stlPageValidator.element('[name=project\\[previously_published_title\\]]'))
      isValid = false
    if (!stlPageValidator.element('[name=project\\[previously_published_year\\]]'))
      isValid = false
    if (!stlPageValidator.element('[name=project\\[previously_published_publisher\\]]'))
      isValid = false
    if (!stlPageValidator.element('[name=project\\[book_genres_attributes\\]\\[0\\]\\[genre_id\\]]'))
      isValid = false
    if (!stlPageValidator.element('[name=project\\[imprint_id\\]]'))
      isValid = false

    if(isValid) {
      $("#submit-to-layout-page-2").hide();
      $("#submit-to-layout-page-3").show();
    }
  });

  $("#submit_to_layout_next_button_3").click(function() {

    var isValid = true
    if (!stlPageValidator.element('[name=does_contain_images]'))
      isValid = false
    if (!stlPageValidator.element('[name=dropbox_link]'))
      isValid = false
    if (!stlPageValidator.element('[name=teamtrope_link]'))
      isValid = false
    if (!stlPageValidator.element('[name=project\\[has_sub_chapters\\]]'))
      isValid = false
    if (!stlPageValidator.element('[name=project\\[table_of_contents\\]]'))
      isValid = false

    if(isValid) {
      $("#submit-to-layout-page-3").hide();
      $("#submit-to-layout-page-4").show();
    }

  });

  $("#submit_to_layout_next_button_4").click(function() {

    var isValid = true
    if (!stlPageValidator.element('[name=project\\[layout_attributes\\]\\[layout_style_choice\\]]'))
      isValid = false
    if (!stlPageValidator.element('[name=project\\[layout_attributes\\]\\[page_header_display_name\\]]'))
      isValid = false
    if (!stlPageValidator.element('[name=project\\[layout_attributes\\]\\[use_pen_name_on_title\\]]'))
      isValid = false
    if (!stlPageValidator.element('[name=project\\[layout_attributes\\]\\[pen_name\\]]'))
      isValid = false
    if (!stlPageValidator.element('[name=project\\[layout_attributes\\]\\[use_pen_name_for_copyright\\]]'))
      isValid = false
    if (!stlPageValidator.element('[name=project\\[layout_attributes\\]\\[exact_name_on_copyright\\]]'))
      isValid = false

    if(isValid) {
      $("#submit-to-layout-page-4").hide();
      $("#submit-to-layout-page-5").show();
      $("#final_manuscript_upload").show();
    }

  });

  $("#submit_to_layout_submit_button_fake").click(function() {
    var isValid = true
    if (!stlPageValidator.element('[name=project\\[proofed_word_count\\]]'))
      isValid = false
    if (!stlPageValidator.element('[name=have_target_market_date]'))
      isValid = false
    if (!stlPageValidator.element('[name=target_market_launch_date_display]'))
      isValid = false

    if (isValid)
    {
      $("#submit_to_layout_form").submit();
    }
  });

  // Back Buttons
  $("#submit_to_layout_back_button_2").click(function() {
    $("#submit-to-layout-page-1").show();
    $("#submit-to-layout-page-2").hide();
  });

  $("#submit_to_layout_back_button_3").click(function() {
    $("#submit-to-layout-page-2").show();
    $("#submit-to-layout-page-3").hide();
  });

  $("#submit_to_layout_back_button_4").click(function() {
    $("#submit-to-layout-page-3").show();
    $("#submit-to-layout-page-4").hide();
  });

  $("#submit_to_layout_back_button_5").click(function() {
    $("#submit-to-layout-page-4").show();
    $("#submit-to-layout-page-5").hide();
    $("#final_manuscript_upload").hide();
  });

});
