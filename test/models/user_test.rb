require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test 'the truth' do
    assert true
  end

  test 'should full name' do
    [
      ['Full', 'Test', 'Full Test'],
      ['Another', 'Surname', 'Another Surname'],
    ].each do |attr|
      user = User.new(first_name: attr[0], last_name: attr[1])

      assert_equal attr[2], user.full_name, 'Result not as expected'
    end
  end

  test 'first name validators' do
    validators =  User.validators_on(:first_name)

    assert_equal 1, validators.size, '1 Validator should be present on User.first_name'
    assert validators.map(&:class).include?(ActiveRecord::Validations::PresenceValidator), 'User.first_name should have PresenceValidator'
  end

  test 'last name validators' do
    validators =  User.validators_on(:last_name)

    assert_equal 1, validators.size, '1 Validator should be present on User.last_name'
    assert validators.map(&:class).include?(ActiveRecord::Validations::PresenceValidator), 'User.last_name should have PresenceValidator'
  end

  test 'email validators' do
    validators =  User.validators_on(:email)

    assert_equal 3, validators.size, '3 Validators should be present on User.email'

    assert validators.map(&:class).include?(ActiveRecord::Validations::PresenceValidator), 'User.email should have PresenceValidator'
    assert validators.map(&:class).include?(ActiveRecord::Validations::UniquenessValidator), 'User.email should have UniquenessValidator'
    assert validators.map(&:class).include?(ActiveModel::Validations::FormatValidator), 'User.email should have FormatValidator'
  end

end
