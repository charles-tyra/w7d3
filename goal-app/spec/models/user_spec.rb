# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  username        :string           not null
#  password_digest :string           not null
#  session_token   :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'uniqueness' do
    subject(:tobie) {
      User.create(
        username: 'tobie',
        password: 'woofwoof'
        )
    }
    
    it { should validate_uniqueness_of(:username)}
    it { should validate_uniqueness_of(:session_token)}
  end

  it { should validate_presence_of(:username) }
  it { should validate_presence_of(:password_digest) }
  it { should validate_presence_of(:session_token) }

  it { should validate_length_of(:password).is_at_least(6) }

  it { should allow_value(nil).for(:password) }

  context "has ::find_by_credentials" do 
    subject(:tobie) {
       User.create(
        username: 'tobie',
        password: 'woofwoof'
        )
    }

    # it "it should accept a username and password argument" do
      
    # end
    
    context "valid user" do
      it "should return the user" do
        expect(User.find_by_credentials(tobie.username, tobie.password)).to eq(tobie)
      end
    end

    context "invalid user" do
      it "should return nil" do
        expect(User.find_by_credentials('tobiethenotdog', 'BARKABARKABRJAKRAN')).to be_nil
      end
    end

    # cate = User.create(username: 'cat', password:'sixcharacters')
    # it "should use #is_password? helper method" do
      # expect(BCrypt::Password.new(tobie.password_digest)).to receive(:is_password?).with(tobie.password).and_return(true)
      # expect(User.find_by(username: tobie.username)).to receive(:is_password?).with(tobie.password)
      # User.find_by_credentials(tobie.username, tobie.password)
      # User.find_by_credentials(cat.use)
      # expect_any_instance_of(User).to receive(:is_password?).with('woofwoof').and_return(true)

    # end


    
  end
  describe 'is_password?' do
    let!(:user) { create(:user) }                     #using let w bang creates the object immediately after the line and cache the object immediately, rather then lazy load

    context 'with a valid password' do
      it 'should return true' do
        expect(user.is_password?('password')).to be true
      end
    end

    context 'with an invalid password' do
      it 'should return false' do
        expect(user.is_password?('bananaman')).to be false
      end
    end
  end

  describe 'password hashing' do
    it 'does not save passwords to the database' do
      FactoryBot.create(:harry_potter)                 #or just FactoryBot.create(:user, username: 'Harry Potter')

      user = User.find_by(username: 'Harry Potter')
      expect(user.password).not_to eq('password')
    end

    it 'hashes password using BCrypt' do
      expect(BCrypt::Password).to recieve(:create).with('abcdef')
      FactoryBot.build(:user, password: 'abcdef')
    end
  end
end
