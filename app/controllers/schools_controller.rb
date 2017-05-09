class SchoolsController < ApplicationController
    authorize_resource
    before_action :set_school, only: [:show, :edit, :update, :destroy]

    before_action :check_login, except: [:index, :show]

    def index
        @active_schools = School.active.alphabetical.paginate(:page => params[:page]).per_page(20)
        @inactive_schools = School.inactive.alphabetical.paginate(:page => params[:page]).per_page(20)
    end

    def new
        @school = School.new
    end

    def create
        @school = School.new(school_params)
    end

    def show
    end

    def edit
    end

    def destroy
    end

    private
    
    def set_school
    @school = School.find(params[:id])
    end
    
    def school_params
    params.require(:school).permit(:name, :street_1, :street_2, :city, :state, :zip, :min_grade, :max_grade)
    end



end
