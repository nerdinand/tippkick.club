require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test 'valid user' do
    user = User.new(email: 'messi@tippkick.test', password: 'messi', rooting_for_team: 'ESP')

    assert_difference -> { Bet.count }, +51 do
      assert user.save!
    end

    assert_match /[[:alnum:]]{5}/, user.tippkick_id
    assert_match /[[:alnum:]]{5}/, user.nickname

    assert_equal 1, user.teams.count
    assert_equal teams(:global), user.teams.first
    assert_not user.admin?
  end

  test 'team association' do
    user = users(:diego)

    assert_includes user.teams,
                    teams(:campeones)
  end

  test 'validates rooting_for_team' do
    user = users(:diego)

    assert_not user.update(rooting_for_team: 'ARG')
    assert_includes user.errors[:rooting_for_team], 'is not included in the list'

    assert user.update(rooting_for_team: '')
  end

  test 'validates locale' do
    user = users(:diego)

    assert_not user.update(locale: 'xy')
    assert_includes user.errors[:locale], 'is not included in the list'

    assert user.update(locale: 'en')
  end

  test '#membership_for' do
    user = users(:diego)
    team = teams(:campeones)
    membership = memberships(:diego_campeones)

    assert_equal membership, user.membership_for(team)
  end

  test 'validates #titles' do
    user = User.new(titles: -1)
    assert_not user.valid?
    assert_includes user.errors[:titles], 'must be greater than or equal to 0'
  end

  test '#titles?' do
    assert_not User.new(titles: 0).titles?
    assert User.new(titles: 1).titles?
  end
end
