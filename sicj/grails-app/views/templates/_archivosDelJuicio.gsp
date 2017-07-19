<div class="wrapper wrapper-content">
    <div class="row">
        <div class="col-lg-3">
            <div class="ibox float-e-margins">
                <div class="ibox-content">
                    <div class="file-manager">
                        <button class="btn btn-primary btn-block" onclick="mostrarArchivos(${juicio?.id});">Mostrar Archivos</button>
                        <g:if test="${juicio?.estadoDeJuicio?.id == 1 || juicio?.estadoDeJuicio?.id == 2 || juicio?.estadoDeJuicio?.id == 5}">
                        <button class="btn btn-primary btn-block" onclick="mostrarAreaUpload();">Cargar Archivo</button>
                        </g:if>
                        <div class="clearfix"></div>
                    </div>
                </div>
            </div>
        </div>
        <div id="divSubirArchivo" class="col-lg-9 animated fadeInRight" style="display:none;">
            <div class="ibox float-e-margins">
                <div class="ibox-title">
                    <h5>Área de Carga de Archivos</h5>
                </div>
                <div class="ibox-content">
                    <div class="row">
                    <g:render template="/templates/subirArchivos"/>
                    </div>
                </div>
            </div>
        </div>
        <div id="divLista" class="col-lg-9 animated fadeInRight">
            <g:render template="/templates/listaDeArchivos"/>
        </div>
    </div>
</div>