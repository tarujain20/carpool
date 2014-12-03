module RidesHelper
  def leave_home_at
    timings = ['5:00', '5:30', '6:00', '6:30', '7:00', '7:30', '8:00', '8:30', '9:00', '9:30', '10:00', '10:30', '11:00']
    timings.collect { |p| [ "#{p} am", "#{p} am" ] }
  end

  def leave_work_at
    timings = ['3:00', '3:30', '4:00', '4:30', '5:00', '5:30', '6:00', '6:30', '7:00', '7:30', '8:00', '8:30', '9:00', '9:30', '10:00', '10:30']
    timings.collect { |p| [ "#{p} pm", "#{p} pm" ] }
  end
end