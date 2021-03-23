require 'application_system_test_case'

class TeamsTest < ApplicationSystemTestCase
  test 'create team' do
    before_tournament do
      sign_in_as :diego

      within 'section#teams' do
        click_on 'Create new team'
      end

      fill_in 'Name', with: 'Argentinos'
      click_on 'Create Team'

      assert_selector '.flash-messages', text: 'Team created successfully.'
      assert_selector 'h1', text: 'Argentinos'
      assert_selector '.stats--members-count', text: '1'
    end
  end

  test 'show team and memberships' do
    before_tournament do
      sign_in_as :diego

      within 'section#teams' do
        click_on 'Campeones'
      end

      within 'section#memberships' do
        assert_selector '.team-membership--user--nickname', text: 'digi'
        assert_selector '.team-membership--user--nickname', text: 'pele'
      end
    end
  end

  test 'coach deletes team' do
    before_tournament do
      sign_in_as :diego

      within 'section#teams' do
        click_on 'Campeones'
      end

      click_on 'Delete'
      assert_selector '.flash-messages', text: 'Team deleted successfully.'
      assert_selector 'h1', text: 'Dashboard'
    end
  end

  test 'non-coach cannot delete team' do
    before_tournament do
      sign_in_as :pele

      within 'section#teams' do
        click_on 'Campeones'
      end

      assert_selector 'a', text: 'Delete', count: 0
    end
  end

  test 'coach edits team' do
    before_tournament do
      sign_in_as :diego

      within 'section#teams' do
        click_on 'Campeones'
      end

      click_on 'Edit'
      fill_in 'Name', with: 'The Champions'
      click_on 'Update Team'

      assert_selector '.flash-messages', text: 'Team updated successfully.'
      assert_selector 'h1', text: 'The Champions'
    end
  end

  test 'non-coach cannot edit team' do
    before_tournament do
      sign_in_as :pele

      within 'section#teams' do
        click_on 'Campeones'
      end

      assert_selector 'a', text: 'Edit', count: 0
    end
  end

  test 'coach can NOT leave the team' do
    before_tournament do
      sign_in_as :diego

      within 'section#teams' do
        click_on 'Campeones'
      end

      assert_selector 'a', text: 'Leave team', count: 0
    end
  end

  test 'non-coach can leave the team' do
    before_tournament do
      sign_in_as :pele

      within 'section#teams' do
        click_on 'Campeones'
      end

      click_on 'Leave team'

      assert_selector '.flash-messages', text: 'You left the team.'
      assert_selector 'h1', text: 'Dashboard'
    end
  end
end
