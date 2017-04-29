class SchoolsController < ApplicationController
    before_action :check_login
    authorize_resource

    def index
        @active_schools = School.active.alphabetical.to_a
        @inactive_schools = School.inactive.alphabetical.to_a
    end

    def new
    end

    def show
    end

    def edit
    end


end
