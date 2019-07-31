class CoursesController < ApplicationController
  # GET /courses/:id/curriculum
  def curriculum
    @course = authorize(Course.find(params[:id]))
    @presenter = Courses::CurriculumPresenter.new(view_context, @course)
    render layout: 'student_course'
  end

  # GET /courses/:id/leaderboard?weeks_before=
  def leaderboard
    @course = authorize(Course.find(params[:id]))
  end

  # GET /courses/:id/apply
  def apply
    @course = authorize(Course.find(params[:id]))
    render layout: 'student'
  end

  def about
    @course = authorize(Course.find(params[:id]))
    render layout: 'student'
  end
end
