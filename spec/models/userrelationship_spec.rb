require 'spec_helper'

describe Userrelationship do
  let(:follower) {FactoryGirl.create(:user)}
  let(:followed) {FactoryGirl.create(:user)}
  let(:userrelationship) {follower.userrelationships.build(followed_id: followed.id)}

  subject {userrelationship}

  it {should be_valid}

  describe "follower methods" do
  	it {should respond_to(:follower)}
  	it {should respond_to(:followed)}
  	its(:follower) { should eq follower}
  	its(:followed) { should eq followed}
  end

  describe "when followed id is not present" do
    before { userrelationship.followed_id = nil }
    it { should_not be_valid }
  end

  describe "when follower id is not present" do
    before { userrelationship.follower_id = nil }
    it { should_not be_valid }
  end
end
