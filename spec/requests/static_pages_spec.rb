require 'spec_helper'

describe "Static pages" do
  subject {page}

  shared_examples_for "all static pages" do
    it { should have_selector('h1', text: heading) }
    it {should have_title(full_title(page_title)) }
  end

  describe "Home page" do
    before { visit root_path }
    let(:heading) { 'Sample App' }
    let(:page_title) { '' }

    it_should_behave_like "all static pages"
    it { should_not have_title('| Home') }

    describe "for signed in users" do
      let(:user) { FactoryGirl.create(:user) }
      before do
        FactoryGirl.create(:micropost, user: user, content: "Lorem ipsum")
        FactoryGirl.create(:micropost, user: user, content: "Dolor sit amet")
        sign_in user
        visit root_path
      end

      it "should render the user's feed with delete links only on own posts" do
        user.feed.each do |item|
          expect(page).to have_selector("li##{item.id}", text: item.content)
          if item.user != user
          expect(page).not_to have_link('delete')
          end
        end
      end
    end   
  end


	describe "Contact page" do
    before {visit contact_path}
    let(:heading) { 'Contact Us'}
    let(:page_title) {'Contact Us'}

    it_should_behave_like "all static pages"
  end

  describe "About page" do
    before {visit about_path}
    let(:heading) { 'About Us'}
    let(:page_title) {'About Us'}

    it_should_behave_like "all static pages"
  end
    
  describe "Help page" do
    before {visit help_path}
    let(:heading) { 'Help'}
    let(:page_title) {'Help'}

    it_should_behave_like "all static pages"
  end

  it "should have the correct links" do
    visit root_path
    click_link "Sign up now!"
    expect(page).to have_title(full_title('Sign Up'))
    click_link "Home"
    expect(page).to have_title(full_title(''))
    click_link "About"
    expect(page).to have_title(full_title('About Us'))
    click_link "Contact"
    expect(page).to have_title(full_title('Contact Us'))
    click_link "Help"
    expect(page).to have_title(full_title('Help'))
    click_link "sample app"
    expect(page).to have_title(full_title(''))
  end
end