require 'spec_helper'

describe Micropost do
	
	let(:user) {FactoryGirl.create(:user)}

  	before { @micropost = user.microposts.build(content: "Lorem Ipsum") }
	

	subject { @micropost }

	it { should respond_to(:content) }
	it { should respond_to(:user_id) }
	it { should respond_to(:user) }
	its(:user) { should eq user }

	it {should be_valid}

	describe 'when no user id is present' do
		before { @micropost.user_id = nil}
		it {should_not be_valid}
	end

	describe 'with blank content' do
		before { @micropost.content = " " }
		it {should_not be_valid }
	end

	describe 'longer than 140 characters' do
		before { @micropost.content = "a" * 141 }
		it {should_not be_valid }
	end
end
