class TodosController < ApplicationController
  before_action :set_todo, only: %i[show edit update destroy]

  def index
    @todos = Todo.all
  end

  def show
    @todo = Todo.find(params[:id])
  end

  def new
    @todo = Todo.new
  end

  def create
    @todo = Todo.new(todo_params)
    if @todo.save
      redirect_to todos_path, notice: 'ToDoが作成されました。'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @todo.update(todo_params)
      redirect_to todos_path, notice: 'ToDoが更新されました。'
    else
      render :edit
    end
  end

  def destroy
    @todo.destroy
    redirect_to todos_path, notice: 'ToDoが削除されました。'
  end

  private

  def set_todo
    @todo = Todo.find(params[:id])
  end

  def todo_params
    params.require(:todo).permit(:title, :description, :deadline, :status)
  end
end
