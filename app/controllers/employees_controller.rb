class EmployeesController < ApplicationController
  include Pagy::Backend
  before_action :set_employee, only: %i[ show edit update destroy ]
  
  def index
    # todo: get this from the paramaters so we can vary the page count
    count = 10
    @pagy, @employees = pagy(Employee.all, items: count)
  end

  def search 
    query = params[:search]
    records = Employee.name_like(query)

    @records = records.map { |m| Hash[m.id => m.first_name + ' ' + m.last_name] }

    # path = params[:returnPath]
    
    render json: @records

  end

  def show
    @employee = Employee.includes(:manager).find(params[:id])
    @manager = @employee.manager
  end

  def edit
    @employee = Employee.find(params[:id])
    @manager = @employee.manager
  end

  def new
    @employee = Employee.new
  end

  def create
    @employee = Employee.new(employee_params)
    
    password = 'password'
    @employee.password = password
    @employee.password_confirmation = password 

    if @employee.save
      redirect_to @employee, notice: "employee was successfully created."
    else
      render inertia: 'employees/new', props: { 
        employee: @employee,
        errors: @employee.errors
      }
    end

  end

  def update
    if @employee.update(employee_params)
      redirect_to @employee, notice: "employee was successfully updated."
    else
      render inertia: 'people/edit', props: { 
        employee: @employee,
        errors: @employee.errors
      }
    end
  end

  def destroy
    @employee.destroy!
    redirect_to employees_url, notice: "employee was successfully destroyed.", status: :see_other
  end

private

  def set_employee
    @employee = Employee.find(params[:id])
  end

  def employee_params
    params.require(:employee).permit(:email, :last_name, :first_name, :reports_to, :hire_date)
    # params.require(:employee).permit(:last_name, :first_name, :title, :title_of_courtesy, :birth_date, :hire_date, :address1, :address2, :city, :region, :postal_code, :country, :home_phone, :extension, :photo)
  end

end
