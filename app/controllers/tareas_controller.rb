class TareasController < ApplicationController
  respond_to :html, :xml, :json
  before_action :set_tarea, only: [:show, :edit, :update, :destroy]

  def index
    @clientes = Usuario.where(:tipo_de_usuario => 4)
    if params[:estadoTarea] == "Asignadas"
      @tareas = current_usuario.tareas_asignadas.where.not(:estado => "Completada")
    elsif params[:estadoTarea] == "Terminadas"
      @tareas = current_usuario.tareas_asignadas.where(:estado => "Completada")
    else
      @tareas = current_usuario.tareas_asignadas
    end
    respond_with(@tareas, @clientes)
  end

  def show
    @usuarios = Usuario.all
    @ejecutante = @usuarios.find_by(id: @tarea.ejecutante)
    respond_with(@tarea)
  end

  def new
    @tarea = Tarea.new
    respond_with(@tarea)
  end

  def edit
    @tarea = Tarea.find(params[:id])
    @ejecutantes = Usuario.where(:id => 0)
    @empresas = current_usuario.empresas
    @empresas.each do |empresa|
      @ejecutantes += empresa.usuarios.where(:tipo_de_usuario => 3)
    end
  end

  def create
    @tarea = Tarea.new(tarea_params)
     if @tarea.save
      respond_with(@tarea)
     else
        respond_to do |format|  ## Add this
        format.html { render  "new" }
        format.json { render json: @tarea.errors, status: :unprocessable_entity }
        end
      end
  end

  def update
    @tarea.update(tarea_params)
    respond_with(@tarea)
  end

  def update_archivo
    @tarea.update(tarea_params_archivo)
    respond_with(@tarea)
  end

  def destroy
    @tarea.destroy
    respond_with(@tarea)
  end

  private
    def set_tarea
      @tarea = Tarea.find(params[:id])
    end

    def tarea_params
      params.require(:tarea).permit(:nombre, :estado, :creacion, :termino, :descripcion, :ejecutante, :servicio_id)
    end

    def tarea_params_archivo
      params.require(:tarea).permit(:nombreArchivo)
    end

end
