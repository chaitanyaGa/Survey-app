require 'spec_helper'

describe CirclesController do
  before (:each) do
    @user = FactoryGirl.create(:user)
    sign_in @user
  end 

  context 'Circle' do
    it 'should create new circle' do
      @user.circles.count.should == 0
      expect {
        post :create, :circle => {:name => 'New Circle'}, :format => :json
      }.to change(Circle, :count).by(1)
      @user.circles.count.should == 1 
    end

    it 'should add a new member to circle' do
      member = FactoryGirl.create(:user)
      circle = @user.create_circle({name: 'New Circle'})
      expect{
        post :add_member, {:circle_ids => [circle.id], :person_id => member.id}
      }.to change(CircleMember, :count).by(1)
    end

    it 'should add a new member to multiple circles' do
      member = FactoryGirl.create(:user)
      circle1 = @user.create_circle({name: 'Circle 1'})
      circle2 = @user.create_circle({name: 'Circle 2'})
      expect{
        post :add_member, {:circle_ids => [circle1.id, circle2.id], :person_id => member.id}
      }.to change(CircleMember, :count).by(2)
    end

    it 'should remove member from circles' do
      member = FactoryGirl.create(:user)
      circle1 = @user.create_circle({name: 'Circle 1'})
      circle2 = @user.create_circle({name: 'Circle 2'})
      Circle.add_member(@user, [circle1.id, circle2.id], member.id)
      
      # remove member from circle 1
      expect{
        post :add_member, {:circle_ids => [circle2.id], :person_id => member.id}
      }.to change(CircleMember, :count).by(-1)
    end

    it 'should not remove member from others circles' do
      member = FactoryGirl.create(:user)
      circle1 = @user.create_circle({name: 'Circle 1'})
      circle2 = @user.create_circle({name: 'Circle 2'})
      Circle.add_member(@user, [circle1.id, circle2.id], member.id)
     
      # create user 2 and circle and circle_member
      user2 = FactoryGirl.create(:user)
      circle3 = user2.create_circle({name: 'Circle 1'})
      circle4 = user2.create_circle({name: 'Circle 2'})
      Circle.add_member(user2, [circle3.id, circle4.id], member.id)
      
      # remove member from circle 1 for user 1
      expect{
        post :add_member, {:circle_ids => [circle2.id], :person_id => member.id}
      }.to change(CircleMember, :count).by(-1)

      CircleMember.all.count.should == 3
    end

  end
end
