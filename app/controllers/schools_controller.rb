class SchoolsController < ApplicationController
   
    before_action :set_school, only: [:show, :edit, :update, :destroy]

    before_action :check_login, except: [:index, :show]
     authorize_resource

    def index
        @active_schools = School.active.alphabetical.paginate(:page => params[:page]).per_page(100)
        @inactive_schools = School.inactive.alphabetical.paginate(:page => params[:page]).per_page(20)
    end

    def new
        @school = School.new
    end

    def create
        @school = School.new(school_params)

        if @school.save!
            redirect_to school_path(@school), notice: "Successfully created #{@school.name}."
        else
            render action: 'new'
        end

    end

    def show
    end

    def edit
    end

    def update
        if @school.update(school_params)
            redirect_to school_path(@school), notice: "Successfully updated #{@school.name}."
        else
        render action: 'edit'
        end
    end

    

    def destroy

        if @school.destroy
          redirect_to :back, notice: "Succcessfully removed #{@school.name} from the system."
        else
          redirect_to :back, notice: "Cannot remove #{@school.name} from the system because orders have been placed. #{@school.name} has been deactivated instead."

        end
    end

    private
    
    def set_school
    @school = School.find(params[:id])
    end
    
    def school_params
    params.require(:school).permit(:name, :street_1, :street_2, :city, :state, :zip, :min_grade, :max_grade, :active)
    end



end
