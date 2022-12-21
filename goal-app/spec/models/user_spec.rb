require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_uniqueness_of(:username)}
  it { should validate_uniqueness_of(:session_token)}

  it { should validate_presence_of(:username) }
  it { should validate_presence_of(:password_digest) }
  it { should validate_presence_of(:session_token) }

  it { should validate_length_of(:password).is_at_least(6) }

  context "has User::find_by_credentials" do 
    before :each do
      let!(:user) { User.create(username: 'tobiethedog', password: 'woofwoof')}                #'!' ?
    end

    # it "it should accept a username and password argument" do
      
    # end
    
    context "valid user" do
      it "should return the user" do
        expect(User.find_by_credentials(user.username, user.password)).to eq(user)
      end
    end

    context "invalid user" do
      it "should return nil" do
        expect(User.find_by_credentials('tobiethenotdog', 'BARKABARKABRJAKRAN')).to be_nil
      end
    end

    it "should use #is_password? helper method" do
      expect(user).to_recieve(:is_password?).with('woofwoof')
    end
    
  end
end
