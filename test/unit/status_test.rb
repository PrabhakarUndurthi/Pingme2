require 'test_helper'

class StatusTest < ActiveSupport::TestCase
  # Validating the content of the status while the user posting .
  #If the user posts the content without any text in it ,
  #it throws an error.
  test "that a status requires content" do
  	status = Status.new
  	assert !status.save
  	assert !status.errors[:content].empty?	
  end


  test "that a status's contnet is at least 2 letters "do
  status = Status.new
  status.content = "H"
  assert !status.save
  assert !status.errors[:content].empty?
  end
  test "that a status has a user id" do
    status = Status.new
    status.content= "Hello"
    assert !status.save
    assert !status.errors[:user_id].empty?
    end
end
