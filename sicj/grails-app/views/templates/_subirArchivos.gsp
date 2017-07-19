<div id="divDropzone" class="col-lg-12">
    <div id="actions" class="row">
        <div class="col-lg-6">
            <span class="btn btn-primary fileinput-button dz-clickable">
                <i class="glyphicon glyphicon-plus"></i>
                <span>Agregar Archivos</span>
            </span>
            <button type="submit" class="btn btn-success start">
                <i class="glyphicon glyphicon-upload"></i>
                <span>Iniciar Carga</span>
            </button>
            <button id="botonDescarga" class="btn btn-warning" style="display: none;">
                <i class="glyphicon glyphicon-download"></i>
                <span>Descargar Archivo</span>
            </button>
        </div>
        <div class="col-lg-6">
            <span class="fileupload-process">
                <div id="total-progress" class="progress progress-striped active" style="background-color: #BDBDBD;" role="progressbar" aria-valuemin="0" aria-valuemax="100" aria-valuenow="0">
                    <div class="progress-bar progress-bar-success" style="width:0%;" data-dz-uploadprogress=""></div>
                </div>
            </span>
        </div>
    </div>
    <br />
    <div class="row">
        <div class="table table-striped files" id="previews">
            <div id="template" class="file-row">
                <div class="row">
                    <div class="col-lg-offset-1 col-lg-5">
                        <p><strong>Nombre del Archivo: </strong><span class="name" data-dz-name></span></p>
                        <strong class="error text-danger" data-dz-errormessage></strong>
                    </div>
                    <div class="col-lg-4">
                        <p><strong>Tamaño del Archivo: </strong><span class="badge badge-primary size" data-dz-size></span></p>
                        <div class="progress progress-striped active" style="background-color: #BDBDBD;" role="progressbar" aria-valuemin="0" aria-valuemax="100" aria-valuenow="0">
                            <div class="progress-bar progress-bar-primary" style="width:0%;" data-dz-uploadprogress></div>
                        </div>
                    </div>
                    <div class="col-lg-2 text-center">
                        <button data-dz-remove class="btn btn-danger delete">
                            <i class="glyphicon glyphicon-trash"></i>
                            <span>Eliminar</span>
                        </button>
                    </div>
                </div>
            </div>
        </div>
        <div id="mensajesDropzone"></div>
        <div id="mensaje"></div>
    </div>
</div>
