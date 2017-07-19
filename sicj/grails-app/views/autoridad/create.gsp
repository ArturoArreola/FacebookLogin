<!DOCTYPE html>
<html>
    <head>
        <meta name="layout" content="inspinia" />
        <g:set var="entityName" value="${message(code: 'delegacion.label', default: 'Autoridad')}" />
        <title><g:message code="default.create.label" args="[entityName]" /></title>
    </head>
    <body>
        <div class="row wrapper border-bottom white-bg page-heading">
            <div class="col-sm-4">
                <h2>Consola de Administración</h2>
                <ol class="breadcrumb">
                    <li>
                        <a href="index.html">Autoridades</a>
                    </li>
                    <li class="active">
                        <strong>Registro de Autoridades</strong>
                    </li>
                </ol>
            </div>
        </div>
        <div>
            <g:render template="/templates/menuAdmin"/>
            <div class="row">
                <div class="col-lg-12">
                    <div class="ibox float-e-margins">
                        <div class="ibox-title">
                            <h5>Registrar Autoridad</h5>
                        </div>
                        <div class="ibox-content">
                            <g:if test="${flash.message}">
                                <div class="alert alert-info alert-dismissable">
                                    <button aria-hidden="true" data-dismiss="alert" class="close" type="button">×</button>
                                    ${flash.message}
                                </div>
                            </g:if>
                            <g:hasErrors bean="${this.autoridad}">
                                <g:eachError bean="${this.autoridad}" var="error">
                                    <g:if test="${error in org.springframework.validation.FieldError}">
                                        <div class="alert alert-danger alert-dismissable">
                                            <button aria-hidden="true" data-dismiss="alert" class="close" type="button">×</button>
                                            <g:message error="${error}"/>
                                        </div>
                                    </g:if>
                                </g:eachError>
                            </g:hasErrors>
                            <g:form action="save" class="form-horizontal">
                                <div class="form-group">
                                    <label class="col-sm-2 control-label">Materia: </label>
                                    <div class="col-sm-10">
                                        <div class="input-group">
                                            <g:select data-placeholder="Elija la materia..." required class="chosen-select" style="width:350px;" tabindex="2" name="materia.id" from="${mx.gox.infonavit.sicj.catalogos.Materia?.list(sort:'id')}" value="${autoridad?.materia?.id}" optionKey="id" />
                                        </div>
                                    </div>
                                </div>
                                <div class="hr-line-dashed"></div>
                                <div class="form-group">
                                    <label class="col-sm-2 control-label">Ámbito: </label>
                                    <div class="col-sm-10">
                                        <div class="input-group">
                                            <g:select data-placeholder="Elija un Ámbito..." required class="chosen-select" style="width:350px;" tabindex="2" name="ambito.id" from="${mx.gox.infonavit.sicj.catalogos.Ambito?.list(sort:'nombre')}" value="${autoridad?.ambito?.id}" optionKey="id" />
                                        </div>
                                    </div>
                                </div>
                                <div class="hr-line-dashed"></div>
                                <div class="form-group">
                                    <label class="col-sm-2 control-label">Estado: </label>
                                    <div class="col-sm-10">
                                        <div class="input-group">
                                            <g:select noSelection="['':'Elija el Estado...']" required data-placeholder="Elija el Estado..." class="chosen-select" style="width:300px;" tabindex="2" name="estado.id" id="estado" from="${mx.gox.infonavit.sicj.catalogos.Estado?.list(sort:'nombre')}" optionKey="id" onchange = "${remoteFunction(controller : 'autoridad', action : 'obtenerMunicipios', params : '\'estado=\' + escape(this.value)', onSuccess : 'actualizar(data,\'municipio\')')}"/>
                                        </div>
                                    </div>
                                </div>
                                <div class="hr-line-dashed"></div>
                                <div class="form-group">
                                    <label class="col-sm-2 control-label">Municipio: </label>
                                    <div class="col-sm-10">
                                        <div class="input-group">
                                            <select class="chosen-select" required id="municipio" name="municipio.id" data-placeholder="Elija primero el Estado..." style="width:300px;" tabindex="2">
                                            </select>    
                                        </div>
                                    </div>
                                </div>
                                <div class="hr-line-dashed"></div>
                                <div class="form-group">
                                    <label class="col-sm-2 control-label">Tipo de Autoridad: </label>
                                    <div class="col-sm-10">
                                        <div class="input-group">
                                            <span class="input-group-addon" onclick="$('#modalAltaTipoDeAutoridad').modal('show');">
                                                <i class="fa fa-plus"></i>
                                            </span> 
                                            <g:select data-placeholder="Elija el Tipo de Autoridad..." required class="chosen-select" style="width:350px;" tabindex="2" id="tipoDeAutoridad" name="tipoDeAutoridad.id" from="${mx.gox.infonavit.sicj.catalogos.TipoDeAutoridad?.list(sort:'nombre')}" value="${autoridad?.tipoDeAutoridad?.id}" optionKey="id" />
                                        </div>
                                    </div>
                                </div>
                                <div class="hr-line-dashed"></div>
                                <div class="form-group"><label class="col-sm-2 control-label">Nombre de la Autoridad: </label>
                                    <div class="col-sm-10"><input type="text" required class="form-control" name='nombre' size='50' maxlength='255' autocomplete='off' value='${autoridad.nombre}' onBlur="this.value=this.value.toUpperCase();"/></div>
                                </div>
                                <div class="hr-line-dashed"></div>
                                <div class="form-group">
                                    <div class="col-sm-4 col-sm-offset-2">
                                        <button class="btn btn-primary" type="submit">Guardar</button>
                                    </div>
                                </div>
                            </g:form>
                        </div>
                    </div>
                </div>
            </div>
            <div class="modal inmodal fade" id="modalAltaTipoDeAutoridad" data-keyboard="false" data-backdrop="static" tabindex="-1" role="dialog" aria-hidden="true">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <div class="modal-header">
                            <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Cerrar</span></button>
                            <h4 class="modal-title">Registrar Nuevo Tipo de Autoridad</h4>
                            <small class="font-bold">Proporcione los siguientes datos para registrar el nuevo Tipo de Autoridad.</small>
                        </div>
                        <div class="modal-body">
                            <g:render template="/templates/altaTipoDeAutoridad"/>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-white" data-dismiss="modal">Cerrar</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <script type="text/javascript">
            function actualizar(data, tipo) {
            var resultado = eval(data);
            var html = "";
        html += "<option value='null'>Elija un Municipio...</option>";
            for (var x = 0; x < resultado.length; x++) {          
            html += "<option value='" + resultado[x].id + "'>" + resultado[x].nombre + "</option>";          
            }
            $('#' + tipo).html(html);
            $('#' + tipo).trigger("chosen:updated");
            }

            function seleccionarNuevoTipoDeAutoridad(data){
            var respuesta = eval(data);
            if(respuesta.id){
            obtenerTipoDeAutoridad(respuesta.id);
            } else {
            alert("Ocurrio un error al cargar el tipo de autoridad");
            }
            }

            function obtenerTipoDeAutoridad(idNuevo){
            jQuery.ajax({
            type:'GET',
            url:'/sicj/tipoDeAutoridad/obtenerTiposDeAutoridad',
            success:function(data,textStatus){
            actualizar(data, 'tipoDeAutoridad');
            $('#tipoDeAutoridad').val(idNuevo);
            $('#tipoDeAutoridad').trigger("chosen:updated");
            },
            error:function(XMLHttpRequest,textStatus,errorThrown){}
            });
            }

            function ocultarModal(){
            $('#modalAltaTipoDeAutoridad').modal('toggle');
            }
        </script>
    </body>
</html>
