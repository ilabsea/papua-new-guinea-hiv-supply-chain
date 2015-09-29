# encoding: utf-8
module Admin
  class LabTestsController < Controller
    load_and_authorize_resource

    def index
      @lab_tests = LabTest.includes(:lab_test_category, :unit).paginate(paginate_options)
    end

    def new
      @lab_test = LabTest.new
    end

    def edit
      @lab_test = LabTest.find(params[:id])
    end

    def create
      @lab_test = LabTest.new(params[:lab_test])

      if @lab_test.save
        redirect_to admin_lab_tests_path, notice: 'Lab Test has been created successfully.'
      else
        render action: "new"
      end
    end

    def update
      @lab_test = LabTest.find(params[:id])

      if @lab_test.update_attributes(params[:lab_test])
        redirect_to admin_lab_tests_path, notice: 'Lab Test has been updated successfully.' 
      else
        render action: "edit" 
      end
    end

    def destroy
      begin
        @lab_test = LabTest.find(params[:id])
        @lab_test.destroy
        redirect_to admin_lab_tests_path , :notice => 'Lab Test has been removed'
      rescue Exception => ex
        redirect_to admin_lab_tests_path , :error => ex.message
      end
    end

  end
end