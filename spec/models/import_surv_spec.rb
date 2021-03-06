# == Schema Information
#
# Table name: import_survs
#
#  id         :integer          not null, primary key
#  surv_type  :string(255)
#  form       :string(255)
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  year       :integer
#  month      :integer
#

require 'spec_helper'

describe ImportSurv do
  describe 'Create Import Surv' do
    before(:each) do
      @valid_attr = { :surv_type => ImportSurv::TYPES_SURV1, :month => 0, :year => 2013 }
    end

    describe 'with valid attributes' do
      it "should create surv with valid attributes" do
        import_surv =  ImportSurv.new(@valid_attr)
        expect{import_surv.save}.to change{ImportSurv.count}.by(1)
      end
    end

    describe 'with invalid attributes' do
      it 'should require month' do
        import_surv = ImportSurv.new(@valid_attr.merge(:month => ""))
        expect{import_surv.save}.to change{ImportSurv.count}.by(0)
        import_surv.errors.full_messages[0].should eq "Month can't be blank"
      end

      it 'should require year to be a numberic value' do
        import_surv = ImportSurv.new @valid_attr.merge(:year => '')
        expect{import_surv.save}.to change{ImportSurv.count}.by(0)
        import_surv.errors.full_messages[0].should eq 'Year is not a number'
      end

      it 'should require surv to be unique in scope of year, month, surv_type' do
         import_surv1 = FactoryGirl.create :import_surv

         import_surv2 = ImportSurv.new( :surv_type => import_surv1.surv_type,
                         :year      => import_surv1.year,
                         :month      => import_surv1.month )



         expect{import_surv2.save}.to change{ImportSurv.count}.by(0)
         import_surv2.errors.full_messages.count.should eq 2
         import_surv2.errors.full_messages[0].should eq "Year January, #{import_surv1.year} has already been chosen"
         import_surv2.errors.full_messages[1].should eq "Month January, #{import_surv1.year} has already been chosen"
      end

    end

  end
end
