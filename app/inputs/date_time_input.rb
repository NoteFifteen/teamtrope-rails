class DateTimeInput < SimpleForm::Inputs::DateTimeInput
  # overriding the default bootstrap date input class
  # including 'date' in the class causes squery validate (http://jqueryvalidation.org)
  # to incorrectly interpret dates as invalid when they aren't.
  def input(wrapper_options)
    super.remove!('date ')
  end
end
